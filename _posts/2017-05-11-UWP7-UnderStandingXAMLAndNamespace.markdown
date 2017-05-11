---
layout:     post
title:      "3.4 UWP开发 理解XAML Schemas和Namespace"
subtitle:   "UWP"
date:       2017-05-11 22:00:00
author:     "FishYan"
header-img: "img/UWP-header.jpg" 
catalog:    true
tags:
    - UWP
    - Visual Sutdio
    - XAML
---
<video src="http://v6.365yg.com/video/m/220e63153ad34d34d649d2f394b1a19972f11469310000415b63efa65a/?Expires=1494485017&AWSAccessKeyId=qh0h9TdcEMoS2oPj7aKX&Signature=DVQMegd%2BlHkNdQzhfjqu0oUHl2U%3D" width="700px" height="400px" controls="controls">

</video>

## 学习要点

```
    xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation"
    xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml"
    xmlns:local="using:WhatIsXAML"
    xmlns:d="http://schemas.microsoft.com/expression/blend/2008"
    xmlns:mc="http://schemas.openxmlformats.org/markup-compatibility/2006"
```
在每个xaml文件中都会有以上代码，这些代码就是schemas，确保下面所写的代码都遵循这些schemas。个人认为这些也可以说是源文件，下面所用的控件都来自这些文件。

这些代码不只是给出了schema，还定义了namespace：":x,:local,:d,:mc"

例如：给TextBlock赋值Name属性的时候这么写：```x:Name="name"```这个属性就是被定义在了xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml" 中。 当然现在也可以这么写```Name="name"``` 因为Name的属性现在默认定义在xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation" 中。

> xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation"
>
> 是用来定义所有UI控件及其属性,如Grid，Button，TextBlock等等

> xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml"
>
> 是用来声明所有的XAML的通用规则

> xmlns:local="using:WhatIsXAML"
> 
> 事实上只是引用一个本地的命名空间

> xmlns:d="http://schemas.microsoft.com/expression/blend/2008"
>
> xmlns:mc="http://schemas.openxmlformats.org/markup-compatibility/2006"
>
> 这两个是提供给设计器用的

**同步发布**
[今日头条](http://www.toutiao.com/i6418713189604655618/)