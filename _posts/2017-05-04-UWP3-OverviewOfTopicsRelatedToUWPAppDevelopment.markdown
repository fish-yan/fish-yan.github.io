---
layout:     post
title:      "UWP开发相关内容概述"
subtitle:   "UWP"
date:       2017-05-04 22:00:00
author:     "FishYan"
header-img: "img/UWP-header.png" 
catalog:    true
tags:
    - UWP
    - Visual Sutdio
---

<video src="http://v3.365yg.com/d26fcbe03d2d44d7bcf5c2c88b9258c4/590d2565/video/m/22099e1dc75f8f74f0d994e0ad2037aa1b711465f0000036f37d161356/" width="700px" height="400px" controls="controls">

</video>

## 学习要点

- 1.UWP的开发和WPF，ASP.net的开发非常的相似，拥有这两种开发经验的人学起来会十分轻松。
- 2.我们需要用XMAL来搭建界面，XMAL非常类似与HTML，当然还需要一些后台代码来控制控件，就是C#（本教程使用C#，当然你也可以使用C++，JavaScript...）在这里XAML代码写在MainPage.XAML，C#代码写在MainPage.XAML.cs中，这是一对文件。
- 3.partial class 表示为某一个类的一部分，只要类名相同，命名空间相同，我们就可以把同一个类存储到不同的文件中。
- 4.MainPage.XAML和MainPage.XAML.cs关联，在MainPage.XAML.cs中类继承自Page，MainPage.XAML中的根标签也是- Page，并且关联的类为x:Class="HelloWorld.MainPage"这是HelloWorld命名空间中的MainPage类
- 5.调试功能
- 6.模拟器的使用
- 7.Grid网格控件
- 8.还有Extention SDK 来实现一些特定设备上的特定功能
- 9.UWP适应性开发，在不同的设备上具有不同的特性，
- 10.设计app的时候要遵循一定的设计规范，编码规范

**同步发布**
[今日头条](http://www.toutiao.com/i6416099725417644546/)