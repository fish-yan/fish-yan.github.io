---
layout:     post
title:      "iOS 动画 Animation-0-8：CALayer十则示例-CAShapeLayer"
subtitle:   "iOS 动画 Animation"
date:       2016-08-23 22:00:00
author:     "FishYan"
header-img: "img/blog-header.png" 
catalog:    true
tags:
    - iOS
    - iOS 动画
---

## CAShapeLayer

CAShapeLayer利用可缩放的矢量路径进行绘制，绘制速度比使用图片快很多，还有个好处是不用分别提供常规、@2x和@3x版本的图片，好用。

另外还有各种属性，让你可以自定线粗、颜色、虚实、线条接合方式、闭合线条是否形成闭合区域，还有闭合区域要填充何种颜色等。举例如下：


```swift
import UIKit
  
class ViewController: UIViewController {
  
  @IBOutlet weak var someView: UIView!
  
  // 1
  let rwColor = UIColor(red: 11/255.0, green: 86/255.0, blue: 14/255.0, alpha: 1.0)
  let rwPath = UIBezierPath()
  let rwLayer = CAShapeLayer()
  
  // 2
  func setUpRWPath() {
    rwPath.moveToPoint(CGPointMake(0.22, 124.79))
    rwPath.addLineToPoint(CGPointMake(0.22, 249.57))
    rwPath.addLineToPoint(CGPointMake(124.89, 249.57))
    rwPath.addLineToPoint(CGPointMake(249.57, 249.57))
    rwPath.addLineToPoint(CGPointMake(249.57, 143.79))
    rwPath.addCurveToPoint(CGPointMake(249.37, 38.25), controlPoint1: CGPointMake(249.57, 85.64), controlPoint2: CGPointMake(249.47, 38.15))
    rwPath.addCurveToPoint(CGPointMake(206.47, 112.47), controlPoint1: CGPointMake(249.27, 38.35), controlPoint2: CGPointMake(229.94, 71.76))
    rwPath.addCurveToPoint(CGPointMake(163.46, 186.84), controlPoint1: CGPointMake(182.99, 153.19), controlPoint2: CGPointMake(163.61, 186.65))
    rwPath.addCurveToPoint(CGPointMake(146.17, 156.99), controlPoint1: CGPointMake(163.27, 187.03), controlPoint2: CGPointMake(155.48, 173.59))
    rwPath.addCurveToPoint(CGPointMake(128.79, 127.08), controlPoint1: CGPointMake(136.82, 140.43), controlPoint2: CGPointMake(129.03, 126.94))
    rwPath.addCurveToPoint(CGPointMake(109.31, 157.77), controlPoint1: CGPointMake(128.59, 127.18), controlPoint2: CGPointMake(119.83, 141.01))
    rwPath.addCurveToPoint(CGPointMake(89.83, 187.86), controlPoint1: CGPointMake(98.79, 174.52), controlPoint2: CGPointMake(90.02, 188.06))
    rwPath.addCurveToPoint(CGPointMake(56.52, 108.28), controlPoint1: CGPointMake(89.24, 187.23), controlPoint2: CGPointMake(56.56, 109.11))
    rwPath.addCurveToPoint(CGPointMake(64.02, 102.25), controlPoint1: CGPointMake(56.47, 107.75), controlPoint2: CGPointMake(59.24, 105.56))
    rwPath.addCurveToPoint(CGPointMake(101.42, 67.57), controlPoint1: CGPointMake(81.99, 89.78), controlPoint2: CGPointMake(93.92, 78.72))
    rwPath.addCurveToPoint(CGPointMake(108.38, 30.65), controlPoint1: CGPointMake(110.28, 54.47), controlPoint2: CGPointMake(113.01, 39.96))
    rwPath.addCurveToPoint(CGPointMake(10.35, 0.41), controlPoint1: CGPointMake(99.66, 13.17), controlPoint2: CGPointMake(64.11, 2.16))
    rwPath.addLineToPoint(CGPointMake(0.22, 0.07))
    rwPath.addLineToPoint(CGPointMake(0.22, 124.79))
    rwPath.closePath()
  }
  
  // 3
  func setUpRWLayer() {
    rwLayer.path = rwPath.CGPath
    rwLayer.fillColor = rwColor.CGColor
    rwLayer.fillRule = kCAFillRuleNonZero
    rwLayer.lineCap = kCALineCapButt
    rwLayer.lineDashPattern = nil
    rwLayer.lineDashPhase = 0.0
    rwLayer.lineJoin = kCALineJoinMiter
    rwLayer.lineWidth = 1.0
    rwLayer.miterLimit = 10.0
    rwLayer.strokeColor = rwColor.CGColor
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
  
    // 4
    setUpRWPath()
    setUpRWLayer()
    someView.layer.addSublayer(rwLayer)
  }
  
}
```
代码解释：

- 创建颜色、路径、图形图层对象。
- 绘制图形图层路径。如果不喜欢编写生硬的绘图代码的话，你可以尝试PaintCode这款软件，可以利用简便的工具进行可视化绘制，支持导入现有的矢量图（SVG）和Photoshop（PSD）文件，并自动生成代码。
- 设置图形图层。路径设为第二步中绘制的CGPath路径，填充色设为第一步中创建的CGColor颜色，填充规则设为非零（non-zero），即默认填充规则。
- 填充规则共有两种，另一种是奇偶（even-odd）。不过示例代码中的图形没有相交路径，两种填充规则的结果并无差异。
- 非零规则记从左到右的路径为+1，从右到左的路径为-1，累加所有路径值，若总和大于零，则填充路径围成的图形。
- 从结果上来讲，非零规则会填充图形内部所有的点。
- 奇偶规则计算围成图形的路径交叉数，若结果为奇数则填充。这样讲有些晦涩，还是有图有真相：

右图围成中间五边形的路径交叉数为偶数，故中间没有填充，而围成每个三角的路径交叉数为奇数，故三角部分填充颜色。

![](http://cc.cocimg.com/api/uploads/20150318/1426647596649451.png)

- 调用路径绘制和图层设置代码，并把图层添加到视图结构树。

上述代码绘制raywenderlich.com的图标：

![](http://cc.cocimg.com/api/uploads/20150318/1426647615311989.png)

顺便看看使用PaintCode的效果图：

![](http://cc.cocimg.com/api/uploads/20150318/1426647671786117.png)

图层演示应用中，你可以随意修改很多CAShapeLayer属性：

![](http://cc.cocimg.com/api/uploads/20150318/1426647796269573.png)

注：我们先跳过演示应用中的下一个示例，因为CAEAGLLayer多少显得有些过时了，iOS 8 Metal框架有更先进的CAMetalLayer。在此推荐[iOS 8 Metal入门教程](http://www.raywenderlich.com/77488/ios-8-metal-tutorial-swift-getting-started)。
