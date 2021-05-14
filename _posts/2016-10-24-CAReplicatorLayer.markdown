---
layout:     post
title:      "iOS 动画Animation-4-4: CALayer子类：CAReplicatorLayer"
subtitle:   "iOS 动画 Animation"
date:       2016-10-24 22:00:00
author:     "FishYan"
header-img: "img/blog-header.png" 
catalog:    true
tags:
    - iOS
    - iOS 动画
---

# iOS 动画Animation-4-4: CALayer子类：CAReplicatorLayer

>首先说明：这是一系列文章，参考本专题下其他的文章有助于你对本文的理解。

上一片介绍了CAShpeLayer，并且做了两个示例，如果创造力比较强，就那些东西可以创造出你以前不敢想象的动画效果。

今天我们接着来讲一下CAReplication
CAReplication是一个复制图层，可以按要求将layer复制出若干份，先来看看在CALayer的基础上又增加了那些API

| API | 描述 |
| - | -- |
| instanceCount|重复实例Layer（以下简称实例）的个数 |
|instanceDelay|实例持续的时间|
|instanceTransform|实例动画|
|instanceColor|实例颜色|
|instanceRedOffset|红色偏移|
|instanceGreenOffset|绿色偏移|
|instanceBlueOffset|蓝色偏移|
|instanceAlphaOffset|透明度偏移|
·
今天我以一个菊花为例，效果是这样的[Demo下载](https://github.com/fish-yan/CAReplicatorLayer)

![这里写图片描述](http://img.blog.csdn.net/20160413225941990)

这个可以作为tableView的下拉刷新的效果，当然我比较懒，是用了一个slider代替了tableView下拉的偏移量。

他的实现过程也很简单，我们就创建一个CAReplicatorLayer吧。
```swift
var replicatorLayer = CAReplicatorLayer()
replicatorLayer.frame = someView.bounds
someView.layer.addSublayer(replicatorLayer)
```
- 解释
同样someView为storyboard中创建的View
给定大小，并将其添加到someView的layer上


其实这一个菊花是有很多个重复的矩形layer组成的。那么还需要一个矩形的layer
```swift
var instanceLayer = CALayer()
let layerWidth: CGFloat = 10.0
let midX = CGRectGetMidX(someView.bounds) - layerWidth / 2
instanceLayer.frame = CGRect(x: midX, y: 0.0, width: layerWidth, height: layerWidth * 2.5)
instanceLayer.backgroundColor = UIColor.whiteColor().CGColor

replicatorLayer.addSublayer(instanceLayer)
```
- 解释
这里创建的小矩形layer叫instanceLayer
将其添加到replicatorLayer上

这样写到这只是在视图上放了一个replicatorLayer，然后又添加了一个矩形layer，接下来就可以开始设置replicatorLayer的属性了

先设定颜色
```swift
replicatorLayer.instanceColor = UIColor.grayColor().CGColor
     
//        replicatorLayer.instanceRedOffset = 0.0
//        replicatorLayer.instanceGreenOffset = 0.0
//        replicatorLayer.instanceBlueOffset = 0.0
//        replicatorLayer.instanceAlphaOffset = 0.0
```
- 解释
颜色偏移量自己尝试着调一下，看看有什么变化   

在storyboard上创建一个slider，用拖线的方式生成一个方法
```swift
 @IBAction func slider(sender: UISlider) {
        let count: Int = Int(sender.value * 30)
        replicatorLayer.instanceCount = count
        if sender.value == 1 {
            replicatorLayer.instanceDelay = CFTimeInterval(1.0 / Double(count))
            addAnimation()
        }else{
            if faderAnimation != nil {
                instanceLayer.opacity = 1.0
               instanceLayer.removeAnimationForKey("fader")
            }
            
        }
        
        replicatorLayer.instanceTransform = CATransform3DMakeRotation(CGFloat(Float(M_PI * 2.0) * sender.value / Float(count)), 0.0, 0.0, 1.0)
    }
```
- 解释
设置instancCount根据slider的值发生变化，int类型
持续1秒，CFTimeInterval类型，在这里代表的是生成count个layer所需要的时间
在slider的值不为1.0的时候，将动画去除，并且不透明度设为1
instanceTransform，设置动画，上面是3D动画绕Z轴旋转的角度

添加动画
```swift
func addAnimation() {
        faderAnimation = CABasicAnimation(keyPath: "opacity")
        faderAnimation.fromValue = 1.0
        faderAnimation.toValue = 0.0
        faderAnimation.duration = 1
        faderAnimation.repeatCount = Float(Int.max)
        instanceLayer.opacity = 0.0
        instanceLayer.addAnimation(faderAnimation, forKey: "fader")
        
    }

```
动画我就不解释，想了解动画的请看本专题下之前的文章