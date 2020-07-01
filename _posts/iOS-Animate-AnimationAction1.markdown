---
layout:     post
title:      "iOS 动画Animation - 6 - 1：实战练习之圆弧下拉动效"
subtitle:   "iOS 动画 Animation"
date:       2016-11-11 22:00:00
author:     "FishYan"
header-img: "img/blog-header.png" 
catalog:    true
tags:
    - iOS
    - iOS 动画
---

>首先说明：这是一系列文章，参考本专题下其他的文章有助于你对本文的理解。

动画的基础教程基本上都讲解完了，下面就进入实战练习部分，这部分相信大家会更加喜欢一些，毕竟做出来的效果要比讲解部分bolg做出来的效果要好很多。但是做出来的这些东西都是利用了之前讲到的东西，如果还不够了解，请看前面的基础教程。

昨天刚讲过UIBezier，今天就趁热打铁，练习一下

先上一张图看看今天要做的是什么效果

![这里写图片描述](http://img.blog.csdn.net/20160420194339978)

是不是在有些app里都见过这种效果呢？不要以为这是什么高大上的东西，如果你认真学习了前一节知识一定会想到这是怎么做到的，这简直简单的不要不要的。

如果还不明白，我把这个效果拆解一下再上一张图，你就明白了。
![这里写图片描述](http://img.blog.csdn.net/20160420194838606)

我换了两种不同的颜色，是不是觉得脑洞大开呢？其实两个视图是分开的，二者之间没有什么关系，只不过颜色相同了就看起来不一样了，上面的view也可以是导航条。
下面就看代码是怎么实现的，总共不过50行哦

首先我们需要创建上面那个view，我怎么去了个这种颜色，好吧，我也不知道这叫什么颜色，反正就是cyanColor，这个都懂。

```swift
	
    @IBOutlet weak var headerView: UIView!
```
这里叫headerView，不在叫someView了，换个名字，也是用storyboard拖的。

然后，创建一个CAShapeLayer，就是下面橘黄色那一部分
```swift
	var layer:CAShapeLayer = CAShapeLayer()
	//填充颜色
    layer.fillColor = UIColor.orangeColor().CGColor
    view.layer.addSublayer(layer)
```

在touchBegan的方法里记录起始位置
```swift
	var beganPoint: CGPoint!
	override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        let touch = touches.first!
        beganPoint = touch.locationInView(view)
    }
```

在touchMoved的方法里计算手指移动的距离

```swift
	override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        let touch = touches.first!
        let currentPoint = touch.locationInView(view)
        var pointY = currentPoint.y - beganPoint.y
        //如果y轴移动的距离大于100就让他等于100，不让无限拉伸
        if pointY > 100 {
            pointY = 100
        }else{
            pointY = currentPoint.y - beganPoint.y
        }
        
        let path = UIBezierPath()
        path.moveToPoint(CGPoint(x: 0, y: 100))
        
        path.addQuadCurveToPoint(CGPoint(x: UIScreen.mainScreen().bounds.size.width, y: 100), controlPoint: CGPoint(x: currentPoint.x, y: 100 + pointY))
        layer.path = path.CGPath
        
    }

```
是不是看到熟悉的东西了？上面的path就是昨天讲到的二次贝塞尔曲线，还记得吗，不记得赶紧往前翻翻。

touchEnded的方法里让他恢复原样，就是重新初始化一下path就好了
```swift
	override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        let path = UIBezierPath()
        layer.path = path.CGPath
    }
```

实战到此结束，是不是很简单呢，再也不用羡慕别人的酷炫效果了，自己也可以的。
最后附上[Demo下载](https://github.com/fish-yan/TestUIBezier)