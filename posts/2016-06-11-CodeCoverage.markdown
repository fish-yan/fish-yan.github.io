---
layout:     post
title:      "iOS 9 学习系列: Xcode Code Coverage"
subtitle:   "iOS 9 学习系列"
date:       2016-06-11 22:00:00
author:     "FishYan"
header-img: "img/blog-header.png" 
catalog:    true
tags:
    - iOS
    - iOS 9 新特性
---

# iOS 9 学习系列: Xcode Code Coverage

>Code coverage 是一个计算你的单元测试覆盖率的工具。高水平的覆盖给你的单元测试带来信心，也表明你的应用被彻底的测试过了。你可能写了几千个单元测试，但如果覆盖率不高，那么你写的这套测试可能价值也不大。
这里并没有一个确切的百分比，要求你必须到达这个覆盖率。这很大程度上取决于你的项目（的具体情况）。譬如说，如果你的项目中有很多不能写单元测试的视觉组件，那么覆盖率就会比单纯处理数据的框架要低的多。
## Code Coverage in Xcode

在过去，如果你想要制作一个测试的代码覆盖报告出来，需要设置很多[选项]。非常复杂，还有许多需要手动设置。在 iOS 9中，苹果提供了智能的代码覆盖工具，他是和 LLVM 一体的，每次运行测试都会被调用和计算。
## Using the Code Coverage Tools

现在我们用一个例子来展示，如何使用新的 code coverage 工具和怎样提升现在的测试用例。完成后的代码放在了 Github 上，你可以跟着做。
第一件事是创建一个新项目，并确认你选上了Unit tests选项。这会按要求创建一个默认项目，现我们需要测试点什么。这个测试可能是你的任意需求，这里我添加一个空的 swift 文件，里面写好了一个全局的方法。这个方法检测两个字母串是否是仅排序不同的相同字母组成的词。写成全局的方法，可能不是好的设计，但这里我们仅演示一下。
这是一个相对简单的方法，所以我们可能会得到一个没有任何问题的，100%覆盖的测试覆盖率。

![](http://upload-images.jianshu.io/upload_images/28255-89ba9ede100424ee.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240/q/100)
一旦你写好了算法，就该写个测试了。打开项目创建时已经创建好了的默认的XCTestCase,添加一个下面的简单的测试方法。他看起来是这样子的。


![](http://upload-images.jianshu.io/upload_images/28255-dddc1204c1597219.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240/q/100)
在运行测试之前，我们必须先确认 code coverage 是否被打开了，写代码时，默认是关闭的。所以你需要编辑一下你的测试 scheme，把它打开。

![](http://upload-images.jianshu.io/upload_images/28255-d2a146e38ddc692f.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240/q/100)
确保"Gather coverage data"是被选中的，然后点击关闭按钮，运行测试的 target. 我们希望刚刚创建的测试用例能够顺利通过。

## The Coverage Tab
一旦这个测试通过了，你就能知道 checkWord 这个方法，至少有一条路径是对的。但你不知道的是，还多多少没有被测试到。这就是code coverage这个工具的好处。当你打开code coverage tab后，你可以清楚的看到测试的覆盖情况。他们按找 target, file, function 进行了自动分组。
打开Xcode左边窗口的Report Navigator面板，选中你刚运行的测试。然后在tab中选中 Coverage。

![](http://upload-images.jianshu.io/upload_images/28255-49035818969f2e6b.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240/q/100)
这会展示一个你的类、方法的列表，并标示出每个的测试覆盖率。如果你将鼠标悬停在checkWord这个方法上，你可以看到测试的覆盖率是28%。不能接受啊！我们需要找到，那些代码分支是能够被测试执行，那些是不能的，进而改善他们。双击方法的名字，Xcode会打开类的代码，并且看到code coverage的情况。

![](http://upload-images.jianshu.io/upload_images/28255-924ae1927651386f.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240/q/100)
白色的区域表示这些代码时测试覆盖过的。灰色区域时测试无法覆盖的，我们需要添加更多的测试用例来覆盖灰色部分的代码。在右手边的数字，表明这些代码块，在这次测试中被执行的次数。
## Improving Coverage

很显然，28%的覆盖率不是我们的目标。这里没有 UI，看起来是个完美的编写测试用例的候选function。所以，我们添加一个测试用例。理想情况下，我们希望每个分支都能被测试到。这样就能达到完整的覆盖。添加下面的测试用例到你的测试类中。

![](http://upload-images.jianshu.io/upload_images/28255-21447319eaaab5a0.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240/q/100)
这些测试用例应该能够完全覆盖我们的代码了。运行一下单元，然后打开最后一个测试报告。

t![](http://upload-images.jianshu.io/upload_images/28255-3be8cf443c4e607d.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240/q/100)
我们成功了，100%的覆盖率。你可以看到整个代码都变成了白色，右面的数字也展示了每个代码段至少被执行了一次。
使用code coverage是一个非常棒的方式，帮你建立真正有价值的测试组合。远好于你写了很多测试用例，但没有真正测试到代码。Xcode 7 让这种方式变的非常简单，我推荐你在项目中开启 Code Coverage。即使你已经写好了测试，也可以帮你知道到底测试写的怎么样。

[Demo](https://github.com/fish-yan/XCode-Code-Coverage)