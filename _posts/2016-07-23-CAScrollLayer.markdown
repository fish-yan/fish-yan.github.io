---
layout:     post
title:      "iOS 动画 Animation-0-2：CALayer十则示例-CAScrollLayer"
subtitle:   "iOS 动画 Animation"
date:       2016-07-15 22:00:00
author:     "FishYan"
header-img: "img/blog-header.png"
tags:
    - iOS
    - iOS 动画
---


## CAScrollLayer

CAScrollLayer显示一部分可滚动图层，该图层十分基础，无法直接响应用户的触摸操作，也不能直接检查可滚动图层的边界，故可避免越界无限滚动。 

UIScrollView用的不是CAScrollLayer，而是直接改动图层边界。

CAScrollLayer的滚动模式可设为水平、垂直或者二维，你也可以用代码命令视图滚动到指定位置：

```swift
// In ScrollingView.swift
import UIKit
  
class ScrollingView: UIView {
  // 1
  override class func layerClass() -> AnyClass {
    return CAScrollLayer.self
  }
}
  
// In CAScrollLayerViewController.swift
import UIKit
  
class CAScrollLayerViewController: UIViewController {
  @IBOutlet weak var scrollingView: ScrollingView!
  
  // 2
  var scrollingViewLayer: CAScrollLayer {
    return scrollingView.layer as CAScrollLayer
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    // 3
    scrollingViewLayer.scrollMode = kCAScrollBoth
  }
  
  @IBAction func tapRecognized(sender: UITapGestureRecognizer) {
    // 4
    var newPoint = CGPoint(x: 250, y: 250)
    UIView.animateWithDuration(0.3, delay: 0, options: .CurveEaseInOut, animations: {
      [unowned self] in
      self.scrollingViewLayer.scrollToPoint(newPoint)
      }, completion: nil)
  }
  
}
```
以上代码：

- 定义一个继承UIView的类，重写layerClass()返回CAScrollLayer，该方法等同于创建一个新图层作为子图层（CALayer示例中做过）。
- 一个用以方便简化访问自定义视图滚动图层的计算属性。
- 设滚动模式为二维滚动。
- 识别出轻触手势时，让滚动图层在UIView动画中滚到新建的点。（注：scrollToPoint(_:)和scrollToRect(_:)不会自动使用动画效果。）

案例研究：如果ScrollingView实例包含大于滚动视图边界的图片视图，在运行上述代码并点击视图时结果如下：

![](http://cc.cocimg.com/api/uploads/20150317/1426581687136971.gif)

图层演示应用中有可以锁定滚动方向（水平或垂直）的开关。

以下经验规律用于决定是否使用CAScrollLayer：

如果想使用轻量级的对象，只需用代码操作滚动：可以考虑CAScrollLayer。
如果想让用户操作滚动，UIScrollView大概是更好的选择。

如果是滚动大型图片：考虑使用CATiledLayer（见后文）。