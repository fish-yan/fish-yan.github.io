---
layout:     post
title:      "iOS 9 学习系列: UI Testing"
subtitle:   "iOS 9 学习系列"
date:       2016-05-04 22:00:00
author:     "FishYan"
header-img: "img/blog-header.png" 
catalog:    true
tags:
    - iOS
    - iOS 9 新特性
---

》自动化测试用户界面工具对于开发软件来说是非常有用的，他可以快速的帮你定位到问题。一套成功的测试流程，可以为你最终发布软件带来信心。在iOS平台上，我们使用 Automation 来完成这个工作。这要打开一个单独的应用 Instruments，然后编写和运行 JavaScript 脚本。整个流程痛苦且漫长。

## UI Testing
在Xcode7中，苹果介绍了一种新的方式来管理你的应用界面的测试工作。UI testing 允许你对 UI 元素进行查找，交互，验证属性和状态。在 Xcode7 中，UI testing 伴随着测试报告，并且和单元测试一起运行。 XCTest 是在 Xcode 5 时融入到测试框架的，在Xcode7 中，新增了对 UI 的测试能力。允许在特定点设置断言，查看UI当时的状态。

## Accessibility（辅助功能）
为了 UI Testing 能够工作，框架需要和你的众多元素直接建立连接，然后安排好操作。你可以设定义特别的点，或者在某个 UI 上创建 tweak，然后指定点击或者滑动操作。但是这在不同尺寸设备上就失效了。

这时候 accessibility，就能提供帮助了。Accessibility 是苹果早就发布的一个框架，提供给有一定身体障碍（例如失明）的人使用，让他们能够操作和使用你的应用。他把你的 UI 以语义话的方式提供给这些用户，允许他们进行丰富的操作。你可以（也应该）让你的元素具备Accessibility的能力。有很多原因，比如说自定义的控件，不能够被自动发现。

UI Testing 有能力通过你的应用提供给 Accessibility 的特性，来对不同尺寸的设备进行测试提供解决方案。也保证了你在重新组织了一下你的 UI 之后，不必全部重新写一套测试。不仅能够帮助你测试自己的 UI，同时也能够对你的应用，更好的支持有一定身体障碍的人群使用而带来帮助。

## UI 录制
一旦你设置好了你的 accessible UI,你将要创建 UI 的测试项。编写 UI 的测试是非常耗时，无聊的，如果你的 UI 比较复杂，也是非常困难的。感谢 Xcode7, 苹果介绍了 UI Recording. 他允许你新建、或者在已有项目中创建测试。当你打开时，测试代码会随着你在设备或模拟器上操作自动创建。好了，简介到此结束，是时候用一个例子来看一下，如何使用了。

## 创建 UI 测试例子
我们将通过UI Testing套件来创建一个实例，展示 UI Testing 是如何工作的。最终的demo 可以在Github下载，你可以跟着我们一起来练习和查看结果。

## 创建
在Xcode7中，当你创建新项目时，如果选择包含 UI Tests，将会为你创建一个新的 target,你可以在弹出框中设置所有你想要的配置。


![](http://upload-images.jianshu.io/upload_images/28255-5effea79b7e379c0.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240/q/100)
本项目非常简单，但已经足够帮我们演示 UI Testing 在 Xcode 7 中是如何工作的了。


![](http://upload-images.jianshu.io/upload_images/28255-7e561197f4b76051.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240/q/100)
这里有一个 menuViewController,里面包含一个 switch 和一个 button。点击 button，可以 push 到  detailViewController 页面。当 switch 的状态为 off 的时候，是禁止 push 的。详细页面有一个按钮和一个标签，点击按钮可以增加标签的值。

## 使用 UI Recording
一旦UI控件创建好，并且写好了方法。我们就可以写测试单元，确保代码的变化，不会影响方法的效果。

## The XCTest UI Testing API
在我们录制测试的动作之前，我们需要决定断言放在哪里。为了能够测试我们的UI，我们可以使用 XCTest Framework，他现在扩充了三个新的 API。

**XCUIApplication** 这是你要测试的应用的代理，他能够把你的应用启动起来，并且每次都在一个新进程中。这可能会花一点儿时间，但这意味着每次要测试你的应用时，他都会把需要处理的工作完成，保持一个干净的，全新的状态。

**XCUIElement** 这是你要测试的应用的 UI 元素的代理。元素都有类型和唯一标识。你可以结合使用来找到你的元素在哪里，这些元素以树状结构组合，构成了你的应用的表现形式。

**XCUIElementQuery** 当你要要查找元素时，会用到 XCUIElementQuery, 每一个 XCUIElement 基于一个查询。这个查询必须在你的元素树上找到对应的元素，否则就会失败。异常信息会提示不存在，你可以去检查一下是否展现在树上了。XCUIElementQuery 具有通用性，如果你查找一个辅助功能支持的元素，查询会返回一组结果。

现在我们准备好写测试了，通过这个测试来进一步解释提到的这些API。

## Test 1 - 确保switch关闭时，导航不能生效
首先我们定义一个测试方法。
```swift
func testTapViewDetailWhenSwitchIsOffDoesNothing() {

}
```
定义好方法后，我们让光标移到方法中，点击Xcode窗口底部的录制按钮。


![](http://upload-images.jianshu.io/upload_images/28255-30f7c44e8ce4959f.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240/q/100)
现在应用启动起来了，点击一下 switch, 让其处于关闭状态，然后点击一下“View Detail”按钮，下面这些代码会自动插入到 `testTapViewDetailWhenSwitchIsOffDoesNothing`方法中.

>let app = XCUIApplication()
>
>app.switches["View Detail Enabled Switch"].tap()
>
>app.buttons["View Detail"].tap()

现在再点一下录制按钮，录制会停止下来。可以看到，实际上并没有 push 到 detailViewController 页面。但这时测试并不知道，我们要加个断言，判断一下没有变化。我们可以比较导航栏的标题值，这并不优雅，但当前演示就够了。

>XCTAssertEqual(app.navigationBars.element.identifier, "Menu")

添加了这一行断言后运行，发现测试还是能够通过。如果你把导航栏的标题改为“Detail”,你会发现测试通过不了了。下面试最终的测试代码，加了一些解释行为的注释。


![](http://upload-images.jianshu.io/upload_images/28255-503c3ce6b1c7343f.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240/q/100)
## Test 2 - 确保 switch 的状态为 on 时，导航可以正常工作
第二个测试前面的非常相似，我们就不细讲了。唯一的区别是switch是可用状态，所以应用会加载详细页面到屏幕上。XCTAssertEqual 方法来验证是否正确。


![](http://upload-images.jianshu.io/upload_images/28255-2afcf88665fc9b73.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240/q/100)
## Test 3 - 确保增长按钮确实增加了标签的值
在这个测试中，我们要验证点击了增长按钮，标签的值是否会加1.前两行代码和前面的例子很像，我们复制过来。
```
let app = XCUIApplication()

// Tap the view detail button to open the detail page.

app.buttons["View Detail"].tap()
```
下一步我们要得到button，我们将多点击几下。所以我们要把按钮作为一个变量。我们不必手写代码和 debug 他。再次录制并且点击一下 increase 的按钮，这会自动给你添加下面的代码。
```
app.buttons["Increment Value"].tap()
```
我们停止录制，把代码改成下面这样。
```
let incrementButton = app.buttons["Increment Value"]
```
这种方法，让我们不必手动编写代码，同样的方式，我们获的 lable 变量。
```
let valueLabel = app.staticTexts["Number Value Label"]
```
现在我们得到了能够交互的感兴趣的元素。下面这个测试中，我们测试点击10次 button 按钮，看标签的值是否随之增长。我们可以录制10遍，但既然我们得到了变量，我们可以写一个循环来测试它。


![](http://upload-images.jianshu.io/upload_images/28255-319679543d954f2f.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240/q/100)
这三个测试离一个完整的测试距离甚远，但给你展示了一个很好的开始，你可以轻松的扩展开来。为什么不写一个自己的测试练习一下呢。比如去验证一下 button 是 enable 的 时候，你可以在switch 关闭的情况下导航成功呢？

## 当录制发生错误时
有时候你发现你在录制的时候，点击了一个元素，但是产生的代码看起来不正确。通常这是由于你的元素对于 Accessibility 是不可用的。为了确定是否是这个原因，你可以打开Xcode的Accessibility Inspector。


![](http://upload-images.jianshu.io/upload_images/28255-3cf242155bcbf703.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240/q/100)
一旦打开Accessibility Inspector，如果你按下CMD＋F7，鼠标悬浮在元素上时，你可以在热点下面，看到完整的元素的信息。这能够在你找不到元素时给你提供一些线索。

一旦你找到问题所在，你可以打开 Interface Builder.在属性拦里找到 Accessibility 栏。他允许你设置元素的 accessibility。这是个强大的工具，设置你的图形接口的 accessibility 属性。


![](http://upload-images.jianshu.io/upload_images/28255-1770760c4de21ac5.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240/q/100)
## 当测试失败时
当测试失败时，如果你不确定为什么？有很多办法能够帮你修复错误。首先，你可以去测试报告里看一看。


![](http://upload-images.jianshu.io/upload_images/28255-da202eb4e3903d13.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240/q/100)
当你打开这个视图，将鼠标悬停在某一步上时，你会发现在方法的右面有一个小的眼睛图标。点击一下这个眼睛图标，会给你一个当时的截图，你能够清晰的看到当时你的UI的状态以便发现错误。

和单元测试一样，你可以设置断点，允许你更方便的发现问题。你可以输出UI的层次结构，元素的属性等，然后找到原因。

## 为什么要进行UI测试
UI自动化测试是一个很好的办法，为你在修改应用时，提高信心，并提供质量保证，。我们已经看到了，在 Xcode 中添加 UI 测试和运行是多么简单。他不仅帮助你发现问题，并且能够对有部分功能障碍的人使用你的应用提供帮助。

Xcode 的一个特别好的特性是，可以从 continuous integration server 来测试你的应用。这个可以利用 Xcode 的机器人来进行测试，并且 [from the command line](https://krausefx.com/blog/run-xcode-7-ui-tests-from-the-command-line) 意味着，如果一个测试失败，你会第一时间被通知到。

延伸阅读
想了解更多的关于UI Testing的内容，推荐你收看WWDC 2015的 session 406, [UI Testing in Xcode](https://developer.apple.com/videos/wwdc/2015/?id=406). 你可能也会对阅读文档[《Testing in Xcode Documentation》](https://developer.apple.com/library/prerelease/ios/documentation/DeveloperTools/Conceptual/testing_with_xcode/chapters/Introduction.html#//apple_ref/doc/uid/TP40014132)和[《Accessibility for Developers Documentation》](https://developer.apple.com/accessibility/)感兴趣。

[Demo](https://github.com/fish-yan/User-Interface-Testing)