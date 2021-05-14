---
layout:     post
title:      "iOS 9 学习系列: MapKit"
subtitle:   "iOS 9 学习系列"
date:       2016-05-20 22:00:00
author:     "FishYan"
header-img: "img/blog-header.png" 
catalog:    true
tags:
    - iOS
    - iOS 9 新特性
---

>MapKit 的每次迭代都会为开发者带来一些新的特性，iOS 9的更新也不例外。在本文中，我们将预览一些新的API。我们将在一个应用中使用它们，给大家展示一下如何通过程序来估算（货物的）运达时间。

## Notable New API
## MapKit View Improvements
现在你可以在地图控件上，指定更多的高级的布局和标注方式。MKAnnotation 现在拥有了如下可以自定义的属性。
```
＊ Title

＊ Subtitle

＊ Right Accessory View

＊ Left Accessory View

＊ Detail Callout Accessory View
```
Detail Callout Accessory View 是 iOS 9 中新增的，允许你自定义 detail accessory view，他支持auto layout 和 constraints。非常方便你自定义一个已经存在的标注。

另外，MKMapView 中也增加了一些新的、自解释的属性。如下：
```
＊ showsTraffic

＊ showsScale

＊ showsCompass

＊ Transit Improvements
```
## Transit Improvements
在 iOS 9 中新介绍了 MKDirectionsTransportType。目前为止，也是唯一个能用于获取 ETA 请求的类。当你使用 calculateETAWithCompletionHandler 方法发起一个 ETA request后，可以得到一个 MKETAResponse 对象，包括了诸如运送时间、距离、预计到达时间、预计出发时间等数据。

## Building a Sample App
为了演示这些 API,我们创建如下一个 App。这个 Demo 中，我们将演示当点击了伦敦的众多标记中的一个点后，他的 transit 相关信息。




![](http://upload-images.jianshu.io/upload_images/28255-19b746281877cb93.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)
第一步是在 storyboard 中创建 MKMapView 和 UITableView,添加一些必要的约束信息，以确保地图控件在页面的上半部分，而表格视图在页面的下半部分。

当这些完成后，给表格添加必要的元素。这里我们不展开解释怎么操作了，因为本文重点不是这个。你要确保 ViewController 作为 table 的数据源和 MKMapViewDelegate 的 delegate。当你把这些 UI 都创建好后，看起来像下面的样子。


![](http://upload-images.jianshu.io/upload_images/28255-7dd1992f1579570d.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

你需要自定义个UITableViewCell，目前为止，还很简单。都是一些 lable 控件，创建好他们和storyboard 之间的连接。

![](http://upload-images.jianshu.io/upload_images/28255-f7beb031fd09d72e.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

现在 storyboard 已经创建好了，我们开始在地图上添加一些标记。为了完成这些，我们需要添加几个目的地。创建 Destination 类，用来存储与位置有关的信息。

![](http://upload-images.jianshu.io/upload_images/28255-e25b5fea44ea86bc.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

我们可以如下方式，简单的创建一个目的地。

![](http://upload-images.jianshu.io/upload_images/28255-9640922f6d304644.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

我们添加几个地址，保存到数组，然后用来在加载地图后展示出来。

在 ViewController 的 viewDidLoad()方法中，添加如下代码，把目的地标示添加到地图中。


![](http://upload-images.jianshu.io/upload_images/28255-b683830dc3beea5d.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)
他们将展示在地图中，你同样需要初始化地图的起始地址。添加如下代码。


![](http://upload-images.jianshu.io/upload_images/28255-dcfc9048eff65fcd.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)
接下来，我们把目的地的相关信息，展示在表格中。


![](http://upload-images.jianshu.io/upload_images/28255-baa1e03fe66f6eae.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)
运行程序，你会看到目的地都已经标示在了地图上，同时在表格里也显示了标示的目的地的名称。


![](http://upload-images.jianshu.io/upload_images/28255-e508ddc116a4d101.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)
这很棒，但是我们还没法计算运输信息，因为我们还没有定义任何的出发地点。我们可以使用用户的地址，但是我们喜欢获得一个真实的距离信息。所以，我们用用户在地图上的一次点击来确定为起始点。

我们给地图控件添加一个点击的手势。


![](http://upload-images.jianshu.io/upload_images/28255-edcd0851816eaaf3.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)
然后我们创建一个获取点击后的方法，将点击事件转换为地图上的一个坐标。


![](http://upload-images.jianshu.io/upload_images/28255-d59042cfe3f5f9f6.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)
当创建完成后，我们把 coordinate 存储起来，稍后会用到。我们添加一个 annotation 用来展示用户的位置，如果之前已经存在的话，请先清除再添加。


![](http://upload-images.jianshu.io/upload_images/28255-e6d7339acc4d63e5.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)
最后，我们要把位置信息设置给表格的 cell，然后来更新 ETA 的信息。 首先，添加如下代码：


![](http://upload-images.jianshu.io/upload_images/28255-69d2aca49138d202.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)
同样我们还需要给表格的 tableView:cellForRowAtIndexPath 的方法复制，以确保重新加载表格时能够正确的现实数据。添加如下代码：


![](http://upload-images.jianshu.io/upload_images/28255-edffffb260644d57.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)
当坐标正确的赋值给 tableviewcell 之后，我们要更新相关信息。

我们可以调用 userCoordinate 的 didSet 属性来设置更新。首先，我们要清理掉所用的lable的信息，因为之前所有的展示信息都不需要了。


![](http://upload-images.jianshu.io/upload_images/28255-ee1f448734ba2db7.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)
现在我们有了一个用户设置的坐标作为起始位置，我们可以创建一个MKDirectionsRequest 对象来计算 ETA信息。我们设置MKMapItem的属性，设置initialised的坐标，设置终点坐标，设置transportType。最后，我们在calculateETAWithCompletionHandler 里获取ETA的信息，然后更新label的值。


![](http://upload-images.jianshu.io/upload_images/28255-5b0abe27402d7fb9.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)
现在，运行程序，你会得到下面的效果。


![](http://upload-images.jianshu.io/upload_images/28255-066202e6ce4b98a7.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)
当你在地图上点击某处后，相应的表格里的ETA信息发生变化。

还有最后一件事时，响应 View Route 按钮的事件。在 IBAction 里添加如下代码：


![](http://upload-images.jianshu.io/upload_images/28255-52494d1eb93e4476.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)
这将会在打开的地图应用中，显示目的地，并展示出导航路线来。

## Customising the Pin Colors
现在应用已经完整了，但是还有一点儿小毛病。就是无法分辨出哪些是我们展示的，哪些是用户点击的坐标。为了自定义 pin 的显示，我们指定 MKMapViewDelegate 的代理为ViewController,并实现它的协议。添加如下代码：


![](http://upload-images.jianshu.io/upload_images/28255-c1e3949488dc9ab8.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)
pinTintColor 是iOS 就中新介绍的可以设置（大头针）颜色的新的属性。如你所看到的，我们把用户点击后的大头针坐标的颜色设为红色。把一开始就设置好的目的地的大头针颜色设为蓝色。这样可以方便的分辨出用户设置的出发点和预设好的目的地的点。

延伸阅读
想了解更多关于本文中我们提到的 MapKit的新特性，请观看 WWDC 2015 的session 206，[What’s New in MapKit](https://developer.apple.com/videos/wwdc/2015/?id=206)。

[Demo](https://github.com/shinobicontrols/iOS9-day-by-day/tree/master/10-MapKit-Transit)