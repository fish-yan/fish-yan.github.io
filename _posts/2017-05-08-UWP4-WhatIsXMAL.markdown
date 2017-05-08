---
layout:     post
title:      "3.1 UWP开发 什么是XMAL"
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

<video src="http://v6.365yg.com/video/m/2205e083b990e344aecb7a714434eddb03e11469e100003290ca242176/?Expires=1494219312&AWSAccessKeyId=qh0h9TdcEMoS2oPj7aKX&Signature=BMDhVcg8hUYuMqpjhyZnEx496YQ%3D" width="700px" height="400px" controls="controls">

</video>

## 学习要点

### 1.XMAL 的用途和本质

XMAL 看起来跟HTML很类似，实际上XMAL来自于XML--可扩展标记语言，与XML属于同一种语言发展而来。HTML用于构建网页文档，而XML更具备通用性，你可以定义属性的名字和元素来满足不同的需求，也经常用于存储赢用设置，或者作为两个不相关的系统之间交换数据。XMAL是XML的一种特殊用法，XMAL与构建应用的用户界面有关。XMAL与HTML的本质区别是，XMAL实质上是用来创建事例类，并且为他们的属性赋值。

### 2.用XMAL创建实例比C#更简单

在上节中我们用XMAL创建Button，TextBlock... 这节使用C#来创建一个Button，虽然不是常用，但是还是要会用。以此来比较一下XMAL创建Button和C#创建Button的区别。

**C#创建Button**

首先要在XMAL中mc:添加Loaded="Page_Loaded"，其中mc:标签为标记兼容性标签，Loaded是指创建页面时会加载的代码，顺带解释一下前面的Ignorable，是页面加载时那些XMAL的命名空间的前缀需要被忽略。

光标指向Page_Loaded按下F12会自动生成并跳转到对应的C#代码中。

```C#
private void Page_loaded(object sender, RoutedEventArgs e)
{
    Button myButton = new Button();
    myButton.Name = "ClickMeButton";
    myButton.Content = "Click Me";
    myButton.Width = 200;
    myButton.Height = 100;
    myButton.Margin = new Thickness(20,20,0,0);
    myButton.HorizontalAlignment = Windows.UI.Xaml.HorizontalAilgnment.Left;
    myButton.VerticalAlignment = Windows.UI.Xaml.VerticalAlignment.Top;

    myButton.Background = new SolidColorBrush(Windows.UI.Colors.Red);
    myButton.Click += ClickMeButton_Click;

    LayoutGrid.Children.Add(myButton);
}

```

**XMAL创建Button**

实际上这段代码相当于XMAL中的

```HTML
<Button Name="ClickMeButton"
        Content="Click Me"
        HorizontalAilgnment="Left"
        VerticalAlignment="Top"
        Margin="20,20,0,0"
        Background="Red"
        Width="200"
        Height="100"
        />
```

一看就知道那个更简单了。XMAL是一种简单的创建实例的方式，并且可以通过这种比C#简单很多得语言来设定这些对象的属性。除此之外，XMAL的代码可以实时的反映到可视化界面中，而C#的代码不能。

**同步发布**
[今日头条](http://www.toutiao.com/i6417591420546187777/)