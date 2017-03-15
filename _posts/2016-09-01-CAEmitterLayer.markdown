---
layout:     post
title:      "iOS 动画 Animation-0-10：CALayer十则示例-CAEmitterLayer"
subtitle:   "iOS 动画 Animation"
date:       2016-09-01 22:00:00
author:     "FishYan"
header-img: "img/blog-header.png" 
catalog:    true
tags:
    - iOS
    - iOS 动画
---


## CAEmitterLayer

CAEmitterLayer渲染的动画粒子是CAEmitterCell实例。CAEmitterLayer和CAEmitterCell都包含可调整渲染频率、大小、形状、颜色、速率以及生命周期的属性。示例如下：

```swift
import UIKit
  
class ViewController: UIViewController {
  
  // 1
  let emitterLayer = CAEmitterLayer()
  let emitterCell = CAEmitterCell()
  
  // 2
  func setUpEmitterLayer() {
    emitterLayer.frame = view.bounds
    emitterLayer.seed = UInt32(NSDate().timeIntervalSince1970)
    emitterLayer.renderMode = kCAEmitterLayerAdditive
    emitterLayer.drawsAsynchronously = true
    setEmitterPosition()
  }
  
  // 3
  func setUpEmitterCell() {
    emitterCell.contents = UIImage(named: "smallStar")?.CGImage
  
    emitterCell.velocity = 50.0
    emitterCell.velocityRange = 500.0
  
    emitterCell.color = UIColor.blackColor().CGColor
    emitterCell.redRange = 1.0
    emitterCell.greenRange = 1.0
    emitterCell.blueRange = 1.0
    emitterCell.alphaRange = 0.0
    emitterCell.redSpeed = 0.0
    emitterCell.greenSpeed = 0.0
    emitterCell.blueSpeed = 0.0
    emitterCell.alphaSpeed = -0.5
  
    let zeroDegreesInRadians = degreesToRadians(0.0)
    emitterCell.spin = degreesToRadians(130.0)
    emitterCell.spinRange = zeroDegreesInRadians
    emitterCell.emissionRange = degreesToRadians(360.0)
  
    emitterCell.lifetime = 1.0
    emitterCell.birthRate = 250.0
    emitterCell.xAcceleration = -800.0
    emitterCell.yAcceleration = 1000.0
  }
  
  // 4
  func setEmitterPosition() {
    emitterLayer.emitterPosition = CGPoint(x: CGRectGetMidX(view.bounds), y: CGRectGetMidY(view.bounds))
  }
  
  func degreesToRadians(degrees: Double) -> CGFloat {
    return CGFloat(degrees * M_PI / 180.0)
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
  
    // 5
    setUpEmitterLayer()
    setUpEmitterCell()
    emitterLayer.emitterCells = [emitterCell]
    view.layer.addSublayer(emitterLayer)
  }
  
  // 6
  override func traitCollectionDidChange(previousTraitCollection: UITraitCollection?) {
    setEmitterPosition()
  }
  
}
```
以上代码解析：

- 1.创建粒子发射器图层和粒子胞（Creates an emitter layer and cell.）。

- 2.按照下方步骤设置粒子发射器图层：

    为随机数生成器提供种子，随机调整粒子胞的某些属性，如速度。

    在图层背景色和边界之上按renderMode指定的顺序渲染粒子胞。

注：渲染模式默认为无序（unordered），其他模式包括旧粒子优先（oldest first），新粒子优先（oldest last），按z轴位置从后至前（back to front）还有叠加式渲染（additive）。

由于粒子发射器需要反复重绘大量粒子胞，设drawsAsynchronously为true会提升性能。

然后借助第四条中会提到的辅助方法设置发射器位置，这个例子有助于理解把drawsAsynchronously设为true为何能够提升性能和动画流畅度。

- 3.这段代码设了不少东西。

    配置粒子胞，设内容为图片（图片在图层演示项目中）。

    指定初速及其变化量范围（velocityRange），发射器图层利用上面提到的随机数种子创建随机数生成器，在范围内产生随机值（初值+/-变化量范围），其他以“Range”结尾的相关属性的随机化规则类似。

    设颜色为黑色，使自变色（variance）与默认的白色形成对比，白色形成的粒子亮度过高。

    利用随机化范围设置颜色，指定自变色范围，颜色速度值表示粒子胞生命周期内颜色变化快慢。

    接下来这几行代码指定粒子胞分布范围，一个全圆锥。设置粒子胞转速和发射范围，发射范围emissionRange属性的弧度值决定粒子胞分布空间。

    设粒子胞生命周期为1秒，默认值为0，表示粒子胞不会出现。birthRate也类似，以秒为单位，默认值为0，为使粒子胞显示出来，必须设成正数。

    最后设xy加速度，这些值会影响已发射粒子的视角。

- 4.把角度转换成弧度的辅助方法，还有设置粒子胞位置为视图中点。

- 5.设置发射器图层和粒子胞，把粒子胞添加到图层，然后把图层添加到视图结构树。

- 6.iOS 8的新方法，处理当前设备形态集（trait collection）的变化，比如设备旋转。不熟悉形态集的话可以参阅iOS 8教程。 

总算说完了！信息量很大，但相信各位聪明的读者可以高效吸收。

上述代码运行效果如下：

![](http://cc.cocimg.com/api/uploads/20150318/1426650203373253.gif)

图层演示应用中，你可以随意调节很多属性：

![](http://cc.cocimg.com/api/uploads/20150318/1426650241174615.png)

 


恭喜，看完十则示例和各种图层子类，CALayer之旅至此告一段落。

但现在才刚刚开始！新建一个项目，或者打开已有项目，尝试利用图层提升性能或营造酷炫效果！实践出真知。