---
layout:     post
title:      "iOS 动画 Animation-0-续: 详解 CALayer 和 UIView 的区别和联系"
subtitle:   "iOS 动画 Animation"
date:       2016-09-11 22:00:00
author:     "FishYan"
header-img: "img/blog-header.png" 
catalog:    true
tags:
    - iOS
    - iOS 动画
---

# iOS 动画 Animation-0-续: 详解 CALayer 和 UIView 的区别和联系

>首先说明：这是一系列文章，参考本专题下其他的文章有助于你对本文的理解。

## 1.首先UIView可以响应事件，Layer不可以.

UIKit使用UIResponder作为响应对象，来响应系统传递过来的事件并进行处理。UIApplication、UIViewController、UIView、和所有从UIView派生出来的UIKit类（包括UIWindow）都直接或间接地继承自UIResponder类。

在 UIResponder中定义了处理各种事件和事件传递的接口, 而 CALayer直接继承 NSObject，并没有相应的处理事件的接口。

下面列举一些处理触摸事件的接口
```
– touchesBegan:withEvent:
– touchesMoved:withEvent:
– touchesEnded:withEvent:
– touchesCancelled:withEvent:
```
其实还有一些运动和远程控制事件等等，这里就不一一列举了。

下面的两篇文章详细介绍了 iOS 事件的处理和传递

参考链接：

http://blog.csdn.net/chun799/article/details/8223612
http://yishuiliunian.gitbooks.io/implementate-tableview-to-understand-ios/content/uikit/1-1-2.html

## 2.View和CALayer的Frame映射及View如何创建CALayer.

一个 Layer 的 frame 是由它的 anchorPoint,position,bounds,和 transform 共同决定的，而一个 View 的 frame 只是简单的返回 Layer的 frame，同样 View 的 center和 bounds 也是返回 Layer 的一些属性。（PS:center有些特列）为了证明这些，我做了如下的测试。

首先我自定义了两个类CustomView,CustomLayer分别继承 UIView 和 CALayer

在 CustomView 中重写了

```objc
+ (Class)layerClass
{
    return [CustomLayer class];
}
- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
}
- (void)setCenter:(CGPoint)center
{
    [super setCenter:center];
}
- (void)setBounds:(CGRect)bounds
{
    [super setBounds:bounds];
}
```
同样在 CustomLayer中同样重写这些方法。只是 setCenter方法改成setPosition方法

我在两个类的初始化方法中都打下了断点

![](http://cc.cocimg.com/api/uploads/20150827/1440656675741540.png)

首先我们会发现，我们在 [view initWithFrame] 的时候调用私有方法【UIView _createLayerWithFrame】去创建 CALayer。

然后我在创建 View 的时候，在 Layer 和 View 中Frame 相关的所有方法中都加上断点，可以看到大致如下的调用顺序如下

```objc
[UIView _createLayerWithFrame]
[Layer setBounds:bounds]
[UIView setFrame：Frame]
[Layer setFrame:frame]
[Layer setPosition:position]
[Layer setBounds:bounds]
```
我发现在创建的过程只有调用了 Layer 的设置尺寸和位置的然而并没有调用View 的 SetCenter 和 SetBounds 方法。

然后我发现当我修改了 view的 bounds.size 或者 bounds.origin 的时候也只会调用上边 Layer的一些方法。所以我大胆的猜一下，View 的 Center 和 Bounds 只是直接返回layer 对应的 Position 和 Bounds.

View中frame getter方法，bounds和center，UIView并没有做什么工作；它只是简单的各自调用它底层的CALayer的frame，bounds和position方法。

关于 Frame 的理解参考：http://www.cocoachina.com/industry/20131209/7498.html

## 3.UIView主要是对显示内容的管理而 CALayer 主要侧重显示内容的绘制。

我在 UIView 和 CALayer 分别重写了父类的方法。

```.objc
[UIView drawRect:rect]//UIView    
[CALayer display]//CALayer
```
然后我在上面两个方法加了断点，可以看到如下的执行。

![](http://cc.cocimg.com/api/uploads/20150827/1440656715211434.png)

可以看到 UIView 是 CALayer 的CALayerDelegate，我猜测是在代理方法内部[UIView(CALayerDelegate) drawLayer:inContext]调用 UIView 的 DrawRect方法，从而绘制出了 UIView 的内容.

## 4.在做 iOS 动画的时候，修改非 RootLayer的属性（譬如位置、背景色等）会默认产生隐式动画，而修改UIView则不会。

对于每一个 UIView 都有一个 layer,把这个 layer 且称作RootLayer,而不是 View 的根 Layer的叫做 非 RootLayer。我们对UIView的属性修改时时不会产生默认动画，而对单独 layer属性直接修改会，这个默认动画的时间缺省值是0.25s.

在 Core Animation 编程指南的 “How to Animate Layer-Backed Views” 中，对为什么会这样做出了一个解释：

UIView 默认情况下禁止了 layer 动画，但是在 animation block 中又重新启用了它们

是因为任何可动画的 layer 属性改变时，layer 都会寻找并运行合适的 'action' 来实行这个改变。在 Core Animation 的专业术语中就把这样的动画统称为动作 (action，或者 CAAction)。

layer 通过向它的 delegate 发送 actionForLayer:forKey: 消息来询问提供一个对应属性变化的 action。delegate 可以通过返回以下三者之一来进行响应：

- 它可以返回一个动作对象，这种情况下 layer 将使用这个动作。
- 它可以返回一个 nil， 这样 layer 就会到其他地方继续寻找。
- 它可以返回一个 NSNull 对象，告诉 layer 这里不需要执行一个动作，搜索也会就此停止。
- 当 layer 在背后支持一个 view 的时候，view 就是它的 delegate；

这部分的具体内容参考：http://objccn.io/issue-12-4/

## 总结

总接来说就是如下几点：

- 每个 UIView 内部都有一个 CALayer 在背后提供内容的绘制和显示，并且 UIView 的尺寸样式都由内部的 Layer 所提供。两者都有树状层级结构，layer 内部有 SubLayers，View 内部有 SubViews.但是 Layer 比 View 多了个AnchorPoint
- 在 View显示的时候，UIView 做为 Layer 的 CALayerDelegate,View 的显示内容由内部的 CALayer 的 display
- CALayer 是默认修改属性支持隐式动画的，在给 UIView 的 Layer 做动画的时候，View 作为 Layer 的代理，Layer 通过 actionForLayer:forKey:向 View请求相应的 action(动画行为)
- layer 内部维护着三分 layer tree,分别是 presentLayer Tree(动画树),modeLayer Tree(模型树), Render Tree (渲染树),在做 iOS动画的时候，我们修改动画的属性，在动画的其实是 Layer 的 presentLayer的属性值,而最终展- 示在界面上的其实是提供 View的modelLayer
- 两者最明显的区别是 View可以接受并处理事件，而 Layer 不可以