---
layout:     post
title:      "Swift编程规范之 Documentation/Comments"
subtitle:   "Swift"
date:       2016-12-29 22:00:00
author:     "FishYan"
header-img: "img/blog-header.png" 
catalog:    true
tags:
    - iOS
    - Swift
---

# Swift编程规范之 Documentation/Comments

Documentation/Comments

## 1 Documentation

如果某个函数不是简单地O(1)操作，那么最好就是为该函数添加一些注释文档，这样能有效地提高代码的可读性与可维护性。之前有个非常不错的文档工具VVDocumenter。推荐阅读Apple的官方指南中的描述：described in Apple's Documentation.

Guidelines:

- 1.1 每行不应超过160个字符

- 1.2 即使某些注释只有一行，也应该使用块注释符： (/** */).

- 1.3 不用给每行的开头都加上： *.

- 1.4 使用新的 - parameter 标识符来代替老的:param: syntax (注意这边是小写的 parameter 而不是Parameter).

- 1.5 如果你准备对参数/返回值/异常值来写注释，那么注意要一个不落的全局加上，尽管有时候会让文档显得重复冗余。有时候，如果只需要对单个参数进行注释，那么还不如直接放在描述里进行声明，而不需要专门的为参数写一个注释。

- 1.6 对于复杂的使用类，应该添加一些具体的使用用例来描述类的用法。注意Swift的注释文档中是支持MarkDown语法的，这是一个很好的特性。
```swift
/**
 ## Feature Support
 This class does some awesome things. It supports:
 - Feature 1
 - Feature 2
 - Feature 3
 ## Examples
 Here is an example use case indented by four spaces because that indicates a
 code block:
     let myAwesomeThing = MyAwesomeClass()
     myAwesomeThing.makeMoney()
 ## Warnings:告警
 There are some things you should be careful of:
 1. Thing one
 2. Thing two
 3. Thing three
 */
class MyAwesomeClass {
    /* ... */
}
```
- 1.7 使用 - ` 在注释中著名引用的代码
```swift
/**
 This does something with a `UIViewController`, perchance.
 - warning: Make sure that `someValue` is `true` before running this function.
 */
func myFunction() {
    /* ... */
}
```
- 1.8 保证文档的注释尽可能的简洁

## 2 Other Commenting Guidelines:其他的注释规则

- 2.1 //后面总是要跟上一个空格

- 2.2 注释永远要放在单独的行中

- 2.3 在使用// MARK: - whatever的时候，注意MARK与代码之间保留一个空行
```swift
class Pirate {
    // MARK: - instance properties
    private let pirateName: String
    // MARK: - initialization
    init() {
        /* ... */
    }
}
```