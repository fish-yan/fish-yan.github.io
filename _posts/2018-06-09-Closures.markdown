---
layout:     post
title:      "5. Swift 中的闭包"
subtitle:   "Swift"
date:       2018-06-09 22:00:00
author:     "FishYan"
header-img: "img/blog-header.png" 
catalog:    true
tags:
    - iOS
    - Swift
---

### 闭包定义

闭包（Closure）是自包含的函数代码块，可以在代码中被传递和使用。swift 中的闭包和 c 或 oc 中的 block 以及其他的编程语言的匿名函数类似。

在 swift 中闭包的范围比较广泛，不只是 oc 中 block 这种的，还包含像上节中讲到的全局函数和嵌套函数，全局函数是一种有名字但不会捕获任何只的闭包。嵌套函数是一种有名字可以捕获其封闭函数块中的值。

### 一般闭包表达式

类似于 OC 的 block 的一般闭包表达式

```
// 闭包的声明
var closure: ((String, Int) -> String)!

// 闭包的实现
closure = { (name, age) in
    return "\(name)是\(age)岁"
}

// 闭包的调用
print(closure("小明", 15))
```

闭包声明：是将各个参数的类型抽出来如果没有参数用```()```表示，如果没有返回值用``` ->()```或者```->Void```表示。

闭包的实现：闭包实现整体用大括号包起来，参数写在 ```in``` 之前 有返回值则用 ```return``` 返回。

闭包的调用：和 oc 中的调用方式一样。

不再举过多例子了，这里的闭包只是比较基本的表达方法，其余无参无返，有参无返，无参有返，表达方式可以参考上节的函数的表达方式。

### 闭包进阶

以排序```sorted(by:)```为例

常规的用法：
```swift
var arr = ["2", "3"]

arr = arr.sorted(by: { (str1, str2) -> Bool in
    return str1 > str2
})

print(arr) //["3", "2"]
```

这是一个比较简单的闭包，只有默认的两个参数，并且只是一个简单的返回比较大小的处理，实际上还可以这么写
```swift
var arr = ["2", "3"]

arr = arr.sorted(by: {$0 > $1})

print(arr) //["3", "2"]
```
隐式返回：swift 中的闭包是支持直接将表达式的返回值作为闭包的返回值。

参数压缩：```$0,$1...```分别代表了第一个参数和第二个参数...。

还可以更简单
```swift
var arr = ["2", "3"]

arr = arr.sorted(by: >)

print(arr) //["3", "2"]
```
这里的```>```不止是表面上的一个```>```而是一个运算符方法

### 尾随闭包

```swift
func someFunctionThatTakesAClosure(closure: () -> Void) {
    // 函数体部分
}
 
// 以下是不使用尾随闭包进行函数调用
someFunctionThatTakesAClosure(closure: {
    // 闭包主体部分
})
 
// 以下是使用尾随闭包进行函数调用
someFunctionThatTakesAClosure() {
    // 闭包主体部分
}

```

### 闭包值捕获

在闭包中和嵌套函数中都可以捕获上一层函数体中的变量
```swift
func makeIncrementer(forIncrement amount: Int) -> () -> Int {
    var runningTotal = 0
    func incrementer() -> Int {
        runningTotal += amount
        return runningTotal
    }
    return incrementer
}

```

### 逃逸闭包

闭包默认不允许逃逸出当前闭包体，如果需要逃逸则要加```@escaping```来表明这个这个闭包可以逃逸

逃逸：是指这个闭包需要脱离当前函数体，例如作为参数传给另一个函数，或者在另个闭包体内调用这个闭包。

```swift
var completionHandlers: [() -> Void] = []
func someFunctionWithEscapingClosure(completionHandler: @escaping () -> Void) {
    completionHandlers.append(completionHandler)
}

```

### 自动闭包

```@autoclosure```仅作了解，使用场景不多，用在需要延迟执行方法的时候，下例中可以用自动闭包使 serve 当做方法接收 ```String``` 类型的参数.

```swift
var customersInLine = ["Chris", "Alex", "Ewa", "Barry", "Daniella"]

func serve(customer customerProvider: @autoclosure () -> String) {
    print("Now serving \(customerProvider())!")
}
serve(customer: customersInLine.remove(at: 0))
```