---
layout: "post"
title: "为什么加了 async 还是卡 UI？从调用者隔离理解 Swift 并发"
subtitle: "用代码对照 async 函数是否占用 MainActor"
description: "async 不会自动把同步计算移到后台。通过特性开关对照和可运行示例，区分调用者隔离、模块默认隔离与真实 UI 性能验证。"
date: "2026-10-21 09:00:00 +0800"
author: "FishYan"
header-img: "img/blog-header.png"
catalog: true
tags: ["iOS", "Swift", "Swift Concurrency", "性能优化"]
---

`@MainActor` 方法里的同步计算，即使加了 `async`、外面再包一层 `Task`，也可能继续占用 MainActor。要把这段工作移出去，需要检查函数的隔离声明和编译设置。

## 1. 先看一段容易误判的代码

```swift
@MainActor
final class PageModel {
    private(set) var checksum = 0

    func reload() {
        Task {
            checksum = await calculateOnMainActor()
        }
    }

    private func calculateOnMainActor() async -> Int {
        (0..<5_000_000).reduce(0, &+)
    }
}
```

这里确实创建了任务，也确实调用了异步函数。但是，`PageModel` 隔离到 MainActor，方法中的 `Task` 保留了相应的 actor 上下文；计算方法同样受该类的隔离约束。循环执行期间没有真正让出执行机会，工作仍然占用 MainActor。`Task` 的上下文继承规则可参考 [Swift 并发语言指南](https://github.com/swiftlang/swift-book/blob/main/TSPL.docc/LanguageGuide/Concurrency.md)。

这个示例通过了类型检查。循环次数只用于展示一段连续同步计算，不代表任意设备都能观察到相同程度的卡顿。

## 2. async、await 与耗时位置

`async` 表示函数可以参与异步调用；`await` 标记潜在的挂起点，并不保证每次调用都会挂起。有关挂起点的语言定义见 [SE-0296](https://github.com/swiftlang/swift-evolution/blob/main/proposals/0296-async-await.md)。

假设页面处理数据的流程是：

```text
等待响应 → 解析数据 → 排序与转换 → 更新页面状态
```

即使等待响应的阶段能让出执行机会，后面的同步工作仍需要单独检查。网络请求完成只是一个节点，不能证明解析和排序也离开了 MainActor。

沿这条调用链查找 `decode`、`sorted`、`map` 等同步操作，确认它们所在方法的隔离声明。请求已经结束、页面却迟迟不更新时，解析和转换阶段也需要采样。

## 3. 普通 nonisolated async 的行为需要看配置

按照 [SE-0338](https://github.com/swiftlang/swift-evolution/blob/main/proposals/0338-clarify-execution-non-actor-async.md) 描述的规则，非 actor 隔离的异步函数使用通用执行器，不在某个 actor 的执行器上运行。这里说的是执行器语义，不能据此承诺固定后台线程。

[SE-0461](https://github.com/swiftlang/swift-evolution/blob/main/proposals/0461-async-function-isolation.md) 在 Swift 6.2 引入新的选择：启用 `NonisolatedNonsendingByDefault` 后，普通 `nonisolated async` 默认保留调用者的隔离；`nonisolated(nonsending)` 可显式表达这一行为，`@concurrent` 可显式要求切离调用者的 actor。

下面三种函数都从 **MainActor** 调用，模块默认隔离设置为 `nonisolated`。比较的是：开关变化后，函数里的同步代码是否继续占用 MainActor。

| 函数声明 | 关闭 `NonisolatedNonsendingByDefault` | 开启 `NonisolatedNonsendingByDefault` |
|---|---|---|
| `nonisolated func ... async` | 离开 MainActor 执行 | 留在 MainActor 执行 |
| `nonisolated(nonsending) func ... async` | 留在 MainActor 执行 | 留在 MainActor 执行 |
| `@concurrent func ... async` | 离开 MainActor 执行 | 离开 MainActor 执行 |

第一行会随开关改变；后两行显式指定了行为。开启该特性时，只给耗时函数加 `nonisolated async`，仍不能让它离开调用者的 MainActor。

这些结果由下一节的 `#isolation` 输出核对：`Optional(Swift.MainActor)` 表示观察到 MainActor 隔离，`nil` 表示没有 actor 隔离。后者不承诺固定的后台线程。

还有一个独立设置需要区分：[SE-0466](https://github.com/swiftlang/swift-evolution/blob/main/proposals/0466-control-default-actor-isolation.md) 的模块默认隔离，决定未显式标注的声明如何推断。它与普通非隔离异步函数如何执行是两个问题。接手工程时，至少记录语言模式、Default Actor Isolation 和相关特性开关，不根据某个 Xcode 模板猜测整个工程。

核对耗时函数所属 target 的有效构建参数，不要只检查 App 主 target；计算可能位于另一个模块。

## 4. 用一个小探针确认边界

```swift
import Foundation

nonisolated func implicitWork() async {
    let isolation: (any Actor)? = #isolation
    print("implicit:", isolation as Any)
}

nonisolated(nonsending) func callerBoundWork() async {
    let isolation: (any Actor)? = #isolation
    print("caller-bound:", isolation as Any)
    MainActor.assertIsolated()
}

@concurrent func concurrentWork() async {
    let isolation: (any Actor)? = #isolation
    print("concurrent:", isolation as Any)
}

@main
struct IsolationProbe {
    @MainActor
    static func main() async {
        await implicitWork()
        await callerBoundWork()
        await concurrentWork()
    }
}
```

开启特性时，本机输出为：

```text
implicit: Optional(Swift.MainActor)
caller-bound: Optional(Swift.MainActor)
concurrent: nil
```

将启用参数替换为 `-disable-upcoming-feature NonisolatedNonsendingByDefault`，第一行变成 `implicit: nil`，后两行不变。

## 5. 把纯计算与页面状态分开

对已经确认耗时的解析逻辑，可以让并发边界围绕输入和输出建立，而不是捕获整个页面对象：

```swift
import Foundation

nonisolated struct Report: Decodable, Sendable {
    let total: Int
}

nonisolated enum ReportParser {
    @concurrent
    static func parse(_ data: Data) async throws -> Report {
        let report = try JSONDecoder().decode(Report.self, from: data)
        return report
    }
}

@MainActor
final class ReportModel {
    private(set) var report: Report?

    func load(data: Data) async throws {
        let parsed = try await ReportParser.parse(data)
        report = parsed
    }
}
```

这个示例的职责划分很直接：解析函数接收数据、创建局部解码器、返回值；页面模型在自身隔离域更新状态。

