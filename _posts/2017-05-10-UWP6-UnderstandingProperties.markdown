---
layout:     post
title:      "3.3 UWP开发 理解默认属性，复杂属性和元素属性语法"
subtitle:   "UWP"
date:       2017-05-10 22:00:00
author:     "FishYan"
header-img: "img/UWP-header.jpg" 
catalog:    true
tags:
    - UWP
    - Visual Sutdio
    - XAML
---

<video src="http://v3.365yg.com/70624cb5dc513968f4397a7b4bb4eacf/5912885b/video/m/220a4c168b77db64591abd9a7847d6881e711469060000079b46c4f092/" width="700px" height="400px" controls="controls">

</video>

## 学习要点

XAML中的元素可以内含其他的元素，比如Page内含Grid，Grid内含Button，TextBlock... 这些控件的放置关系就是子父控件关系。

### 1.默认属性

举例Button的Content属性就是默认属性，默认属性有个共同的特点，当你在开标签和闭标签之间的内容会默认赋给该元素的某一个属性，那么这个属性就是默认属性。

```HTML
<Button>默认属性</Button> 等价于 <Button Content="默认属性"/>
```

### 2.复杂属性

先回顾一下上节讲到的类型转换，类似于HorizontalAlignment="Left"，可以直接转换为C#中的枚举，这一类的属性属于简单属性，另一类属性如Margin，Background对应的C#代码要创建对应的 Thickness和SolidColorBrush对象，这类属性属于复杂属性。

```HTML
<Button ...
        Margin="20,20,0,0"
        Background="Red"
        .../>
```
等价于
```C#
...
myButton.Margin = new Thickness(20,20,0,0);
myButton.Background = new SolidColorBrush(Windows.UI.Color.Red);
...
```
### 3.元素属性语法

一些更为复杂的元素属性就需要用到元素属性语法，这些属性的特点是 <元素.属性>...</元素.属性> 

例如 Button的Background属性，我们需要的是一个渐变色，就可以用以下代码实现

```HTML
<Button.Background>
    <LinearGradientBrush EndPoint="0.5,1" StartPoint="0.5,0">
        <GradientStop Color="Black" Offset="0"/>
        <GradientStop Color="White" Offset="1"/>
    </LinearGradientBrush>
</Button.Background>
```

**同步发布**
[今日头条](http://www.toutiao.com/i6418318091737891330/)