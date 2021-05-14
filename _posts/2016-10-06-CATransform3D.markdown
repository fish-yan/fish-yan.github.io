---
layout:     post
title:      "iOS 动画Animation-3: CATransform3D 特效详解"
subtitle:   "iOS 动画 Animation"
date:       2016-10-06 22:00:00
author:     "FishYan"
header-img: "img/blog-header.png" 
catalog:    true
tags:
    - iOS
    - iOS 动画
---

# iOS 动画Animation-3: CATransform3D 特效详解

>首先说明：这是一系列文章，参考本专题下其他的文章有助于你对本文的理解。

关于图层的几个坐标系。

对于ios来说，坐标系的（0，0）点在左上角，就是越往下，Y值越大。越往右，X值越大。

一个图层的frame，它是position，bounds，anchorPoint和transform属性的一部分。

设置一个新的frame将会相应的改变图层的position和bounds，但是frame本身并没有保存。

position：是一个CGPoint值，它指定图层相当于它父图层的位置，该值基于父图层的坐标系。

bounds：是一个CGRect值，指定图层的大小（bounds.size）和图层的原点（bounds.origin），这个坐标系是基于自身的。如果改变bounds的origin，那么在该图层的子图层，坐标会跟着改变。也就是说，改变自身的坐标系，本身在父图层的位置不变，但它上的子图层位置变化。

anchorPoint：是一个CGPoint值，它是指定了一个基于bounds的符合坐标系的位置。锚点（anchor point）制定了bounds相对于position的值，同时也作为一个变化时候的中心点。锚点使用空间坐标系取值范围是0-1之间的数。默认是0.5，也就是秃瓢的中心点，如果是（0，0）那么，图层向左上方移动。如果是（1，1）就向右下方移动。

看下面的两个图，就能够够清晰的看出锚点变化所带来的不一样。（此图为MAC OS 坐标系，如果是IOS，那么（0，0）点在图的左上方。）


![](http://my.csdn.net/uploads/201204/11/1334157821_5490.png)

对于anchorPoint的解释在ios中如图：

下图中的红点位置就是 锚点的位置：默认为（0.5，0.5）。在对图像进行变换时，都是按照这个点来进行缩放，偏移等。

![](http://my.csdn.net/uploads/201204/12/1334200299_8006.png)

一旦修改锚点的位置为：（0，0），那么图像就会变成下图。各种变换就会按照这个点来运动。

![](http://my.csdn.net/uploads/201204/12/1334200450_4610.png)

所以说，在ios系统中，锚点的坐标系是：左上角为（0，0），右下角为（1，1）。
根据此图，在理解上面的定义，就直观了一些。

![](http://my.csdn.net/uploads/201204/12/1334200860_6476.png)

 
图层的几何变换。

可以通过矩阵来改变一个图层的几何形状。

CATransform3D 的数据结构定义了一个同质的三维变换（4x4 CGFloat值的矩阵），用于图层的旋转，缩放，偏移，歪斜和应用的透视。

图层的2个属性指定了变换矩阵：transform 和 sublayerTransform。

transform ： 是结合 anchorPoint（锚点）的位置来对图层和图层上的子图层进行变化。

sublayerTransform：是结合anchorPoint（锚点）的位置来对图层的子图层进行变化，不包括本身。

CATransform3DIdentity 是单位矩阵，该矩阵没有缩放，旋转，歪斜，透视。该矩阵应用到图层上，就是设置默认值。


变换函数

CATransform3DMakeTranslation 

官方文档：

Returns a transform that translates by '(tx, ty, tz)'. t' = [1 0 0 0; 0 1 0 0; 0 0 1 0; tx ty tz 1].

CATransform3D CATransform3DMakeTranslation (CGFloat tx, CGFloat ty, CGFloat tz)。

做一个解释，对于初学者来说，可能没有看明白是什么意思。我详细说下
对于CATransform3D来说，它是一个4x4 CGFloat的矩阵。

而上面给的值：[1 0 0 0; 0 1 0 0; 0 0 1 0; tx ty tz 1].

给竖起来后。就发现：
|tx|ty|tz|1|
|-|-|-|-|
|1|0|0|0|
|0|1|0|0|
|0|0|1|0|


竖起来看就很明显了。

CATransform3D 又是一个结构。他有自己的一个公式，可以进行套用。

 ```objc
struct CATransform3D
{
CGFloat     m11（x缩放）,    m12（y切变）,      m13（旋转）,     m14（）;

CGFloat     m21（x切变）,    m22（y缩放）,      m23（）,             m24（）;

CGFloat     m31（旋转）,      m32（ ）,               m33（）,              m34（透视效果，要操作的这个对象要有旋转的角度，否则没有效果。正直/负值都有意义）;

CGFloat     m41（x平移）,     m42（y平移）,     m43（z平移）,     m44（）;
};
```
根据这个公式，就一目了然了。
 
CATransform3D CATransform3DMakeTranslation (CGFloat tx, CGFloat ty, CGFloat tz)

的参数意思就是 

tx:：x平移。  ty：y平移。  tz：z平移


换换函数：

CATransform3D CATransform3DMakeTranslation (CGFloat tx, CGFloat ty, CGFloat tz)

tx：X轴偏移位置，往下为正数。

ty：Y轴偏移位置，往右为正数。

tz：Z轴偏移位置，往外为正数。

例：

如果有2个图层，一个是绿色的，一个是红色的。先加载绿色，后加载红色。
tx，ty的左右偏移先不说了。

如果绿色的tz为-10 ，红色的tz为 0 效果如下。

![](http://my.csdn.net/uploads/201204/12/1334193488_5379.png)

如果绿色的tz为 0 ，红色的tz为-10 效果如下。

![](http://my.csdn.net/uploads/201204/12/1334193493_3796.png)

对于tz来说，值越大，那么图层就越往外（接近屏幕），值越小，图层越往里（屏幕里）。

CATransform3D CATransform3DTranslate (CATransform3D t, CGFloat tx, CGFloat ty, CGFloat tz);

t：就是上一个函数。其他的都一样。

就可以理解为：函数的叠加，效果的叠加。


CATransform3D CATransform3DMakeScale (CGFloat sx, CGFloat sy, CGFloat sz);

sx：X轴缩放，代表一个缩放比例，一般都是 0 --- 1 之间的数字。

sy：Y轴缩放。

sz：整体比例变换时，也就是m11（sx）== m22（sy）时，若m33（sz）>1，图形整体缩小，若0<1，图形整体放大，若m33（sz）<0，发生关于原点的对称等比变换。

当sx = 1，sy = 1时。如图：

![](http://my.csdn.net/uploads/201204/12/1334202947_8749.png)

当sx = 0.5，sy = 0.5时。如图：

![](http://my.csdn.net/uploads/201204/12/1334203009_7408.png)

CATransform3D CATransform3DScale (CATransform3D t, CGFloat sx, CGFloat sy, CGFloat sz)
 
t：就是上一个函数。其他的都一样。

就可以理解为：函数的叠加，效果的叠加。


CATransform3D CATransform3DMakeRotation (CGFloat angle, CGFloat x, CGFloat y, CGFloat z);

旋转效果。
angle：旋转的弧度，所以要把角度转换成弧度：角度 * M_PI / 180。

x：向X轴方向旋转。值范围-1 --- 1之间

y：向Y轴方向旋转。值范围-1 --- 1之间

z：向Z轴方向旋转。值范围-1 --- 1之间

例：向X轴旋转60度。

![](http://my.csdn.net/uploads/201204/12/1334208076_1359.png)

向Y轴旋转60度。

![](http://my.csdn.net/uploads/201204/12/1334208076_1359.png)

向Z轴旋转60度。

![](http://my.csdn.net/uploads/201204/12/1334208197_4641.png)
                       
向 X轴，Y轴都旋转60度，就是沿着对角线旋转。

![](http://my.csdn.net/uploads/201204/12/1334208592_1285.png)

可以通过X，Y，Z轴同时变化，来旋转图像。

CATransform3D CATransform3DRotate (CATransform3D t, CGFloat angle, CGFloat x, CGFloat y, CGFloat z);
 
t：就是上一个函数。其他的都一样。

就可以理解为：函数的叠加，效果的叠加。


CATransform3D CATransform3DInvert (CATransform3D t);

翻转效果。

未使用 

![](http://my.csdn.net/uploads/201204/12/1334210214_1027.png)  

使用 

![](http://my.csdn.net/uploads/201204/12/1334210219_6168.png)
  

CGAffineTransform CATransform3DGetAffineTransform (CATransform3D t);

bool CATransform3DIsAffine (CATransform3D t);

仿射效果。

就是把一个 CATransform3D 对象转换成一个 CGAffineTransform 对象。
也就是把 CATransform3D 矩阵 转换成 CGAffineTransform 矩阵

 
变换函数同时提供了可以比较一个变换矩阵是否是单位矩阵,或者两个矩阵是否相等。

bool CATransform3DIsIdentity (CATransform3D t);

bool CATransform3DEqualToTransform (CATransform3D a, CATransform3D b);


也可以通过修改数据结构和键值来设置变换效果。
 ```objc
struct CATransform3D
{

    CGFloat m11, m12, m13, m14；

    CGFloat m21, m22, m23, m24；

    CGFloat m31, m32, m33, m34；

    CGFloat m41, m42, m43, m44；
}
```
可以直接修改 其中的一个值，来达到相同的效果。

或者修改键值

[myLayer setValue:[NSNumber numberWithInt:0] forKeyPath:@"transform.rotation.x"];

![](http://my.csdn.net/uploads/201204/12/1334211496_7014.png)
