---
layout:     post
title:      "Swift 3.1 更新了什么"
subtitle:   "Swift"
date:       2017-04-07 22:00:00
author:     "FishYan"
header-img: "img/blog-header.png" 
catalog:    true
tags:
    - iOS
    - Swift
---

# Swift 3.1 更新了什么

> Swift 3.1 于3月27发布更新，是一个小版本更新，其中主要包含对标准库的改进，Swift对Linux的更新，和Swift软件包管理器的更新。


## 语言更新

Swift 3.1 属于小版本更新，兼容 Swift 3.0 版本，但是 Xcode 8.3 已经不再支持 Swift 2.3 。

它主要包含以下更新，主要是对 [Swift Evolution Process](https://swift.org/contributing/#participating-in-the-swift-evolution-process) 的更新

### 新增Sequence协议成员

该Sequence协议现在有两个新成员：

```swift
protocol Sequence {
  // ...
  /// Returns a subsequence by skipping elements while `predicate` returns
  /// `true` and returning the remainder.
  func drop(while predicate: (Self.Iterator.Element) throws -> Bool) rethrows -> Self.SubSequence
  /// Returns a subsequence containing the initial elements until `predicate`
  /// returns `false` and skipping the remainder.
  func prefix(while predicate: (Self.Iterator.Element) throws -> Bool) rethrows -> Self.SubSequence
}
```

这两个函数的意思正好相反，

prefix(while:) 返回满足某 predicate 的最长子序列。从序列的开头开始，并且在第一个从给定闭包中返回 false 的元素处停下。

drop(while:) 做相反的操作：从第一个在闭包中返回 false 的元素开始，直到序列的结束，返回此子序列。

举例：
```Swift
let array = [1,5,3,7,4,6,5,8,9,10]

let interval = array.prefix(while: {$0 < 6})

print(interval) // [1, 5, 3] 遇到 7 > 6 return false 时停止

let interval1 = array.drop(while:  {$0 < 6})

print(interval1) // [7, 4, 6, 5, 8, 9, 10] 遇到 7 > 6 return false 时开始
```

请参见：[SE-0045：Add prefix(while:) and drop(while:) to the stdlib](https://github.com/apple/swift-evolution/blob/master/proposals/0045-scan-takewhile-dropwhile.md)

### Swift3.1扩展了@availability
Swift 3.1将@availability属性扩展为使用Swift版本来指示声明的使用范围。例如，在Swift 3.1中删除的API将被写为：

```swift

@available(swift, obsoleted: 3.1)
class Foo {
  //...
}

```
查看更多：[SE-0141：Availability by Swift version](https://github.com/apple/swift-evolution/blob/master/proposals/0141-available-by-swift-version.md)

### 改进的数字转换初始化器
Swift 3.1 为所有的数字类型 (Int, Int8, Int16, Int32, Int64, UInt, UInt8, UInt16, UInt32, UInt64, Float, Float80, Double) 实现了可失败初始化方法，要么完全成功、不损失精度，要么返回 nil ；

举个例子：
```Swift
let a: Double = 2.22

let b = Int(exactly: a) // nil, Swift 3.1 新增

let c = Int(a) // 2
```

请参见：[SE-0080：Failable Numeric Conversion Initializers](https://github.com/apple/swift-evolution/blob/master/proposals/0080-failable-numeric-initializers.md)

### 废弃和替换UnsafeMutablePointer.initialize（from :)

将采用 Collection 的 UnsafeMutablePointer.initialize(from:) 替换为采用 Sequence 的  UnsafeMutableRawBufferPointer.initialize(as:from:) 以提高内存安全性和实现更快的存储速度

查看更多在：[SE-0147：Move UnsafeMutablePointer.initialize(from:) to UnsafeMutableBufferPointer](https://github.com/apple/swift-evolution/blob/master/proposals/0147-move-unsafe-initialize-from.md)


### 改进Linux实现

- 实现 NSDecimal
- 实现 NSLengthFormatter
- 实现 Progress
- 对URLSession的功能进行较多的改进，包括 API 和 优化 libdispatch 的使用。
- 改进API包含NSArray，NSAttributedString等
- 显着提高 Data 性能。[查看更多细节](https://github.com/apple/swift-corelibs-foundation/blob/master/Docs/Performance%20Refinement%20of%20Data.md)
- 改进 JSON 序列化性能
- 固定内存泄漏 NSUUID，NSURLComponents 等
- 改进的单元测试，尤其是 URLSession

## 软件包管理器更新

**可编辑包**

默认情况下，软件包依赖文件是放在工具管理的目录中，新的swift package edit命令允许用户在软件包上进行编辑，并让用户控制（在Packages目录），免除依赖关系更新，并允许用户提交并将更改推送到该包。

查看更多信息：[SE-0082： Package Manager Editable Packages](https://github.com/apple/swift-evolution/blob/master/proposals/0082-swiftpm-package-edit.md)

**版本锁定**

您使用的每一个依赖包的版本都会记录在Package.pins文件中，可以签入，以便与其他用户共享这个版本的依赖包; 可以通过 swift package pin和swift package unpin 进行控制。在解析依赖关系时，默认情况下取消包的依赖关系的固定版本，但 swift package update 会为你的项目添加最新的依赖包。

请参见：[SE-0145：Package Manager Version Pinning](https://github.com/apple/swift-evolution/blob/master/proposals/0145-package-manager-version-pinning.md)

**工具版本**

软件包现在可以指定所需Swift工具的最低版本。该要求可以用swift package tools-version命令编辑，并记录在 Package.swift 的顶部。相对于那些将要被忽略的依赖，软件包版本需要新的 Swift 工具，因此软件包可以采用新的Swift功能，而不会破坏正在使用旧版Swift工具的客户端。所需的最低工具版本决定了哪些Swift语言版本用于编译 Package.swift ，以及哪个版本的 PackageDescription API可用。

查看更多信息：[SE-0152：Package Manager Tools Version](https://github.com/apple/swift-evolution/blob/master/proposals/0152-package-manager-tools-version.md)

**Swift语言兼容版本**

软件包现在可以指定它们的来源是以Swift 3或Swift 4语言版本编写的。如果未指定，则从软件包的最小Swift工具版本推断出默认值。

查看更多信息：[SE-0151：Package Manager Swift Language Compatibility Version](https://github.com/apple/swift-evolution/blob/master/proposals/0151-package-manager-swift-language-compatibility-version.md)

**其他包管理器改进**

- 修正了以前版本所存在的一些问题。在构建过程中检测依赖关系周期，并且尽可能少的修改源文件。

- swift test现在支持--parallel标签并行运行测试。swift build，swift test和swift package命令现在支持--enable-prefetching标签并行地获取这些依赖关系。

可以在文档库中找到[Swift Package Manager](https://github.com/apple/swift-package-manager/tree/swift-3.1-branch/Documentation)。

## 迁移到Swift 3.1

Swift 3.1与Swift 3.0兼容。为了帮助从Swift的早期版本迁移到Swift 3.1，Xcode 8.3包含一个代码迁移器，可以自动处理大多需要修改的源代码。还有一个[迁移指南](https://swift.org/migration-guide/)来指导您完成其他的修改。





