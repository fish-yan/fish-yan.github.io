---
layout:     post
title:      "iOS 动画Animation-4-3: CALayer子类：CAShapeLayer"
subtitle:   "iOS 动画 Animation"
date:       2016-10-18 22:00:00
author:     "FishYan"
header-img: "img/blog-header.png" 
catalog:    true
tags:
    - iOS
    - iOS 动画
---

# iOS 动画Animation-4-3: CALayer子类：CAShapeLayer

>首先说明：这是一系列文章，参考本专题下其他的文章有助于你对本文的理解。

好久没有更新博客，我也是上班一族，前一段时间工作量有点大，比较忙，也一直没有时间写博客。好在项目在上周末终于通过测试上线了，有可以休息一段时间了。

下面进入正题：今天介绍CAShapeLayer

- CAShapeLayer作为CALayer(关于CALayer参考：[iOS动画Animation-4-1:CALayer](http://blog.csdn.net/fish_yan_/article/details/51139953))的子类，他有多了那些常用的API呢？

|API |  描述 |
|:-:|:-|
| Path | 这是一个比较重要的属性, 与UIBezier结合, 可以随心所欲的绘制出各种图形|
|FillColor|填充颜色(看名字就懂)|
|FillRule|填充规则|
|StrokeColor|描边颜色|
|StrokeStart|描边起始位置(0.0-1.0)|
|StrokeEnd|描边结束位置(0.0-1.0)|
|LineCap|线类型(下方有图)|
|LineJoin|拐角类型(下方有图)|
| LineWidth | 线的宽度|
|MiterLimit |斜接限制(Demo中有解释) |

LineCap:
![LineCap](http://img.blog.csdn.net/20160412230423621)

LineJoin
![LineJoin](http://img.blog.csdn.net/20160412230753846)

如果看过我的博客都知道，我介绍的很多一部分东西都是从基础入手，这会让大家感觉效果上看起来很酷炫的东西实际上在实现起来并不困难。就比如说这个
先看Demo的效果图：

![这里写图片描述](http://img.blog.csdn.net/20160412224731818)


这个可并不是找了一个弧形的图给个动画让他在这转，这个Demo并没有用到任何图片素材

具体的实现原理是这样的:
首先上图的圆是用UIBezier画出来的，虽然不是一个完整的圆，但实际上就是一个圆，只是剩余部分没有配色。
```Objective-C
let path = UIBezierPath(arcCenter: CGPoint(x: 150.0, y: 150.0), radius: 150, startAngle: 0, endAngle: CGFloat(M_PI * 2), clockwise: true)
```
- 解释：
第一个参数arcCenter猜就知道是圆心了，
第二个参数猜：半径，
第三个参数开始角度：坐标系x轴为0° ，
第四个参数：结束角度，跟后面第五个参数还有关系，
第五个参数：是否顺时针，true顺时针，flase逆时针

如果想更深入的了解UIBezier，不要急，后续我会写博客来帮助大家了解。

好了，一个圆画出来了，但是，也只是用代码画出来了，怎么让他显示呢？这是后就用到CAShapeLayer的path属性了
先初始化一个CAShapeLayer
```Objective-C
 let shapeLayer = CAShapeLayer()
 shapeLayer.frame = someView.bounds
 shapeLayer.path = path.CGPath
```
- 解释：
这里的someView是我用storyboard创建的的一个View
然后将path赋给shapLayer

写到这还是不显示，因为没有颜色，下面设置颜色
```swift
 shapeLayer.strokeColor = UIColor.greenColor().CGColor // 边缘线的颜色
 shapeLayer.fillColor = UIColor.clearColor().CGColor // 闭环填充的颜色
shapeLayer.lineCap = kCALineCapSquare // 边缘线的类型
/*
 kCALineCapButt  平角(切掉多出的)
        
kCALineCapRound 圆角
        
kCALineCapSquare 平角(补齐空缺)
*/
```
还有线宽
```swift
shapeLayer.lineWidth = 4.0//边缘线宽度(是从边缘位置向两边延伸)
```
设置shapeLayer的起始位置和终止位置
```swift
shapeLayer.strokeStart = 0.0//起始位置0--1
shapeLayer.strokeEnd = 0.75//结束为止0--1
someView.layer.addSublayer(shapeLayer)
```
终于出来了，但是还不会动，这是后就要加一个动画了，关于动画的讲解请看本专题之前的文章
```swift
//添加旋转动画
        let animation = CABasicAnimation(keyPath: "transform.rotation")
        animation.duration = 1
        animation.fromValue = 0
        animation.toValue = M_PI * 2
        animation.repeatCount = Float(Int.max)
        shapeLayer.addAnimation(animation, forKey: nil)

```
到此位置效果就出来了，是不是看起来很简单呢，其实他就是这么简单，不要以为有多么的高大上，或者复杂。
[Demo位置](https://github.com/fish-yan/CAShapeLayer)
下面还有一个Demo会讲到另外两个本文没有讲到的属性不常用，效果是这样的，做跑马灯倒是挺好玩的，实际上是连贯的，gif效果不好，自己下载Demo玩吧
![这里写图片描述](http://img.blog.csdn.net/20160412235109120)


练习Demo
[Demo2](https://github.com/fish-yan/CAShapeLayer1)