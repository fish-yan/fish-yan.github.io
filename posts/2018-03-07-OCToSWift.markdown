---
layout:     post
title:      "一眼看穿 swift （从 OC 转来 Swift）"
subtitle:   "Swift"
date:       2018-03-07 22:00:00
author:     "FishYan"
header-img: "img/blog-header.png" 
catalog:    true
tags:
    - iOS
    - Swift
---

# 一眼看穿 swift （从 OC 转来 Swift）

# #Swift

### let, var 
---

let 声明为不可变类型

var 声明为可变类型

去 NS 化，swift 会尽可能的把常用类型的前缀去掉

BOOL --> Bool ```YES/NO --> true/fasle != 0/1```

NSInteger --> Int

CGFloat --> Float

Double --> Double

NSString/NSMutableString --> ```String```

NSArray/NSMutableArray --> Array ```[Any]```

NSDictionary/NSMutableDictionary --> Dictionary ```[String: Any]```

NSSet/NSMutableSet --> Set ```[Any]```

(Tuple) ```(Any)```

### 可选值， 非可选值
---

```swift
var a: Int? = nil 

var b: Int = 2

// 强制解包：可能解包失败崩溃
 var c = a!

// 安全解包：将可选值解包为非可选值
if let d = a {
    print(d) //d 为非可选值
}

guard let e = a else {
    return
}
print(e) //d 为非可选值

// 可选链式调用
let arr: [String]? = ["a"]
let count = arr?.count // count 为可选类型

```

### 泛型
---

声明一个参数类型用来替代未知的参数类型一般用 T 表示

```swift
func test<T>(_ a: T) {
    print(a)
}

test(["a"])

test("a")

test(3)
```

### 闭包
---

```swift
var closure: ((Bool)->Void) = { (success) in
    
}

func closureFunc(closure: @escaping (Bool)->Void) {
    closure()
}

closureFunc { (success) in
    
}
```

### 元祖
---

小括号表示()
```swift
var tuple = ("s", ["a", "s"], ["w":"d"])
```
### 函数：
---

一般格式
```swift
// 实例方法
func test(_ a: String, b: Int) -> (String, [Int]) {

}

// 类方法
static func test(_ a: String, b: Int) -> (String, [Int]) {
    
}
```

函数嵌套

```swift
func test(a: String) {
    func test1() {

    }
}
```
函数参数
```swift
func test1() {
    
}

func test2(a: Selector) {
    
}

test2(a: #selector(test1))
```
默认参数
```swift
func test(a: Int ,b: Int = 2) {
    
}

test(a: 2)

test(a: 3, b: 4)
```
可变参数
```swift
func test(a: Int...) {
    // a: [Int]
}

test(2,3,5)
```
inout 参数
```swift
func test(a: inout String) {
    a = "10" // 可直接修改参数
}

var a = "ss"

test(a: &a)
```