---
layout:     post
title:      "iOS 动画 Animation-0：CALayer十则示例"
subtitle:   "iOS 动画 Animation"
date:       2016-07-15 22:00:00
author:     "FishYan"
header-img: "img/blog-header.png" 
catalog:    true
tags:
    - iOS
    - iOS 动画
---


![](http://cc.cocimg.com/api/uploads/20150317/1426579343207253.png)

首先说明：这是一系列文章，参考本专题下其他的文章有助于你对本文的理解。

如你所知，我们在iOS应用中看到的都是视图（view），包括按钮视图、表视图、滑动条视图，还有可以容纳其他视图的父视图等。

但你或许不知道在iOS中支撑起每个视图的是一个叫做"图层（layer）"的类，确切地说是CALayer。

本文中您会了解CALayer及其工作原理，还有应用CALayer打造酷炫效果的十则示例，比如绘制矢量图形、渐变色，甚至是粒子系统。

本文要求读者熟悉iOS应用开发和Swift语言的基础知识，包括利用Storyboard构建用户界面。

注：如果您尚未掌握这些基础，不必担心，我们有不少相关教程，例如[使用Swift语言编写iOS应用](http://www.raywenderlich.com/77176/learn-to-code-iOS-apps-with-swift-tutorial-4)和[iOS学徒](http://www.raywenderlich.com/store/iOS-apprentice)。

## 准备开始

要理解图层是什么，最简便的方式就是"实地考察"。我们这就创建一个简单的项目，从头开始玩转图层。

准备好写代码了吗？好！启动Xcode，然后：

- 1.选择File\New\Project菜单项。

- 2.在对话框中选择iOS\Application\Single View Application。

- 3.点击Next，Product Name填写CALayerPlayground，然后输入你自己的Organization Name和Identifier。

- 4.Language选Swift，Devices选Universal。

- 5.取消选择Core Data，点击Next。

- 6.把项目保存到合适的位置（个人习惯把项目放在用户目录下建立的Source文件夹），点击Create。

好，文件准备就绪，接下来就是创建视图了：

- 7.在项目导航栏（Project navigator）中选择Main.storyboard。

- 8.选择View\Assistant Editor\Show Assistant Editor菜单项，如果没有显示对象库（Object Library），请选择View\Utilities\Show Object Library。

- 9.然后选择Editor\Canvas\Show Bounds Rectangles，这样在向场景添加视图时就可以看到轮廓了。

- 10.把一个视图（View）从对象库拖入视图控制器场景，保持选中状态，在尺寸检查器（View\Utilities\Show Size Inspector）中将x和y设为150，Width和Height设为300。

- 11.视图保持选中，点击自动布局工具栏（Storyboard右下角）的Align按钮，选中Horizontal Center in Container和Vertical Center in Container，数值均为0，然后点击Add 2 Constraints。

- 12.点击Pin按钮，选中Width和Height，数值均设为300，点击Add 2 Constraints。

最后按住control从刚刚创建的视图拖到ViewController.swift文件中viewDidLoad()方法的上方，在弹框中将outlet命名为viewForLayer，如图：

![](http://cc.cocimg.com/api/uploads/20150317/1426579424904056.png)

点击Connect创建outlet。

将ViewController.swift中的代码改写为：
```swift
import UIKit
  
class ViewController: UIViewController {
  
  @IBOutlet weak var viewForLayer: UIView!
  
  var l: CALayer {
    return viewForLayer.layer
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setUpLayer()
  }
  
  func setUpLayer() {
    l.backgroundColor = UIColor.blueColor().CGColor
    l.borderWidth = 100.0
    l.borderColor = UIColor.redColor().CGColor
    l.shadowOpacity = 0.7
    l.shadowRadius = 10.0
  }
  
}
```
之前提到iOS中的每个视图都拥有一个关联的图层，你可以通过yourView.layer访问图层。这段代码首先创建了一个叫"l"（小写L）的计算属性，方便访问viewForLayer的图层，可让你少写一些代码。

这段代码还调用了setUpLayer方法设置图层属性：阴影，蓝色背景，红色粗边框。你马上就可以了解这些东西，不过现在还是先构建App，在iOS模拟器中运行（我选了iPhone 6），看看自定义的图层如何。

![](http://cc.cocimg.com/api/uploads/20150317/1426579545493233.png)

几行代码，效果还不错吧？还是那句话，每个视图都由图层支撑，所以你也可以对App中的任何视图做出类似修改。我们继续深入。

## CALayer基本属性

CALayer有几个属性可以用来自定外观，想想刚才做的：

- 把图层背景色从默认的无色改为蓝色
- 通过把边框宽度从默认的0改为100来添加边框
- 把边框颜色从默认的黑色改为红色
- 最后把阴影透明度从0（全透明）改为0.7，产生阴影效果，此外还把阴影半径从默认的3改为10。

以上只是CALayer中可以设置的部分属性。我们再试两个，在setUpLayer()中追加以下代码：

```swift
l.contents = UIImage(named: "star")?.CGImage
l.contentsGravity = kCAGravityCenter
```
CALayer的contents属性可以把图层的内容设为图片，这里我们要设置一张"星星"的图片，为此你需要把图片添加到项目中，请下载图片并添加到项目中。

构建，运行，欣赏一下效果：

![](http://cc.cocimg.com/api/uploads/20150317/1426579593409676.png)

注意星星居中，这是因为contentsGravity属性被设为kCAGravityCenter，如你所想，重心也可以设为上、右上、右、右下、下、左下、左、左上。

## 更改图层外观

仅供娱乐，我们来添加几个手势识别器来控制图层外观。在Xcode中，向viewForLayer对象上拖一个轻触手势识别器（tap gesture recognizer），见下图：

![](http://cc.cocimg.com/api/uploads/20150317/1426580159705181.png)

注：如果你对手势识别器比较陌生，请参阅[Using UIGestureRecognizer with Swift](http://www.raywenderlich.com/76020/using-uigesturerecognizer-with-swift-tutorial)。

以此类推，再添加一个捏合手势识别器（pinch gesture recognizer）。

然后按住control依次将两个手势识别器从Storyboard场景停靠栏拖入ViewController.swift，放在setUpLayer()和类自身的闭合花括号之间。

在弹框中修改连接为Action，命名轻触识别操作为tapGestureRecognized，捏合识别操作为pinchGestureRecognized，例如：

![](http://cc.cocimg.com/api/uploads/20150317/1426580242880273.png)

如下改写tapGestureRecognized(_:)：

```swift

@IBAction func tapGestureRecognized(sender: UITapGestureRecognizer) {
  l.shadowOpacity = l.shadowOpacity == 0.7 ? 0.0 : 0.7
}
```
当令视图识别出轻触手势时，代码告知viewForLayer图层在0.7和0之间切换阴影透明度。

你说视图？嗯，没错，重写CALayer的hitTest(_:)也可以实现相同效果，本文后面也会看到这个方法，不过我们这里用的方法也有道理：图层本身并不能响应手势识别，只能响应点击测试，所以我们在视图上设置了轻触手势识别器。

然后如下修改pinchGestureRecognized(_:)：

``` swift
@IBAction func pinchGestureRecognized(sender: UIPinchGestureRecognizer) {
  let offset: CGFloat = sender.scale < 1 ? 5.0 : -5.0
  let oldFrame = l.frame
  let oldOrigin = oldFrame.origin
  let newOrigin = CGPoint(x: oldOrigin.x + offset, y: oldOrigin.y + offset)
  let newSize = CGSize(width: oldFrame.width + (offset * -2.0), height: oldFrame.height + (offset * -2.0))
  let newFrame = CGRect(origin: newOrigin, size: newSize)
  if newFrame.width >= 100.0 && newFrame.width <= 300.0 {
    l.borderWidth -= offset
    l.cornerRadius += (offset / 2.0)
    l.frame = newFrame
  }
}
```
此处基于用户的捏合手势创建正负偏移值，借此调整图层框架大小、边缘宽度和边角半径。

图层的边角半径默认值为0，意即标准的90度直角。增大半径会产生圆角，如果想将图层变成圆形，可以设边角半径为宽度的一半。

注意：调整边角半径并不会裁剪图层内容（星星图片），除非图层的masksToBounds属性被设为true。

构建运行，尝试在视图中使用轻触和捏合手势：

![](http://cc.cocimg.com/api/uploads/20150317/1426580331528181.png)

嘿，再好好装扮一下都能当头像用了！ :]

## CALayer体验

CALayer中的属性和方法琳琅满目，此外还有几个包含特有属性和方法的子类。

要遍历如此酷炫的API，Raywenderlich.com导游先生最好不过了。

接下来，你需要以下材料：

[Layer Player App](https://itunes.apple.com/us/app/layer-player/id949768742?mt=8)
[Layer Player 源代码](https://github.com/scotteg/LayerPlayer)
该App包含十种不同的CALayer示例，本文后面会依次介绍，十分方便。先来吊吊大家的胃口：

![](http://cc.cocimg.com/api/uploads/20150317/1426580919559307.png)

下面在讲解每个示例的同时，我建议在CALayer演示应用中亲自动手试验，还可以读读代码。不用写，只要深呼吸，轻松阅读就可以了。 :]

我相信这些酷炫的示例会启发您利用不同的CALayer为自己的App锦上添花，希望大家喜欢！

