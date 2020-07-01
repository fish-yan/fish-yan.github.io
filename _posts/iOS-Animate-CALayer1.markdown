---
layout:     post
title:      "iOS动画Animation-4-1:CALayer"
subtitle:   "iOS 动画 Animation"
date:       2016-10-08 22:00:00
author:     "FishYan"
header-img: "img/blog-header.png" 
catalog:    true
tags:
    - iOS
    - iOS 动画
---

>首先说明：这是一系列文章，参考本专题下其他的文章有助于你对本文的理解。
##   一、CALayer简介
CALayer作为动画主要的依托对象,想要深入的了解动画，必须先理解CALayer。CALayer包含在QuartzCore框架中，这是一个跨平台的框架，既可以用在iOS中又可以用在Mac OS X中。在使用Core Animation开发动画的本质就是将CALayer中的内容转化为位图从而供硬件操作。
在iOS中CALayer的设计主要是了为了内容展示和动画操作，CALayer本身并不包含在UIKit中，它不能响应事件。由于CALayer在设计之初就考虑它的动画操作功能，CALayer很多属性在修改时都能形成动画效果，这种属性称为“隐式动画属性”。但是对于UIView的根图层而言属性的修改并不形成动画效果，因为很多情况下根图层更多的充当容器的做用，如果它的属性变动形成动画效果会直接影响子图层。另外，UIView的根图层创建工作完全由iOS负责完成，无法重新创建，但是可以往根图层中添加子图层或移除子图层。
![这里写图片描述](http://img.blog.csdn.net/20160321144845060)

##   二、CALayer常见属性
下面表格中是CALayer的常见的属性:
![这里写图片描述](http://img.blog.csdn.net/20160321145025170)

1.隐式属性动画的本质是这些属性的变动默认隐含了CABasicAnimation动画实现，详情大家可以参照Xcode帮助文档中“Animatable Properties”一节。

2.在CALayer中很少使用frame属性，因为frame本身不支持动画效果，通常使用bounds和position代替。

3.CALayer中透明度使用opacity表示而不是alpha；中心点使用position表示而不是center。

4.anchorPoint属性是图层的锚点，范围在（0~1,0~1）表示在x、y轴的比例，这个点永远可以同position（中心点）重合，当图层中心点固定后，调整anchorPoint即可达到调整图层显示位置的作用（因为它永远和position重合）

为了进一步说明anchorPoint的作用，假设有一个层大小100*100，现在中心点位置（50,50），由此可以得出frame（0,0,100,100）。上面说过anchorPoint默认为（0.5,0.5），同中心点position重合，此时使用图形描述如图1；当修改anchorPoint为（0,0），此时锚点处于图层左上角，但是中心点poition并不会改变，因此图层会向右下角移动，如图2；然后修改anchorPoint为（1,1,），position还是保持位置不变，锚点处于图层右下角，此时图层如图
![这里写图片描述](http://img.blog.csdn.net/20160321150037987)

我也顺手写了一个[Demo](https://github.com/fish-yan/CALayer)来帮助大家了解一下其中一部分属性的作用。

**代码**
```objc
import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var viewForLayer: UIView!
    var myLayer: CALayer{
        return viewForLayer.layer
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpLayer()
        // Do any additional setup after loading the view, typically from a nib.
    }
    func setUpLayer(){
        myLayer.backgroundColor = UIColor.blueColor().CGColor
        myLayer.borderWidth = 100
        myLayer.borderColor = UIColor.redColor().CGColor
        myLayer.shadowRadius = 3
        myLayer.shadowOffset = CGSize(width: 0, height: 3)
        myLayer.shadowOpacity = 0.7
        myLayer.contents = UIImage(named: "star")?.CGImage
        myLayer.contentsGravity = kCAGravityCenter
        myLayer.magnificationFilter = kCAFilterTrilinear
        myLayer.geometryFlipped = false
    }

    @IBAction func tap(sender: AnyObject) {
        myLayer.shadowOpacity = myLayer.shadowOpacity == 0.7 ? 0.0 : 0.7
    }
    @IBAction func pinch(sender: UIPinchGestureRecognizer) {
        let offset: CGFloat = sender.scale < 1 ? 5.0 : -5.0
        let oldFrame = myLayer.frame
        let oldOrgin = oldFrame.origin
        let newSize = CGSize(width: oldFrame.width + (offset * -2.0), height: oldFrame.height + (offset * -2.0))
        let newOrgin = CGPoint(x: oldOrgin.x + offset, y: oldOrgin.y + offset)
        let newFrame = CGRect(origin: newOrgin, size: newSize)
        if newFrame.width >= 100.0 && newFrame.width < 300 {
            myLayer.borderWidth -= offset
            myLayer.cornerRadius += offset / 2.0
            myLayer.frame = newFrame
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}
```

**效果图**
![这里写图片描述](http://img.blog.csdn.net/20160321150559153)