---
layout:     post
title:      "iOS 动画Animation - 6 - 2：实战练习之淘宝购物车动画解析"
subtitle:   "iOS 动画 Animation"
date:       2016-11-16 22:00:00
author:     "FishYan"
header-img: "img/blog-header.png" 
catalog:    true
tags:
    - iOS
    - iOS 动画
---

# iOS 动画Animation - 6 - 2：实战练习之淘宝购物车动画解析

>首先说明：这是一系列文章，参考本专题下其他的文章有助于你对本文的理解。

首先我所要说的购物车动画并不是说把商品加入购物车时商品图片旋转飞出的动画，如果看了我这一个系列的博客，就会觉得那个简直不要太简单。

我今天要说的是这个动画，就是在点击购物车的时候弹出View的动画，这个动画在很多APP上都有，包括淘宝，天猫，简书，京东，等等。
淘宝上的效果是这样的：

![这里写图片描述](http://img.blog.csdn.net/20160424140719370)

虽然说网上有人家已经封装好的，但是在看了本篇博客后，你就会发现，完全不需要用别人的，因为总共就没多少东西，只不过不容易想到罢了。
下面看已经做好的效果

![这里写图片描述](http://img.blog.csdn.net/20160424140305314)

首先将这个动画拆分为两个阶段，

第一个阶段：商品详情这个view绕x轴旋转一定角度，并同时进行缩放。动画是进行到这个状态

![这里写图片描述](http://img.blog.csdn.net/20160424141109059)

第二个阶段：商品详情这个view向上平移，并再次缩放。动画是这个状态
![这里写图片描述](http://img.blog.csdn.net/20160424141250420)

这两个阶段组成的presentview的动画，dismiss的动画正好相反，所有过度的动画都是用的block动画。原理已经告诉大家了，下面来看代码是怎么写的

首先，准备一个cartView作为弹出的View，和一个maskView
```swift
	var cartView: UIView!
    var maskView: UIView!
	cartView = UIView(frame: CGRect(x: 0, y: UIScreen.mainScreen().bounds.size.height, width: UIScreen.mainScreen().bounds.size.width, height: UIScreen.mainScreen().bounds.size.height/2))
    cartView.backgroundColor = UIColor.cyanColor()
    
    maskView = UIView(frame: view.bounds)
    maskView.backgroundColor = UIColor.blackColor()
    maskView.alpha = 0.0

```
解释：上述cartView和maskView均为属性。因为后面还要用到

在点击per的时候，进行两步动画
```swift
	var rect = self.cartView.frame
	rect.origin.y = UIScreen.mainScreen().bounds.size.height / 2
    view.addSubview(maskView)  
    //第一步动画：改变maskview的alpha，执行第一阶段动画  
	UIView.animateWithDuration(0.3, animations: {
       self.maskView.alpha = 0.5
       self.view.layer.transform = self.firstTran()
    }) { (finish: Bool) in    
    //第二步动画：盖面cartView的frame，执行第二阶段动画
       UIView.animateWithDuration(0.3, animations: {
       self.view.layer.transform = self.secondTran()
	   self.cartView.frame = rect
	   //不能将cartView添加到self.view上，因为self.view的大小已经改变               UIApplication.sharedApplication().windows[0].addSubview(self.cartView)
       }, completion:nil)
}
```
解释：为什么要是用block动画，在试用block动画时，我们只需要关心其实状态和结束状态，中间的动画过程由系统自动完成。

第一阶段动画：
```swift
	func firstTran() -> CATransform3D {
        var transform = CATransform3DIdentity
        transform.m24 = -1/2000
        transform = CATransform3DScale(transform, 0.9, 0.9, 1)
        return transform
    }
```
解释：ransform.m24为绕x轴旋转的动画，带透视效果。如果不懂，请移步前面的文章。

第二阶段动画：
```swift
	func secondTran() -> CATransform3D {
        var transform = CATransform3DIdentity
        transform = CATransform3DTranslate(transform, 0, self.view.frame.size.height * (-0.08), 0)
        transform = CATransform3DScale(transform, 0.8, 0.8, 1)
        return transform
    }
```

下面是dismiss的方法，在这里我将它写在了touchbegan的方法里，
```swift
	override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        
        var rect = self.cartView.frame
        rect.origin.y = UIScreen.mainScreen().bounds.size.height
        //这里为什么第一步也是试用的第一阶段的动画？因为在这时候的其实状态是为persent动画的结束状态，所以动画效果正好反过来。
        UIView.animateWithDuration(0.3, animations: {
            self.view.layer.transform = self.firstTran()
            self.cartView.frame = rect
            self.maskView.alpha = 0.0
        }) { (finish: Bool) in
        //移除视图，完成第二步动画，就是还原。
            self.cartView.removeFromSuperview()
            UIView.animateWithDuration(0.3, animations: {
                self.view.layer.transform = CATransform3DIdentity
                }, completion: nil)
            
        }
    }
```

其实就这么多内容，非常简单。练习[Demo地址](https://github.com/fish-yan/TaoBaoCart)

如果实在不想看，或者看不懂，我也封装了一个，傻瓜式使用[封装后地址](https://github.com/fish-yan/XYCart)
你只需要将XYCart拖入你的工程就可以使用了。