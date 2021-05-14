---
layout:     post
title:      "iOS 动画 Animation-0-9：CALayer十则示例-CATransformLayer"
subtitle:   "iOS 动画 Animation"
date:       2016-08-27 22:00:00
author:     "FishYan"
header-img: "img/blog-header.png" 
catalog:    true
tags:
    - iOS
    - iOS 动画
---

# iOS 动画 Animation-0-9：CALayer十则示例-CATransformLayer

## CATransformLayer

CATransformLayer不像其他图层类一样把子图层结构平面化，故适宜绘制3D结构。变换图层本质上是一个图层容器，每个子图层都可以应用自己的透明度和空间变换，而其他渲染图层属性（如边宽、颜色）会被忽略。

变换图层本身不支持点击测试，因为无法直接在触摸点和平面坐标空间建立映射，不过其中的子图层可以响应点击测试，例如：

```swift
import UIKit
  
class ViewController: UIViewController {
  
  @IBOutlet weak var someView: UIView!
  
  // 1
  let sideLength = CGFloat(160.0)
  var redColor = UIColor.redColor()
  var orangeColor = UIColor.orangeColor()
  var yellowColor = UIColor.yellowColor()
  var greenColor = UIColor.greenColor()
  var blueColor = UIColor.blueColor()
  var purpleColor = UIColor.purpleColor()
  var transformLayer = CATransformLayer()
  
  // 2
  func setUpTransformLayer() {
    var layer = sideLayerWithColor(redColor)
    transformLayer.addSublayer(layer)
  
    layer = sideLayerWithColor(orangeColor)
    var transform = CATransform3DMakeTranslation(sideLength / 2.0, 0.0, sideLength / -2.0)
    transform = CATransform3DRotate(transform, degreesToRadians(90.0), 0.0, 1.0, 0.0)
    layer.transform = transform
    transformLayer.addSublayer(layer)
  
    layer = sideLayerWithColor(yellowColor)
    layer.transform = CATransform3DMakeTranslation(0.0, 0.0, -sideLength)
    transformLayer.addSublayer(layer)
  
    layer = sideLayerWithColor(greenColor)
    transform = CATransform3DMakeTranslation(sideLength / -2.0, 0.0, sideLength / -2.0)
    transform = CATransform3DRotate(transform, degreesToRadians(90.0), 0.0, 1.0, 0.0)
    layer.transform = transform
    transformLayer.addSublayer(layer)
  
    layer = sideLayerWithColor(blueColor)
    transform = CATransform3DMakeTranslation(0.0, sideLength / -2.0, sideLength / -2.0)
    transform = CATransform3DRotate(transform, degreesToRadians(90.0), 1.0, 0.0, 0.0)
    layer.transform = transform
    transformLayer.addSublayer(layer)
  
    layer = sideLayerWithColor(purpleColor)
    transform = CATransform3DMakeTranslation(0.0, sideLength / 2.0, sideLength / -2.0)
    transform = CATransform3DRotate(transform, degreesToRadians(90.0), 1.0, 0.0, 0.0)
    layer.transform = transform
    transformLayer.addSublayer(layer)
  
    transformLayer.anchorPointZ = sideLength / -2.0
    applyRotationForXOffset(16.0, yOffset: 16.0)
  }
  
  // 3
  func sideLayerWithColor(color: UIColor) -> CALayer {
    let layer = CALayer()
    layer.frame = CGRect(origin: CGPointZero, size: CGSize(width: sideLength, height: sideLength))
    layer.position = CGPoint(x: CGRectGetMidX(someView.bounds), y: CGRectGetMidY(someView.bounds))
    layer.backgroundColor = color.CGColor
    return layer
  }
  
  func degreesToRadians(degrees: Double) -> CGFloat {
    return CGFloat(degrees * M_PI / 180.0)
  }
  
  // 4
  func applyRotationForXOffset(xOffset: Double, yOffset: Double) {
    let totalOffset = sqrt(xOffset * xOffset + yOffset * yOffset)
    let totalRotation = CGFloat(totalOffset * M_PI / 180.0)
    let xRotationalFactor = CGFloat(totalOffset) / totalRotation
    let yRotationalFactor = CGFloat(totalOffset) / totalRotation
    let currentTransform = CATransform3DTranslate(transformLayer.sublayerTransform, 0.0, 0.0, 0.0)
    let rotationTransform = CATransform3DRotate(transformLayer.sublayerTransform, totalRotation,
      xRotationalFactor * currentTransform.m12 - yRotationalFactor * currentTransform.m11,
      xRotationalFactor * currentTransform.m22 - yRotationalFactor * currentTransform.m21,
      xRotationalFactor * currentTransform.m32 - yRotationalFactor * currentTransform.m31)
    transformLayer.sublayerTransform = rotationTransform
  }
  
  // 5
  override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
    if let location = touches.anyObject()?.locationInView(someView) {
      for layer in transformLayer.sublayers {
        if let hitLayer = layer.hitTest(location) {
          println("Transform layer tapped!")
          break
        }
      }
    }
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
  
    // 6
    setUpTransformLayer()
    someView.layer.addSublayer(transformLayer)
  }
  
}
```
上述代码解释：

- 创建属性，分别为立方体的边长、每个面的颜色，还有一个变换图层。
- 创建六个面，旋转后添加到变换图层，构成立方体，然后设置变换图层的z轴锚点，旋转立方体，将其添加到视图结构树。
- 辅助代码，用来创建指定颜色的面，还有角度和弧度的转换。在变换代码中利用弧度转换函数在某种程度上可以增加代码可读性。 :]
- 基于指定xy偏移的旋转，注意变换应用对象设为sublayerTransform，即变换图层的子图层。
- 监听触摸，遍历变换图层的子图层，对每个图层进行点击测试，一旦成功相应立即跳出循环，不用继续遍历。
- 设置变换图层，添加到视图结构树。

注：currentTransform.m##是啥？问得好，是CATransform3D属性，代表矩阵元素。想学习如上代码中的矩阵变换，请参考RW教程组成员Rich Turton的三维变换娱乐教学，还有Mark Pospesel的初识矩阵项目。

在250 x 250的someView视图中运行上述代码结果如下：

![](http://cc.cocimg.com/api/uploads/20150318/1426649245764582.png)

再试试点击立方体的任意位置，控制台会输出“Transform layer tapped!”信息。

图层演示应用中可以调整透明度，此外Bill Dudney轨迹球工具, Swift移植版可以基于简单的用户手势应用三维变换。

![](http://cc.cocimg.com/api/uploads/20150318/1426649284464542.png)
