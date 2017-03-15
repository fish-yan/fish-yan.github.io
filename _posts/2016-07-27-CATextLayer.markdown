---
layout:     post
title:      "iOS 动画 Animation-0-3：CALayer十则示例-CATextLayer"
subtitle:   "iOS 动画 Animation"
date:       2016-07-27 22:00:00
author:     "FishYan"
header-img: "img/blog-header.png" 
catalog:    true
tags:
    - iOS
    - iOS 动画
---

## CATextLayer

CATextLayer能够对普通文本或属性字串进行简单快速的渲染。与UILabel不同，CATextLayer无法指定UIFont，只能使用CTFontRef或CGFontRef。

像下面这样的代码完全可以掌控文本的字体、字体大小、颜色、对齐、折行（wrap）和截断（truncation）规则，也有动画效果：

```swift
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

不仅是CATextLayer，所有图层类的渲染缩放系数都默认为1。在添加到视图时，图层自身的contentsScale缩放系数会自动调整，适应当前画面。你需要为手动创建的图层明确指定contentsScale属性，否则默认的缩放系数1会在Retina显示屏上产生部分模糊。

如果创建的文本图层添加到了方形的someView，效果会像这样：

![](http://cc.cocimg.com/api/uploads/20150317/1426582054545948.png)

你可以设置截断（Truncation）属性，生效时被截断的部分文本会由省略号代替显示。默认设定为无截断，位置可设为开头、末尾或中间截断：

![](http://cc.cocimg.com/api/uploads/20150317/1426582060628623.png)

图层演示应用中，你可以随心所欲地修改很多CATextLayer属性：

![](http://cc.cocimg.com/api/uploads/20150317/1426582127466083.png)
