---
layout:     post
title:      "iOS 9 学习系列: UIKit Dynamics"
subtitle:   "iOS 9 学习系列"
date:       2016-05-13 22:00:00
author:     "FishYan"
header-img: "img/blog-header.png"
catalog:    true
tags:
    - iOS
    - iOS 9 新特性
---

>UIKit Dynamics 在 iOS 7 中首次被介绍的，可以让开发者通过简单的方式，给应用界面添加模拟物理世界的交互动画。iOS 9 中又加入了一些大的改进，我们将在本文中查看一些。

## Non-Rectangular Collision Bounds
在 iOS 9 之前，UIKitDynamics 的 collision bounds 只能是长方形。这让一些并非是完美的长方形的碰撞效果看起来有些古怪。iOS 9 中支持三种 collision bounds 分别是 Rectangle(长方形), Ellipse（椭圆形） 和 Path（路径）。Path 可以是任意路径，只要是逆时针的，并且不是交叉在一起的。一个警告是，path 必须是凸面的不能使凹面的。

为了提供一个自定义的collision bounds ，你可以子定义一个 UIView 的子类。


![](http://upload-images.jianshu.io/upload_images/28255-7d655a86501d6121.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)
如果你有个自定义的视图有一个自定义的bounds，你同样可以这么做。

## UIFieldBehavior
在 iOS 9 之前，只有一种 gravity behaviour(重力感应）类型的 behaviour。开发者也无法扩展或者自定义其他类型。

现在，UIKit Dynamics 包含了更多的 behaviours.
```
Linear Gravity

Radial Gravity

Noise

Custom
```
这些 behaviours 都有一些属性可以用来设置不同的效果，并且可以简单的添加和使用。

## Building a UIFieldBehavior & Non-Rectangular Collision Bounds Example
我们来用创建一个例子，把这两个特性都融合进来。它有几个视图（一个椭圆和一个正方形）添加了一些碰撞逻辑和一些噪音的 UIFieldBehavior。


![](http://upload-images.jianshu.io/upload_images/28255-1071611dfd5b04d4.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)
要使用 UIKit Dynamics,首先要创建一个 UIDynamicAnimator。在 viewDidLoad方法中，为你的变量创建一个引用。


![](http://upload-images.jianshu.io/upload_images/28255-71d0c149346bfa49.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)
现在你需要添加一些视图，他们将会动起来。


![](http://upload-images.jianshu.io/upload_images/28255-1f0c41c20060bc82.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)
这是我们给view 添加的两个基本的behaviors。


![](http://upload-images.jianshu.io/upload_images/28255-9ce004cd1092b72f.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)
第一个 behaviors, 我们添加了一个重力感应模型。


![](http://upload-images.jianshu.io/upload_images/28255-d0f0eae83c2bdff8.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)
接下来我们添加了一个 UIFieldBehavior。使用noiseFieldWithSmoothness方法进行了初始化。我们把方形和椭圆形添加到了behavior中，然后给 animator 添加了 field behavior。


![](http://upload-images.jianshu.io/upload_images/28255-e2a15d8c50855288.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)
我们接着创建了一个 UICollisionBehavior。这会阻止两个元素在碰撞时叠加，并增加了物理模型的动画效果。我们使用setTranslatesReferenceBoundsIntoBoundaryWithInsets，给视图添加了一个边缘的设置。如果不设置这个盒子的话，刚才的重力感应动画会把方形和椭圆形的视图掉进屏幕以下，而回不来。（我们就看不到碰撞了）

说到重力感应，我们需要确保他的方向始终是朝下的，也就是实际的物理世界中的方向。为了做到这点，我们需要使用 CoreMotion framework。创建一个CMMotionManager 变量。


![](http://upload-images.jianshu.io/upload_images/28255-55b0d2f64128e9ba.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)
我们设置一个变量作为类的属性，是因为我们始终需要用到它。否则的话，CMMotionManager 会因为被释放掉而无法更新。当我们发现设备的方向发生变化，为们设置重力感应模型的 gravityDirection 属性来，让重力的方向始终向下。


![](http://upload-images.jianshu.io/upload_images/28255-770c6ef7f1620ebf.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)
注意，我们这个例子只支持了 portrait一种模式，如果你希望支持全部的方向的话，你可以自己添加一些计算代码。

当你打开应用时，你可以看到如下图一样的画面。


![](http://upload-images.jianshu.io/upload_images/28255-05ddd12d2907ceec.jpg?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)
方形视图围绕着椭圆移动，但你无法看出什么门道。WWDC的session 229，介绍了一个方法，可以可视化的看到动画的效果。你需要添加一个桥接头（如果是用swift写的项目），添加以下代码。


![](http://upload-images.jianshu.io/upload_images/28255-9b949c5f8dadb504.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)
这会暴露一些私有 API，让UIDynamicAnimator 把debug模式打开。这能让你观察到空间扭曲的情况。在ViewController 类中，把 animator 的 debugEnable 属性设置为 true。


![](http://upload-images.jianshu.io/upload_images/28255-c9cff9da41ce5276.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)
现在，当你打开应用时，你就能够看到 UIFieldBehavior 提供的空间扭曲了。


![](http://upload-images.jianshu.io/upload_images/28255-91c389dfbf3ca852.jpg?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)
你同样能够看到视图碰撞时,围绕在方形和圆形上的的轮廓线。你还可以添加另外一些属性，他们并非 API 的标注属性，但是可以在lldb中使用。比如 debugInterval 和 debugAnimationSpeed ，当你需要debug你的动画时，他们会非常有帮助。

我们可以看到field 起了作用，可以清楚的看到碰撞的效果。如果我们想tweak更多属性。我们可以给对象设置具体的数值。然后重启应用看看他的变化。我们给页面添加三个UISlider 控制组件。分别控制力量，平滑度和速度。力量的组件数值范围在0-25，其他两个都是0-1。


![](http://upload-images.jianshu.io/upload_images/28255-587460033787410e.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)
当你在Interface Builder中创建好，拖拽三个动作事件到ViewController类。，然后按下面设置，更新他们的属性。


![](http://upload-images.jianshu.io/upload_images/28255-eae971d204e82448.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)
现在，运行应用。你可以通过控制条来设置属性的具体值，以观察动画的实际效果。


![](http://upload-images.jianshu.io/upload_images/28255-d075c0642b20afb1.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)
希望这些能够让你快速理解 UIKit Dynamics 里UIFieldBehavior 和  non-rectangular  collision bounds APIs 是怎么工作和 debug 的。我推荐你在真实的设备（而不是模拟器）中查看效果，否则你看不出 motion 所带来的效果变化。

## 延伸阅读
想要了解更多关于 UIKit Dynamics 的新特性，请浏览 WWDC 2015 的 [session 229What’s New in UIKit Dynamics and Visual Effects](https://developer.apple.com/videos/wwdc/2015/?id=229)。另外，并忘了我们的 demo 项目文件可以在 Github 上找到。