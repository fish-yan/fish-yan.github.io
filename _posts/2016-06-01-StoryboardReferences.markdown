---
layout:     post
title:      "iOS 9 学习系列: Storyboard References"
subtitle:   "iOS 9 学习系列"
date:       2016-06-01 22:00:00
author:     "FishYan"
header-img: "img/blog-header.png"
tags:
    - iOS
    - iOS 9 新特性
---


>如果你曾经使用 interface builder 创建过一个复杂、界面非常多的应用，你就会明白最后那些Storyboards 文件变的有多大。他会迅速变的无法管理，阻碍你的进度。自从引入 Storyboard 以来，其实是可以把你的应用的不同模块切开到不同的 Storyboard 中的。在过去，这要手动创建多个 Storyboard 文件，并且要写大量的代码。

为了解决这个问题，在 iOS 9 中苹果介绍了 Storyboard References 这个概念。Storyboard References 允许你从 segue 中引用其他 storyboard 中的 viewController。这意味中你可以保持不同功能模块化，同时 Storyboard 的体积变小并易与管理。不仅容易理解了，和团队一起工作时，合并（工作成果）也变的简单了。

## 简化 Storyboard
为了演示Storyboard References是如何工作的，让我们拿一个创建好的应用，并试着简化一下他的结构。这个有问题的应用已经上传到了 Github 上，如果你希望跟着做，并且看到最后的结果。以 OldMain.Storyboard 命名的文件是我们的最初文件。在这个项目中仅仅是被引用进来，我们并没有用它。如果你想从头开始跟着做，删除所有其他的 storyboard，然后把 OldMain.Storyboard 文件改为 Main.Storyboard.

下面的截图，是原来的 Storyboard 的样子。




![](http://upload-images.jianshu.io/upload_images/28255-a8ba0b3eb5f8c08d.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240/q/100)
正如你们看到的，我们使用了 TabBarController 作为初始的 viewController.这个 TabBarController 拥有三个 navigationController,每个对应一个不同的根 viewController。第一个是个 tableViewController,有一个联系人列表，第二个也是一个 tableViewController，是收藏的联系人列表。这两个都链接到一个详细页的 viewController 上。第三个 navigationController,包括了更多的信息，一个账户详细页，一个反馈页和一个关于页。

尽管应用还远称不上复杂，但是这个 Storyboard 已经非常大了。我们至少看到10个以上的 viewController，我们明白，很快就会变的难以管理。现在我们可以拆开他们了，那么从哪里开始呢？这个例子中，我们有三个不同的模块。我们可以清楚地在 tabBarController 上辨别出他们来。

我们从最简单的开始，在 Main.storyboard 的右手边，你可以看到这个给应用提供更多信息的 viewController,他是单独的，不和其他的 viewController 有链接。

我们要做的是，通过拖动选中他们（高亮显示），然后点击 Xcode 的菜单栏，选择"Editor->Refactor to Storyboard"。




![](http://upload-images.jianshu.io/upload_images/28255-3cfdd0f09e8814fb.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240/q/100)
给这个 storyboard  起个名字叫 More.storyboard 然后点击保存。More.storyboard 就会自动添加到应用中，并且处于打开状态。




![](http://upload-images.jianshu.io/upload_images/28255-5efc719b706d98ca.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240/q/100)
你可以看到 storyboard 已经创建成功了。这个时候，如果你返回到 Main.storyboard 你可以看到tabBarController 其中的一个 viewController 已经变了，变成了一个指向 storyboard 的引用。




![](http://upload-images.jianshu.io/upload_images/28255-d314a7e730d9929d.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240/q/100)
太棒了。我们把整个一部分的 UI 划分到了另外一个 storyboard 中。不仅分割开了模块，并且能够在其他地方复用。虽然在我们这个例子中用不着，但他是非常有用，有价值的新特性。

现在我们要把其他的模块也分拆开，这要比前面一步复杂一点儿，因为事实上这两部分链接了同一个viewController。两个 TableView 都通过一个 segue 展示联系人详细信息页。你可以选择怎么做？

>保持 viewController 在 Main.storyboard

>重构 viewController到自己的 storyboard

两种选择都可以，我个人倾向于把他们分开。所以选中详细页 viewController 然后点击 Xcode 的菜单“Editor->Refactor to Storyboard”. 给新的 storyboard 取个名字，并保存。这会创建并打开一个新的 storyboard。他会链接到联系人页和收藏的联系人页的 tableViewController 中。

现在回到 Main.storyboard 去，选中 navigation 和联系人的 tableViewController,把他们创建为新的 storyboard 引用。同样的方法把收藏的 viewController 也操作一遍。下面是操作后的结果。




![](http://upload-images.jianshu.io/upload_images/28255-b4b4e0afd643cd4f.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240/q/100)
我们在项目中把 Main.storyboard 拆分为了5个 storyboard。

- Main.storyboard 包含一个 tabBarController 和三个链接到其他 storyboard 的 controller

- Contacts.storyboard 一个导航栏和一个tableViewController，当点击一行时，链接到ContactDetails.storyboard

- Favorites.storyboard 一个导航栏和一个tableViewController，当点击一行时，链接到ContactDetails.storyboard

- ContactDetail.storyboard  单独的viewController展示联系人的详细信息，并且可以链接到 Contact 和 favorite 的 storyboard 中

- More.storyboard 包括一个viewController，展示关于 app 的更多信息。

这个重构让我们的 storyboard 变的更加的模块化、组件化。可以帮助我们后面更好的开发这个应用。

## 从 Storyboard Reference 中打开一个特定的 viewController
到现在为止，我们只是分享了怎么从 storyboard 的 segue 中创建和展示 storyboard reference，还没有展示不用重构工具的情况下，如何手动添加 storyboard。

假设，我们要在联系人页的右上角添加一个“account”按钮，点击这个按钮可以快速的到达账户页查看更多信息，而无需去到设置页面里点击。

打开 Contacts.Storyboard, 拖拽一个 UIBarButtonItem 到 tableViewController 的导航栏上，把 title 设置为 “Account”。然后，找到“Storyboard Reference”控件，拖拽一个到 Contacts Storyboard上来。并且打开 attributes inspector 面板。

把 Storyboard 属性选为“more”，把 Referenced ID 属性设置为“accountViewController”。这允许我们引用账号信息页的 viewController,而不是链接到 more storyboard 的初始 view controller上。




![](http://upload-images.jianshu.io/upload_images/28255-d1fd3c32d0d474b5.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240/q/100)
选中“account”的按钮，按住 Control 健和鼠标左键，拖拽到 storyboard reference上，这样就创建了一个 segue。




![](http://upload-images.jianshu.io/upload_images/28255-c1111d5eba3c5f2c.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240/q/100)
最后一步是，设置 accountViewController 的 identifier。打开 More.storyboard 选中 accountViewController，打开 identity inspector 设置 Storyboard ID 为 “accountViewController”。这样，当你点击 account 按钮时，就会转到账号的详细页面去。

如果所见，添加 Storyboard Reference，无论是通过重构工具还是手动添加都非常简单、直接、有效。他允许你创建更加组件化、可复用化、模块化的应用。最后，这个指南的最终结果可以在Github 上查看。

延伸阅读
查看更多关于 Xcode 7 的 Storyboard References 的内容，可以观看 WWDC 2015 的 session 215. [What's New in Storyboards](https://developer.apple.com/videos/wwdc/2015/?id=215)。前20分钟讲的正是 Storyboard References 的内容。