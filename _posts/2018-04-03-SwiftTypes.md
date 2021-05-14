---
layout:     post
title:      "2. Swift 中的那些常用的类型"
subtitle:   "Swift"
date:       2018-04-03 22:00:00
author:     "FishYan"
header-img: "img/blog-header.png" 
catalog:    true
tags:
    - iOS
    - Swift
---

> Swift 语言因为是从底层重新去构建，区别于 OC 是基于 C，所以在大多数类型的使用上尽可能的做了去 NS 化，使语言更加简洁。所以在 Swift 中大多数类型都可以看到已经没有了前缀。

下面就列举一下常用的类型的变化，我不会去列举所有的类型，那也不太现实，其实我列举几个剩下的大家都能猜大概要怎么写了。

### 1.基本数据类型
```
BOOL –> Bool YES/NO --> ```true/fasle != 0/1```

NSInteger –> Int

CGFloat –> Float

Double –> Double

...
```
这些其实没必要解释太多，除了类型名称发生变化，用法跟 OC 一模一样。

需要另外说明的是 Bool 类型，在 Swift 中 Bool 类型是用 true/false 而不是 YES/NO，而且，true != 1, false != 0，这是跟 OC 有区别的。

### 2.String

NSString/NSMutableString --> String

如上篇文章所说，在 OC 中的可变类型与不可变类型，在 Swift 中都是同一种类型，区别是声明的方式不同。

```
let str: String = "abcd" // 此时 str 不能被重新赋值，不能被修改。

var str: String = "abcd" // 此时 str 可以被重新赋值，可以被修改。
```
 事实上，在上面例子中的类型 String 是完全可以省略掉的，在 Swift 中如果语义足够明确，那么声明所指定的类型是可以省略的。
```
var str = "abcd" // 这已经足够表明 str 是一个 String 类型而不需要再去指定为 String 类型。这也是在开发中的常用写法。
```
对于可变的 str，在 Swift 中对 str 的操作与 OC 中对 str 的操作，变化很大。这里只举几个常用的例子，更多的内容请自己查阅开发文档。

在 Swift 中 String 遵循了更多的协议。

如Equatable，Comparable协议这使 String 类型可以直接进行相等比较和大小比较

```
let a = "123"

let b = "123"

print(a == b) // true

print(a > b) // false

```

遵循 Collection 协议，为 String 增加了很多集合的特性。

```
var a = "123"

/// 字符串拼接
a.append("4") // 1234

a += "5" /// 12345

/// 按下标获取某一个字符
let c = a[a.startIndex] // (Character)1

/// 字符串截取
let g = a.prefix(3) // 123

let h = a.suffix(3) // 345

let d = a[a.startIndex...a.index(a.startIndex, offsetBy: 2)] // (Substring)123

let count = a.count // 不再是 length，统一跟数组一样是 count

/// 字符串中字符替换
let f = a.replacingOccurrences(of: "3", with: "6")

```

### 3.Array

NSArray/NSMutableArray --> Array

初始化一个数组：
```
let a = Array()
```
大家是不是觉得该这么写？但是实际上这么写是错误的，因为 Swift 是类型安全的语言，如果在声明一个数组的时候，必须要指定数组中元素的类型。
```
let a = Array<Any>()
```
上面的这种写法没问题，是正确的，但是我们还是很少会这么去写，更多的时候我们采用语法糖的形式去初始化一个数组。
```
let a = [Any]()
```
这样写起来是不是就简单很多了呢。Swift 中数组的表示方式似乎与 OC 中差别并不是很大，而且他遵循 Collection 协议，数组的操作方式与上面所讲到的 String 的操作方式几乎一样。

```
var a = ["1", "2", "3"]

a.append("4") // ["1", "2", "3", "4"]

a += ["5"] // ["1", "2", "3", "4", "5"]

a.remove(at: 4) // ["1", "2", "3", "4"]

a.remove(at: a.index(of: "4")!) // ["1", "2", "3"]

a.insert("4", at: 3) // ["1", "2", "3", "4"]

a.joined() // "1234"

```
在 Swift 中废弃了 OC 中的 for 循环，保留了 for...in...，新增了forEach
```
a.forEach { (element) in
    
}

// enumerated()函数 其中 (index, element) 为元祖 (Tuple) 后面会讲到
for (index, element) in a.enumerated() {
    print(index, element)
}

```
另外需要强调的是 Swift 中的数组支持不同类型的元素在同一个数组中，因为这些类型度属于 Any，还可以包含 nil，所以会看到下面的写法：
```
var a:[Any?] = ["2", 2, 2.0, nil]
```

### 4.Dictionary

字典也属于集合类型，同样遵循 Collection 协议、

字典的初始化，也是必须指定元素的类型，其中 Key 必须遵循 Hashable 协议
```
let dict = Dictionary<String, Any>()
```
当然一般也都不这么写，而是跟数组类似的语法糖写法：
```
let dict = [String: Any]()
```

字典的一般操作：
```
var dict = ["a": "123", "b": "456"]

dict.updateValue("789", forKey: "c") // 跟新字典

dict.remove(at: dict.index(forKey: "a")!) // 根据下标移除元素

dict.removeValue(forKey: "b") // 根据 key 移除元素

var dictionary = ["a": 1, "b": 2]

// 字典合并
// 保留旧值:
dictionary.merge(["a": 3, "c": 4]) { (current, _) in current }
// ["b": 2, "a": 1, "c": 4]

// 保留新值:
dictionary.merge(["a": 5, "d": 6]) { (_, new) in new }
// ["b": 2, "a": 5, "c": 4, "d": 6]
```

### 5.Tuple

这在 Swift 中是一个新的类型，OC 中不存在元祖，元祖也属于集合类型，同样遵循 Collection 

元祖的初始化用()表示
```
let a = ("13", 222, ["ddd"])
```
元祖中的元素可以有多种类型表示，通常使用在某一个方法中需要返回多个返回值的情况，

获取元祖中的元素可以使用：
```
print(a.0, a.1, a.2)

a.0 = "35"
```
元祖所需要介绍的内容不多，用法也比较简单。

*至于其他的内容，我相信你看官方文档会比我的跟全面，更快。本文章也是重在入门，不在搬运官方文档。*

