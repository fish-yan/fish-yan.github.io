---
layout:     post
title:      "8. Swift 闭包循环引用问题"
subtitle:   "Swift"
date:       2020-11-28 22:00:00
author:     "FishYan"
header-img: "img/blog-header.png" 
catalog:    true
tags:
    - iOS
    - Swift
---

**在开始之前先提出来几个问题**

1. swift 中那种情况会造成循环引用？什么时候需要使用 unowned 或 weak 
   
2. swift 中 unowned 和 weak 有什么区别？
   
3. 使用 unowned 或 weak 如何避免 closure 中所访问的对象被提前释放？
   
**如果你也对上面问题有疑问，那就请往下看**

#### 第一个问题
很简单，相信大多数人都知道。简单来说就是 A 引用了 B ，B 又引用了 A，这时候就会循环引用，造成内存泄漏，有可能这个循环链会很长，比如 A 引用了 B， B 引用了 C，C 引用了...引用了 X，X又引用了 A，这种的就需要仔细观察，一层层拆解，找到原因。

有没有必要无脑使用 weak 或 unowned？下面举个不会循环引用的例子

例子1：
```Swift
class A {
    var closure: ((Bool)->Void)?
    ...
}

class B {
   func test() {
      let a = A()
      a.closure = { b in
         print("start")
         self.a = "cccc"
         print(self.a)
     }
   }
}
```
对于这个例子：B 的实例 self 没有强引用 A 的实例 a，a 引用了 B 的 实例 self。self 没有强引用 a，这里断开了，没有形成闭环。所以完全没必要使用 weak 或 unowned。

例子2：
```swift
class A: NSObject {
    
    var a = "bbb"
    
    var closure: ((Bool)->Void)?
    
    func test() {
        closure = { (b) in
            self.a = "cccc"
            print(self.a)
        }
    }
}
```
这个例子就是典型的 self 无法被释放的例子。self 持有 closure， closure 持有 self，形成闭环。

#### 第二个问题
unowned 和 weak 有什么区别

- unowned：弱引用指定对象，并表明该对象一定不为nil
- weak：弱引用指定对象，该对象可以为nil
  
何时使用 unowned，何时使用 weak？

实际上两个可以相互替换使用，但两个有不同优先使用的场景。当需要弱引用对象在上下文中肯定不会为nil，这时候使用 unowned 可减少可选类型出现，使代码整洁更利于理解。相反，如果要弱引用的对象可能为空，这时使用weak 将对象弱引用为可选类型，防止对象为nil产生崩溃。

那么将例子2的 self 弱引用，修改为一下代码：

例子3：
```swift
class A: NSObject {
    
    var a = "bbb"
    
    var closure: ((Bool)->Void)?
    
    func test() {
        closure = { [unowned self] (b) in
            self.a = "cccc"
            print(self.a)
        }
    }
}

class B: NSObject {
    func action() {
        var a: A? = A()
        a?.test()
        a?.closure?(true)
        a = nil
    }
}
````

在closure执行结束之前self不会为nil，此时可以使用 unowned，

再将例子3代码修改：

例子4：
```swift
class A: NSObject {
    
    var a = "bbb"
    
    var closure: ((Bool)->Void)?
    
    func test() {
        closure = { [weak self] (b) in
            print("start")
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                self?.a = "cccc"
                print(self?.a)
            }
        }
    }
}

class B: NSObject {
    func action() {
        var a: A? = A()
        a?.test()
        a?.closure?(true)
        a = nil
    }
}
```
此时只能使用 weak 而不能使用 unowned，a 对象在调用closure之后就置nil，closure中代码延迟2秒之后 self 已经是nil，如果使用 unowned 代码将在此处发生崩溃。

#### 第三个问题
如何能在例子4中使用 self ？

在 closure 执行耗时操作之前将需要使用的对象复制一份，即将其引用计数加1。将例子5修改如下：

例子5：
```swift
class A: NSObject {
    
    var a = "bbb"
    
    var closure: ((Bool)->Void)?
    
    func test() {
        closure = { [unowned self] (b) in
            print("start")
            let that = self
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                that.a = "cccc"
                print(that.a)
            }
        }
    }
    
    deinit {
        print("A deinit")
    }
}

class B: NSObject {
    func action() {
        var a: A? = A()
        a?.test()
        a?.closure?(true)
        a = nil
    }
}
```

此时使用 unowned 是安全的。并且在 closure 耗时操作执行完成之后会调用 deinit 方法，释放 a 对象。