---
layout:     post
title:      "1. Swift 中的 let 和 var"
subtitle:   "Swift"
date:       2018-04-02 22:00:00
author:     "FishYan"
header-img: "img/blog-header.png" 
catalog:    true
tags:
    - iOS
    - Swift
---

# 1. Swift 中的 let 和 var

> Swift 中的变量声明相对于 OC 中简化了很多。可变与不可变取决于声明的方式，不在取决于类型了，这样简化了很多不必要的类型。比如 OC 中可变的为 NSMutableArray，不可变的是 NSArray，而 Swift 中的数组不管可变与不可变就是 Array 。

## Swift 中变量的声明

在 Swift 中声明变量有两种方式: ```let```,```var```

Swift 中的变量的声明方式跟 OC 大不相同，摒弃了 OC 中的 alloc init 的方式，在写法上进行了简化，使整体的入门难度降低，但仅仅是入门难度降低了。

### let

```let``` 所声明的变量统统为不可变的变量。
```Swift
    let a: Int = 0
```
这是简单的声明了一个 Int 类型的变量 a ，a 的值只能是初始值 0 ，不能被再次修改，一般结构：let (变量名):(类型) = (值)
```Swift
    a = 1
```
如果在写上面这句代码，编译器就会直接给出报错提示```Cannot assign to value: 'a' is a 'let' constant```, 所以在用```let```声明的变量，是不能被再次赋值，包括修改。这一点跟 OC 中的不可变类型有区别，OC 中是不能被修改，但是可以被重新赋值。

Swift 中声明一个变量是不是看起来很简单？对，入门很简单，But... 举几个例子：

```Swift
    let a = 0 // Int 类型的 0
    let a: Int = 0 // Int 类型的 0
    let a = 0.0 // Double 类型的 0
    let a: Float = 0 // Float 类型的 0
    let a: Double = 0 // Double 类型的 0
    let a = {
        return 0
    }()
```
为什么 ```let a = 0``` 是 ```Int``` 类型而 ```let a = 0.0``` 就是 ```Double``` 类型的呢？在 Swift 中有类型推断的机制，当你声明一个变量，如果没有指定类型，那么系统就会去推断这个变量是什么类型的。

### var

```var``` 所声明的变量统统为可变的变量。

```Swift
    var a: Int = 0
    a = 3
```
如果上面没有写 ```a = 3``` 那么系统会给出黄色提示 ```Variable 'a' was never mutated; consider changing to 'let' constant``` 提示你声明的是一个可变的变量而你没有修改它，建议用 ```let``` 修饰。

Swift 是类型安全的语言，所以在对类型的要求比较严格。如果你不需要修改变量那么就用 ```let``` 声明，如果你需要修改那么就用 ```var``` 声明。

同样举几个例子，跟 ```let``` 一样就不解释了

```Swift
    var a = 0 // Int 类型的 0
    var a: Int = 0 // Int 类型的 0
    var a = 0.0 // Double 类型的 0
    var a: Float = 0 // Float 类型的 0
    var a: Double = 0 // Double 类型的 0
    var a = {
        return 0
    }()
```

本篇只是简单介绍一下一个变量的声明方式，区分一下 ```let``` 和 ```var``` 的区别，什么时候用 ```let```，什么时候用 ```var```，对于那些希望从 OC 转向 Swift 语言开发的希望有些帮助。想要了解更多的 Swift 的知识请往下看。