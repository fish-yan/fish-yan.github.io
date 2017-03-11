---
layout:     post
title:      "iOS 动画 Animation-1: 动画基础：Block动画"
subtitle:   "iOS 动画 Animation"
date:       2016-09-19 22:00:00
author:     "FishYan"
header-img: "img/blog-header.png"
tags:
    - iOS
    - iOS 动画
---

首先说明：这是一系列文章，参考本专题下其他的文章有助于你对本文的理解。
- 在iOS开发中，制作动画效果是最让开发者享受的环节之一。一个设计严谨、精细的动画效果能给用户耳目一新的效果，吸引他们的眼光 —— 这对于app而言是非常重要的。So 一个优秀的动画设计能让App填色不少。

- 今天就先从基本的开始，在以后的文章中在慢慢深入。

##  1、要学动画必须要知道CALayer

- ios中我们能看到的控件都是UIView的子类,比如Button等
- UIView能够在屏幕上显示,是应为在创建他的时候内部自动添加一个  CALayer图层,通过这个图层,在屏幕上显示的时候会电泳一个drawRect的方法完成绘图,才能在屏幕上显示,
- CALayer本身具有显示功能,但是他不能相应用户的交互事件,如果只是单纯的向显示一个图形此时可以使用CALayer创建,或者是使用UIView创建但是如果这个图形想相应用户的交互事件必须使用UIView或他的子类
- 取到当前视图控制器自带view的图层
```swift
	let layer = view.layer
    layer.backgroundColor = UIColor.redColor().CGColor
```
每一个可见的视图都会存在一个layer层，这里不对layer做详细介绍，如果需要，可以看一下这里[详解 CALayer 和 UIView 的区别和联系](http://blog.csdn.net/fish_yan_/article/details/50826038%20%E8%AF%A6%E8%A7%A3%20CALayer%20%E5%92%8C%20UIView%20%E7%9A%84%E5%8C%BA%E5%88%AB%E5%92%8C%E8%81%94%E7%B3%BB) 和[Swift语言iOS开发：CALayer十则示例](http://blog.csdn.net/fish_yan_/article/details/50826007)。

## 2、属性动画
首先用storyboard创建一个view，这里叫animationView。
可动画的属性 :frame,center,bounds alpha,background,tranform
修改属性做动画,属性修改的结果是真实的作用在动画的视图上,不能自动恢复到以前的样子;

属性动画的四个block：
在这些block中可以做上面所说的属性改变都可以产生动画效果。
[这里有demo](https://github.com/fish-yan/Animation1)，可以跟着一起敲一下，观察不同的动画效果

```swift
//1.
//01.动画持续 的时长
UIView.animateWithDuration(1) { () -> Void in

}
//2.
//01.动画持续 的时长
UIView.animateWithDuration(1, animations: { () -> Void in
            
}) { (finished: Bool) -> Void in
//动画完成后操作
                
}
//3.
//01.动画持续 的时长
//02.延迟时间
//03.动画效果
UIView.animateWithDuration(1, delay: 1, options: UIViewAnimationOptions.AllowUserInteraction, animations: { () -> Void in

}) { (finshed: Bool) -> Void in
                
}
//4.
//01.动画持续 的时长
//02.延迟时间
//03.动画弹回强度
//04.设置弹回速度
//05.动画效果
UIView.animateWithDuration(5, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 20, options: UIViewAnimationOptions.TransitionNone, animations: { () -> Void in
           
}) { (finished: Bool) -> Void in
                
}
```
附加：关于transform
```swift
//位移
//参1：与自身对比
//参2：x轴偏移量
//参2：y轴偏移量
self.animationView.transform = CGAffineTransformTranslate(self.animationView.transform, 10, 50)

//缩放
//参2：x轴缩放比例
//参3：y轴缩放比例
self.animationView.transform = CGAffineTransformScale(self.animationView.transform, 0.5, 0.5);

//旋转
//参2：旋转角度
self.animationView.transform = CGAffineTransformRotate(self.animationView.transform, CGFloat(M_PI))
```
## 3、过度动画

过度动画的两个方法：
```swift
UIView.transitionWithView(self.view, duration: 1, options: UIViewAnimationOptions.TransitionNone, animations: { () -> Void in
        
}) { (finished: Bool) -> Void in
        
}
let toView = UIView(frame: CGRect(x: 100, y: 100, width: 100, height: 100))
toView.backgroundColor = UIColor.blueColor()
//该方法，只能执行一次
//fromView原来的视图， toView替换后的视图
UIView.transitionFromView(self.animationView, toView: toView, duration: 1, options: UIViewAnimationOptions.TransitionNone) { (finished: Bool) -> Void in
            
}   
   
```
上面第二个方法调用完毕后，相当于执行了下面两句代码：
```swift     
// 添加toView到父视图
self.animationView.superview?.addSubview(toView)
// 把fromView从父视图中移除
self.animationView.removeFromSuperview() 
```

关于Block动画就介绍到这里，属性动画是一种比较简单的动画实现方式，但也是使用最频繁的。

