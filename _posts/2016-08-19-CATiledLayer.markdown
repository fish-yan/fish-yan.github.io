---
layout:     post
title:      "iOS 动画 Animation-0-7：CALayer十则示例-CATiledLayer"
subtitle:   "iOS 动画 Animation"
date:       2016-08-19 22:00:00
author:     "FishYan"
header-img: "img/blog-header.png" 
catalog:    true
tags:
    - iOS
    - iOS 动画
---

# iOS 动画 Animation-0-7：CALayer十则示例-CATiledLayer

## CATiledLayer

CATiledLayer以图块（tile）为单位异步绘制图层内容，对超大尺寸图片或者只能在视图中显示一小部分的内容效果拔群，因为不用把内容完全载入内存就可以看到内容。

处理绘制有几种方法，一种是重写UIView，使用CATiledLayer绘制图块填充视图背景，如下：

```swift
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
- 代码绘制6×6随机色块方格，最终效果如下：

![](http://cc.cocimg.com/api/uploads/20150318/1426647023367477.png)

图层演示应用中除此之外还可以在图层背景上绘制轨迹：

![](http://cc.cocimg.com/api/uploads/20150318/1426647029483150.png)

在视图中放大时，上述截图中的星星图案会变得模糊：

![](http://cc.cocimg.com/api/uploads/20150318/1426647051453930.png)

产生模糊的根源是图层的细节层次（level of detail，简称LOD），CATiledLayer有两个相关属性：levelsOfDetail和levelsOfDetailBias。

levelsOfDetail顾名思义，指图层维护的LOD数目，默认值为1，每进一级会对前一级分辨率的一半进行缓存，图层的levelsOfDetail最大值，也就是最底层细节，对应至少一个像素点。

而levelsOfDetailBias指的是该图层缓存的放大LOD数目，默认为0，即不会额外缓存放大层次，每进一级会对前一级两倍分辨率进行缓存。

例如，设上述分块图层的levelsOfDetailBias为5会缓存2x、4x、8x、16x和32x的放大层次，放大的图层效果如下：

![](http://cc.cocimg.com/api/uploads/20150318/1426647088473224.png)

不错吧？别着急，还没讲完呢。

CATiledLayer裁刀，买不了吃亏，买不了上当，只要998…（译注：此处内容稍作本地化处理，原文玩的是1978年美国Ginsu刀具的梗，堪称询价型电视购物广告的万恶之源。） :]

开个玩笑。CATiledLayer还有一个更实用的功能：异步绘制图块，比如在滚动视图中显示一张超大图片。

在用户滚动画面时，要让分块图层知道哪些图块需要绘制，写代码在所难免，不过换来性能提升也值了。

图层演示应用的UIImage+TileCutter.swift中包含一个UIImage扩展，教程编纂组成员Nick Lockwood在著作iOS Core Animation: Advanced Techniques的一个终端应用程序中利用了这段代码。

代码的职责是把原图片拆分成指定尺寸的方块，按行列位置命名图块，比如第三行第七列的图块windingRoad62.png（索引从零开始）。

![](http://cc.cocimg.com/api/uploads/20150318/1426647105880761.png)

有了这些图块，我们可以自定义一个UIView子类，绘制分块图层：

```swift
import UIKit
  
class TilingViewForImage: UIView {
  
  // 1
  let sideLength = CGFloat(640.0)
  let fileName = "windingRoad"
  let cachesPath = NSSearchPathForDirectoriesInDomains(.CachesDirectory, .UserDomainMask, true)[0] as String
  
  // 2
  override class func layerClass() -> AnyClass {
    return CATiledLayer.self
  }
  
  // 3
  required init(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    let layer = self.layer as CATiledLayer
    layer.tileSize = CGSize(width: sideLength, height: sideLength)
  }
  
  // 4
  override func drawRect(rect: CGRect) {
    let firstColumn = Int(CGRectGetMinX(rect) / sideLength)
    let lastColumn = Int(CGRectGetMaxX(rect) / sideLength)
    let firstRow = Int(CGRectGetMinY(rect) / sideLength)
    let lastRow = Int(CGRectGetMaxY(rect) / sideLength)
  
    for row in firstRow...lastRow {
      for column in firstColumn...lastColumn {
        if let tile = imageForTileAtColumn(column, row: row) {
          let x = sideLength * CGFloat(column)
          let y = sideLength * CGFloat(row)
          let point = CGPoint(x: x, y: y)
          let size = CGSize(width: sideLength, height: sideLength)
          var tileRect = CGRect(origin: point, size: size)
          tileRect = CGRectIntersection(bounds, tileRect)
          tile.drawInRect(tileRect)
        }
      }
    }
  }
  
  func imageForTileAtColumn(column: Int, row: Int) -> UIImage? {
    let filePath = "\(cachesPath)/\(fileName)_\(column)_\(row)"
    return UIImage(contentsOfFile: filePath)
  }
  
}
```
以上代码：

- 创建属性，分别是图块边长、原图文件名、供TileCutter扩展保存图块的缓存文件夹路径。
- 重写layerClass()返回CATiledLayer。
- 实现init(_:)，把视图的图层转换为分块图层，设置图块大小。注意此处不必设置contentsScale适配屏幕，因为是直接修改视图自身的图层，而不是手动创建子图层。
- 重写drawRect()，按行列绘制各个图块。

像这样，原图大小的自定义视图就可以塞进一个滚动视图：

![](http://cc.cocimg.com/api/uploads/20150318/1426647145442038.png)

多亏CATiledLayer，滚动5120 x 3200的大图也会这般顺滑：

![](http://cc.cocimg.com/api/uploads/20150318/1426647161684958.gif)

如你所见，快速滚动时绘制图块的过程还是很明显，你可以利用更小的分块（上述例子中分块为640 x 640），或者自己创建一个CATiledLayer子类，重写fadeDuration()返回0：
```swift
class TiledLayer: CATiledLayer {
  
  override class func fadeDuration() -> CFTimeInterval {
    return 0.0
  }
  
}
```