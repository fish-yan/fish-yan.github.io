---
layout:     post
title:      "iOS 动画 Animation-0-5：CALayer十则示例-CAGradientLayer"
subtitle:   "iOS 动画 Animation"
date:       2016-08-10 22:00:00
author:     "FishYan"
header-img: "img/blog-header.png" 
catalog:    true
tags:
    - iOS
    - iOS 动画
---

## CAGradientLayer

CAGradientLayer简化了混合两种或更多颜色的工作，尤其适用于背景。要配置渐变色，你需要分配一个CGColor数组，以及标识渐变图层起止点的startPoint和endPoint。

注意：startPoint和endPoint并不是明确的点，而是用单位坐标空间定义，在绘制时映射到图层边界。也就是说x值为1表示点在图层右边缘，y值为1表示点在图层下边缘。

CAGradientLayer包含type属性，虽说该属性只有kCAGradientLayerAxial一个选择，由数组中的各颜色产生线性过渡渐变。

具体含义是渐变过渡沿startPoint到endPoint的向量A方向产生，设B与A垂直，则各条B平行线上的所有点颜色相同。

![](http://cc.cocimg.com/api/uploads/20150317/1426583040917604.gif)

此外，locations属性可以使用一个数组（元素取值范围0到1），指定渐变图层参照colors顺序取用下一个过渡点颜色的位置。

未设定时默认会平均分配过渡点。一旦设定就必须与colors的数量保持一致，否则会出错。 

下面是创建渐变图层的例子：

```swift
let gradientLayer = CAGradientLayer()
gradientLayer.frame = someView.bounds
gradientLayer.colors = [cgColorForRed(209.0, green: 0.0, blue: 0.0),
  cgColorForRed(255.0, green: 102.0, blue: 34.0),
  cgColorForRed(255.0, green: 218.0, blue: 33.0),
  cgColorForRed(51.0, green: 221.0, blue: 0.0),
  cgColorForRed(17.0, green: 51.0, blue: 204.0),
  cgColorForRed(34.0, green: 0.0, blue: 102.0),
  cgColorForRed(51.0, green: 0.0, blue: 68.0)]
gradientLayer.startPoint = CGPoint(x: 0, y: 0)
gradientLayer.endPoint = CGPoint(x: 0, y: 1)
someView.layer.addSublayer(gradientLayer)
  
func cgColorForRed(red: CGFloat, green: CGFloat, blue: CGFloat) -> AnyObject {
  return UIColor(red: red/255.0, green: green/255.0, blue: blue/255.0, alpha: 1.0).CGColor as AnyObject
}
```
上述代码创建一个渐变图层，框架设为someView边界，指定颜色数组，设置起止点，添加图层到视图结构树。效果如下：

![](http://cc.cocimg.com/api/uploads/20150317/1426583069121832.png)

五彩缤纷，姹紫嫣红！ 

图层演示应用中，你可以随意修改起止点、颜色和过渡点：

![](http://cc.cocimg.com/api/uploads/20150317/1426583112222761.png)
