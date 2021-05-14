---
layout:     post
title:      "iOS 9 学习系列: UIStack View"
subtitle:   "iOS 9 学习系列"
date:       2016-04-06 22:00:00
author:     "FishYan"
header-img: "img/blog-header.png"
catalog:    true
tags:
    - iOS
    - iOS 9 新特性
---

> 在 iOS9 中，Apple 引入了 UIStackView，他让你的应用可以通过简单的方式，纵向或横向的叠放你的 views。UIStackView 采用 auto layout 的方式来管理他的子视图的位置和尺寸。让你更简单的构建自适应的 UI。

如果在 iOS9 之前，你想要创建类似 UIStackView 为你提供的这种布局，你需要构建大量的 constraints。你需要编辑许多诸如边距、高度、x/y 轴的位置，还有它们的依赖关系等。

UIStackView 把这些全部帮你做了。甚至在你添加或者移除某些 view 时，还提供了平滑的动画。当 view 状态改变时，他会自动的改变 layout 的属性值。

## 使用 UIStackView

现在我们通过创建一个例子来说明怎么使用 UIStackView，最终的代码放在了 Github，你可以下载来研究.我们要创建一个简单的示范，演示 UIStackView 是怎么工作的？这个页面底部有2个segmented controls，用来控制 UIStackView 的对齐和分布的属性。

![](http://upload-images.jianshu.io/upload_images/28255-72dbb18fec9aad08.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240/q/100)


result
上面的图片就是我们要创建的示例。如你所见，我们显示了4个朋友的图片，还有2个 segmented controls 在下面。这些 UI 使用了auto layout 布局，可以适配多种尺寸。

一会儿的制作过程，会让你感到惊喜，我们仅仅手动的添加了4个 layout positioning constraints。所有在这个UIStackView中的view都由它自动控制位置。我们一共有4个 UIStackView, 只有第一个我们需要设置一下他的 constraints。这是我们页面中 stackview 所在的位置。


![](http://upload-images.jianshu.io/upload_images/28255-f1dcba9db7f7917c.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240/q/100)



constraints
当你从 Interface Builder 中拖拽了一个 vertical stack view 到页面上后，你可以打开它的 constraint 面板，像上图一样编辑它的属性。这会把这个主 stack view 放在页面的中央，正确的位置上。

从 Interface Builder 中拖拽3个 horizontal stack view 到刚才创建好的 UIStackView 中。在最上面的 stack view,包含四个 UIImageView ,每个 imageView 中展示一个我们的朋友的照片。你拖拽四个 UIImageView 到 stack view 中就可以了。每个图片的大小尺寸都是不一样的。为了避免变形，我们给 imageView 的 contentMode 设置为 Aspect Fit。这意味着，不去管图片的尺寸，图片总会以正确的比例展示在 imageView 中。

你可能注意到了，在最终的 demo 中，每个 imageView 之间有个间隔，这是因为设置了 stackView的 spacing 属性为5的原因。在 interface builder 的 attributes inspector 面板可以设置 spacing 的值，同时还可以设置 alignment 和 distribution 的属性。这里我们缺省的设置为 Fill。因为一会儿我们会通过选择 segment 来改变它的值。

另外两个 stackView,同样是 horizontal stack view。非常简单，每个 stack view 中包含一个 label 和一个 segmented control。设置 segmented control为下面的内容。


>**Distribution**
>
>Fill
>
> Fill Equally
>
>Fill Proportionally
>
>Equal Spacing
>
>Equal Centering

>**Alignment**
>
>Fill
>
>Top
>
>Center
>
>Bottom

我们一会儿就能看到，这些属性是如何影响布局的。很多时候，他们的排列方式依赖 contentSize的值。好在，我们这个例子非常简单，image 的大小就是照片的实际大小。

现在我们的 UI 都创建好了。我们需要给 segment 设置选中后的动作。首先把最上面的 stack view 拖拽 outlet 到 viewController 中，命名为 peopleStackView。然后分别拖拽一个 action 给segmented control。在 action 中对 peopleStackView 的 alignment 和 distribution 属性进行调节，对齐和排列方式由用户决定。

![](http://upload-images.jianshu.io/upload_images/28255-bb02e939e9ad2e25.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240/q/100)

你可以看到，我给每个动作加了一个动画的效果，但这不是必须的。如果你移除动画效果，对齐和排列的方式依然会改变。好现在运行一下程序吧。

>你可以看到视频中的结果，[点击打开视频](http://www.tudou.com/programs/view/kaUIlAQNu4g/)

尝试着使用不同的排列组合，看一下会是什么结果。它会让你知道UIStackView时多么强大，在不同尺寸的设备上开发用户界面有多方便。

为现有的view，添加UIStackView
如果你想为你现在已经做好的 view 添加 UIStackView，也很简单。先移除掉你的 view 上的constraint，然后选中他们，点击一下 interface builder 的底部右手边，第一个按钮。（就是原来你给 view 添加 constraint 的那些按钮，左边多了一个）。这会立刻把你选中的view，全部放入一个 UIStackView 中。

![](http://upload-images.jianshu.io/upload_images/28255-a5fe77b6835ea7c2.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240/q/100)

这会把你原来的布局方式转为stack view的布局方式，由stack view来控制布局。

延伸阅读
想要了解更多关于Xcode7中 UIStackView的内容，推荐阅读 WWDC 2015 的 [session 218 Mysteries of Auto Layout](https://developer.apple.com/videos/wwdc/2015/?id=218), Part 1.在视频前15分钟里，Jason Yao 介绍了 UIStackView，并且现场制作了一个Demo演示如何操作的。



写在最后: 这是iOS9特有的的新特性,如果想兼容iOS之前的版本怎么办? 这里提供一个第三方

[FDStackView](https://github.com/forkingdog/FDStackView)

只需要导进工程,将所使用Stack的页面构建版本单独改为iOS9就可以了,其他不需要修改任何东西.

[Demo地址](https://github.com/fish-yan/UIStackView) 

