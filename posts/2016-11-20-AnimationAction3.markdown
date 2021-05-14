---
layout:     post
title:      "iOS 动画Animation - 6 - 3 实战练习之复杂动画拆装"
subtitle:   "iOS 动画 Animation"
date:       2016-11-20 22:00:00
author:     "FishYan"
header-img: "img/blog-header.png" 
catalog:    true
tags:
    - iOS
    - iOS 动画
---

# iOS 动画Animation - 6 - 3 实战练习之复杂动画拆装

> 其实我们在看到的每一个复杂的动画都是有许多简单的动画巧妙的拼装出来的，在教给大家学会拼装一个动画，其实我更愿意教会大家如何去拆解一个动画。如果看到一个动画，会去把它拆解成一个个简单的动画，那么实现这个动画就轻而易举了。

先给大家看一张效果图:

![这里写图片描述](http://img.blog.csdn.net/20160731103821804)

## 动画分析
这个动画其实在实现的时候并不困难，可能很多人怕就怕在没有思路，下面我就将这个动画拆解。

- 1、先出来一个圆，圆形在水平和竖直方向上被挤压，呈椭圆形状的一个过程，最后恢复成圆形

- 2、圆形的左下角、右下角和顶部分别按顺序凸出一小部分

- 3、圆和凸出部分形成的图形旋转一圈后变成三角形

- 4、三角形的左边先后出来两条宽线，将三角形围在一个矩形中

- 5、矩形由底部向上被波浪状填满

- 6、被填满的矩形放大至全屏

## 动画实现
- 1、先出来一个圆，并实现横向和竖向挤压的效果

```swift
	func addCircle() {
        
        shapeLayer.frame = CGRect(x: screenWidth/2 - 50, y: screenHeight/2 - 50, width: 100, height: 100)
        shapeLayer.fillColor = UIColor.orangeColor().CGColor
        view.layer.addSublayer(shapeLayer)
        // 画小圆
        let path1 = UIBezierPath(ovalInRect: CGRect(x: 40, y: 40, width: 20, height: 20))
        // 变成大圆
        let path2 = UIBezierPath(ovalInRect: CGRect(x: 0, y: 0, width: 100, height: 100))
        // 横向挤压
        let path3 = UIBezierPath(ovalInRect: CGRect(x: 5, y: 0, width: 90, height: 100))
        // 恢复
        let path4 = UIBezierPath(ovalInRect: CGRect(x: 0, y: 0, width: 100, height: 100))
	    // 竖向挤压
        let path5 = UIBezierPath(ovalInRect: CGRect(x: 0, y: 5, width: 100, height: 90))
        // 恢复
        let path6 = UIBezierPath(ovalInRect: CGRect(x: 0, y: 0, width: 100, height: 100))
        let animation = CAKeyframeAnimation(keyPath: "path")
        animation.values = [path1.CGPath, path2.CGPath, path3.CGPath, path4.CGPath, path5.CGPath, path6.CGPath, path3.CGPath, path4.CGPath, path5.CGPath, path6.CGPath];
        animation.duration = 1
        animation.beginTime = 0
        animation.removedOnCompletion = false
        animation.fillMode = kCAFillModeForwards
        shapeLayer.addAnimation(animation, forKey: nil)

    }

```

里面的内容我就不再多做介绍了，这些都是简单的动画，如果不够了解，请看本专题之前的文章

实现效果如下图：

![这里写图片描述](http://img.blog.csdn.net/20160731105720144)

- 2、圆形的左下角、右下角和顶部分别按顺序凸出一小部分

看似是圆的周围一次多出来一个角，实际行就是一个颜色与圆相同的三角在做变化，这个动画跟圆没有关系。如果我将这个三角换一种颜色，并且将动画放慢，就是这样的

![这里写图片描述](http://img.blog.csdn.net/20160731110417184)

看代码：
```swift

    func addSanjiao() {
        
        shapeLayer1.frame = CGRect(x: screenWidth/2 - 50, y: screenHeight/2 - 50, width: 100, height: 100)
        shapeLayer1.strokeColor = UIColor.orangeColor().CGColor
        shapeLayer1.fillColor = UIColor.orangeColor().CGColor
        shapeLayer1.lineJoin = kCALineJoinRound
        shapeLayer1.lineWidth = 10
        view.layer.addSublayer(shapeLayer1)
        // 画一个三角，一定要小于圆
        let path11 = UIBezierPath()
        path11.moveToPoint(CGPoint(x: 50, y: 10))
        path11.addLineToPoint(CGPoint(x: 15, y: 75))
        path11.addLineToPoint(CGPoint(x: 85, y: 75))
        path11.closePath()
        // 改变三角左下角的位置
        let path12 = UIBezierPath()
        path12.moveToPoint(CGPoint(x: 50, y: 10))
        path12.addLineToPoint(CGPoint(x: -5, y: 75))
        path12.addLineToPoint(CGPoint(x: 85, y: 75))
        path12.closePath()
        // 改变三角右下角的位置
        let path13 = UIBezierPath()
        path13.moveToPoint(CGPoint(x: 50, y: 10))
        path13.addLineToPoint(CGPoint(x: -5, y: 75))
        path13.addLineToPoint(CGPoint(x: 105, y: 75))
        path13.closePath()
        // 改变三角顶角的位置
        let path14 = UIBezierPath()
        path14.moveToPoint(CGPoint(x: 50, y: -10))
        path14.addLineToPoint(CGPoint(x: -5, y: 75))
        path14.addLineToPoint(CGPoint(x: 105, y: 75))
        path14.closePath()
        
        let animation1 = CAKeyframeAnimation(keyPath: "path")
        animation1.values = [path11.CGPath, path12.CGPath, path13.CGPath, path14.CGPath];
        animation1.duration = 0.25
        animation1.removedOnCompletion = false
        animation1.fillMode = kCAFillModeForwards
        shapeLayer1.addAnimation(animation1, forKey: nil)

    }

```

- 3、圆和凸出部分形成的图形旋转一圈后变成三角形
这个其实只是让三角旋转就好了，因为圆的旋转看不出来的O(∩_∩)O~~，然后圆做缩小动画，同样将动画放慢，效果如下：
![这里写图片描述](http://img.blog.csdn.net/20160731111300508)

三角画的有点不规整啊，转起来有点丑，请忽略细节(* ^__^*)

实现代码如下：

```swift
    func xuanzhuan() {
	    // 三角旋转
        let animation = CAKeyframeAnimation(keyPath: "transform.rotation")
        animation.duration = 0.5
        animation.values = [0, M_PI * 2]
        shapeLayer1.addAnimation(animation, forKey: nil)
        // 圆缩小
        let animation1 = CAKeyframeAnimation(keyPath: "transform.scale")
        animation1.duration = 1
        animation1.values = [1, 0]
        animation1.removedOnCompletion = false
        animation1.fillMode = kCAFillModeForwards
        shapeLayer.addAnimation(animation1, forKey: nil)

    }
```

- 4、三角形的左边先后出来两条宽线，将三角形围在一个矩形中
这部分相对来说就更简单了， 就是画一矩形
![这里写图片描述](http://img.blog.csdn.net/20160731112048926)

代码如下：

```
	func rectAngle() {
        let shapeLayer2 = CAShapeLayer()
        shapeLayer2.frame = CGRect(x: screenWidth/2 - 60, y: screenHeight/2 - 90, width: 120, height: 120)
        view.layer.addSublayer(shapeLayer2)
        let path21 = UIBezierPath(rect:  CGRect(x: 0, y: 0, width: 120, height: 120))
        shapeLayer2.transform = CATransform3DMakeRotation(CGFloat(-M_PI), 0, 0, 1)
        shapeLayer2.path = path21.CGPath
        shapeLayer2.strokeStart = 0
        shapeLayer2.lineWidth = 5
        shapeLayer2.strokeColor = UIColor.cyanColor().CGColor
        shapeLayer2.fillColor = UIColor.clearColor().CGColor
        let animation = CABasicAnimation(keyPath: "strokeEnd")
        animation.duration = 0.5
        animation.fromValue = 0
        animation.toValue = 1
        shapeLayer2.addAnimation(animation, forKey: nil)
    }
```

- 5、矩形由底部向上被波浪状填满

波浪线就是二次贝塞尔曲线在不停的变换，我画的有点多了，其实可以省点画
同样将动画放慢

![这里写图片描述](http://img.blog.csdn.net/20160731122241225)
```swift
    func waves() {
        let shapeLayer3 = CAShapeLayer()
        shapeLayer3.frame = CGRect(x: screenWidth/2 - 60, y: screenHeight/2 - 90, width: 120, height: 120)
        shapeLayer3.fillColor = UIColor.cyanColor().CGColor
        view.layer.addSublayer(shapeLayer3)
        let path31 = UIBezierPath()
        path31.moveToPoint(CGPoint(x: 0, y: 100))
        path31.addCurveToPoint(CGPoint(x: 120, y: 100), controlPoint1: CGPoint(x: 40, y: 80), controlPoint2: CGPoint(x: 80, y: 120))
        path31.addLineToPoint(CGPoint(x: 120, y: 120))
        path31.addLineToPoint(CGPoint(x: 0, y: 120))
        path31.closePath()
        let path32 = UIBezierPath()
        path32.moveToPoint(CGPoint(x: 0, y: 80))
        path32.addCurveToPoint(CGPoint(x: 120, y: 80), controlPoint1: CGPoint(x: 40, y: 100), controlPoint2: CGPoint(x: 80, y: 60))
        path32.addLineToPoint(CGPoint(x: 120, y: 120))
        path32.addLineToPoint(CGPoint(x: 0, y: 120))
        path32.closePath()
        let path33 = UIBezierPath()
        path33.moveToPoint(CGPoint(x: 0, y: 60))
        path33.addCurveToPoint(CGPoint(x: 120, y: 60), controlPoint1: CGPoint(x: 40, y: 40), controlPoint2: CGPoint(x: 80, y: 80))
        path33.addLineToPoint(CGPoint(x: 120, y: 120))
        path33.addLineToPoint(CGPoint(x: 0, y: 120))
        path33.closePath()
        let path34 = UIBezierPath()
        path34.moveToPoint(CGPoint(x: 0, y: 40))
        path34.addCurveToPoint(CGPoint(x: 120, y: 40), controlPoint1: CGPoint(x: 40, y: 60), controlPoint2: CGPoint(x: 80, y: 20))
        path34.addLineToPoint(CGPoint(x: 120, y: 120))
        path34.addLineToPoint(CGPoint(x: 0, y: 120))
        path34.closePath()
        let path35 = UIBezierPath()
        path35.moveToPoint(CGPoint(x: 0, y: 20))
        path35.addCurveToPoint(CGPoint(x: 120, y: 20), controlPoint1: CGPoint(x: 40, y: 0), controlPoint2: CGPoint(x: 80, y: 40))
        path35.addLineToPoint(CGPoint(x: 120, y: 120))
        path35.addLineToPoint(CGPoint(x: 0, y: 120))
        path35.closePath()
        let path36 = UIBezierPath()
        path36.moveToPoint(CGPoint(x: 0, y: 0))
        path36.addCurveToPoint(CGPoint(x: 120, y: 0), controlPoint1: CGPoint(x: 40, y: 0), controlPoint2: CGPoint(x: 80, y: 0))
        path36.addLineToPoint(CGPoint(x: 120, y: 120))
        path36.addLineToPoint(CGPoint(x: 0, y: 120))
        path36.closePath()
        let animation1 = CAKeyframeAnimation(keyPath: "path")
        animation1.values = [path31.CGPath, path32.CGPath, path33.CGPath, path34.CGPath, path35.CGPath, path36.CGPath];
        animation1.duration = 0.5
        animation1.removedOnCompletion = false
        animation1.fillMode = kCAFillModeForwards
        shapeLayer3.addAnimation(animation1, forKey: nil)

    }
```

都是重复的内容，我也不想说啥

- 6、被填满的矩形放大至全屏

在来个放大到全屏的动画，整个动画就ok了

![这里写图片描述](http://img.blog.csdn.net/20160731122345982)

```swift
	func fullScreen() {
        let someView = UIView()
        someView.frame = CGRect(x: screenWidth/2 - 60, y: screenHeight/2 - 90, width: 120, height: 120)
        view.addSubview(someView)
        someView.backgroundColor = UIColor.cyanColor()
        UIView.animateWithDuration(0.25) { 
            someView.frame = CGRect(x: 0, y: 0, width: self.screenWidth, height: self.screenHeight)
        }
    }
```

>结束语:
>
> 其实单从每一步来讲，每个动画都不困难，重要的是要能想到这么做。这里有做好的[demo](https://github.com/fish-yan/testAnimation)可以参考一下