---
layout:     post
title:      "3.6 UWP开发 StackPanel布局控件"
subtitle:   "UWP"
date:       2017-05-16 22:00:00
author:     "FishYan"
header-img: "img/UWP-header.jpg" 
catalog:    true
tags:
    - UWP
    - Visual Sutdio
---
<video src="http://v1.365yg.com/a1997afc6b9bb34c04b0422fee2c8d88/591a8039/video/m/220e0b389a88bfe4a1198145510dac994ed1146fb0000000d925a371db/" width="700px" height="400px" controls="controls">

</video>

## 学习要点

### 1.StackPanel

- StackPanel类似于HTML中的div，默认水平从左到右
- Orientation属性用来设置排版方向，Horizontal为横向，Vertical为竖向
- StackPanel子空间都按照设定的方向依次排列

看一个例子

```HTML
    <Grid>
        <StackPanel Orientation="Horizontal" VerticalAlignment="Top">
            <Rectangle Width="200" Height="200" Fill="Bisque" />
            <StackPanel Orientation="Vertical">
                <StackPanel Orientation="Horizontal">
                    <Rectangle Width="100" Height="100" Fill="Azure" />
                    <StackPanel Orientation="Vertical">
                        <Rectangle Width="100" Height="50" Fill="RosyBrown" d:IsLocked="True" />
                        <Rectangle Width="100" Height="50" Fill="DarkCyan" />
                    </StackPanel>
                </StackPanel>
                <StackPanel Orientation="Horizontal">
                    <Rectangle Width="100" Height="100" Fill="Tomato" />
                    <StackPanel Orientation="Vertical">
                        <Rectangle Width="100" Height="50" Fill="BurlyWood" />
                        <Rectangle Width="100" Height="50" Fill="SaddleBrown" />
                    </StackPanel>
                </StackPanel>
            </StackPanel>
        </StackPanel>
    </Grid>
```
![](/img/blog/StackPanel/1.png)

### 2.视图树(Document Outline)

如果左边的工具栏没有，那么选择View --> Other Windows --> Document Outline 来快速查看整个视图的结构及找到想要的视图。

### 3.StackPanel和Grid的区别

- StackPanel 子控件按照设定的方向依次排列，不会重叠
- Grid 子控件默认居中，可以重叠

**同步发布**
[今日头条](http://toutiao.com/item/6420554412472680962/)