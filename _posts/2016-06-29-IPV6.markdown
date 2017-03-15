---
layout:     post
title:      "iOS开发：关于IPV6"
subtitle:   ""
date:       2016-06-29 22:00:00
author:     "FishYan"
header-img: "img/blog-header.png" 
catalog:    true
tags:
    - iOS
---

![这里写图片描述](http://img.blog.csdn.net/20160619091717737)

>IPv6是IETF(Internet Engineering Task Force 译：互联网工程任务组)设计的用于替代现行版本IP协议-IPv4-的下一代IP协议，它由128位二进制数码表示。苹果从6月1好开始执行APP都要支持IPV6网络

## IPV6的优势
- （1）IPV6地址长度为128位，地址空间增加了2^128-2^32个。
- （2）灵活的IP报文头部格式。使用一系列固定格式的扩展头部
取代了IPV4中可变长度的选项字段。IPV6中选项部分的出现方式也有所变化，使路由器可以简单路过选项而不做任何处理，加快了报文处理速度；
- （3）IPV6简化了报文头部格式，字段只有8个，加快报文转发，提高了吞吐量；
- （4）提高安全性。身份认证和隐私权是IPV6的关键特性；
- （5）支持更多的服务类型；
- （6）允许协议继续演变，增加新的功能，使之适应未来技术的发展；

## APP如何支持IPV6-Only

对于如何支持IPV6-Only，官方给出了如下几点标准：

1. Use High-Level Networking Frameworks;

2. Don’t Use IP Address Literals;

3. Check Source Code for IPv6 DNS64/NAT64 Incompatibilities;

4. Use System APIs to Synthesize IPv6 Addresses;

**3.1 NSURLConnection是否支持IPV6？**

官方的这句话让我们疑惑顿生：
```
using high-level networking APIs such as NSURLSession and the CFNetwork frameworks and you connect by name, you should not need to change anything for your app to work with IPv6 addresses
```
只说了NSURLSession和CFNetwork的API不需要改变，但是并没有提及到NSURLConnection。 从上文的参考资料中，我们看到NSURLSession、NSURLConnection同属于Cocoa的url loading system，可以猜测出NSURLConnection在ios9上是支持IPV6的。

应用里面的API网络请求，大家一般都会选择AFNetworking进行请求发送，由于历史原因，应用的代码基本上都深度引用了AFHTTPRequestOperation类，所以目前API网络请求均需要通过NSURLConnection发送出去，所以必须确认NSURLConnection是否支持IPV6. 经过测试，NSURLConnection在最新的iOS9系统上是支持IPV6的。

**3.2 Reachability是否需要修改支持IPV6？**

我们可以查到应用中大量使用了Reachability进行网络状态判断，但是在里面却使用了IPV4的专用API。

在Pods:Reachability中
```
AF_INET                  Files:Reachability.m
struct sockaddr_in       Files:Reachability.h , Reachability.m
```
那Reachability应该如何支持IPV6呢？

（1）目前Github的开源库Reachability的最新版本是3.2，苹果也出了一个Support IPV6 的Reachability的官方样例，我们比较了一下源码，跟Github上的Reachability没有什么差异。

（2）我们通常都是通过一个0.0.0.0 (ZeroAddress)去开启网络状态监控，经过我们测试，在iOS9以上的系统上IPV4和IPV6网络环境均能够正常使用；但是在iOS8上IPV4和IPV6相互切换的时候无法监控到网络状态的变化，可能是因为苹果在iOS8上还并没有对IPV6进行相关支持相关。（但是这仍然满足苹果要求在最新系统版本上支持IPV6的网络）。

（3）当大家都在要求Reachability添加对于IPV6的支持，其实苹果在iOS9以上对Zero Address进行了特别处理，[官方发言](https://developer.apple.com/library/ios/samplecode/Reachability/Listings/ReadMe_md.html#//apple_ref/doc/uid/DTS40007324-ReadMe_md-DontLinkElementID_11)是这样的：

reachabilityForInternetConnection: This monitors the address 0.0.0.0,

which reachability treats as a special token that causes it to actually

monitor the general routing status of the device, both IPv4 and IPv6.

```swift
+ (instancetype)reachabilityForInternetConnection {
    struct sockaddr_in zeroAddress;
    bzero(&zeroAddress, sizeof(zeroAddress));
    zeroAddress.sin_len = sizeof(zeroAddress);
    zeroAddress.sin_family = AF_INET;
    return [self reachabilityWithAddress: (const struct sockaddr *) &zeroAddress];
}
```
综上所述，Reachability不需要做任何修改，在iOS9上就可以支持IPV6和IPV4，但是在iOS9以下会存在bug，但是苹果审核并不关心。

## 搭建IPV6测试环境
搭建 IPv6 测试环境说白了就是用 Mac 做一个热点，然后用 iPhone 连接这个 Wi-Fi，但是前提是需要你用网线连接你的Mac

和正常的开启 Mac 热点的方式的区别是这次我们产生的是一个本地的 IPv6 DNS64/NAT64 网络，这项功能是 OS X 10.11 新加的功能（如果你的 Mac 系统版本不是的话必须要升级哦，才能产生 IPv6 的热点 ）。

下面看图说话：

1.进入系统偏好设置，按着option+打开共享，这时候在共享的界面下方就会出现一个“创建NAT64网络”的选项，

![这里写图片描述](http://img.blog.csdn.net/20160619094032309)


2.勾选“创建NAT64网络”就好。

![这里写图片描述](http://img.blog.csdn.net/20160619094437405)

3.随后请点击 共享以下来源的连接 的下拉列表，选择我们想要共享出去的网络接口。我当前是想要共享的是 USB 10/100/1000 LAN ，（因为的我用的是 有线的 RJ-45 接头转 USB 输出的网络转换工具 ）。

PS：如果你的 Mac 是用有线拨号上网的话，请选择 PPOE 选项作为共享源。如果你的 Mac 是用有线上网（不用拨号的）的话，请选择 Thunderbolt 以太网有线网 选项作为共享源。

![这里写图片描述](http://img.blog.csdn.net/20160619094602552)

![这里写图片描述](http://img.blog.csdn.net/20160619094711062)

4.用以下端口共享给电脑 选项此处选择 Wi-Fi

![这里写图片描述](http://img.blog.csdn.net/20160619094759368)

5.点击 Wi-Fi选项... 选项，个性化自己的热点的哦

![这里写图片描述](http://img.blog.csdn.net/20160619094942401)

6.最后一步，勾选互联网共享，启动互联网共享。

![这里写图片描述](http://img.blog.csdn.net/20160619095101825)

出现一下变化证明你已经成功产生了一个 IPv6 的热点

![这里写图片描述](http://img.blog.csdn.net/20160619095201017)

下面看一下手机连接到IPV4和IPV6网络的区别：

IPV4

![这里写图片描述](http://img.blog.csdn.net/20160619095319611)

IPV6

![这里写图片描述](http://img.blog.csdn.net/20160619095401424)

对比2张图中 DNS 的地址看到区别了吧，一个 . 分割，一个 : 分割。

下面就可以来测试你的APP是否支持IPV6了（提前关闭掉移动数据网络），如果你的APP可以通过该无线连接到网络就说明你的APP事支持IPV6的，反之则不支持。