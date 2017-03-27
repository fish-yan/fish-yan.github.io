---
layout:     post
title:      "Swift 4 进入最后阶段， 推迟API稳定"
subtitle:   "Swift"
date:       2016-12-25 22:00:00
author:     "FishYan"
header-img: "img/blog-header.png" 
catalog:    true
tags:
    - iOS
    - Swift
    - Translation
---

## Swift 4 进入最后阶段， 推迟API稳定

苹果公司详细介绍了[Swift 4 的发布流程](1)，该版本应该在2017年秋季发布。Swift 4 的主要重点任务是在提供源代码兼容性的同时，对核心语言和标准库进行显著增强。Ted Kremenek解释说，最初在计划中的ABI兼容性将被推迟，他将取代Chris Lattner成为苹果Swift团队的项目负责人。

由于Swift 3 包含的更改数量太多，Swift 4 将无法与Swift 3 进行正确的源代码兼容。但是，自 Swift 以来编译器将首次支持兼容性模式，除了那些 Swift 4 中被修正的只有老编译器接受的错误代码之外，-swift-version-3 应该能够编译绝大多数Swift 3 源代码。该-swift-version-4模式将支持计划中做列出的所有新功能。重要的是，在使用相同的编译器进行编译的前提下，Swift编译器将能够把使用上述模式编译的框架和模块链接在一起。

[Kremenek还表示](2)，推迟 Swift 4 ABI 稳定性，是为了避免在基本面正确之前就宣布ABI稳定的风险。

克雷斯•莱特纳（Chris Lattner）是克莱梅内克（Kremenek）公布的原始语言创作者：[评论](3)

> 考虑到我们今年的时间表，我认为这是一个务实的决定。ABI的稳定性对于大多数开发人员来说对于苹果来说要重要得多，所以我很高兴看到您正在优先考虑社区的需求（改进的编译时间，编译器的稳定性等），特别是考虑到对于Swift长期成功的正确的事情。

延迟ABI稳定性目标并不意味着ABI稳定的工作已经停止，Lattner表示希望所有ABI稳定性要求在Swift 5开发的早期阶段得到巩固。Kremenek将很快公布一个ABI稳定性计划表，其中将显示所有剩余任务的清单，以宣布ABI稳定及其状态。

进入第二阶段意味着在发布中被接受的变更条件会更高。例如，任何新的语法/ API必须比现有语法明显更好，影响源兼容性的任何更改都必须具有现有代码等的迁移路径。所有开发将在master分支中进行，直到发布管理器创建最终分支，大概在2017年初的夏天release版本只会选择行的做修复工作。


[1]: https://swift.org/blog/swift-4-0-release-process/ "Swift 4 发布流程"
[2]: https://lists.swift.org/pipermail/swift-evolution/Week-of-Mon-20170213/032116.html "Kremenek还表示"
[3]: https://lists.swift.org/pipermail/swift-evolution/Week-of-Mon-20170213/032145.html "评论"