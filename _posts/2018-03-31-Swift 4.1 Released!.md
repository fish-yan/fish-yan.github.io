---
layout:     post
title:      "Swift 4.1 Released!"
subtitle:   "Swift"
date:       2018-03-31 22:00:00
author:     "FishYan"
header-img: "img/blog-header.png" 
catalog:    true
tags:
    - iOS
    - Swift
---

>Swift 4.1现已正式发布！它包含核心语言的更新，包括对泛型，新构建选项的更多支持，以及对Swift Package Manager和Foundation的小改进。在稳定ABI方面也取得了重大进展。
>
>Doug Gregor和Ben Cohen最近在Swift Unwrapped播客的两部分集中讨论了许多这些功能。查看这里的播客：[第1部分][1]和[第2部分][2]。

## 编译器更新

Swift 4.1是一个小语言版本。它与Swift 4.0的源代码兼容。它包含以下语言更改和更新，其中大部分都通过了[Swift Evolution process][3]

## 语言改进
Swift 4.1为该语言增加了更多的泛型特性，进一步推进了[Swift Generics Manifesto][4]中提出的目标。以下与泛型相关的提案已在本版本中实施：

- [SE-0143 Conditional Conformance][SE-0143]
- [SE-0157 Support recursive constraints on associated types][SE-0157]
- [SE-0185 Synthesizing Equatable and Hashable conformance][SE-0185]
- [SE-0187 Introduce Sequence.compactMap(_:)][SE-0187]
- [SE-0188 Make Standard Library Index Types Hashable][SE-0188]
- [SE-0191 Eliminate IndexDistance from Collection][SE-0191]

有关在Swift 4.1中所取得进展的更多信息，请查看[此博客文章][5]。

## 构建改善

此版本提供了更多配置构建的方式，包括新的代码大小优化以及指定目标环境和平台支持的更简单的方法。

## 代码大小优化模式

编译器现在支持一种新的优化模式，该模式支持专用优化以减少代码大小。

这在[此博客文章][6]中更详细地讨论过。

## 构建导入测试

```canImport()```平台的参数可能不是所有平台上都存在。此条件下的测试不管是否导入模块，都不实际导入它。如果模块存在，则平台状况返回true; 否则，它返回false。

请参阅：[SE-0075 Adding a Build Configuration Import Test][7]和[Conditional Compilation Block ][8]。

## 目标环境条件

代码编译为模拟器时，```targetEnvironment(simulator)```平台条件返回true; 否则，它返回false。

有关更多信息，请参见：[SE-0190 Target environment platform condition][9] 和 [Conditional Compilation Block][10]。

## Foundation

这些JSONEncoder和JSONDecoder类现在支持在编码和解码期间转换密钥的新策略。

这个[论坛帖子][11]中有更详细的讨论。

## 其他更新

这些是在此版本中实施的其他Swift Evolution提议：

- [SE-0184 Unsafe[Mutable][Raw][Buffer]Pointer: add missing methods, adjust existing labels for clarity, and remove deallocation size][SE-0183]
- [SE-0186 Remove ownership keyword support in protocols][SE-0186]
- [SE-0189 Restrict Cross-module Struct Initializers][SE-0189]
- [SE-0198 Playground QuickLook API Revamp][SE-0198]

## ABI稳定性

Swift 4.1包含了许多内部变化，这些变化是稳定Swift 5中ABI的努力的一部分。以下是本版本中完成的任务列表：

- [在本地对象头中使用字大小字段进行引用计数（SR-4353）][SR-4353]
- [通过见证表（SR-4332）审查与枚举鉴别器交互的效率][SR-4332]
- [决定存在类型元数据的布局，包括协议描述符（SR-4341）][SR-4341]
- [定义对命令无关修改的通用和协议要求的规范化（SR-3733）][SR-3733]
- [审核每个运行时功能的合意性和行为（SR-3735）][SR-3735]
- [对Sequences和Collections 执行适当的限制（SR-3453）][SR-3453]
- [使用条件一致性（SR-3458）折叠各种收集包装][SR-3458]

有关Swift的ABI稳定性进度的更多信息，请查看[ABI仪表板][12]。

## 程序包管理器增强

在Swift 4.1中对Swift Package Manager有一些改进：

Swift Package Manager现在可以正确解决使用不同URL方案（例如ssh和）的软件包图形的依赖性http。对于具有共享依赖性的包图，性能得到了显着改善。

## 迁移到Swift 4.1

Swift 4.1与Swift 4.0是源代码兼容的。为了帮助从早期版本的Swift移植到Swift 4.1，Apple的[Xcode 9.3][13]包含一个代码迁移器，可以自动处理许多所需的源代码更改。还有一个[迁移指南][14]可用于指导您完成许多更改 - 特别是通过那些机械性较差并需要更直接审查的[迁移指南].

[1]: https://itunes.apple.com/us/podcast/50-swift-4-1-w-doug-ben-part-1/id1209817203?i=1000406832583&mt=2
[2]:https://itunes.apple.com/us/podcast/51-swift-4-1-w-doug-ben-part-2/id1209817203?i=1000407502590&mt=2
[3]:https://swift.org/contributing/#participating-in-the-swift-evolution-process
[4]:https://github.com/apple/swift/blob/master/docs/GenericsManifesto.md
[5]:https://swift.org/blog/conditional-conformance/
[6]:https://swift.org/blog/osize/
[7]:https://github.com/apple/swift-evolution/blob/master/proposals/0075-import-test.md
[8]:https://developer.apple.com/library/content/documentation/Swift/Conceptual/Swift_Programming_Language/Statements.html#//apple_ref/doc/uid/TP40014097-CH33-ID539
[9]:https://github.com/apple/swift-evolution/blob/master/proposals/0190-target-environment-platform-condition.md
[10]:https://developer.apple.com/library/content/documentation/Swift/Conceptual/Swift_Programming_Language/Statements.html#//apple_ref/doc/uid/TP40014097-CH33-ID539
[11]:https://forums.swift.org/t/jsonencoder-key-strategies/6958
[12]:https://swift.org/abi-stability/
[13]:https://swift.org/migration-guide/
[14]:https://swift.org/migration-guide/

[SE-0143]:https://github.com/apple/swift-evolution/blob/master/proposals/0143-conditional-conformances.md
[SE-0157]:https://github.com/apple/swift-evolution/blob/master/proposals/0157-recursive-protocol-constraints.md
[SE-0185]:https://github.com/apple/swift-evolution/blob/master/proposals/0185-synthesize-equatable-hashable.md
[SE-0187]:https://github.com/apple/swift-evolution/blob/master/proposals/0187-introduce-filtermap.md
[SE-0188]:https://github.com/apple/swift-evolution/blob/master/proposals/0188-stdlib-index-types-hashable.md
[SE-0191]:https://github.com/apple/swift-evolution/blob/master/proposals/0191-eliminate-indexdistance.md
[SE-0183]:https://github.com/apple/swift-evolution/blob/master/proposals/0184-unsafe-pointers-add-missing.md
[SE-0186]:https://github.com/apple/swift-evolution/blob/master/proposals/0186-remove-ownership-keyword-support-in-protocols.md
[SE-0189]:https://github.com/apple/swift-evolution/blob/master/proposals/0189-restrict-cross-module-struct-initializers.md
[SE-0198]:https://github.com/apple/swift-evolution/blob/master/proposals/0198-playground-quicklook-api-revamp.md
[SR-4353]:https://bugs.swift.org/browse/SR-4353
[SR-4332]:https://bugs.swift.org/browse/SR-4332
[SR-4341]:https://bugs.swift.org/browse/SR-4341
[SR-3733]:https://bugs.swift.org/browse/SR-3733
[SR-3735]:https://bugs.swift.org/browse/SR-3735
[SR-3453]:https://bugs.swift.org/browse/SR-3453
[SR-3458]:https://bugs.swift.org/browse/SR-3458