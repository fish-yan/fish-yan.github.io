---
layout:     post
title:      "4. Swift 中的函数"
subtitle:   "Swift"
date:       2018-06-02 22:00:00
author:     "FishYan"
header-img: "img/blog-header.png" 
catalog:    true
tags:
    - iOS
    - Swift
---

# 4. Swift 中的函数

Swift 中的函数，和我们 OC 中所说的方法类似，但不完全相同，大多数使用场景可以替换。

### 1.函数的定义和调用

```swift
// 函数的定义
func greet(name: String) -> String {
    return "hello " + name
}

// 函数的调用
print(greet(name: "小明"))

```

Swift 和 OC 最直观的差别是OC的方法名是尽可能的描述明确，而 Swift 更提倡命名简介明了，能表达清楚的，绝不多加一个字母。在 OC 中可以看到很长的方法名，但是在 swif 中将很少看到过长的函数名。

举个例子，对于打招呼

OC 中可能是这么写：
```swift
// 方法的定义
- (NSString *)greetToPersonWithName:(NSString *)name {
    //...
}

// 方法的调用
NSLog(@"%@", [self greetToPersonWithName:@"小明" ]);
```

Swift 中应该这么写：
```swift
// 函数的定义
func greet(to name: String) -> String {
    return "hello " + name
}

// 函数的调用
print(greet(to: "小明"))
```
swift 的写法简明了很多，并且也不会造成语义不明的情况。

### 2.函数的参数和返回值

```Swift

// 无参无返
func greet() {
    
}

// 有参无返
func greet(name: String) {
    
}

// 有参有返
func greet(name: String) -> String {
    return "hello " + name
}

// 多参多返
func greet(name1: String, name2: String) -> (String, String) {
    return ("hello " + name1, "hello " + name2)
}

```

上面都是很中规中矩的写法，相信大家一看都比较明了，不在做过多解释，下面介绍一些 OC 中没有的

**标签**

指定参数标签
```swift
func greet(to name: String) -> String {
    return "hello " + name
}

print(greet(to: "小明"))
```
```to``` 在这里就是标签，```name```才是参数。标签的命名大多是介词，如```to, in, of, on, with...```，有这些标签的好处是，加上这些标签后函数的语义就更加明确了。如果没有标签，类似之前的写法，则默认标签和参数名相同，也就是说上面在方法调用中的 name 并不是参数，而是标签。

忽略参数标签
```swift
func greet(_ name: String) -> String {
    return "hello " + name
}

print(greet("小明"))
```

**默认参数**

默认参数在其他语言中很早就有，swift 也是引进过来，使用非常方便

```swift
func greet(to name: String = "小红") -> String {
    return "hello " + name
}

print(greet()) // "hello 小红"

print(greet(to: "小明")) // "hello 小明"

```
这就是默认参数的使用，才函数声明的时候可以给参数赋值默认值，在方法调用的时候，如果没有给这个参数传值，那么将使用默认值。

**可变参数**

可变参数是在类型后面加上```...```，表示对该参数的扩展

```swift
func greet(to name: String...) -> String {
    for n in name {
        print("hello \(n)")
    }
    return "end"
}

print(greet(to: "小明", "小红"))
```
加上```...```之后 name 参数在调用的时候是多个字符串的形式，在函数体内，则是数组的形式。

**输入输出参数**

inout 类似于 OC 中的参数传址，会直接改变 a 和 b 的值
```swift
func swapTwoInts(_ a: inout Int, _ b: inout Int) {
    let temporaryA = a
    a = b
    b = temporaryA
}

var a = 6, b = 8

swapTwoInts(&a, &b)

```

### 3.函数类型

不知道大家对我在2中举的那几个例子有没有疑惑，函数名字一样而不会报错？这是因为，在 swift 中判定两个函数是否相同，不但会看方法名字是否相同，还要看函数的类型是否相同。2中所举的例子函数名字虽然一样，但是类型都不一样，所以他们不会被报错。
```Swift

// 无参无返 类型:()->Void
func greet() {
    
}

// 有参无返 类型:(String)->Void
func greet(name: String) {
    
}

// 有参有返 类型:(String)->String
func greet(name: String) -> String {
    return "hello " + name
}

// 多参多返 类型:(String, String)->(String, String)
func greet(name1: String, name2: String) -> (String, String) {
    return ("hello " + name1, "hello " + name2)
}

```

### 4.全局函数

swift 中支持全局函数，类似全局变量一样在类之外，在任何地方都可以直接调用不需要借助任何实例对象。

### 5.嵌套函数

在 swift 中也支持了函数的嵌套，这也是很多语言都具有的特性

```swift
func greet() {
    func hi() {

    }
}
```

### 6.函数类型作为参数类型

这实际上就是 swift 中所说的闭包，我们将在新的篇章中讲述这部分内容。