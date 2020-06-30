---
layout:     post
title:      "iOS 9 学习系列: Search APIs"
subtitle:   "iOS 9 学习系列"
date:       2016-03-27 22:00:00
author:     "FishYan"
header-img: "img/blog-header.png" 
catalog:    true
tags:
    - iOS
    - iOS 9 新特性
---

>在 iOS9 之前，你只能在 spotlight 中输入关键字，比如应用名字，搜索到应用。在 iOS9 中苹果提供了一套 Search APIs。允许开发者选择应用的内容，索引起来供 spotlight 进行搜索，同时可以设置在 spotlight 中的展示效果，以及点击之后如何响应。

## 3个新的搜索相关API

- NSUserActivity

NSUserAcitivity 在介绍 iOS8 的 Handoff 时引入，iOS9 中允许对这些 activities 进行搜索。你可以提供元数据给这些 activities, 这意味着Spotlight 可以索引这些内容。类似于浏览器展示网页的做法（你打开过的历史页面被记录了下来），用户可以快速的在 Spotlight中搜索，打开最近的 activities。

- Web Markup

Web Markup 允许应用镜像自己的内容，并在 Spotlight 中建立索引。用户并不需要应用安装在自己的设备上来展示搜索结果。苹果的爬虫自己去抓取你网站上打了 markup 的内容，这些内容稍后会提供给 Safari 和 Spotlight。

事实上，这个重要的特性，甚至并不需要用户安装了你的应用在自己的设备上。这样可以将你的应用展示给更多的潜在用户。苹果的云服务，将你的应用的内容索引起来，让你的应用和 public Search APIs 保持一个深度连接。更多关于Web Markup 的内容，可以阅读苹果官方的文档 《Use Web Markup to Make App Content Searchable》。

- CoreSpotlight

CoreSpotlight 是 iOS9 提供的新 Freamework，允许你索引你的应用内容。当使用它的 Api，你可以方便的将你喜欢的数据，索引起来，NSUserActivity  帮助存储用户的使用历史。它让你的应用可以底层的和 CoreSpotlight 进行连接，将索引存储在用户设备上。

- 使用 Core Spotlight APIs

NSUserActivity 和 Markup 更简单和容易使用一些， CoreSpotlight 则相对复杂一些。为了示范Core Spotlight APIs 是怎么工作的，让我们来创建一个简单的应用。这个应用展示我的一个朋友列表，点击朋友的名字可以查看照片。你可以在 [Github](https://github.com/fish-yan/Search-APIs) 上找到源文件。

![](http://upload-images.jianshu.io/upload_images/28255-b86ccb99330bd0a7.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240/q/100)


这个应用有一个简单的 storyboard, 包含两个 controller,  FriendTableViewController 展示一个列表，每行显示一个朋友的名字， FriendViewController 展示朋友的详细信息。

![](http://upload-images.jianshu.io/upload_images/28255-e07e8c2bffcd1c62.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240/q/100)

首先，我们重载 Datasource 类的 init() 方法，创建和存储一个包含 Person 对象的数组。你可能希望从数据库中，或者你的服务器加载数据，这里只是为了展示，所以我们选择创建简单的模拟数据。

![](http://upload-images.jianshu.io/upload_images/28255-c64854bb29e32eba.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240/q/100)

一旦数据存储到了 People 这个数组中，Datasource 类就准备好可以用了。

现在数据准备好了，在FriendTableViewController 中创建一个 instance, 给 table 的 cell 来展示数据。

![](http://upload-images.jianshu.io/upload_images/28255-a4dab3d663f18550.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240/q/100)


在 cellForRowAtIndexPath 方法中，展示内容

![](http://upload-images.jianshu.io/upload_images/28255-bebd7de32f93d523.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240/q/100)

现在，模拟数据已经准备好了。我们用 iOS9 提供的新 API  把他们存储到 Core Spotlight 中。回到Datasource 类中，我们创建一个 savePeopleToIndex 方法。这个可以在FriendTableViewController的视图加载完成后调用。

![](http://upload-images.jianshu.io/upload_images/28255-9e9dc06c68000c92.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240/q/100)

最后一步是调用 CSSearchableIndex的indexSearchableItems 方法。它会真正的把 items 存储到CoreSpotlight 中，这样用户就可以搜索和展示出结果了。

![](http://upload-images.jianshu.io/upload_images/28255-750dbe46adb05d5a.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240/q/100)

好了，当你运行一下你的应用后，数据就索引起来了，当你在 spotlight 中搜索时，朋友的信息出来了。

![](http://upload-images.jianshu.io/upload_images/28255-55ad1796a64a11b5.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240/q/100)

响应用户的选中事件

现在用户看到了搜索的结果，希望他们会点击一下。但是，如果现在他们点击了，会怎么样呢？只会打开你的应用。如果你希望跳转至展示用户点击的朋友的详细信息，你还需要再做一点点工作。当用户用点击的方式打开应用时。，我们可以通过 UIApplicationDelegate 中的continueUserActivity，具体规定应用的行为。

![](http://upload-images.jianshu.io/upload_images/28255-abb9ecbaf9165b18.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240/q/100)

如你所见，我们之前，通过 indexSearchableItems 方法，存储在 CoreSpotligh t中的信息，现在可以让 userActivity.userInfo 字典使用了。我们唯一感兴趣的是 friend ID, 之前我们 items 的 kCSSearchableItemActivityIdentifier 存储在了索引中。

一旦我们从 userInfo 字典中拿到数据，我们找到应用的 navigation controller, 然后退到root（不用动画，以免用户察觉异样），然后调用 showFriend 方法。我不详细讲这些了。总之，大体上就是根据 friend ID, 找到 friend 的详细信息的数据，然后 push 了一个新的 ViewController 来展示他。这就是所有的操作了，现在，当用户点击一个结果时，应用被打开，同时到了这个朋友的详细页面。

![](http://upload-images.jianshu.io/upload_images/28255-2ff1b2b485ae307a.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240/q/100)

如你所见，在应用左上角有一个“回到搜索”的按钮，可以让用户直接快速的返回到Spotlight，当然也可以在应用中，点击标准按钮，来切换页面。

Demo 总结

在上面的demo中，我们展示了，多么简单就可以把应用的内容索引到 CoreSpotlight 中，对于用户搜索特定内容多么有帮助，多么强大的吸引用户打开你的应用。

我们没有展示如何从索引中移除数据。这对你来说很重要，要时刻保持 spotlight 中的数据是最新的。要了解怎么移除旧的数据，可以翻阅相关文档，查看deleteSearchableItemsWithIdentifiers, deleteSearchableItemsWithDomainIdentifiers 和 deleteAllSearchableItemsWithCompletionHandler这三个方法。

好公民准则的重要性

看起来存储尽可能多的内容到 Spotlight 和 Safari 中是个好主意，但是希望大家能够在 iOS 的生态系统中做个好公民，遵守让用户高兴的准则。并且 Apple 也会注意到你的行为，他们设置了相关的规则，一旦发现恶意的使用 Spotlight，你的内容很容易被移到搜索的最后。

延伸阅读

想了解更多的关于Search APIs的内容，推荐你收看WWDC 2015的 session 709,[Introducing Search APIs](https://developer.apple.com/videos/wwdc/2015/?id=709). 你也会对阅读文档[《NSUserActivity Class Reference》](https://developer.apple.com/library/prerelease/ios/documentation/Foundation/Reference/NSUserActivity_Class/)和[《documentation for CoreSpotlight》](https://developer.apple.com/library/prerelease/ios/releasenotes/General/WhatsNewIniOS/Articles/iOS9.html#//apple_ref/doc/uid/TP40016198-SW3)感兴趣。

[Demo地址](https://github.com/fish-yan/Search-APIs)