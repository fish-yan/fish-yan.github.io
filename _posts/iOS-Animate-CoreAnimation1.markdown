---
layout:     post
title:      "iOS 动画Animation-2-2: 动画基础：核心动画"
subtitle:   "iOS 动画 Animation"
date:       2016-10-03 22:00:00
author:     "FishYan"
header-img: "img/blog-header.png" 
catalog:    true
tags:
    - iOS
    - iOS 动画
---

>首先说明：这是一系列文章，参考本专题下其他的文章有助于你对本文的理解。

上一篇已经简单的介绍过核心动画了，这次就针对实力详细介绍一下Animation 核心动画。

Demo在[Github地址](https://github.com/fish-yan/Animation2)，可以下载下来跟着敲一下
## CALayer动画
- 前面也说了，核心动画是作用在layer层的动画。所以也先简单的介入一下CALayer动画，CALayer动画主要有两个属性anchorPoint和position。
1.锚点 anchorPoint 锚点决定layer层上的那个点是position点 锚点默认是(0.5,0.5)跟视图的中心点重合
2.基准点 position 决定当前视图的layer在父视图上得位置,他以父视图的坐标系为准,
3.视图创建出来的时候锚点,中心点,基准点是重合的，
```swift
  func layerAnimation(){
        animationView.layer.anchorPoint = CGPointMake(0.5, 0)
        animationView.transform = CGAffineTransformRotate(self.animationView.transform, CGFloat(M_PI_4))
        animationView.layer.position = CGPointMake(200, 300)
    }
```
这样做就会使animationView围绕着设定的那个点旋转。

## CABasicAnimation 基础动画
CA动画是根据KVC的原理去修改layer层的属性,以达到做动画的效果
keypath一般为"position"和"transform"，以及他们等点出来的属性

```swift
func basicAnimation(){

        let basic = CABasicAnimation(keyPath: "position.x")
        basic.duration = 3.0
        basic.repeatCount = 5
        basic.fromValue = -80
        basic.toValue = 500
        animationView.layer.addAnimation(basic, forKey: nil)
   }
```
## 关键帧动画

```swift
func keyFrameAnimation(){
        /*
        let keyFrame = CAKeyframeAnimation(keyPath: "position.x")
        keyFrame.duration = 0.1
        keyFrame.repeatCount = 10
        let center = animationView.center
        keyFrame.values = [center.x - 5, center.x, center.x + 5]
        animationView.layer.addAnimation(keyFrame, forKey: nil)
        */
        /*
        let keyFrame = CAKeyframeAnimation(keyPath: "position")
        keyFrame.duration = 5
        keyFrame.repeatCount = 5
        //节点位置
        let point1 = animationView.center
        let point2 = CGPoint(x: 200, y: 100)
        let point3 = CGPoint(x: 100, y: point1.y)
        let point4 = CGPoint(x: 300, y: point1.y)
        let value1 = NSValue(CGPoint: point1)
        let value2 = NSValue(CGPoint: point2)
        let value3 = NSValue(CGPoint: point3)
        let value4 = NSValue(CGPoint: point4)
        //将节点位置加入到values中
        keyFrame.values = [value1, value4, value2, value3, value1]
        self.animationView.layer.addAnimation(keyFrame, forKey: nil)
        */
       
        let keyFrame = CAKeyframeAnimation(keyPath: "transform.rotation")
        keyFrame.duration = 0.1
        keyFrame.values = [-4/180*M_PI, 4/180*M_PI, -4/180*M_PI]
        keyFrame.repeatCount = 10
        animationView.layer.addAnimation(keyFrame, forKey:
 nil)
       
    }
```
## CALayer过度动画
```swift
let transiton = CATransition()
        transiton.duration = 1
        transiton.repeatCount = 5
        transiton.type = "rippleEffect"
        self.view.layer.addAnimation(transiton, forKey: nil)
}
```
**其他常见的API**
/*
        *  各种动画效果  其中除了'fade', `moveIn', `push' , `reveal' ,其他属于私有的API(我是这么认为的,可以点进去看下注释).
       
        *  ↑↑↑上面四个可以分别使用'kCATransitionFade', 'kCATransitionMoveIn', 'kCATransitionPush', 'kCATransitionReveal'来调用.
       
        *  @"cube"                     立方体翻滚效果
       
        *  @"moveIn"                   新视图移到旧视图上面
       
        *  @"reveal"                   显露效果(将旧视图移开,显示下面的新视图)
       
        *  @"fade"                     交叉淡化过渡(不支持过渡方向)             (默认为此效果)
       
        *  @"pageCurl"                 向上翻一页
       
        *  @"pageUnCurl"               向下翻一页
       
        *  @"suckEffect"               收缩效果，类似系统最小化窗口时的神奇效果(不支持过渡方向)
       
        *  @"rippleEffect"             滴水效果,(不支持过渡方向)
       
        *  @"oglFlip"                  上下左右翻转效果
       
        *  @"rotate"                   旋转效果
       
        *  @"push"
       
        *  @"cameraIrisHollowOpen"     相机镜头打开效果(不支持过渡方向)
       
        *  @"cameraIrisHollowClose"    相机镜头关上效果(不支持过渡方向)
       
        */

## CAAnimationGroup分组动画
```swift
  func animationGroup(){
        //创建第一个关键帧动画,给热气球提供一个运动轨迹,
        let keyFramePath = CAKeyframeAnimation(keyPath: "position")
        //贝赛尔曲线
        //1.指定贝塞尔曲线的半径
        //CGFloat radius = kScreenHeight;
        //01.圆心
        //02.半径
        //03.开始角度
        //04.结束角度
        //05.旋转方向,YES是顺时针,NO是逆时针
        let path = UIBezierPath(arcCenter: CGPoint(x: -100, y: 300), radius: 300, startAngle: CGFloat(-M_PI_2), endAngle: CGFloat(M_PI_2), clockwise: true)
        keyFramePath.path = path.CGPath
        //2设置动画执行完毕后，不删除动画
        keyFramePath.removedOnCompletion = false
        //3设置保存动画的最新状态
        keyFramePath.fillMode = kCAFillModeForwards
        //4.代理，有一个start和一个stop方法
        keyFramePath.delegate = self
       
        //4设置动画的节奏
        keyFramePath.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        //创建第二个关键帧动画,让热气球运动的时候由小-->大-->小
        let keyFrameScale = CAKeyframeAnimation(keyPath: "transform.scale")
        keyFrameScale.values = [1.0,1.2,1.4,1.8,2.2,1.8,1.4,1.2,1.0]
        let group = CAAnimationGroup()
        group.duration = 8
        group.repeatCount = 100
        //将两个动画效果添加到分组动画中
        group.animations = [keyFramePath, keyFrameScale]
        balloon.layer.addAnimation(group, forKey: nil)
       
    }
```
当然，这些并不全面，这里只起到一个抛砖引玉的作用。
