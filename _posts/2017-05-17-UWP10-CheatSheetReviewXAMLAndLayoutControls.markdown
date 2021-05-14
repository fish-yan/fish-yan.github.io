---
layout:     post
title:      "3.7 UWP开发 复习：XAML和布局控件"
subtitle:   "UWP"
date:       2017-05-17 22:00:00
author:     "FishYan"
header-img: "img/UWP-header.jpg" 
catalog:    true
tags:
    - UWP
    - Visual Sutdio
---

# 3.7 UWP开发 复习：XAML和布局控件

<video src="http://v1.365yg.com/84a10e373e921a75fe61a9cddb962370/591bc6f2/video/m/2203cdffda1bad24bcd9894d1a042cc0b9a1146ff3000003f61328876b/" width="700px" height="400px" controls="controls">

</video>

## 学习要点

**这一节是复习课**

### UWP-04 - What is XAML

XAML是一种XML语法，用来搭建用户界面

### UWP-05 - Understanding Type Converters

类型转换器可以将XAML中特定的字符串属性转换为对应的C#枚举

### UWP-06 - Understanding Default Properties

默认属性：例如Button的content，可以默认写在开标签和闭标签之间的属性

复杂属性：属性在类型转换的时候需要转换为C#对应的事例对象，而不是枚举

属性元素语法：类似于XAML的标签语法，例如设置Button的背景

```HTML
<Button.Background>
    <LinearGradientBrush EndPoint="0.5,1" StartPoint="0.5,0">
        <GradientStop Color="Black" Offset="0"/>
        <GradientStop Color="Red" Offset="1"/>
    </LinearGradientBrush>
</Button.Background>
```
### UWP-07 - Understanding XAML Schemas and Namespace Declarations

理解Schemas和Namespace,定义了语法规则，以及控件的API

在XAML顶部的这段代码，在刚开始学习的时候尽量不要去动他，除非你非常肯定你需要去改动。

### UWP-08 - XAML Layout with Grids

Grids 网格布局，是会经常用到的布局方式之一，主要有Row和Column属性来定义网格，在网格内的控件默认居中

网格尺寸：Auto自动适应子空间的尺寸，*占据剩余空间，前面加上数字，按数字等比分配。

### UWP-09 - XAML Layout with StackPanel

StackPanel 也是常用布局方式之一，特点是会按照设定的Orientation属性，按水平或竖直方向依次排列，不会重叠。网格控件（Grid）会重叠。

**同步发布**
[今日头条](http://www.toutiao.com/i6420938726028870146/)