---
layout:     post
title:      "iOS 动画Animation-4-5: CALayer子类:CATransformLayer"
subtitle:   "iOS 动画 Animation"
date:       2016-10-29 22:00:00
author:     "FishYan"
header-img: "img/blog-header.png" 
catalog:    true
tags:
    - iOS
    - iOS 动画
---

>首先说明：这是一系列文章，参考本专题下其他的文章有助于你对本文的理解。


今天来讲解一下CATransformLayer：CATransformLayer是一个专门用来创建三维视图的一个layer，也可以说是多个layer的集合。他没有多余的API，可以这么说，他只是承载了子layer。

下面就看一个例子，通过例子来讲解。

国际惯例先上图：

![这里写图片描述](http://img.blog.csdn.net/20160416123724847)

图就是这样的纯手工打造。

先创建一个CATransformLayer对象：
```swift
var transformLayer = CATransformLayer()
transformLayer.frame = someView.bounds
someView.layer.addSublayer(transformLayer)
```
这个没有任何技术含量。同样someView为我用storyboard创建的一个view

然后创建他的子layer，将layer添加到transformLayer上
```swift
var layer = sideLayerWithColor(redColor)
transformLayer.addSublayer(layer)
        
layer = sideLayerWithColor(orangeColor)
var transform = CATransform3DMakeTranslation(sideLength / 2, 0.0, sideLength / -2)
transform = CATransform3DRotate(transform, degreesToRadians(90.0), 0.0, 1.0, 0.0)
layer.transform = transform
transformLayer.addSublayer(layer)
        
layer = sideLayerWithColor(yellowColor)
layer.transform = CATransform3DMakeTranslation(0.0, 0.0, -sideLength)
transformLayer.addSublayer(layer)
        
layer  = sideLayerWithColor(greenColor)
transform = CATransform3DMakeTranslation(sideLength / -2, 0.0, sideLength / -2)
transform = CATransform3DRotate(transform, degreesToRadians(90.0), 0.0, 1.0, 0.0)
layer.transform = transform
transformLayer.addSublayer(layer)
        
layer = sideLayerWithColor(blueColor)
transform = CATransform3DTranslate(transform, 0.0, sideLength / -2, sideLength / 2)
transform = CATransform3DRotate(transform, degreesToRadians(90.0), 1.0, 0.0, 0.0)
layer.transform = transform
transformLayer.addSublayer(layer)
        
layer = sideLayerWithColor(purpleColor)
transform = CATransform3DMakeTranslation(0.0, sideLength / 2.0, sideLength / -2.0)
transform = CATransform3DRotate(transform, degreesToRadians(90.0), 1.0, 0.0, 0.0)
layer.transform = transform
transformLayer.addSublayer(layer)

transformLayer.anchorPointZ = sideLength / -2.0
```
* 解释：

可以看到代码分为六块，这分别是创建一个立方体的六个面。不外乎都是根据第一个做了下旋转和平移（如果有对这个不太理解的请看：[iOS 动画Animation-3: CATransform3D 特效详解](http://blog.csdn.net/fish_yan_/article/details/50885136)）

再说到：sideLayerWithColor(purpleColor)这是什么鬼？

不要急，这是为了方便写的一个创建layer的方法，内容如下

```swift
func sideLayerWithColor(color: UIColor) -> CALayer {
    let layer = CALayer()
    layer.frame = CGRect(origin: CGPointZero, size:   CGSize(width: sideLength, height: sideLength))
    layer.backgroundColor = color.CGColor
    return layer
}
```
还有一个：degreesToRadians（），这个是转换角度，看上去更方便也更顺眼。
```swift
func degreesToRadians(degrees: Double) -> CGFloat {
    return CGFloat(degrees * M_PI / 180.0)
}
```

括号内的参数分别是我定义的颜色来区分每个面的颜色不同
```swift
var redColor = UIColor.redColor()
var orangeColor = UIColor.orangeColor()
var yellowColor = UIColor.yellowColor()
var greenColor = UIColor.grayColor()
var purpleColor = UIColor.purpleColor()
var blueColor = UIColor.blueColor()
```
最后一行设置锚点，将锚点设置为立方体的中心

现在一个立方体已经做好了，但是运行之后看到的仍然是平面，因为这个立方体是正对着屏幕，其他面都被遮挡了。

下面就写个方法让他旋转角度
```swift
func applyRoationForXOffset(xOffset: Double, yOffset: Double){
        
    let totalOffset = sqrt(xOffset * xOffset + yOffset * yOffset)
    let totalRotation = CGFloat(totalOffset * M_PI / 180.0)
        
    let xRotationalFactor = CGFloat(xOffset) / totalRotation
    let yRotationalFactor = CGFloat(yOffset) / totalRotation
    let currentTransform = CATransform3DTranslate(transformLayer.sublayerTransform, 0.0, 0.0, 0.0)
    
    let rotationTransform = CATransform3DRotate(transformLayer.sublayerTransform, totalRotation, xRotationalFactor * currentTransform.m12 - yRotationalFactor * currentTransform.m11,  xRotationalFactor * currentTransform.m22 - yRotationalFactor * currentTransform.m21, xRotationalFactor * currentTransform.m32 - yRotationalFactor * currentTransform.m31)
    print(currentTransform.m12, currentTransform.m11)
    transformLayer.sublayerTransform = rotationTransform
    }
```
* 解释

- 第一个函数是求平方和然后开根，算出直线距离，
CGFloat(totalOffset * M_PI / 180.0)是将移动距离转回为角度
初始化Transform

关于矩阵变换不懂得也请参考：[iOS 动画Animation-3: CATransform3D 特效详解](http://blog.csdn.net/fish_yan_/article/details/50885136)）
然后在适当的地方调用这个方法，（就是在添加完所有的子layer后）

给参数设定值之后就可以看到一个有立体效果的立方体了，

下面就开始让这个立方体动起来，

手势的操作，当然少不了touchBegan和touchMoved了。

```swift
override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
    let touch: UITouch = touches.first!
    startPoint = touch.locationInView(someView)
}

override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
    let touch: UITouch = touches.first!
    let currentPoint = touch.locationInView(someView)
    let deltaX = currentPoint.x - startPoint.x
    let deltaY = currentPoint.y - startPoint.y
    applyRoationForXOffset(Double(deltaX), yOffset: Double(deltaY))
    startPoint = touch.locationInView(someView)

}
```
* 解释

- 在touchBegan的时候记录下手指开始位置（startPoint）
- 在touchMoved的时候记录下手指当前的位置（currentPoint）
- 然后通过计算的到x轴和y轴移动的距离
- 调用让立方体旋转的方法：applyRoationForXOffset(Double(deltaX), yOffset: Double(deltaY))
- 并且要及时的更新（startPoint）。

好了，相信如上图的效果也出来了，在这里放上自己做的[Demo](https://github.com/fish-yan/CATransformLayer)，以便还不是很懂的童鞋参考一下。

*对CALayer子类的介绍也告一段落了，但是不代表动画的介绍就结束了，还没呢！继续关注吧！*
