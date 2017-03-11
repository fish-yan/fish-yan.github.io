---
layout:     post
title:      "iOS 9 新特性：开发者集合篇（不断更新中......）"
subtitle:   "iOS 9 学习系列"
date:       2016-06-26 22:00:00
author:     "FishYan"
header-img: "img/blog-header.png"
tags:
    - iOS
    - iOS 9 新特性
---

- iOS更新到9.0后, Xcode7.0之后, 苹果又开放了很多新的API, 这里整理了这些在iOS9后的一些新的特性, 以供大家学习交流.当然文章肯定还不够全面，欢迎各位在评论区投稿,我会在这里不断完善。

### 1、[ iOS 9 学习系列：Contacts Framework](http://blog.csdn.net/fish_yan_/article/details/50630724)
iOS 9 中，苹果介绍了新的 Contacts framework。允许用户使用 Objective-C 的 API 和设备的通讯录进行交互，同样适用于 Swift 语言。比起之前通过 AddressBook framework 来读取联系人信息来说，这是一个巨大的进步。因为 AddressBook framework 没有 Objective-C 的 API，非常难用，用 Swift 写的时候更是痛苦。希望新的 Contacts framework 能够解决这些痛点。

### 2、[iOS 9 学习系列: Search APIs](http://blog.csdn.net/fish_yan_/article/details/50635433)
在 iOS9 之前，你只能在 spotlight 中输入关键字，比如应用名字，搜索到应用。在 iOS9 中苹果提供了一套 Search APIs。允许开发者选择应用的内容，索引起来供 spotlight 进行搜索，同时可以设置在 spotlight 中的展示效果，以及点击之后如何响应。

**3个新的搜索相关API**

**NSUserActivity**

NSUserAcitivity 在介绍 iOS8 的 Handoff 时引入，iOS9 中允许对这些 activities 进行搜索。你可以提供元数据给这些 activities, 这意味着Spotlight 可以索引这些内容。类似于浏览器展示网页的做法（你打开过的历史页面被记录了下来），用户可以快速的在 Spotlight中搜索，打开最近的 activities。

**Web Markup**

Web Markup 允许应用镜像自己的内容，并在 Spotlight 中建立索引。用户并不需要应用安装在自己的设备上来展示搜索结果。苹果的爬虫自己去抓取你网站上打了 markup 的内容，这些内容稍后会提供给 Safari 和 Spotlight。

事实上，这个重要的特性，甚至并不需要用户安装了你的应用在自己的设备上。这样可以将你的应用展示给更多的潜在用户。苹果的云服务，将你的应用的内容索引起来，让你的应用和 public Search APIs 保持一个深度连接。更多关于Web Markup 的内容，可以阅读苹果官方的文档 《Use Web Markup to Make App Content Searchable》。

**CoreSpotlight**

CoreSpotlight 是 iOS9 提供的新 Freamework，允许你索引你的应用内容。当使用它的 Api，你可以方便的将你喜欢的数据，索引起来，NSUserActivity  帮助存储用户的使用历史。它让你的应用可以底层的和 CoreSpotlight 进行连接，将索引存储在用户设备上。

### 3、[iOS 9 学习系列: UIStack View](http://blog.csdn.net/fish_yan_/article/details/50736526)
在 iOS9 中，Apple 引入了 UIStackView，他让你的应用可以通过简单的方式，纵向或横向的叠放你的 views。UIStackView 采用 auto layout 的方式来管理他的子视图的位置和尺寸。让你更简单的构建自适应的 UI。
如果在 iOS9 之前，你想要创建类似 UIStackView 为你提供的这种布局，你需要构建大量的 constraints。你需要编辑许多诸如边距、高度、x/y 轴的位置，还有它们的依赖关系等。

UIStackView 把这些全部帮你做了。甚至在你添加或者移除某些 view 时，还提供了平滑的动画。当 view 状态改变时，他会自动的改变 layout 的属性值。

### 4、[iOS 9 学习系列: Apple Pay](http://blog.csdn.net/fish_yan_/article/details/50747271)
Apple Pay 是在 iOS 8 中第一次被介绍，它可以为你的应用中的实体商品和服务，提供简单、安全、私密的支付方式。它使得用户支付起来非常简便，只需按一下指纹就可以授权进行交易。

Apple Pay 只能在特定的设备上使用，目前为止，这些设备包括 iPhone 6, iPhone 6+, iPad Air 2, iPad mini 3. 这是因为 Apple Pay 需要特定的硬件芯片来支持，这个硬件叫做 Secure Element （简称SE，安全元件）,他可以用来存储和加解密信息。

假如说你的应用里有需要购买才能解锁的某些特性的话（比如去广告），你不应该使用 Apple Pay 这种支付方式。 Apple Pay 是用来解决购买实体商品和服务的，例如，聚乐部会员，酒店预订，订票等。

### 5、[iOS 9 学习系列: UI Testing](http://blog.csdn.net/fish_yan_/article/details/50747861)
自动化测试用户界面工具对于开发软件来说是非常有用的，他可以快速的帮你定位到问题。一套成功的测试流程，可以为你最终发布软件带来信心。在iOS平台上，我们使用 Automation 来完成这个工作。这要打开一个单独的应用 Instruments，然后编写和运行 JavaScript 脚本。整个流程痛苦且漫长。

### 6、[iOS 9 学习系列: UIKit Dynamics](http://blog.csdn.net/fish_yan_/article/details/50748639)
UIKit Dynamics 在 iOS 7 中首次被介绍的，可以让开发者通过简单的方式，给应用界面添加模拟物理世界的交互动画。iOS 9 中又加入了一些大的改进，我们将在本文中查看一些。

### #**Non-Rectangular Collision Bounds**

在 iOS 9 之前，UIKitDynamics 的 collision bounds 只能是长方形。这让一些并非是完美的长方形的碰撞效果看起来有些古怪。iOS 9 中支持三种 collision bounds 分别是 Rectangle(长方形), Ellipse（椭圆形） 和 Path（路径）。Path 可以是任意路径，只要是逆时针的，并且不是交叉在一起的。一个警告是，path 必须是凸面的不能使凹面的。

### 7、[iOS 9 学习系列: MapKit](http://blog.csdn.net/fish_yan_/article/details/50748655)
MapKit 的每次迭代都会为开发者带来一些新的特性，iOS 9的更新也不例外。在本文中，我们将预览一些新的API。我们将在一个应用中使用它们，给大家展示一下如何通过程序来估算（货物的）运达时间。

### 8、[iOS 9 学习系列: Storyboard References](http://blog.csdn.net/fish_yan_/article/details/50748668)
如果你曾经使用 interface builder 创建过一个复杂、界面非常多的应用，你就会明白最后那些Storyboards 文件变的有多大。他会迅速变的无法管理，阻碍你的进度。自从引入 Storyboard 以来，其实是可以把你的应用的不同模块切开到不同的 Storyboard 中的。在过去，这要手动创建多个 Storyboard 文件，并且要写大量的代码。
为了解决这个问题，在 iOS 9 中苹果介绍了 Storyboard References 这个概念。Storyboard References 允许你从 segue 中引用其他 storyboard 中的 viewController。这意味中你可以保持不同功能模块化，同时 Storyboard 的体积变小并易与管理。不仅容易理解了，和团队一起工作时，合并（工作成果）也变的简单了。

### 9、[ iOS 9 学习系列: Xcode Code Coverage](http://blog.csdn.net/fish_yan_/article/details/50820872)
Code coverage 是一个计算你的单元测试覆盖率的工具。高水平的覆盖给你的单元测试带来信心，也表明你的应用被彻底的测试过了。你可能写了几千个单元测试，但如果覆盖率不高，那么你写的这套测试可能价值也不大。
这里并没有一个确切的百分比，要求你必须到达这个覆盖率。这很大程度上取决于你的项目（的具体情况）。譬如说，如果你的项目中有很多不能写单元测试的视觉组件，那么覆盖率就会比单纯处理数据的框架要低的多。

### 10、[3D Touch开发初体验](http://www.jianshu.com/p/c9a8ec970003)
3D Touch功能的开发难度并不大，但是由于该功能需要有硬件支持，并且在模拟器上无法体验，所以阻挡了一大批开发者的探索脚步。不过在计算机界从来没有能难倒程序员的问题，本文首先将介绍如何使用3D Touch的Home Screen Quick Actions功能，然后介绍如何在模拟器中使用3D Touch。

### 11、[iOS 9学习系列： ReplayKit框架入门](http://www.cocoachina.com/ios/20160318/15716.html)
在iOS 9中，ReplayKit 是一款全新的框架，可谓是游戏开发者(开发商)的福音。它可以让玩家更便捷地记录游戏进度或数据以及分享的功能。除此之外更强大的是：ReplayKit为用户(玩家)提供了一个全功能的交互界面，用户可用它来编辑或制作自己的视频剪辑！

ReplayKit不需要太大电量损耗和性能损耗就可以产出高清的视频记录。ReplayKit支持使用A7芯片以上，操作系统为iOS 9或更高版本的设备。

### 12、[Apple Pay接入详细教程](http://www.cocoachina.com/ios/20160226/15443.html)
Apple Pay运行环境：iPhone6以上设备，操作系统最低iOS9.0以上，部分信息设置需要iOS9.2以上。目前还不支持企业证书添加。

环境搭建好后可以在模拟器上面运行，xcode7.2.1+iPhone6SP9.2系统下，系统会绑定几种虚拟的银行卡，和几个联系人，方便调试，支付也不会发生真实的付款，真的很方便。

### 13、[iOS9 CASpringAnimation 弹簧动画详解](http://www.jianshu.com/p/90a7a1787d1b)
CASpringAnimation是iOS9才引入的动画类，它继承于CABaseAnimation，用于制作弹簧动画，


### 14、[iOS9提示框UIAlertController](http://www.jianshu.com/p/73a0495b7bac)

**iOS8之前**

中部的提示框使用的是UIAlertView
底部的提示框使用的是UIActionSheet;

**iOS8开始及iOS9之后**

使用的是UIAlertController
相当于UIAlertController == UIAlertView + UIActionSheet

### 15、[IOS9的新特性--Bitcode](http://www.jianshu.com/p/db6e944ffd61)

给App瘦身的另一个手段是提交Bitcode给Apple，而不是最终的二进制。Bitcode是LLVM的中间码，在编译器更新时，Apple可以用你之前提交的Bitcode进行优化，这样你就不必再编译器更新后再次提交你的App，也能享受到编译器改进所带来的好处。

本文持续更新中，希望还知道iOS 9 其他新特性的朋友留下一个链接，我会补充上去的......