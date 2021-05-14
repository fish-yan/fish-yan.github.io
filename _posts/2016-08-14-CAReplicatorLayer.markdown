---
layout:     post
title:      "iOS 动画 Animation-0-6：CALayer十则示例-CAReplicatorLayer"
subtitle:   "iOS 动画 Animation"
date:       2016-08-14 22:00:00
author:     "FishYan"
header-img: "img/blog-header.png" 
catalog:    true
tags:
    - iOS
    - iOS 动画
---

## CAReplicatorLayer

CAReplicatorLayer能够以特定次数复制图层，可以用来创建一些很棒的效果。

每个图层复件的颜色和位置都可以改动，而且可以在总复制图层之后延迟绘制，营造一种动画效果。还可以利用深度，创造三维效果。举个例子

```swift
// 1
let replicatorLayer = CAReplicatorLayer()
replicatorLayer.frame = someView.bounds
  
// 2
replicatorLayer.instanceCount = 30
replicatorLayer.instanceDelay = CFTimeInterval(1 / 30.0)
replicatorLayer.preservesDepth = false
replicatorLayer.instanceColor = UIColor.whiteColor().CGColor
  
// 3
replicatorLayer.instanceRedOffset = 0.0
replicatorLayer.instanceGreenOffset = -0.5
replicatorLayer.instanceBlueOffset = -0.5
replicatorLayer.instanceAlphaOffset = 0.0
  
// 4
let angle = Float(M_PI * 2.0) / 30
replicatorLayer.instanceTransform = CATransform3DMakeRotation(CGFloat(angle), 0.0, 0.0, 1.0)
someView.layer.addSublayer(replicatorLayer)
  
// 5
let instanceLayer = CALayer()
let layerWidth: CGFloat = 10.0
let midX = CGRectGetMidX(someView.bounds) - layerWidth / 2.0
instanceLayer.frame = CGRect(x: midX, y: 0.0, width: layerWidth, height: layerWidth * 3.0)
instanceLayer.backgroundColor = UIColor.whiteColor().CGColor
replicatorLayer.addSublayer(instanceLayer)
  
// 6
let fadeAnimation = CABasicAnimation(keyPath: "opacity")
fadeAnimation.fromValue = 1.0
fadeAnimation.toValue = 0.0
fadeAnimation.duration = 1
fadeAnimation.repeatCount = Float(Int.max)
  
// 7
instanceLayer.opacity = 0.0
instanceLayer.addAnimation(fadeAnimation, forKey: "FadeAnimation")
```
以上代码：

- 创建一个CAReplicatorLayer实例，设框架为someView边界。
- 设复制图层数instanceCount和绘制延迟，设图层为2D（preservesDepth = false），实例颜色为白色。
- 为陆续的实例复件设置RGB颜色偏差值（默认为0，即所有复件保持颜色不变），不过这里实例初始颜色为白色，即RGB都为1.0，所以偏差值设红色为0，绿色和蓝色为相同负数会使其逐渐现出红色，alpha透明度偏差值的变化也与此类似，针对陆续的实例复件。
- 创建旋转变换，使得实例复件按一个圆排列。
- 创建供复制图层使用的实例图层，设置框架，使第一个实例在someView边界顶端水平中心处绘制，另外设置实例颜色，把实例图层添加到复制图层。
- 创建一个透明度由1（不透明）过渡为0（透明）的淡出动画。
- 设实例图层透明度为0，使得每个实例在绘制和改变颜色与alpha前保持透明。
这段代码会实现这样的东西：

![](http://cc.cocimg.com/api/uploads/20150318/1426645655395352.gif)

图层演示应用中，你可以改动这些属性：

![](http://cc.cocimg.com/api/uploads/20150318/1426645664752552.png)
