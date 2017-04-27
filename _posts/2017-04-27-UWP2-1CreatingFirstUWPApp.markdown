---
layout:     post
title:      "2.1 UWP开发 创建第一个UWP应用"
subtitle:   "UWP"
date:       2017-04-25 22:00:00
author:     "FishYan"
header-img: "img/blog-header.png" 
catalog:    true
tags:
    - UWP
    - Visual Sutdio
---

<video src="http://v3.365yg.com/4f0b5826f36e85dfe685140205c1bbbf/590181db/video/m/220c3f2d22740014b72b0eacabc054a1d8411462c8000014ad5688eff1/" width="700px" height="400px" controls="controls">

</video>


## 学习要点

假设你已经看过上节的内容，安装了开发所需要的环境。

> 说明：因为视频为 Visual Studio 2015， 所以演示为2015版本的演示，Visual Studio 2017 基本上也大同小异。

Visual Studio 有很多种创建新项目的方式，先演示一种，后面还有遇到其他的新建项目的方式

1.打开 Visual Studio ，点击 New Project... 

![创建项目](/img/blog/CreatingFirstUWPApp/vsstart1.png)

2.依次找到下图左侧Templats/Visual C#/Windows Universal -> 选择 Blank App （空白模板）-> 对项目进行命名 HelloWorld

![创建项目](/img/blog/CreatingFirstUWPApp/vsstart2.png)

3.常用面板解释  

![资源管理器](/img/blog/CreatingFirstUWPApp/Solution.png)

可以直接拖拽一个button到可视化编辑区域，代码编辑区域会自动生成代码。目前这种方式并非常用做法，猜测为未来发展趋势。

修改属性有三种方式

- 直接在可视区域修改button的属性
- 在代码区域修改button的属性
- 在右侧Property区域修改button的属性

// MainPage.xmal

```XML
<Button x:Name="ClickMeButton" Content="Click This" HorizontalAlignment="Left" Margin="68,10,0,0" VerticalAlignment="Top" FontSize="16" Click="ClickMeButton_Click"/>
```

可以用同样的方式创建一个TextBlock，
 
 ```XML
<TextBlock x:Name="ResultTextBlock" HorizontalAlignment="Left" Margin="68,100,0,0" TextWrapping="Wrap" Text="" VerticalAlignment="Top" FontSize="64"/>
```

// MainPage.xmal.cs

```C#
public sealed partial class MainPage : Page
    {
        public MainPage()
        {
            this.InitializeComponent();
        }

        private void ClickMeButton_Click(object sender, RoutedEventArgs e)
        {
            ResultTextBlock.Text = "Hello World";
        }
    }
```

Hello World 创建完成了，可以点击上面的运行按钮选在在不同的设备上运行，查看效果。

> 视频来源Channel 字幕翻译自bilibili-微软信仰中心

> **同步发布**

>[今日头条](http://www.toutiao.com/i6413504636874916353/)

>[FishYan博客](http://fishyan.me/2017/04/25/UWP2-1CreatingFirstUWPApp/)