---
layout:     post
title:      "iOS 动画Animation-4-2: CALayer子类：CAGradientLayer，CATextLayer，CATiledLayer"
subtitle:   "iOS 动画 Animation"
date:       2016-10-11 22:00:00
author:     "FishYan"
header-img: "img/blog-header.png" 
catalog:    true
tags:
    - iOS
    - iOS 动画
---

>首先说明：这是一系列文章，参考本专题下其他的文章有助于你对本文的理解。

在上一篇中对CALayer做了一个简单的介绍。CALayer的属性在这些子类身上也都有。如果对CALayer属性还不够了解，可以参照上一篇。

今天先介绍CALayer这三个子类，这三个子类使用的概率不高，不过可以了解一下，万一用到了呢。在每介绍一个类，我都会在后面附上我写的Demo来方便大家学习，Demo写的都比较简单，力求每一个能从  **iOS 动画Animation-1看到这儿的人都可以看的懂**

## 1、CAGradientLayer
CAGradientLayer简化了混合两种或更多颜色的工作，尤其适用于背景。要配置渐变色，你需要分配一个CGColor数组，以及标识渐变图层起止点的startPoint和endPoint。

注意：startPoint和endPoint并不是明确的点，而是用单位坐标空间定义，在绘制时映射到图层边界。也就是说x值为1表示点在图层右边缘，y值为1表示点在图层下边缘。

CAGradientLayer包含type属性，虽说该属性只有kCAGradientLayerAxial一个选择，由数组中的各颜色产生线性过渡渐变。
先上图：
![这里写图片描述](http://img.blog.csdn.net/20160323135936277)

在上代码：
```objective-c
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
这个比较简单，就不做过多解释了。

## 2、CATextLayer
CATextLayer能够对普通文本或属性字串进行简单快速的渲染。与UILabel不同，CATextLayer无法指定UIFont，只能使用CTFontRef或CGFontRef。

像下面这样的代码完全可以掌控文本的字体、字体大小、颜色、对齐、折行（wrap）和截断（truncation）规则，也有动画效果。

不仅是CATextLayer，所有图层类的渲染缩放系数都默认为1。在添加到视图时，图层自身的contentsScale缩放系数会自动调整，适应当前画面。你需要为手动创建的图层明确指定contentsScale属性，否则默认的缩放系数1会在Retina显示屏上产生部分模糊。

如果创建的文本图层添加到了方形的someView，效果会像这样：

![这里写图片描述](http://img.blog.csdn.net/20160323140438951)

你可以设置截断（Truncation）属性，生效时被截断的部分文本会由省略号代替显示。默认设定为无截断，位置可设为开头、末尾或中间截断：!

![这里写图片描述](http://img.blog.csdn.net/20160323140619795)

上代码：
```objective-c
// 1

let textLayer = CATextLayer()

textLayer.frame = someView.bounds

  

// 2

var string = ""

for _ in 1...20 {

  string += "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Fusce auctor arcu quis velit congue dictum. "

}

  

textLayer.string = string

  

// 3

let fontName: CFStringRef = "Noteworthy-Light"

textLayer.font = CTFontCreateWithName(fontName, fontSize, nil)

  

// 4

textLayer.foregroundColor = UIColor.darkGrayColor().CGColor

textLayer.wrapped = true

textLayer.alignmentMode = kCAAlignmentLeft

textLayer.contentsScale = UIScreen.mainScreen().scale

someView.layer.addSublayer(textLayer)

```
以上代码解释如下：

- 创建一个CATextLayer实例，令边界与someView相同。
- 重复一段文本，创建字符串并赋给文本图层。
- 创建一个字体，赋给文本图层。
- 将文本图层设为折行、左对齐，你也可以设自然对齐（natural）、右对齐（right）、居中对齐（center）或两端对齐（justified），按屏幕设置contentsScale属性，然后把图层添加到视图结构树。


## 3、CATiledLayer

CATiledLayer以图块（tile）为单位异步绘制图层内容，对超大尺寸图片或者只能在视图中显示一小部分的内容效果拔群，因为不用把内容完全载入内存就可以看到内容。

代码绘制6×6随机色块方格，最终效果如下：
 ![这里写图片描述](http://img.blog.csdn.net/20160323144941704)

上代码：
```objective-c
// In ViewController.swift

import UIKit

  

class ViewController: UIViewController {

  

  // 1

  @IBOutlet weak var tiledBackgroundView: TiledBackgroundView!

  

}

  

// In TiledBackgroundView.swift

import UIKit

  

class TiledBackgroundView: UIView {

  

  let sideLength = CGFloat(50.0)

  

  // 2

  override class func layerClass() -> AnyClass {

    return CATiledLayer.self

  }

  

  // 3

  required init(coder aDecoder: NSCoder) {

    super.init(coder: aDecoder)

    srand48(Int(NSDate().timeIntervalSince1970))

    let layer = self.layer as CATiledLayer

    let scale = UIScreen.mainScreen().scale

    layer.contentsScale = scale

    layer.tileSize = CGSize(width: sideLength * scale, height: sideLength * scale)

  }

  

  // 4

  override func drawRect(rect: CGRect) {

    let context = UIGraphicsGetCurrentContext()

    var red = CGFloat(drand48())

    var green = CGFloat(drand48())

    var blue = CGFloat(drand48())

    CGContextSetRGBFillColor(context, red, green, blue, 1.0)

    CGContextFillRect(context, rect)

  }

}
```

代码解释：

- tiledBackgroundView位于 (150, 150) ，宽高均为300。
- 重写layerClass()，令该视图创建的图层实例为CATiledLayer。
- 设置rand48()的随机数种子，用于在drawRect()中生成随机颜色。CATiledLayer类型转换，缩放图层内容，设置图块尺寸，适应屏幕。
- 重写drawRect()，以随机色块填充视图。

今天到此为止，下一篇介绍CAReplicatorLayer（可以制作菊花）
依旧先上图：
 ![这里写图片描述](http://img.blog.csdn.net/20160323145857348)