---
layout:     post
title:      "3.5 UWP开发 网格布局控件"
subtitle:   "UWP"
date:       2017-05-04 22:00:00
author:     "FishYan"
header-img: "img/UWP-header.jpg" 
catalog:    true
tags:
    - UWP
    - Visual Sutdio
    - XAML
---
<video src="http://v6.365yg.com/video/m/2203cf9ef0250f24b62a6a58fd658f9f0881146d300000450cd2d8d78a/?Expires=1494837486&AWSAccessKeyId=qh0h9TdcEMoS2oPj7aKX&Signature=3qEUDsha4jO8ceV0p2A7y%2F1lJwk%3D" width="700px" height="400px" controls="controls">

</video>

## 学习要点

### 网格控件（Grid）

网格控件可以定义你的子控件放在哪一行（Row），哪一列（Column），能后很方便的对app的布局进行布局， 这是一个比较重要的控件，会经常用到。

看几个例子

1.
```HTML
    <Grid Background="{ThemeResource ApplicationPageBackgroundThemeBrush}">
        <Grid.RowDefinitions>
            <RowDefinition Height="Auto" />
            <RowDefinition Height="*" />
        </Grid.RowDefinitions>

        <Rectangle Height="100" Fill="Beige" Grid.Row="0" />
        <Rectangle Grid.Row="1" Fill="SteelBlue" />
    </Grid>

```
- Auto 高度与控件的高度相关联

- ```*``` 占据剩余空间的高度

![](/img/blog/WorkingTheLayoutGridControl/1.png)

2.
```HTML
    <Grid Background="{ThemeResource ApplicationPageBackgroundThemeBrush}">
        <Grid.RowDefinitions>
            <RowDefinition Height="1*" />
            <RowDefinition Height="2*" />
            <RowDefinition Height="3*" />
        </Grid.RowDefinitions>

        <Rectangle Fill="Red" Grid.Row="0" />
        <Rectangle Fill="Blue" Grid.Row="1" />
        <Rectangle Fill="Green" Grid.Row="2" />
    </Grid>
```
- 1*，2*，3*，分别代表1倍高，2倍高，3倍高。按1：2：3划分整个高度

![](/img/blog/WorkingTheLayoutGridControl/2.png)



3.
```HTML
    <Grid Background="Black">
        <Grid.RowDefinitions>
            <RowDefinition Height="*" />
            <RowDefinition Height="*" />
            <RowDefinition Height="*" />
        </Grid.RowDefinitions>
        <Grid.ColumnDefinitions>
            <ColumnDefinition Width="*" />
            <ColumnDefinition Width="*" />
            <ColumnDefinition Width="*" />
        </Grid.ColumnDefinitions>

        <TextBlock>1</TextBlock>
        <TextBlock Grid.Column="1">2</TextBlock>
        <TextBlock Grid.Column="2">3</TextBlock>

        <TextBlock Grid.Row="1">4</TextBlock>
        <TextBlock Grid.Row="1" Grid.Column="1">5</TextBlock>
        <TextBlock Grid.Row="1" Grid.Column="2">6</TextBlock>

        <TextBlock Grid.Row="2">7</TextBlock>
        <TextBlock Grid.Row="2" Grid.Column="1">8</TextBlock>
        <TextBlock Grid.Row="2" Grid.Column="2">9</TextBlock>

    </Grid>

```
- Column 列
- Row 行 
- Grid.Row="2" Grid.Column="1" 表示 第二行第一列

![](/img/blog/WorkingTheLayoutGridControl/3.png)

4.对齐

```HTML
     <Grid Background="Black">
        <Rectangle Fill="Blue" 
                   Height="100" 
                   Width="100" 
                   HorizontalAlignment="Left" 
                   VerticalAlignment="Top" />

        <Rectangle Fill="Red"
                   Height="100"
                   Width="100"
                   HorizontalAlignment="Right"
                   VerticalAlignment="Bottom" />

        <Rectangle Fill="Green"
                   Height="100"
                   Width="100"
                   HorizontalAlignment="Center"
                   VerticalAlignment="Center" />

        <Rectangle Fill="Yellow"
                   Height="100"
                   Width="100"
                   HorizontalAlignment="Left"
                   VerticalAlignment="Top"
                   Margin="100,100"/>

        <Rectangle Fill="White"
                   Height="100"
                   Width="100"
                   HorizontalAlignment="Left"
                   VerticalAlignment="Bottom"
                   Margin="50,0,0,50"/>

    </Grid>
```

- HorizontalAlignment 水平对齐 Left Center Right
- VerticalAlignment 垂直对齐 Top Center Right
- Margin = “左，上，右，下”

![](/img/blog/WorkingTheLayoutGridControl/4.png)

**同步发布**
[今日头条](http://www.toutiao.com/i6420198643768230401/)