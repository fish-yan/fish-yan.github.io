---
layout:     post
title:      "iOS 9 学习系列: Apple Pay"
subtitle:   "iOS 9 学习系列"
date:       2016-04-24 22:00:00
author:     "FishYan"
header-img: "img/blog-header.png" 
catalog:    true
tags:
    - iOS
    - iOS 9 新特性
---

>Apple Pay 是在 iOS 8 中第一次被介绍，它可以为你的应用中的实体商品和服务，提供简单、安全、私密的支付方式。它使得用户支付起来非常简便，只需按一下指纹就可以授权进行交易。

Apple Pay 只能在特定的设备上使用，目前为止，这些设备包括 iPhone 6, iPhone 6+, iPad Air 2, iPad mini 3. 这是因为 Apple Pay 需要特定的硬件芯片来支持，这个硬件叫做 Secure Element （简称SE，安全元件）,他可以用来存储和加解密信息。

假如说你的应用里有需要购买才能解锁的某些特性的话（比如去广告），你不应该使用 Apple Pay 这种支付方式。 Apple Pay 是用来解决购买实体商品和服务的，例如，聚乐部会员，酒店预订，订票等。

## 为什么使用 Apple Pay

Apple Pay 大大简化了开发者的工作。你无需自己来管理卡号，也不需要用户去注册银行卡。你可以移除部分业务模块，甚至不需要用户模块了。购买和账单信息回自动交由 Apple Pay token 来处理。这意味着简化了购买流程，可以带来更高的转化率。

在 WWDC session 702 , Apple Pay Within Apps 中, Nick Shearer 介绍了部分 Apple Pay 在美国的不同商业交易中超高转化率的统计情况。

Stubhub 发现使用 Apple Pay 的客户的转换率超过传统客户 20%。

OpenTable 发现采用了 Apple Pay 之后呈现了 50%的增长。

Staples 发现采用了 Apply Pay 后，实现了109%的转换率增长。
## 创建一个简单的商店应用
我们将创建一个包含商店的应用，演示 Apple Pay 是如何处理我们的交易的。这个应用仅有一个商品，但已经足够展示如何开始使用 Apple Pay 了。

![](http://upload-images.jianshu.io/upload_images/28255-1634d075ec402013.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

这是我们将要创建的最终页面。你可以看，当用户点击“购买”按钮时，弹出了一个 Apple Pay 的表单。

## Enabling Apple Pay
在我们写代码之前，请先确保应用有使用 Apple Pay 的能力。当创建玩空白项目后，打开项目设置，找到 capabilities 这个 tab。

![](http://upload-images.jianshu.io/upload_images/28255-41f6af5efce47fdc.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

你应该能够在 capabilities 里看到 Apple Pay 部分，把状态设置为开启。这时候会让你选择一个开发团队的授权账号，希望接下来， Xcode 能够把设置工作都帮你做好。

我们需要添加一个 Merchant ID，让 Apple 知道如何去为当前付款信息编码。点击在 Merchant ID 位置出现的添加按钮，填写你自己的唯一 Merchant ID。在这个例子中，我们使用的是 merchant.com.shinobistore.appleplay。

![](http://upload-images.jianshu.io/upload_images/28255-6bb0fb21a4dbf1cb.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

就这些，你可以看到 Apple Pay 已经设置为可用了，你应该可以在应用中使用它了。

## 使用 Apple Pay
现在，我们已经设置好了配置文件，我们要开始创建 UI 了，以便让用户可以购买产品和支付。打开 storyboard 添加一些UI（如下图），做成产品出售页面。

![](http://upload-images.jianshu.io/upload_images/28255-ba138dfead6247a8.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

我们刚才创建的 UI 是一个图片，带有标题、价格和描述的文本。这不是这个 demo 的重点。我们需要添加一个按钮，我们把它添到视图的下面。我们要添加的按钮是一个 PKPaymentButton, 这个在 iOS 8.3 时引入。这个按钮是本地化的，能够提供标准的样式。因此，我们强力推荐使用这个按钮来启动 Apple Pay 的支付页面。

这个按钮有三个样式
```
White; WhiteOutLine; Black
```
同样具有两个不同类型
```
Plain; Buy
```
有几种不同的方法可以设置按钮的样式。不幸的是，目前还不支持在 Interface Builder 中设置。所以打开 ViewController.swift ,覆盖 viewDidLoad 方法。

![](http://upload-images.jianshu.io/upload_images/28255-48984e99fd5f8f26.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

这就是我们全部需要做的。它可以自适应，本质上（这个 demo）我们在意的就是这个按钮。 当我们点击了按钮后，在 buyNowButtonTapped 方法里，我们启动购买进程。

![](http://upload-images.jianshu.io/upload_images/28255-f53fa8cc7854106d.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

当UI 创建好后，现在我们必须去处理购买流程。首先，我们需要理解 Apple Pay 的一些类的概念。

**PKPaymentSummaryItem**

    这个 Object 是你的 Apple Pay 交易清单上的一条。它可以是商品的，也可以是税，或者运费。

**PKPaymentRequest**

    PKPaymentRequest 合并你所有想要用户看到的信息。诸如 merchant identifier, country code 和 currency code。

**PKPaymentAuthorisationViewController**

    PKPaymentAuthorisationViewController 让用户及时授权 PKPaymentRequest，并且选择投递地址和支付的卡。

**PKPayment**

    PKPayment包括需要处理的交易的信息，并且包含需要用户确认的消息。

所有这些类都包含在 PassKit（因此以 PK 开头） 之内，所以你需要在用到 Apple Pay 的地方，引入这个框架。

## 设置 Payment
第一步要创建一个 PKPaymentRequest, 我们讲在下面详述

![](http://upload-images.jianshu.io/upload_images/28255-6acdf464abd10b1a.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

首先我们创建一个可以接受的支付网络的数组，它确定了那些类型的卡，是我们可以使用的。

![](http://upload-images.jianshu.io/upload_images/28255-06a99499b3a57bf1.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

然后我们要检测，当前设备是否可以处理这些类型的交易。canMakePaymentsUsingNetworks 是PKPaymentAuthorizationViewController 中标准的检测设备是否有交易处理能力的方法。

![](http://upload-images.jianshu.io/upload_images/28255-795afc9830273624.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

如果设备具备处理交易的能力，上面的代码，开始自动创建一个交易的请求。注释信息表明了每行代码的作用。

![](http://upload-images.jianshu.io/upload_images/28255-1a6cd2bbd74e1a5d.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

然后，如上面的代码，设置你想要在 Apple Pay 表单要显示的商品信息。他们会在接下来的 paymentSummaryItems 中用到。

![](http://upload-images.jianshu.io/upload_images/28255-d32a71a0114f6d1c.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

这个 API 有意思的一点是，在数组最后一个，是用户总共需要支付多少钱。它在表单的最后，会特别表示出来。在这个例子中，是总价。如果，你希望现实更多的条目，你需要手动计算并且在列表最后，添加一个PKPaymentSummaryItem。

![](http://upload-images.jianshu.io/upload_images/28255-3944481d966355a6.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

最后，给请求设置一个 PKPaymentAuthorizationViewController，设置代理，然后展示给用户。

![](http://upload-images.jianshu.io/upload_images/28255-8edce6c6ed61401a.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

现在我们需要确认，是否声明了 PKPaymentAuthorizationViewController 的代理方法。我们需要声明这些方法，以确认是否生成了交易，并在得到授权或完成后，响应相关事件。

在 paymentAuthorizationViewController:didAuthorizePayment 方法中，我们要使用我们的 provider 处理交易数据，并且返回状态给应用。返回的 PKPayment 拥有一个 PKPaymentToken 的属性，我们需要发送给支付的 provider.他是负责编码和私钥加密的。


![](http://upload-images.jianshu.io/upload_images/28255-412e6d3fa8be47fc.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)
在 paymentAuthorizationViewControllerDidFinish 方法中，我们简单的关闭掉我们的 viewController。


![](http://upload-images.jianshu.io/upload_images/28255-3f941bf52cc3bc64.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)
这就是全部了。显然，在现实世界里，你可能还需要把支付的 token 发送给诸如 Stripe，但这个超出本教程的范围。我们还添加了一个  controller 来显示收据。在这个例子中，仅显示支付 token 的 transactionIdentifier。他是一个被格式化好的的全球唯一的一个字符串，可以用来做收据的验证。


![](http://upload-images.jianshu.io/upload_images/28255-45da1e6334f0ef7a.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)
延伸阅读
更多关于 Apple Pay 的信息，我推荐观看 WWDC 2015 的 session 702, [Apple Pay Within Apps](https://developer.apple.com/videos/wwdc/2015/?id=702). 这个视频挺长的，但是如果你对 Apple Pay 感兴趣的话，绝对值得观看。这个 session 中间有一段，讲了 Apple Pay 是如何改进交易处理的用户体验的。

另外，在苹果开发者网站上，还有一个文档 [guide to Apple Pay](https://developer.apple.com/apple-pay/)。如果你想要在应用中集成 Apple Pay 的话，它是非常值得一读的。

[Demo](https://github.com/fish-yan/Apple-Pay)