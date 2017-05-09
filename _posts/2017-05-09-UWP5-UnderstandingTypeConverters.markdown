---
layout:     post
title:      "3.2 UWP开发 类型转换"
subtitle:   "UWP"
date:       2017-05-04 22:00:00
author:     "FishYan"
header-img: "img/UWP-header.jpg" 
catalog:    true
tags:
    - UWP
    - Visual Sutdio
    - XMAL
---

<video src="http://v3.365yg.com/4f28af989f3a4ad1fe460e17e3d652e3/59113c91/video/m/2203b87f2c1c3a848cc8e9991e381f4bd5c1146962000031e1f94847c4/" width="700px" height="400px" controls="controls">

</video>

## 学习要点

这节内容比较短，主要讲解类型转换

在上一节中可以看到XMAL中的代码给属性赋值是用字符串的形式如：HorizontalAlignment="Left"，而C#中是采用枚举的形式：HorizontalAlignment.Left;

XMAL可以将这些字符串转换为显式声明的枚举值，即Windows.UI.Xaml.HorizontalAlignment.Left，这一过程就是通过类型转换器（Type Converter）进行的，并且会在编写代码的时候就进行检查
