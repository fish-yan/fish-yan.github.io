---
layout:     post
title:      "iOS 视图控制器转场详解"
subtitle:   "iOS 转场，结合动画使用，但不属于动画范畴"
date:       2016-12-15 22:00:00
author:     "FishYan"
header-img: "img/blog-header.png" 
catalog:    true
tags:
    - iOS
---


## 前言

屏幕左边缘右滑返回，TabBar 滑动切换，你是否喜欢并十分依赖这两个操作，甚至觉得 App 不支持这类操作的话简直反人类？这两个操作在大屏时代极大提升了操作效率，其背后的技术便是今天的主题：视图控制器转换(View Controller Transition)。

视图控制器中的视图显示在屏幕上有两种方式：最主要的方式是内嵌在容器控制器中，比如 UINavigationController，UITabBarController, UISplitController；由另外一个视图控制器显示它，这种方式通常被称为模态(Modal)显示。View Controller Transition 是什么？在 NavigationController 里 push 或 pop 一个 View Controller，在 TabBarController 中切换到其他 View Controller，以 Modal 方式显示另外一个 View Controller，这些都是 View Controller Transition。在 storyboard 里，每个 View Controller 是一个 Scene，View Controller Transition 便是从一个 Scene 转换到另外一个 Scene；为方便，以下对 View Controller Transition 的中文称呼采用 Objccn.io 中的翻译「转场」。

在 iOS 7 之前，我们只能使用系统提供的转场效果，大部分时候够用，但仅仅是够用而已，总归会有各种不如意的小地方，但我们却无力改变；iOS 7 开放了相关 API 允许我们对转场效果进行全面定制，这太棒了，转场配合动画以及对交互手段的支持带来了无限可能，像开头提到的两种转场搭配简单的动画带来了便利的交互操作，有些转场配合华丽的动画则能让转场变得赏心悦目。

我知道你更想知道如何实现好看的转场动画，不过本文并非华丽的转场动画教程，相反，文中的转场动画效果都十分简单，但我会教你彻底掌握转场动画中转场的那部分，包括转场背后的机制，缺陷以及实现过程中的技巧与陷阱。阅读本文需要读者至少要对 ViewController 和 View 的结构以及协议有基本的了解，最好自己亲手实现过一两种转场动画。如果你对此感觉没有信心，推荐观看官方文档：[View Controller Programming Guide for iOS](https://developer.apple.com/library/ios/featuredarticles/ViewControllerPGforiPhoneOS/index.html#//apple_ref/doc/uid/TP40007457-CH2-SW1)，学习此文档将会让你更容易理解本文的内容。对你想学习的小节，我希望你自己亲手写下这些代码，一步步地看着效果是如何实现的，至少对我而言，看各种相关资料时只有字面意义上的理解，正是一步步的试验才能让我理解每一个步骤。本文涉及的内容较多，为了避免篇幅过长，我只给出关键代码而不是从新建工程开始教你每一个步骤。本文基于 Xcode 7 以及 Swift 2，Demo 合集地址：[iOS-ViewController-Transition-Demo](https://github.com/seedante/iOS-ViewController-Transition-Demo.git)。

文章目录：

* [前奏：触发转场的方式](#Chapter0)
* [Transition 解释](#Chapter1)
* [阶段一：非交互转场](#Chapter2)
    * [动画控制器协议](#Chapter2.1)
    * [动画控制器实现](#Chapter2.2)
    * [特殊的 Modal 转场](#Chapter2.3)
        * [Modal 转场的差异](#Chapter2.3.1)
        * [Modal 转场实践](#Chapter2.3.2)
        * [iOS 8 的改进：UIPresentationController](#Chapter2.3.3)
    * [转场代理](#Chapter2.4)
* [阶段二：交互式转场](#Chapter3)
    * [实现交互化](#Chapter3.1) 
    * [Transition Coordinator](#Chapter3.2)
    * [特殊的 Modal 转场交互化](#Chapter3.3)
    * [封装交互控制器](#Chapter3.4)
    * [交互转场的限制](#Chapter3.5)
* [插曲：UICollectionViewController 布局转场](#Chapter4)
* [进阶](#Chapter5)
    * [案例分析](#Chapter5.1)
        * [子元素动画](#Chapter5.1.1)
        * [Mask 动画](#Chapter5.1.2)
        * [高性能动画框架](#Chapter5.1.3)
    * [自定义容器控制器转场](#Chapter5.2)
        * [实现分析](#Chapter5.2)
        * [协议补完](#Chapter5.2)
        * [交互控制](#Chapter5.2)
            * [动画控制和 CAMediaTiming 协议](#Chapter5.2) 
            * [取消转场](#Chapter5.2)
            * [最后的封装](#Chapter5.2)
* [尾声：转场动画的设计](#Chapter6)



<a name="Chapter0"/> 
<h3 id="Chapter0">前奏：触发转场的方式</h3>

目前为止，官方支持以下几种方式的自定义转场：

1. 在 UINavigationController 中 push 和 pop;
2. 在 UITabBarController 中切换 Tab;
3. Modal 转场：presentation 和 dismissal，俗称视图控制器的模态显示和消失，仅限于`modalPresentationStyle`属性为 UIModalPresentationFullScreen 或 UIModalPresentationCustom 这两种模式;
4. UICollectionViewController 的布局转场：仅限于 UICollectionViewController 与 UINavigationController 结合的转场方式，与上面三种都有点不同，不过实现很简单，[可直接查看这里](#Chapter4)。

官方的支持包含了 iOS 中的大部分转场方式，还有一种自定义容器中的转场并没有得到系统的直接支持，不过借助协议这种灵活的方式，我们依然能够实现对自定义容器控制器转场的定制，在压轴环节我们将实现这一点。

以上前三种转场都需要转场代理和动画控制器(见下节)的帮助才能实现自定义转场动画，而触发的方式分为三种：代码里调用相关动作的方法，Segue 以及，对于上面两种容器 VC，在 UINavigationBar 和 UITabBar 上的相关 Item 的点击操作。

**相关动作方法**

UINavigationController 中所有修改其`viewControllers`栈中 VC 的方法都可以自定义转场动画：

    //我们使用的最广泛的 push 和 pop 方法
    func pushViewController(_ viewController: UIViewController, animated animated: Bool)
    func popViewControllerAnimated(_ animated: Bool) -> UIViewController?
    //不怎么常用的 pop 方法
    func popToRootViewControllerAnimated(_ animated: Bool) -> [UIViewController]?
    func popToRootViewControllerAnimated(_ animated: Bool) -> [UIViewController]?
    //这个方法有有点特别，是对 VC 栈的整体更新，开启动画后的执行比较复杂，具体参考文档说明。不建议在这种情况下开启转场动画。
    func setViewControllers(_ viewControllers: [UIViewController], animated animated: Bool)
UITabBarController 下没什么特别的：

    //注意传递的参数必须是其下的子 VC
    unowned(unsafe) var selectedViewController: UIViewController?
    var selectedIndex: Int
    //和上面类似的整体更新
    func setViewControllers(_ viewControllers: [UIViewController]?, animated animated: Bool)
Modal 转场：
    
    // Presentation 转场
    func presentViewController(_ viewControllerToPresent: UIViewController, animated flag: Bool, completion completion: (() -> Void)?)
    // Dismissal 转场
    func dismissViewControllerAnimated(_ flag: Bool, completion completion: (() -> Void)?)

**Segue**

在 storyboard 里设置 segue有两种方式：Button to VC，这种在点击 Button 的时候触发转场；VC to VC，这种需要在代码中调用`performSegueWithIdentifier:sender:`。`prepareForSegue:sender:`方法是在转场发生前修改转场参数的最后机会。这点对于 Modal 转场比较重要，因为在 storyboard 里 Modal 转场的 Segue 类型不支持选择 Custom 模式，使用 segue 方式触发时必须在`prepareForSegue:sender:`里修改模式。


**iOS 8 的变化**

iOS 8 引入了适应性布局，由此添加了两种新的方式来显示一个视图控制器：

    func showViewController(_ vc: UIViewController, sender sender: AnyObject?)
    func showDetailViewController(_ vc: UIViewController, sender sender: AnyObject?)
这两个方法咋看上去是给 UISplitViewController 用的，在 storyboard 里 segue 的候选模式里，直接给出了`Show(e.g. Push)`和`Show Detail(e.g. Replace)`这样的提示，以至于我之前一直对这两个 segue 有误解。实际上这两个方法智能判断当前的显示环境来决定如何显示，iOS 8 想统一显示视图控制器的方式，不过引入这两个方法增加了使用的复杂性，来看看这两个方法的使用规则。

这两个方法在 UISplitViewController 上的确是按名字显示的那样去工作的，而在本文关注的控制器上是这样工作的：

|    | ViewController | NavigationController | TabBarController |  
| ---|---|---|---|
|showViewController:sender:      |Presentation|Push|Presentation(by self)|
|showDetailViewController:sender:|Presentation|Presentation(by self)|Presentation(by self)|

UINavigationController 重写了`showViewController:sender:`而执行 push 操作，上面的`by self`意思是用容器 VC 本身而非其下子 VC 去执行 presentation。这两个方法的行为可以通过重写来改变。

当非容器类 VC 内嵌在这两种容器 VC 里时，会通过最近的容器 VC 来执行：

|    | VC in NavigationController | VC in TabBarController |  
| ---|---|---|---|
|showViewController:sender:      |Push(by NavigationController)|Presentation(by TabBarController)|
|showDetailViewController:sender:|Presentation(by NavigationController)|Presentation(by TabBarController)|

<a name="Chapter1"/>
<h2 id="Chapter1">Transition 解释</h2>

前言里从行为上解释了转场，那在转场时发生了什么？下图是从 WWDC 2013 Session 218 整理的，解释了转场时视图控制器和其对应的视图在结构上的变化：

![The Anatomy of Transition](https://github.com/seedante/iOS-ViewController-Transition-Demo/blob/master/Figures/The%20Anatomy%20of%20Transition.png?raw=true)

转场过程中，作为容器的父 VC 维护着多个子 VC，但在视图结构上，只保留一个子 VC 的视图，所以转场的本质是下一场景(子 VC)的视图替换当前场景(子 VC)的视图以及相应的控制器(子 VC)的替换，表现为当前视图消失和下一视图出现，基于此进行动画，动画的方式非常多，所以限制最终呈现的效果就只有你的想象力了。图中的 Parent VC 可替换为 UIViewController, UITabbarController 或 UINavigationController 中的任何一种。


iOS 7 以协议的方式开放了自定义转场的 API，协议的好处是不再拘泥于具体的某个类，只要是遵守该协议的对象都能参与转场，非常灵活。转场协议由5种协议组成，在实际中只需要我们提供其中的两个或三个便能实现绝大部分的转场动画：

1.**转场代理(Transition Delegate)：**

自定义转场的第一步便是提供转场代理，告诉系统使用我们提供的代理而不是系统的默认代理来执行转场。有如下三种转场代理，对应上面三种类型的转场：

    <UINavigationControllerDelegate> //UINavigationController 的 delegate 属性遵守该协议。
    <UITabBarControllerDelegate> //UITabBarController 的 delegate 属性遵守该协议。
    <UIViewControllerTransitioningDelegate> //UIViewController 的 transitioningDelegate 属性遵守该协议。
	
这里除了[`<UIViewControllerTransitioningDelegate>`](https://developer.apple.com/library/ios/documentation/UIKit/Reference/UIViewControllerTransitioningDelegate_protocol/index.html#//apple_ref/doc/uid/TP40013060)是 iOS 7 新增的协议，其他两种在 iOS 2 里就存在了，在 iOS 7 时扩充了这两种协议来支持自定义转场。

转场发生时，UIKit 将要求转场代理将提供转场动画的核心构件：动画控制器和交互控制器(可选的)；由我们实现。

2.**动画控制器(Animation Controller)：**

最重要的部分，负责添加视图以及执行动画；遵守[`<UIViewControllerAnimatedTransitioning>`](https://developer.apple.com/library/ios/documentation/UIKit/Reference/UIViewControllerAnimatedTransitioning_Protocol/index.html#//apple_ref/doc/uid/TP40013387)协议；由我们实现。

3.**交互控制器(Interaction Controller)：**

通过交互手段，通常是手势来驱动动画控制器实现的动画，使得用户能够控制整个过程；遵守[`<UIViewControllerInteractiveTransitioning>`](https://developer.apple.com/library/ios/documentation/UIKit/Reference/UIViewControllerInteractiveTransitioning_protocol/index.html#//apple_ref/doc/uid/TP40013059)协议；系统已经打包好现成的类供我们使用。

4.**转场环境(Transition Context):**

提供转场中需要的数据；遵守[`<UIViewControllerContextTransitioning>`](https://developer.apple.com/library/ios/documentation/UIKit/Reference/UIViewControllerContextTransitioning_protocol/index.html#//apple_ref/doc/uid/TP40013057)协议；由 UIKit 在转场开始前生成并提供给我们提交的动画控制器和交互控制器使用。

5.**转场协调器(Transition Coordinator)：**

可在转场动画发生的同时并行执行其他的动画，其作用与其说协调不如说辅助，主要在 Modal 转场和交互转场取消时使用，其他时候很少用到；遵守[`<UIViewControllerTransitionCoordinator>`](https://developer.apple.com/library/ios/documentation/UIKit/Reference/UIViewControllerTransitionCoordinator_Protocol/index.html#//apple_ref/doc/uid/TP40013295)协议；由 UIKit 在转场时生成，UIViewController 在 iOS 7 中新增了方法`transitionCoordinator()`返回一个遵守该协议的对象，且该方法只在该控制器处于转场过程中才返回一个此类对象，不参与转场时返回 nil。

总结下，5个协议只需要我们操心3个；实现一个最低限度可用的转场动画，我们只需要提供上面五个组件里的两个：转场代理和动画控制器即可，还有一个转场环境是必需的，不过这由系统提供；当进一步实现交互转场时，还需要我们提供交互控制器，也有现成的类供我们使用。



<a name="Chapter2"/>
<h2 id="Chapter2">阶段一：非交互转场</h2>

这个阶段要做两件事，提供转场代理并由代理提供动画控制器。在转场代理协议里动画控制器和交互控制器都是可选实现的，没有实现或者返回 nil 的话则使用默认的转场效果。动画控制器是表现转场效果的核心部分，代理部分非常简单，我们先搞定动画控制器吧。

<a name="Chapter2.1"/>
<h3 id="Chapter2.1">动画控制器协议</h3>

动画控制器负责添加视图以及执行动画，遵守`UIViewControllerAnimatedTransitioning`协议，该协议要求实现以下方法：

    //执行动画的地方，最核心的方法。
    (Required)func animateTransition(_ transitionContext: UIViewControllerContextTransitioning)
    //返回动画时间，"return 0.5" 已足够，非常简单，出于篇幅考虑不贴出这个方法的代码实现。
    (Required)func transitionDuration(_ transitionContext: UIViewControllerContextTransitioning?) -> NSTimeInterval
    //如果实现了，会在转场动画结束后调用，可以执行一些收尾工作。
    (Optional)func animationEnded(_ transitionCompleted: Bool)
	
最重要的是第一个方法，该方法接受一个遵守`<UIViewControllerContextTransitioning>`协议的转场环境对象，上一节的 API 解释里提到这个协议，它提供了转场所需要的重要数据：参与转场的视图控制器和转场过程的状态信息。

UIKit 在转场开始前生成遵守转场环境协议`<UIViewControllerContextTransitioning>`的对象 transitionContext，它有以下几个方法来提供动画控制器需要的信息：
	
    //返回容器视图，转场动画发生的地方。
    func containerView() -> UIView?
    //获取参与转场的视图控制器，有 UITransitionContextFromViewControllerKey 和 UITransitionContextToViewControllerKey 两个 Key。 
    func viewControllerForKey(_ key: String) -> UIViewController?
    //iOS 8新增 API 用于方便获取参与参与转场的视图，有 UITransitionContextFromViewKey 和 UITransitionContextToViewKey 两个 Key。
    func viewForKey(_ key: String) -> UIView? AVAILABLE_IOS(8_0)
	
通过`viewForKey:`获取的视图是`viewControllerForKey:`返回的控制器的根视图，或者 nil。`viewForKey:`方法返回 nil 只有一种情况： UIModalPresentationCustom 模式下的 Modal 转场 ，通过此方法获取 presentingView 时得到的将是 nil，在后面的 Modal 转场里会详细解释。

前面提到转场的本质是下一个场景的视图替换当前场景的视图，从当前场景过渡下一个场景。下面称即将消失的场景的视图为 fromView，对应的视图控制器为 fromVC，即将出现的视图为 toView，对应的视图控制器称之为 toVC。几种转场方式的转场操作都是可逆的，一种操作里的 fromView 和 toView 在逆向操作里的角色互换成对方，fromVC 和 toVC 也是如此。**在动画控制器里，参与转场的视图只有 fromView 和 toView 之分，与转场方式无关。你可以在 fromView 和 toView 上添加任何动画，转场动画的最终效果只限制于你的想象力。**这也是动画控制器在封装后可以被第三方使用的重要原因。

在 iOS 8 中可通过以下方法来获取参与转场的三个重要视图，在 iOS 7 中则需要通过对应的视图控制器来获取，为避免 API 差异导致代码过长，示例代码中直接使用下面的视图变量：

    let containerView = transitionContext.containerView()
    let fromView = transitionContext.viewForKey(UITransitionContextFromViewKey)
    let toView = transitionContext.viewForKey(UITransitionContextToViewKey)
  
<a name="Chapter2.2"/>  
<h3 id="Chapter2.2">动画控制器实现</h3>

转场 API 是协议的好处是不限制具体的类，只要对象实现该协议便能参与转场过程，这也带来另外一个好处：封装便于复用，尽管三大转场代理协议的方法不尽相同，但它们返回的动画控制器遵守的是同一个协议，因此可以将动画控制器封装作为第三方动画控制器在其他控制器的转场过程中使用。

需要举个例子了，实现哪个好呢？

![](https://github.com/seedante/iOS-ViewController-Transition-Demo/blob/master/Figures/Push&Pop.gif?raw=true)![](https://github.com/seedante/SDECollectionViewAlbumTransition/blob/PinchPopTransition/Figures/AlbumTransition.gif?raw=true)

毫无疑问，上面那个简单的。Are you kidding me?这种转场动画也需要你写这么长的废话来教我怎么实现？**好吧，你要知道转场动画是转场与动画的配合，下面更炫酷一点的转场动画和上面的五毛动画相比，它们在转场技术部分并没有什么区别，主要的差别在动画的部分。事实是，不管复杂与否，所有的转场动画在实现转场的部分都没有什么差别，而且从技术上来讲，实现转场并没有高深的东西，如果你动手实现过几次，你就能搞定所有的转场动画中转场的那部分。**所以，为了安安静静学习转场以及省点篇幅，我选择上面的转场动画作为例子。

在交互式转场章节里我们将在上面 Slide 动画的基础上实现文章开头提到的两种效果：NavigationController 右滑返回 和 TabBarController 滑动切换。尽管对动画控制器来说，转场方式并不重要，可以对 fromView 和 toView 进行任何动画，是的，任何动画，但上面的动画和 Modal 转场风格上有点不配，主要动画的方向不对，我在这个 Slide 动画控制器里为 Modal 转场适配了和系统的风格类似的竖直移动动画效果；另外 Modal 转场并没有比较合乎操作直觉的交互手段，而且和前面两种容器控制器的转场在机制上有些不同，所以我将为 Modal 转场示范另外一个动画。

Demo 中的 Slide 动画控制器适用于三种转场，不必修改就可以直接在工程中使用。转场中的操作是可逆的，你可以为了每一种操作实现单独的动画控制器，也可以实现通用的动画控制器。为此，Demo 中的 Slide 动画控制器针对转场的操作类型进行了适配。Swift 中 enum 的关联值可以视作有限数据类型的集合体，在这种场景下极其合适。设定转场类型：

    enum SDETransitionType{
        //UINavigationControllerOperation 是枚举类型，有 None, Push, Pop 三种值。
        case NavigationTransition(UINavigationControllerOperation) 
        case TabTransition(TabOperationDirection)
        case ModalTransition(ModalOperation)
    }
	
    enum TabOperationDirection{
        case Left, Right
    }
	
    enum ModalOperation{
        case Presentation, Dismissal
    }
使用示例：在 TabBarController 中切换到左边的页面。

    let transitionType = SDETransitionType.TabTransition(.Left)

Slide 动画控制器的核心代码：

    class SlideAnimationController: NSObject, UIViewControllerAnimatedTransitioning {
        init(type: SDETransitionType) {...}
		
        func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
            ...
	         //1
            containerView.addSubview(toView)
       		
            //计算位移 transform，NavigationVC 和 TabBarVC 在水平方向进行动画，Modal 转场在竖直方向进行动画。
            var toViewTransform = ...
            var fromViewTransform = ...
            toView.transform = toViewTransform
            
            //根据协议中的方法获取动画的时间。
            let duration = self.transitionDuration(transitionContext)
            UIView.animateWithDuration(duration, animations: {
                fromView.transform = fromViewTransform
                toView.transform = CGAffineTransformIdentity
                }, completion: { _ in
                    //考虑到转场中途可能取消的情况，转场结束后，恢复视图状态。
                    fromView.transform = CGAffineTransformIdentity
                    toView.transform = CGAffineTransformIdentity
                    //2
                    let isCancelled = transitionContext.transitionWasCancelled()
                    transitionContext.completeTransition(!isCancelled)
            })
        }
    }

   
**注意上面的代码有2处标记，是动画控制器必须完成的：**

1. 将 toView 添加到容器视图中，使得 toView 在屏幕上显示( Modal 转场中此点稍有不同，下一节细述)，也不必非得是`addSubview:`，某些场合你可能需要调整 fromView 和 toView 的显示顺序，总之将之加入到 containerView 里就行了；
2. 动画结束后正确地结束转场过程。转场的结果有两种：完成或取消。非交互转场的结果只有完成一种情况，不过交互式转场需要考虑取消的情况。如何结束取决于转场的进度，通过`transitionWasCancelled()`方法来获取转场的结果，然后使用`completeTransition:`来通知系统转场过程结束，这个方法会检查动画控制器是否实现了`animationEnded:`方法，如果有，则调用该方法。

至此，你已经能够搞定任何动画控制器中转场的部分了，无论转场动画是简单的还是超级复杂的，是的，就这么简单，没有任何高深的东西了。转场结束后，fromView 会从视图结构中移除，UIKit 自动替我们做了这事，你也可以手动处理提前将 fromView 移除，这完全取决于你。虽然这个动画控制器实现的动画非常简单，但此刻我们已经替换掉了系统提供的默认转场动画。

以上的代码是常规的实现手法，这里还有另外一条更简单的路：`UIView`的类方法

    transitionFromView:toView:duration:options:completion:
    
甚至不需要获取 containerView 以及手动添加 toView 就能实现一个指定类型的转场动画，而缺点则是只能使用指定类型的动画。

    UIView.transitionFromView(fromView, toView: toView, duration: durantion, options: .TransitionCurlDown, completion: { _ in
        let isCancelled = transitionContext.transitionWasCancelled()
        transitionContext.completeTransition(!isCancelled)
    })

看到这里是否想起了点什么？`UIViewController`用于在子 VC 间转换的方法：

    transitionFromViewController:toViewController:duration:options:animations:completion:
该方法用 toVC 的视图替换 fromVC 的视图在父视图中的位置并且执行`animations`闭包里的动画，但这个方法仅限于在自定义容器控制器里使用，直接使用 UINavigationController 和 UITabBarController 调用该方法在其下的子 VC 间转换会抛出异常。不过 iOS 7 中这两个容器控制器开放的自定义转场做的是同样的事情，回头再看第一章 [Transition 解释](#Chapter1)，转场协议 API 将这个方法拆分成了上面的几个组件，并且加入了激动人心的交互控制，以便我们能够方便定制转场动画。

<a name="Chapter2.3"/>    
<h3 id="Chapter2.3">特殊的 Modal 转场</h3>

<a name="Chapter2.3.1"/> 
<h4 id="Chapter2.3.1">Modal 转场的差异</h4>

事先声明：尽管 Modal 转场和上面两种容器 VC 的转场在控制器结构以及视图结构都有点差别，但是在代码里实现转场时，差异非常小，仅有一处地方需要注意。所以，本节也可以直奔末尾，记住结论就好。

上一节里两种容器 VC 的转场里，fromVC 和 toVC 都是其子 VC，而在 Modal 转场里并非这样的关系，fromVC(presentingVC) present toVC(presentedVC)，前者为后者提供显示的环境。两类转场的视图结构差异如下：

![ContainerVC VS Modal](https://github.com/seedante/iOS-ViewController-Transition-Demo/blob/master/Figures/ContainerVC%20VS%20Modal.png?raw=true)

转场前后可以在控制台打印出它们的视图控制器结构以及视图结构观察变化情况，不熟悉相关命令的话推荐使用 [chisel](https://github.com/facebook/chisel) 工具，而使用 Xcode 的 ViewDebugging 功能可以直观地查看应用的视图结构。如果你对转场中 containerView 这个角色感兴趣，可以通过上面的方法来查看。

容器类 VC 的转场里 fromView 和 toView 是 containerView 的子层次的视图，而 Modal 转场里 presentingView 与 containerView 是同层次的视图，只有 presentedView 是 containerView 的子层次视图。

这种视图结构上的差异与 Modal 转场的另外一个不同点是相契合的：转场结束后 fromView 可能依然可见，比如 UIModalPresentationPageSheet 模式的 Modal 转场就是这样。容器 VC 的转场结束后 fromView 会被主动移出视图结构，这是可预见的结果，我们也可以在转场结束前手动移除；而 Modal 转场中，presentation 结束后 presentingView(fromView) 并未主动被从视图结构中移除。准确来说，在我们可自定义的两种模式里，UIModalPresentationCustom 模式(以下简称 Custom 模式)下 Modal 转场结束时 fromView 并未从视图结构中移除；UIModalPresentationFullScreen 模式(以下简称 FullScreen 模式)的 Modal 转场结束后 fromView 依然主动被从视图结构中移除了。这种差异导致在处理 dismissal 转场的时候很容易出现问题，没有意识到这个不同点的话出错时就会毫无头绪。

来看看 dismissal 转场时的场景：

1. FullScreen 模式：presentation 结束后，presentingView 被主动移出视图结构，不过，在 dismissal 转场中希望其出现在屏幕上并且在对其添加动画怎么办呢？实际上，你按照容器类 VC 转场里动画控制器里那样做也没有问题，就是将其加入 containerView 并添加动画。不用担心，转场结束后，UIKit 会自动将其恢复到原来的位置。虽然背后的机制不一样，但这个模式下的 Modal 转场和容器类 VC 的转场的动画控制器的代码可以通用，你不必记住背后的差异。
2. Custom 模式：presentation 结束后，presentingView(fromView) 未被主动移出视图结构，在 dismissal 中，注意不要像其他转场中那样将 presentingView(toView) 加入 containerView 中，否则 dismissal 结束后本来可见的 presentingView 将会随着 containerView 一起被移除。如果你在 Custom 模式下没有注意到这点，很容易出现黑屏之类的现象而不知道问题所在。

对于 Custom 模式，我们可以参照其他转场里的处理规则来打理：presentation 转场结束前手动将 fromView(presentingView) 移出它的视图结构，并用一个变量来维护 presentingView 的父视图，以便在 dismissal 转场中恢复；在 dismissal 转场中，presentingView 的角色由原来的 fromView 切换成了 toView，我们再将其重新恢复它原来的视图结构中。测试表明这样做是可行的。但是这样一来，在实现上，需要动画控制器用一个变量来保存 presentingView 的父视图以便在 dismissal 转场中恢复，第三方的动画控制器必须为此改造。显然，这样的代价是无法接受的。为何 FullScreen 模式的 dismissal 转场里就可以任性地将 presentingView 加入到 containerView 里呢？因为 UIKit 知道 presentingView 的视图结构，即使强行将其从原来的视图结构迁移到 containerView，事后将其恢复到正确的位置也是很容易的事情。

由于以上的区别导致实现交互化的时候在 Custom 模式下无法控制转场过程中添加到 presentingView 上面的动画。解决手段请看[特殊的 Modal 转场交互化](#Chapter3.3)一节。

**结论**：不要干涉官方对 Modal 转场的处理，我们去适应它。**在 Custom 模式下的 dismissal 转场中不要像其他的转场那样将 toView(presentingView) 加入 containerView，否则 presentingView 将消失不见，而应用则也很可能假死。而 FullScreen 模式下可以使用与前面的容器类 VC 转场同样的代码**。因此，上一节里示范的 Slide 动画控制器不适合在 Custom 模式下使用，放心好了，Demo 里适配好了，具体的处理措施，请看下一节的处理。

iOS 8 为`<UIViewControllerContextTransitioning>`协议添加了`viewForKey:`方法以方便获取 fromView 和 toView，但是在 Modal 转场里要注意，presentingView 并非 containerView 的子视图，这时通过`viewForKey:`方法来获取 presentingView 得到的是 nil，必须通过`viewControllerForKey:`得到 presentingVC 后来获取。因此在 Modal 转场中，较稳妥的方法是从 fromVC 和 toVC 中获取 fromView 和 toView。

<a name="Chapter2.3.2"/> 
<h4 id="Chapter2.3.2">Modal 转场实践</h4>

UIKit 已经为 Modal 转场实现了多种效果，当 UIViewController 的`modalPresentationStyle`属性为`.Custom` 或`.FullScreen`时，我们就有机会定制转场效果，此时`modalTransitionStyle`指定的转场动画将会被忽略。**补充说明：**自定义 Modal 转场时，`modalPresentationStyle`属性也可以为其他值，当你提供了转场代理和动画控制器后，系统就将转场这件事全权交给你负责了，UIKit 内部并没有对`modalPresentationStyle`的值进行过滤，然而该属性的值不是`.Custom` 或`.FullScreen`这两个官方支持的值时，会出现各种瑕疵。总之，在探索时可以各种试探，但是干活时还是老老实实听官方的话。详细讨论可以查看这个 [issue](https://github.com/seedante/iOS-Note/issues/2)。

Modal 转场开放自定义功能后最令人感兴趣的是定制 presentedView 的尺寸，下面来我们来实现一个带暗色调背景的小窗口效果。Demo 地址：[CustomModalTransition](https://github.com/seedante/iOS-ViewController-Transition-Demo/tree/master/CustomModalTransition)。

![ModalTransition](https://github.com/seedante/iOS-ViewController-Transition-Demo/blob/master/Figures/ModalTransition.gif?raw=true)

由于需要保持 presentingView 可见，这里的 Modal 转场应该采用 UIModalPresentationCustom 模式，此时 presentedVC 的`modalPresentationStyle`属性值应设置为`.Custom`。而且与容器 VC 的转场的代理由容器 VC 自身的代理提供不同，Modal 转场的代理由 presentedVC 提供。动画控制器的核心代码：

    class OverlayAnimationController: NSobject, UIViewControllerAnimatedTransitioning{
        ...	
        func animateTransition(transitionContext: UIViewControllerContextTransitioning) {            
            ...
            //不像容器 VC 转场里需要额外的变量来标记操作类型，UIViewController 自身就有方法跟踪 Modal 状态。
            //处理 Presentation 转场：
            if toVC.isBeingPresented(){
                //1
                containerView.addSubview(toView)
                //在 presentedView 后面添加暗背景视图 dimmingView，注意两者在 containerView 中的位置。
                let dimmingView = UIView()
                containerView.insertSubview(dimmingView, belowSubview: toView)

                //设置 presentedView 和 暗背景视图 dimmingView 的初始位置和尺寸。
                let toViewWidth = containerView.frame.width * 2 / 3
                let toViewHeight = containerView.frame.height * 2 / 3
                toView.center = containerView.center
                toView.bounds = CGRect(x: 0, y: 0, width: 1, height: toViewHeight)
                
                dimmingView.backgroundColor = UIColor(white: 0.0, alpha: 0.5)
                dimmingView.center = containerView.center
                dimmingView.bounds = CGRect(x: 0, y: 0, width: toViewWidth, height: toViewHeight)
                
                //实现出现时的尺寸变化的动画：
                UIView.animateWithDuration(duration, delay: 0, options: .CurveEaseInOut, animations: {
                    toView.bounds = CGRect(x: 0, y: 0, width: toViewWidth, height: toViewHeight)
                    dimmingView.bounds = containerView.bounds
                    }, completion: {_ in
                        //2
                        let isCancelled = transitionContext.transitionWasCancelled()
                        transitionContext.completeTransition(!isCancelled)
                })
            }
            //处理 Dismissal 转场，按照上一小节的结论，.Custom 模式下不要将 toView 添加到 containerView，省去了上面标记1处的操作；
            if fromVC.isBeingDismissed(){
                let fromViewHeight = fromView.frame.height
                UIView.animateWithDuration(duration, animations: {
                    fromView.bounds = CGRect(x: 0, y: 0, width: 1, height: fromViewHeight)
                    }, completion: { _ in
                        //2
                        let isCancelled = transitionContext.transitionWasCancelled()
                        transitionContext.completeTransition(!isCancelled)
                })
            }
        }
    }

Modal 转场在 Custom 模式下必须区分 presentation 和 dismissal 转场，而在 FullScreen 模式下可以不用这么做，因为 UIKit 会在 dismissal 转场结束后自动将 presentingView 放置到原来的位置。

在 Demo 里，Slide 动画控制器里适配所有类型的转场是这样处理的：
    
    switch transitionType{
        case .ModalTransition(let operation):
            switch operation{
                case .Presentation: containerView.addSubview(toView)
                case .Dismissal: break
            }
        default: containerView.addSubview(toView)
    }

转场环境对象本身也提供了`presentationStyle()`方法来查询 Modal 转场的类型，在一般通用型的动画控制器里可以这样处理：

    if !(transitionContext.presentationStyle() == .Custom && fromVC.isBeingDismissed()){
        containerView.addSubview(toView)
    }

前面容器 VC 的转场里提到可以使用`UIView`的类方法`transitionFromView:toView:duration:options:completion:`在`animateTransition:`方法中来执行子视图的转换，Modal 转场里，fromView 和 toView 并非同一容器视图下同层次的子视图，该方法并不适用。不过经测试，该方法在 Custom 模式下工作正常，FullScreen 模式有点不兼容。由于在 Modal 转场支持两种模式，为避免混淆建议不要使用该方法来转换视图。

至此，三种主流转场的动画控制器基本介绍完毕了，可以看到动画控制器里有关转场的部分是非常简单的，没什么难度，也没什么高级的用法，剩下的动画部分，如前面提到的那样，你可以为 fromView 和 toView 添加任何动画，而这又是另外一个话题了。


<a name="Chapter2.3.3"/> 
<h4 id="Chapter2.3.3">iOS 8的改进：UIPresentationController</h4>

iOS 8 针对分辨率日益分裂的 iOS 设备带来了新的适应性布局方案，以往有些专为在 iPad 上设计的控制器也能在 iPhone 上使用了，一个大变化是在视图控制器的(模态)显示过程，包括转场过程，引入了`UIPresentationController`类，该类接管了 UIViewController 的显示过程，为其提供转场和视图管理支持。在 iOS 8.0 以上的系统里，你可以在 presentation 转场结束后打印视图控制器的结构，会发现 presentedVC 是由一个`UIPresentationController`对象来显示的，查看视图结构也能看到 presentedView 是 UIView 私有子类的`UITtansitionView`的子视图，这就是前面 containerView 的真面目(剧透了)。

当 UIViewController 的`modalPresentationStyle`属性为`.Custom`时(不支持`.FullScreen`)，我们有机会通过控制器的转场代理提供`UIPresentationController`的子类对 Modal 转场进行进一步的定制。实际上该类也可以在`.FullScreen`模式下使用，但是会丢失由该类负责的动画，保险起见还是遵循官方的建议，只在`.Custom`模式下使用该类。官方对该类参与转场的流程和使用方法有非常详细的说明：[Creating Custom Presentations](https://developer.apple.com/library/ios/featuredarticles/ViewControllerPGforiPhoneOS/DefiningCustomPresentations.html#//apple_ref/doc/uid/TP40007457-CH25-SW1)。

`UIPresentationController`类主要给 Modal 转场带来了以下几点变化：

1. 定制 presentedView 的外观：设定 presentedView 的尺寸以及在 containerView 中添加自定义视图并为这些视图添加动画；
2. 可以选择是否移除 presentingView；
3. 可以在不需要动画控制器的情况下单独工作；
4. iOS 8 中的适应性布局。

以上变化中第1点 iOS 7 中也能做到，3和4是 iOS 8 带来的新特性，只有第2点才真正解决了 iOS 7 中的痛点。在 iOS 7 中定制外观时，动画控制器需要负责管理额外添加的的视图，`UIPresentationController`类将该功能剥离了出来独立负责，其提供了如下的方法参与转场，对转场过程实现了更加细致的控制，从命名便可以看出与动画控制器里的`animateTransition:`的关系：

    func presentationTransitionWillBegin()
    func presentationTransitionDidEnd(_ completed: Bool)
    func dismissalTransitionWillBegin()
    func dismissalTransitionDidEnd(_ completed: Bool)

除了 presentingView，`UIPresentationController`类拥有转场过程中剩下的角色：

    //指定初始化方法。
    init(presentedViewController presentedViewController: UIViewController, presentingViewController presentingViewController: UIViewController)
    var presentingViewController: UIViewController { get }
    var presentedViewController: UIViewController { get }
    var containerView: UIView? { get }
    //提供给动画控制器使用的视图，默认返回 presentedVC.view，通过重写该方法返回其他视图，但一定要是 presentedVC.view 的上层视图。
    func presentedView() -> UIView? 	
	
没有 presentingView 是因为 Custom 模式下 presentingView 不受 containerView 管理，`UIPresentationController`类并没有改变这一点。iOS 8 扩充了转场环境协议，可以通过`viewForKey:`方便获取转场的视图，而该方法在 Modal 转场中获取的是`presentedView()`返回的视图。因此我们可以在子类中将 presentedView 包装在其他视图后重写该方法返回包装后的视图当做 presentedView 在动画控制器中使用。

接下来，我用`UIPresentationController`子类实现上一节「Modal 转场实践」里的效果，presentingView 和 presentedView 的动画由动画控制器负责，剩下的事情可以交给我们实现的子类来完成。

参与角色都准备好了，但有个问题，无法直接访问动画控制器，不知道转场的持续时间，怎么与转场过程同步？这时候前面提到的用处甚少的转场协调器(Transition Coordinator)将在这里派上用场。该对象可通过 UIViewController 的`transitionCoordinator()`方法获取，这是 iOS 7 为自定义转场新增的 API，该方法只在控制器处于转场过程中才返回一个与当前转场有关的有效对象，其他时候返回 nil。

转场协调器遵守`<UIViewControllerTransitionCoordinator>`协议，它含有以下几个方法：

    //与动画控制器中的转场动画同步，执行其他动画
    animateAlongsideTransition:completion:
    //与动画控制器中的转场动画同步，在指定的视图内执行动画
    animateAlongsideTransitionInView:animation:completion:
由于转场协调器的这种特性，动画的同步问题解决了。

    class OverlayPresentationController: UIPresentationController {
        let dimmingView = UIView()
        
        //Presentation 转场开始前该方法被调用。
        override func presentationTransitionWillBegin() {
            self.containerView?.addSubview(dimmingView)
            
            let initialWidth = containerView!.frame.width*2/3, initialHeight = containerView!.frame.height*2/3
            self.dimmingView.backgroundColor = UIColor(white: 0.0, alpha: 0.5)
            self.dimmingView.center = containerView!.center
            self.dimmingView.bounds = CGRect(x: 0, y: 0, width: initialWidth , height: initialHeight)
            //使用 transitionCoordinator 与转场动画并行执行 dimmingView 的动画。
            presentedViewController.transitionCoordinator()?.animateAlongsideTransition({ _ in
                self.dimmingView.bounds = self.containerView!.bounds
            }, completion: nil)
        }
        //Dismissal 转场开始前该方法被调用。添加了 dimmingView 消失的动画，在上一节中并没有添加这个动画，
        //实际上由于 presentedView 的形变动画，这个动画根本不会被注意到，此处只为示范。
        override func dismissalTransitionWillBegin() {
            presentedViewController.transitionCoordinator()?.animateAlongsideTransition({ _ in
                self.dimmingView.alpha = 0.0
                }, completion: nil)
        }    
    }
`OverlayPresentationController`类接手了 dimmingView 的工作后，需要回到上一节`OverlayAnimationController`里把涉及 dimmingView 的部分删除，然后在 presentedVC 的转场代理属性`transitioningDelegate`中提供该类实例就可以实现和上一节同样的效果。

    func presentationControllerForPresentedViewController(_ presented: UIViewController, 
                                  presentingViewController presenting: UIViewController, 
                                          sourceViewController source: UIViewController) -> UIPresentationController?{
        return OverlayPresentationController(presentedViewController: presented, presentingViewController: presenting)
    }

在 iOS 7 中，Custom 模式的 Modal 转场里，presentingView 不会被移除，如果我们要移除它并妥善恢复会破坏动画控制器的独立性使得第三方动画控制器无法直接使用；在 iOS 8 中，`UIPresentationController`解决了这点，给予了我们选择的权力，通过重写下面的方法来决定 presentingView 是否在 presentation 转场结束后被移除：
	
	func shouldRemovePresentersView() -> Bool

返回 true 时，presentation 结束后 presentingView 被移除，在 dimissal 结束后 UIKit 会自动将 presentingView 恢复到原来的视图结构中。此时，Custom 模式与 FullScreen 模式下无异，完全不必理会前面 dismissal 转场部分的差异了。另外，这个方法会在实现交互控制的 Modal 转场时起到关键作用，详情请看交互转场部分。

你可能会疑惑，除了解决了 iOS 7 中无法干涉 presentingView 这个痛点外，还有什么理由值得我们使用`UIPresentationController`类？除了能与动画控制器配合，`UIPresentationController`类也能脱离动画控制器独立工作，在转场代理里我们仅仅提供后者也能对 presentedView 的外观进行定制，缺点是无法控制 presentedView 的转场动画，因为这是动画控制器的职责，这种情况下，presentedView 的转场动画采用的是默认的 Slide Up 动画效果，转场协调器实现的动画则是采用默认的动画时间。

iOS 8 带来了适应性布局，[`<UIContentContainer>`](https://developer.apple.com/library/ios/documentation/UIKit/Reference/UIContentContainer_Ref/index.html#//apple_ref/doc/uid/TP40014526)协议用于响应视图尺寸变化和屏幕旋转事件，之前用于处理屏幕旋转的方法都被废弃了。UIViewController 和 UIPresentationController 类都遵守该协议，在 Modal 转场中如果提供了后者，则由后者负责前者的尺寸变化和屏幕旋转，最终的布局机会也在后者里。在`OverlayPresentationController`中重写以下方法来调整视图布局以及应对屏幕旋转：
   
    override func containerViewWillLayoutSubviews() {
        self.dimmingView.center = self.containerView!.center
        self.dimmingView.bounds = self.containerView!.bounds
        
        let width = self.containerView!.frame.width * 2 / 3, height = self.containerView!.frame.height * 2 / 3
        self.presentedView()?.center = self.containerView!.center
        self.presentedView()?.bounds = CGRect(x: 0, y: 0, width: width, height: height)
    }

<a name="Chapter2.4"/> 
<h3 id="Chapter2.4">转场代理</h3>

完成动画控制器后，只需要在转场前设置好转场代理便能实现动画控制器中提供的效果。转场代理的实现也很简单，但是在设置代理时有不少陷阱，需要注意。

<a name="Chapter2.4.1"/> 
<h4 id="Chapter2.4.1">UINavigationControllerDelegate</h4>

定制 UINavigationController 这种容器控制器的转场时，很适合实现一个子类，自身集转场代理，动画控制器于一身，也方便使用，不过这样做有时候又限制了它的使用范围，别人也实现了自己的子类时便不能方便使用你的效果，下面的范例采取的是将转场代理封装成一个类。

    class SDENavigationControllerDelegate: NSObject, UINavigationControllerDelegate {
        //在<UINavigationControllerDelegate>对象里，实现该方法提供动画控制器，返回 nil 则使用系统默认的效果。
        func navigationController(navigationController: UINavigationController, 
             animationControllerForOperation operation: UINavigationControllerOperation, 
                             fromViewController fromVC: UIViewController, 
                                 toViewController toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
            //使用上一节实现的 Slide 动画控制器，需要提供操作类型信息。
            let transitionType = SDETransitionType.NavigationTransition(operation)
            return SlideAnimationController(type: transitionType)
        }
    }

如果你在代码里为你的控制器里这样设置代理：

    //错误的做法，delegate 是弱引用，在离开这行代码所处的方法范围后，delegate 将重新变为 nil，然后什么都不会发生。
    self.navigationController?.delegate = SDENavigationControllerDelegate()
可以使用强引用的变量来引用新实例，且不能使用本地变量，在控制器中新增一个变量来维持新实例就可以了。

    self.navigationController?.delegate = strongReferenceDelegate

解决了弱引用的问题，这行代码应该放在哪里执行呢？很多人喜欢在`viewDidLoad()`做一些配置工作，但在这里设置无法保证是有效的，因为这时候控制器可能尚未进入 NavigationController 的控制器栈，`self.navigationController`返回的可能是 nil；如果是通过代码 push 其他控制器，在 push 前设置即可；`prepareForSegue:sender:`方法是转场前更改设置的最后一次机会，可以在这里设置；保险点，使用`UINavigationController`子类，自己作为代理，省去到处设置的麻烦。

不过，通过代码设置终究显得很繁琐且不安全，在 storyboard 里设置一劳永逸：在控件库里拖拽一个 NSObject 对象到相关的 UINavigationControler 上，在控制面板里将其类别设置为`SDENavigationControllerDelegate`，然后拖拽鼠标将其设置为代理。

最后一步，像往常一样触发转场：

    self.navigationController?.pushViewController(toVC, animated: true)//or
    self.navigationController?.popViewControllerAnimated(true)
Demo 地址：[NavigationControllerTransition](https://github.com/seedante/iOS-ViewController-Transition-Demo/tree/master/NavigationControllerTransition)。

<a name="Chapter2.4.2"/> 
<h4 id="Chapter2.4.2">UITabBarControllerDelegate</h4>

同样作为容器控制器，UITabBarController 的转场代理和 UINavigationController 类似，通过类似的方法提供动画控制器，不过`<UINavigationControllerDelegate>`的代理方法里提供了操作类型，但`<UITabBarControllerDelegate>`的代理方法没有提供滑动的方向信息，需要我们来获取滑动的方向。
	
    class SDETabBarControllerDelegate: NSObject, UITabBarControllerDelegate {
        //在<UITabBarControllerDelegate>对象里，实现该方法提供动画控制器，返回 nil 则没有动画效果。
        func tabBarController(tabBarController: UITabBarController, animationControllerForTransitionFromViewController 
                                        fromVC: UIViewController, 
                         toViewController toVC: UIViewController) -> UIViewControllerAnimatedTransitioning?{
            let fromIndex = tabBarController.viewControllers!.indexOf(fromVC)!
            let toIndex = tabBarController.viewControllers!.indexOf(toVC)!
            
            let tabChangeDirection: TabOperationDirection = toIndex < fromIndex ? .Left : .Right
            let transitionType = SDETransitionType.TabTransition(tabChangeDirection)
            let slideAnimationController = SlideAnimationController(type: transitionType)
            return slideAnimationController
        }
    }
	
为 UITabBarController 设置代理的方法和陷阱与上面的 UINavigationController 类似，注意`delegate`属性的弱引用问题。点击 TabBar 的相邻页面进行切换时，将会看到 Slide 动画；通过以下代码触发转场时也将看到同样的效果：

    tabBarVC.selectedIndex = ...//or
    tabBarVC.selectedViewController = ...
Demo 地址：[ScrollTabBarController](https://github.com/seedante/iOS-ViewController-Transition-Demo/tree/master/ScrollTabBarController)。

<a name="Chapter2.4.3"/> 
<h4 id="Chapter2.4.3">UIViewControllerTransitioningDelegate</h4>

Modal 转场的代理协议`<UIViewControllerTransitioningDelegate>`是 iOS 7 新增的，其为 presentation 和 dismissal 转场分别提供了动画控制器。前面实现的`OverlayAnimationController`类可同时处理 presentation 和 dismissal 转场。`UIPresentationController`只在 iOS 8中可用，通过`available`关键字可以解决 API 的版本差异。 

    class SDEModalTransitionDelegate: NSObject, UIViewControllerTransitioningDelegate {
        func animationControllerForPresentedController(presented: UIViewController, 
                                 presentingController presenting: UIViewController, 
                                         sourceController source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
            return OverlayAnimationController()
        }
        
        func animationControllerForDismissedController(dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
            return OverlayAnimationController()
        }
        
        @available(iOS 8.0, *)
        func presentationControllerForPresentedViewController(presented: UIViewController, 
                                    presentingViewController presenting: UIViewController, 
                                            sourceViewController source: UIViewController) -> UIPresentationController? {
            return OverlayPresentationController(presentedViewController: presented, presentingViewController: presenting)
        }
    }
	
Modal 转场的代理由 presentedVC 的`transitioningDelegate`属性来提供，这与前两种容器控制器的转场不一样，不过该属性作为代理同样是弱引用，记得和前面一样需要有强引用的变量来维护该代理，而 Modal 转场需要 presentedVC 来提供转场代理的特性使得 presentedVC 自身非常适合作为自己的转场代理。另外，需要将 presentedVC 的`modalPresentationStyle`属性设置为`.Custom`或`.FullScreen`，只有这两种模式下才支持自定义转场，该属性默认值为`.FullScreen`。自定义转场时，决定转场动画效果的`modalTransitionStyle`属性将被忽略。

开启转场动画的方式依然是两种：在 storyboard 里设置 segue 并开启动画，但这里并不支持`.Custom`模式，不过还有机会挽救，转场前的最后一个环节`prepareForSegue:sender:`方法里可以动态修改`modalPresentationStyle`属性；或者全部在代码里设置，示例如下：

    let presentedVC = ...
    presentedVC.transitioningDelegate = strongReferenceSDEModalTransitionDelegate
    //当与 UIPresentationController 配合时该属性必须为.Custom。
    presentedVC.modalPresentationStyle = .Custom/.FullScreen      
    presentingVC.presentViewController(presentedVC, animated: true, completion: nil)
	
Demo 地址：[CustomModalTransition](https://github.com/seedante/iOS-ViewController-Transition-Demo/tree/master/CustomModalTransition)。


<a name="Chapter3"/> 
<h2 id="Chapter3">阶段二：交互式转场</h2>

激动人心的部分来了，好消息是交互转场的实现难度比你想象的要低。

<a name="Chapter3.1"/> 
<h3 id="Chapter3.1">实现交互化</h3>

在非交互转场的基础上将之交互化需要两个条件：

1. 由转场代理提供交互控制器，这是一个遵守`<UIViewControllerInteractiveTransitioning>`协议的对象，不过系统已经打包好了现成的类`UIPercentDrivenInteractiveTransition`供我们使用。我们不需要做任何配置，仅仅在转场代理的相应方法中提供一个该类实例便能工作。另外交互控制器必须有动画控制器才能工作。

2. 交互控制器还需要交互手段的配合，最常见的是使用手势，或是其他事件，来驱动整个转场进程。

满足以上两个条件很简单，但是很容易犯错误。

**正确地提供交互控制器**：

如果在转场代理中提供了交互控制器，而转场发生时并没有方法来驱动转场进程(比如手势)，转场过程将一直处于开始阶段无法结束，应用界面也会失去响应：在 NavigationController 中点击 NavigationBar 也能实现 pop 返回操作，但此时没有了交互手段的支持，转场过程卡壳；在 TabBarController 的代理里提供交互控制器存在同样的问题，点击 TabBar 切换页面时也没有实现交互控制。因此仅在确实处于交互状态时才提供交互控制器，可以使用一个变量来标记交互状态，该变量由交互手势来更新状态。

以为 NavigationController 提供交互控制器为例：

    class SDENavigationDelegate: NSObject, UINavigationControllerDelegate {
        var interactive = false
        let interactionController = UIPercentDrivenInteractiveTransition()
        ...
        
        func navigationController(navigationController: UINavigationController, interactionControllerForAnimationController 
                                   animationController: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
            return interactive ? self.interactionController : nil
        }
    }

TabBarController 的实现类似，Modal 转场代理分别为 presentation 和 dismissal 提供了各自的交互控制器，也需要注意上面的问题。

问题的根源是交互控制的工作机制导致的，交互过程实际上是由转场环境对象`<UIViewControllerContextTransitioning>`来管理的，它提供了如下几个方法来控制转场的进度：

    func updateInteractiveTransition(_ percentComplete: CGFloat)//更新转场进度，进度数值范围为0.0~1.0。
    func cancelInteractiveTransition()//取消转场，转场动画从当前状态返回至转场发生前的状态。
    func finishInteractiveTransition()//完成转场，转场动画从当前状态继续直至结束。

交互控制协议`<UIViewControllerInteractiveTransitioning>`只有一个必须实现的方法：

    func startInteractiveTransition(_ transitionContext: UIViewControllerContextTransitioning)
在转场代理里提供了交互控制器后，转场开始时，该方法自动被 UIKit 调用对转场环境进行配置。

系统打包好的`UIPercentDrivenInteractiveTransition`中的控制转场进度的方法与转场环境对象提供的三个方法同名，实际上只是前者调用了后者的方法而已。系统以一种解耦的方式使得动画控制器，交互控制器，转场环境对象互相协作，我们只需要使用`UIPercentDrivenInteractiveTransition`的三个同名方法来控制进度就够了。如果你要实现自己的交互控制器，而不是`UIPercentDrivenInteractiveTransition`的子类，就需要调用转场环境的三个方法来控制进度，压轴环节我们将示范如何做。

交互控制器控制转场的过程就像将动画控制器实现的动画制作成一部视频，我们使用手势或是其他方法来控制转场动画的播放，可以前进，后退，继续或者停止。`finishInteractiveTransition()`方法被调用后，转场动画从当前的状态将继续进行直到动画结束，转场完成；`cancelInteractiveTransition()`被调用后，转场动画从当前的状态回拨到初始状态，转场取消。

在 NavigationController 中点击 NavigationBar 的 backBarButtomItem 执行 pop 操作时，由于我们无法介入 backBarButtomItem 的内部流程，就失去控制进度的手段，于是转场过程只有一个开始，永远不会结束。其实我们只需要有能够执行上述几个方法的手段就可以对转场动画进行控制，用户与屏幕的交互手段里，手势是实现这个控制过程的天然手段，我猜这是其被称为交互控制器的原因。

**交互手段的配合**：

下面使用演示如何利用屏幕边缘滑动手势`UIScreenEdgePanGestureRecognizer`在 NavigationController 中控制 Slide 动画控制器提供的动画来实现右滑返回的效果，该手势绑定的动作方法如下：

    func handleEdgePanGesture(gesture: UIScreenEdgePanGestureRecognizer){
        //根据移动距离计算交互过程的进度。
        let percent = ...
        switch gesture.state{
        case .Began:
            //转场开始前获取代理，一旦转场开始，VC 将脱离控制器栈，此后 self.navigationController 返回的是 nil。
            self.navigationDelegate = self.navigationController?.delegate as? SDENavigationDelegate
            //更新交互状态
            self.navigationDelegate?.interactive = true
            //1.交互控制器没有 start 之类的方法，当下面这行代码执行后，转场开始；
            //如果转场代理提供了交互控制器，它将从这时候开始接管转场过程。
            self.navigationController?.popViewControllerAnimated(true)
        case .Changed:
            //2.更新进度：
            self.navigationDelegate?.interactionController.updateInteractiveTransition(percent)
        case .Cancelled, .Ended:
            //3.结束转场：
            if percent > 0.5{
                //完成转场。
                self.navigationDelegate?.interactionController.finishInteractiveTransition()
            }else{
                //或者，取消转场。
                self.navigationDelegate?.interactionController.cancelInteractiveTransition()
            }
            //无论转场的结果如何，恢复为非交互状态。
            self.navigationDelegate?.interactive = false
        default: self.navigationDelegate?.interactive = false
        }
    }

交互转场的流程就是三处数字标记的代码。不管是什么交互方式，使用什么转场方式，都是在使用这三个方法控制转场的进度。**对于交互式转场，交互手段只是表现形式，本质是驱动转场进程。**很希望能够看到更新颖的交互手法，比如通过点击页面不同区域来控制一套复杂的流程动画。

TabBarController 的 Demo 中也实现了滑动切换 Tab 页面，代码是类似的，就不占篇幅了；示范的 Modal 转场我没有为之实现交互控制，原因也提到过了，没有比较合乎操作直觉的交互手段，不过真要为其添加交互控制，代码和上面是类似的。[修正]由于我没有为本文 Modal 转场的示例实现交互控制，而且没有对 presentingView 添加动画，因此漏掉了一个大坑。这个坑就是在 Custom 模式下交互控制无法控制 presentingView 上的动画，感谢简书@1269 发现并找到了解决办法。此大坑请看[特殊的 Modal 转场交互化](#Chapter3.3)。

到此为止，一个完整的交互转场动画就完成了，在转场代理中提供一个`UIPercentDrivenInteractiveTransition`实例对象外加实现手势的响应办法就够了，这里不涉及任何动画。

转场交互化后结果有两种：完成和取消。取消后动画将会原路返回到初始状态，但已经变化了的数据怎么恢复？

一种情况是，控制器的系统属性，比如，在 TabBarController 里使用上面的方法实现滑动切换 Tab 页面，中途取消的话，已经变化的`selectedIndex`属性该怎么恢复为原值；上面的代码里，取消转场的代码执行后，`self.navigationController`返回的依然还是是 nil，怎么让控制器回到 NavigationController 的控制器栈顶。对于这种情况，UIKit 自动替我们恢复了，不需要我们操心(可能你都没有意识到这回事)；

另外一种就是，转场发生的过程中，你可能想实现某些效果，一般是在下面的事件中执行，转场中途取消的话可能需要取消这些效果。

    func viewWillAppear(_ animated: Bool)
    func viewDidAppear(_ animated: Bool)
    func viewWillDisappear(_ animated: Bool)
    func viewDidDisappear(_ animated: Bool)
交互转场介入后，视图在这些状态间的转换变得复杂，WWDC 上苹果的工程师还表示转场过程中 view 的`Will`系方法和`Did`系方法的执行顺序并不能得到保证，虽然几率很小，但如果你依赖于这些方法执行的顺序的话就可能需要注意这点。而且，`Did`系方法调用时并不意味着转场过程真的结束了。另外，fromView 和 toView 之间的这几种方法的相对顺序更加混乱，具体的案例可以参考这里：[The Inconsistent Order of View Transition Events](http://wangling.me/2014/02/the-inconsistent-order-of-view-transition-events.html)。

如何在转场过程中的任意阶段中断时取消不需要的效果？这时候该转场协调器(Transition Coordinator)再次出场了。

<a name="Chapter3.2"/> 
<h3 id="Chapter3.2">Transition Coordinator</h3>

转场协调器(Transition Coordinator)的出场机会不多，但却是关键先生。Modal
转场中，`UIPresentationController`类只能通过转场协调器来与动画控制器同步，并行执行其他动画；这里它可以在交互式转场结束时执行一个闭包：

    func notifyWhenInteractionEndsUsingBlock(_ handler: (UIViewControllerTransitionCoordinatorContext) -> Void)
当转场由交互状态转变为非交互状态(在手势交互过程中则为手势结束时)，无论转场的结果是完成还是被取消，该方法都会被调用；得益于闭包，转场协调器可以在转场过程中的任意阶段搜集动作并在交互中止后执行。闭包中的参数是一个遵守`<UIViewControllerTransitionCoordinatorContext>`协议的对象，该对象由 UIKit 提供，和前面的转场环境对象`<UIViewControllerContextTransitioning>`作用类似，它提供了交互转场的状态信息。

    override func viewWillAppear(animated: Bool) {
        super.viewWillDisappear(animated)
        self.doSomeSideEffectsAssumingViewDidAppearIsGoingToBeCalled()
        //只在处于交互转场过程中才可能取消效果。
        if let coordinator = self.transitionCoordinator() where coordinator.initiallyInteractive() == true{
            coordinator.notifyWhenInteractionEndsUsingBlock({
                interactionContext in
                if interactionContext.isCancelled(){
                    self.undoSideEffects()
                }
            })
        }
    }

不过交互状态结束时并非转场过程的终点(此后动画控制器提供的转场动画根据交互结束时的状态继续或是返回到初始状态)，而是由动画控制器来结束这一切：

	optional func animationEnded(_ transitionCompleted: Bool)
如果实现了该方法，将在转场动画结束后调用。@liwenDeng 发现这个方法在 UITabBarController 的转场结束后被调用了两次，检查函数调用帧栈后猜测是 UIKit 的内部实现问题，尚无解决办法。

UIViewController 可以通过`transitionCoordinator()`获取转场协调器，该方法的文档中说只有在 Modal 转场过程中，该方法才返回一个与当前转场相关的有效对象。实际上，NavigationController 的转场中 fromVC 和 toVC 也能返回一个有效对象，TabBarController 有点特殊，fromVC 和 toVC 在转场中返回的是 nil，但是作为容器的 TabBarController 可以使用该方法返回一个有效对象。

转场协调器除了上面的两种关键作用外，也在 iOS 8 中的适应性布局中担任重要角色，可以查看[`<UIContentContainer>`](https://developer.apple.com/library/ios/documentation/UIKit/Reference/UIContentContainer_Ref/index.html#//apple_ref/doc/uid/TP40014526)协议中的方法，其中响应尺寸和屏幕旋转事件的方法都包含一个转场协调器对象，视图的这种变化也被系统视为广义上的 transition，参数中的转场协调器也由 UIKit 提供。这个话题有点超出本文的范围，就不深入了，有需要的话可以查看文档和相关 session。

<a name="Chapter3.3"/> 
<h3 id="Chapter3.3">特殊的 Modal 转场交互化</h3>

Modal 转场真是麻烦啊。此坑的具体表现是 Custom 模式下交互控制时无法控制 presentingView 上添加的动画。至于原因，首先你得知道是交互控制的机制，本来实现转场也不需要了解这方面的知识，但是有此坑，不得不讲一下，交互控制的关键在于 CALayer 和CAMediaTiming 协议，如果你有兴趣，可以阅读[自定义容器控制器转场](#Chapter5.2)这个章节。这种控制视图动画进度的手段适用于视图及其子视图，这样为转场实现交互化的时候只需要控制 containerView 即可，而从 [Modal 转场的差异](#Chapter2.3.1)可以知道，presentingView 并非 containerView 的子视图，两者是同层次的视图。因此 Modal 转场交互化无法控制 presentingView 上的动画，等等，FullScreen 模式下没有问题呀，细说的话，FullScreen 模式下 presentation 转场与 Custom 模式有着同样的困境，FullScreen 模式在 dismissal 转场下则不存在这个问题，想想为什么。对此，我的猜测是 FullScreen 模式下交互控制针对的是 presentingView 和 containerView 的父系视图或者对两者同时进行了交互控制，从解决手法看后者的可能性大一些。在 Custom 模式下，UIKit 又对 presengtingView 撒手不管了，怎么办？

感谢简书@1269 找到了解决的办法，具体可参考此处[简书评论](http://www.jianshu.com/p/9333c5f983de/comments/1889234#comment-1889234)。以下是解决办法：

在 iOS 8 以上的系统里，转场时通过提供`UIPresentationController`类并重写以下方法并返回`true`可以解决上述问题：

    func shouldRemovePresentersView() -> Bool

`UIPresentationController`类的作用可参考前面 [iOS 8 的改进：UIPresentationController](#Chapter2.3.3) 一节。注意，`UIPresentationController`参与转场并没有改变 presentingView 与 containerView 的层次关系，能够修复这个问题我猜测是重写的该方法返回`true`后交互转场控制同时对这两个视图进行了控制而非对两者的父系视图进行控制，因为这个方法返回`false`时不起作用。

那 iOS 8 以下的系统怎么办？最好的办法是转场时不要对 presentingView 添加动画，不是开玩笑，我觉得 Modal 转场的视觉风格在 presentingView 上添加动画没有什么必要，不过，真要这样做还是得解决不是。在 [Modal 转场的差异](#Chapter2.3.1)里我尝试了在  Custom 模式来下模拟 FullScreen 模式，就是在动画控制器里用变量维护 presentingView 的父视图，剩下的部分和通用的动画控制器没有区别，将 presentingView 加入到 containerView，只是在转场结束后将 presentingView 恢复到原来的视图结构里。这样，交互控制就能控制 presentingView 上的动画了。如果你要在 Custom 模式下第三方的动画控制器，这些动画控制器都需要调整，代价不小。

Modal 转场 Custom 模式下用于交互化的的动画控制器：

    func animateTransition(transitionContext: UIViewControllerContextTransitioning) {            
        ...
        
        //处理 Presentation 转场：
        if toVC.isBeingPresented(){
            //这个非常关键，而由谁来维持这个父视图呢，看看动画控制器以及转场代理的关系就知道这是个很麻烦的事情。
            presentingSuperview = fromView.superview
            //1:将 presentingView 加入到 containerView 下，这样 presentation 转场时也能控制 presentingView 上的动画
            fromView.removeFromSuperview()
            containerView.addSubview(fromView)
            containerView.addSubview(toView)               
            
            UIView.animateWithDuration(duration, delay: 0, options: .CurveEaseInOut, animations: {
                      /*动画代码*/
                }, completion: {_ in
                    //2：照旧
                    let isCancelled = transitionContext.transitionWasCancelled()
                    transitionContext.completeTransition(!isCancelled)
            })
        }
        //处理 Dismissal 转场：
        if fromVC.isBeingDismissed(){
            //如果在 presentation 转场里已经将 presentingView 添加到 containerView 里了，这里没必要再加一次了。
            UIView.animateWithDuration(duration, animations: {
                /*动画代码*/
                }, completion: { _ in
                    //2：照旧
                    let isCancelled = transitionContext.transitionWasCancelled()
                    transitionContext.completeTransition(!isCancelled)
                    
                    //最后一步：恢复 presentingView 到原来的视图结构里。在 FullScreen 模式下，UIKit 会自动做这件事，可以省去这一步。
                    toView.removeFromSuperview()
                    presentingSuperview.addSubview(toView)
            })
        }
    }


<a name="Chapter3.4"/> 
<h3 id="Chapter3.4">封装交互控制器</h3>

`UIPercentDrivenInteractiveTransition`类是一个系统提供的交互控制器，在转场代理的相关方法里提供一个该类实例就够了，还有其他需求的话可以实现其子类来完成，那这里的封装是指什么？系统把交互控制器打包好了，但是交互控制器工作还需要其他的配置。程序员向来很懒，能够自动完成的事绝不肯写一行代码，写一行代码就能搞定的事绝不写第二行，所谓少写一行是一行。能不能顺便把交互控制器的配置也打包好省得写代码啊？当然可以。

热门转场动画库 [VCTransitionsLibrary](https://github.com/ColinEberhardt/VCTransitionsLibrary#using-an-interaction-controller) 封装好了多种动画效果，并且自动支持 pop, dismissal 和 tab change 等操作的手势交互，其手法是在转场代理里为 toVC 添加手势并绑定相应的处理方法。

为何没有支持 push 和 presentation 这两种转场？因为 push 和 presentation 这两种转场需要提供 toVC，而库并没有 toVC 的信息，这需要作为使用者的开发者来提供；对于逆操作的 pop 和 dismiss，toVC 的信息已经存在了，所以能够实现自动支持。而 TabBarController 则是个例外，它是在已知的子 VC 之间切换，不存在这个问题。需要注意的是，库这样封装了交互控制器后，那么你将无法再让同一种手势支持 push 或 presentation，要么只支持单向的转场，要么你自己实现双向的转场。当然，如果知道 toVC 是什么类的话，你可以改写这个库让 push 和 present 得到支持。不过，对于在初始化时需要配置额外信息的类，这种简单的封装可能不起作用。[VCTransitionsLibrary](https://github.com/ColinEberhardt/VCTransitionsLibrary#using-an-interaction-controller) 库还支持添加自定义的简化版的动画控制器和交互控制器，在封装和灵活之间的平衡控制得很好，代码非常值得学习。

只要愿意，我们还可以变得更懒，不，是效率更高。[FDFullscreenPopGesture](https://github.com/forkingdog/FDFullscreenPopGesture.git) 通过 category 的方法让所有的 UINavigationController 都支持右滑返回，而且，一行代码都不用写，这是配套的博客：[一个丝滑的全屏滑动返回手势](http://blog.sunnyxx.com/2015/06/07/fullscreen-pop-gesture/)。那么也可以实现一个类似的 FullScreenTabScrollGesture 让所有的 UITabBarController 都支持滑动切换，不过，UITabBar 上的 icon 渐变动画有点麻烦，因为其中的 UITabBarItem 并非 UIView 子类，无法进行动画。[WXTabBarController](https://github.com/leichunfeng/WXTabBarController.git) 这个项目完整地实现了微信界面的滑动交互以及 TabBar 的渐变动画。不过，它的滑动交互并不是使用转场的方式完成的，而是使用 UIScrollView，好处是兼容性更好。兼容性这方面国内的环境比较差，iOS 9 都出来了，可能还需要兼容 iOS 6，而自定义转场需要至少 iOS 7 的系统。该项目实现的 TabBar 渐变动画是基于 TabBar 的内部结构实时更新相关视图的 alpha 值来实现的(不是UIView 动画），这点非常难得，而且使用 UIScrollView 还可以实现自动控制 TabBar 渐变动画，相比之下，使用转场的方式来实现这个效果会麻烦一点。

一个较好的转场方式需要顾及更多方面的细节，NavigationController 的 NavigationBar 和 TabBarController 的 TabBar 这两者在先天上有着诸多不足需要花费更多的精力去完善，本文就不在这方面深入了，上面提及的几个开源项目都做得比较好，推荐学习。

<a name="Chapter3.5"/> 
<h3 id="Chapter3.5">交互转场的限制</h3>

如果希望转场中的动画能完美地被交互控制，必须满足2个隐性条件：

1. 使用 UIView 动画的 API。你当然也可以使用 Core Animation 来实现动画，甚至，这种动画可以被交互控制，但是当交互中止时，会出现一些意外情况：如果你正确地用 Core Animation 的方式复现了 UIView 动画的效果(不仅仅是动画，还包括动画结束后的处理)，那么手势结束后，动画将直接跳转到最终状态；而更多的一种状况是，你并没有正确地复现 UIView 动画的效果，手势结束后动画会停留在手势中止时的状态，界面失去响应。使用 Core Animation 实现完美的交互控制也是可以的，详见压轴环节的自定义容器控制器转场，只不过你需要处理很多细节问题，而 UIView 动画 API 作为对 Core Animation 的高级封装，替我们省去了不少麻烦的细节，显著降低了交互转场动画的实现成本，所以官方 Session 里提到必须使用 UIView 动画 API。
2. 在动画控制器的`animateTransition:`中提交动画。问题和第1点类似，在`viewWillDisappear:`这样的方法中提交的动画也能被交互控制，但交互停止时，立即跳转到最终状态。

如果你希望制作多阶段动画，在某个动画结束后再执行另外一段动画，可以通过 UIView Block Animation 的 completion 闭包来实现动画链，或者是通过设定动画执行的延迟时间使得不同动画错分开来，但是交互转场不支持这两种形式。UIView 的 keyFrame Animation API 可以帮助你，通过在动画过程的不同时间节点添加关键帧动画就可以实现多阶段动画。我实现过一个这样的多阶段转场动画，Demo 在此：[CollectionViewAlbumTransition](https://github.com/seedante/SDECollectionViewAlbumTransition.git)。

<a name="Chapter4"/> 
<h2 id="Chapter4">插曲：UICollectionViewController 布局转场</h2>

与三大主流转场不同，布局转场只针对 CollectionViewController 搭配 NavigationController 的组合，且是作用于布局，而非视图。采用这种布局转场时，NavigationController 将会用布局变化的动画来替代 push 和 pop 的默认动画。苹果自家的照片应用中的「照片」Tab 页面使用了这个技术：在「年度-精选-时刻」几个时间模式间切换时，CollectionViewController 在 push 或 pop 时尽力维持在同一个元素的位置同时进行布局转换。

布局转场的实现比三大主流转场要简单得多，只需要满足四个条件：NavigationController + CollectionViewController, 且要求后者都拥有相同数据源， 并且开启`useLayoutToLayoutNavigationTransitions`属性为真。

    let cvc0 = UICollectionViewController(collectionViewLayout: layout0)
    //作为 root VC 的 cvc0 的该属性必须为 false，该属性默认为 false。
    cvc0.useLayoutToLayoutNavigationTransitions = false
    let nav = UINavigationController(rootViewController: cvc0)
    //cvc0, cvc1, cvc2 必须具有相同的数据，如果在某个时刻修改了其中的一个数据源，其他的数据源必须同步，不然会出错。
    let cvc1 = UICollectionViewController(collectionViewLayout: layout1)
    cvc1.useLayoutToLayoutNavigationTransitions = true
    nav.pushViewController(cvc1, animated: true)
    
    let cvc2 = UICollectionViewController(collectionViewLayout: layout2)
    cvc2.useLayoutToLayoutNavigationTransitions = true
    nav.pushViewController(cvc2, animated: true)
    
    nav.popViewControllerAnimated(true)
    nav.popViewControllerAnimated(true)
	
Push 进入控制器栈后，不能更改`useLayoutToLayoutNavigationTransitions`的值，否则应用会崩溃。当 CollectionView 的数据源(section 和 cell 的数量)不完全一致时，push 和 pop 时依然会有布局转场动画，但是当 pop 回到 rootVC 时，应用会崩溃。可否共享数据源保持同步来克服这个缺点？测试表明，这样做可能会造成画面上的残缺，以及不稳定，建议不要这么做。
	
此外，iOS 7 支持 UICollectionView 布局的交互转换(Layout Interactive Transition)，过程与控制器的交互转场(ViewController Interactive Transition)类似，这个功能和布局转场(CollectionViewController Layout Transition)容易混淆，前者是在自身布局转换的基础上实现了交互控制，后者是 CollectionViewController 与 NavigationController 结合后在转场的同时进行布局转换。感兴趣的话可以看[这个功能的文档](https://developer.apple.com/library/ios/documentation/UIKit/Reference/UICollectionView_class/index.html#//apple_ref/occ/instm/UICollectionView/startInteractiveTransitionToCollectionViewLayout:completion:)。

布局转场不支持交互控制。Demo 地址：[CollectionViewControllerLayoutTransition](https://github.com/seedante/iOS-ViewController-Transition-Demo/tree/master/CollectionViewControllerLayoutTransition)。

有人告诉我使用这个布局转场无法达到官方应用里「年度-精选-时刻」里转场的效果，我发现这是苹果又把好东西自己偷着用而只公开一个阉割版本的 API。到底怎么回事？「照片」应用在这个转场里使用了弹簧动画效果，实际上这是对动画的时间曲线进行了设置，但是没有公开的接口，我们使用的这个布局转场的时间曲线是线性的，呈现出来的效果却差了不少。要实现官方的原生效果，还是要在 NavigationController 里自定义转场来控制时间曲线，也就是要使用弹簧动画。

UICollectionView 使用下面的方法对布局的切换添加动画：

    func setCollectionViewLayout(_ layout: UICollectionViewLayout, animated animated: Bool)
    
非常幸运的是，这个方法能够在 UIView Animation 下使用，不然，你要重写整个布局动画。接下来的问题是怎么利用普通的 NavigationController 转场来重现布局转场。大体思路是：toCollectionViewController 以 fromCollectionViewController 的布局初始化，并且调整其下 toCollectionView 可视区域与 fromCollectionView 一致，在转场里执行布局切换的动画。还有一个问题是，怎么调整可视区域一致？这个其实不复杂，调整`contentOffset`属性即可，这是 UIScrollView 的特性。

    //确保 toCollectionVC 的布局和数据源和 fromColletionVC 一致。
    let toCollectionVC = ...  
    //设置 contentOffset 使得两者的可视区域一致。      
    toCollectionVC.collectionView?.contentOffset = (fromCollectionVC.collectionView?.contentOffset)!
    //必须有这行代码，它的作用是强制 toCollectionView 刷新内容，使得上面的代码生效。
    toCollectionVC.collectionView?.layoutIfNeeded()
    //一切准备妥当，Push!
    fromCollectionVC.navigationController?.pushViewController(toCollectionVC, animated: true)

在动画控制器里：

    func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
        let containerView = transitionContext.containerView()
        let toCollectionVC = transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey) as! UICollectionViewController
        
        containerView?.addSubview(toCollectionVC.view)
        //这个弹簧动画其实做不到官方的效果，因为这是个残缺的 API，恩，官方放出的阉割版。
        //iOS 9 里才推出了完整版的弹簧动画的 API，CASpringAnimation，而且是个 Core Animation API，连文档都没有这个类的描述。
        //即使使用了 CASpringAnimation 这个完整版的 API，参数的设置也是很麻烦的事情，你得先去温习高中物理知识。
        UIView.animateWithDuration(1, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 10, options: UIViewAnimationOptions.CurveEaseIn, animations: {
            //这里只示范了 Push 操作。
            if self.operation == .Push{
                ...
                toCollectionVC.collectionView?.setCollectionViewLayout(finalLayout, animated: true)
            }
            
            }, completion: {_ in
                transitionContext.completeTransition(!transitionContext.transitionWasCancelled())
        })
    }

<a name="Chapter5"/> 
<h2 id="Chapter5">进阶</h2>

尽管我在前面做出了解释，你是否依然嫌弃本文中示范的动画效果太过简单并且对我的解释表示怀疑？再次表示，「在动画控制器里，参与转场的视图只有 fromView 和 toView 之分，与转场方式无关。」所有的转场动画里转场的部分都相差无几，能不能写出炫酷的转场动画就看你能不能写出那样炫酷的动画了。因此，学习了前面的内容后并不能帮助你立马就能够实现 Github 上那些热门的转场动画，它们成为热门的原因在于动画本身，与转场本身关系不大，但它们与转场结合后就有了神奇的力量。那学习了作为进阶的本章能立马实现那些热门的转场效果吗？有可能，有些效果其实很简单，一点就透，还有一些效果涉及的技术属于本文主题之外的内容，我会给出相关的提示就不深入了。

本章的进阶分为两个部分：

1. 案例分析：动画的方式非常多，有些并不常见，有些只是简单到令人惊讶的组合，只是你不曾了解过所以不知道如何实现，一旦了解了就不再是难事。尽管这些动画本身并不属于转场技术这个主题，但与转场结合后往往有着惊艳的视觉效果，这部分将提供一些实现此类转场动画的思路，技巧和工具来扩展视野。有很多动画类型我也没有尝试过，可能的话我会继续更新一些有意思的案例。
2. 自定义容器转场：官方支持四种方式的转场，而且这些也足以应付绝大多数需求了，但依然有些地方无法顾及。本文一直通过探索转场的边界的方式来总结使用方法以及陷阱，在本文的压轴部分，我们将挣脱系统的束缚来实现自定义容器控制器的转场效果。

<a name="Chapter5.1"/> 
<h3 id="Chapter5.1">案例分析</h3>

动画的持续时间一般不超过0.5秒，稍纵即逝，有时候看到一个复杂的转场动画也不容易知道实现的方式，我一般是通过逐帧解析的手法来分析实现的手段：开源的就运行一下，使用系统自带的 QuickPlayer 对 iOS 设备进行录屏，再用 QuickPlayer 打开视频，按下 cmd+T 打开剪辑功能，这时候就能查看每一帧了；Gif 等格式的原型动画的动图就直接使用系统自带的 Preview 打开看中间帧。

<a name="Chapter5.1.1"/> 
<h4 id="Chapter5.1.1">子元素动画</h4>

当转场动画涉及视图中的子视图时，往往无法依赖第三方的动画库来实现，你必须为这种效果单独定制，神奇移动就是一个典型的例子。神奇移动是 Keynote 中的一个动画效果，如果某个元素在连续的两页 Keynote 同时存在，在页面切换时，该元素从上一页的位置移动到下一页的位置，非常神奇。在转场中怎么实现这个效果呢？最简单的方法是截图配合移动动画：伪造那个元素的视图添加到 containerView 中，从 fromView 中的位置移动到 toView 中的位置，这期间 fromView 和 toView 中的该元素视图隐藏，等到移动结束恢复 toView 中该元素的显示，并将伪造的元素视图从 containerView 中移除。

UIView 有几个`convert`方法用于在不同的视图之间转换坐标：

    func convertPoint(_ point: CGPoint, toView view: UIView?) -> CGPoint
    func convertPoint(_ point: CGPoint, fromView view: UIView?) -> CGPoint
    func convertPoint(_ point: CGPoint, fromView view: UIView?) -> CGPoint
    func convertPoint(_ point: CGPoint, fromView view: UIView?) -> CGPoint

对截图这个需求，iOS 7 提供了趁手的工具，UIView Snapshot API：

    func snapshotViewAfterScreenUpdates(_ afterUpdates: Bool) -> UIView
    //获取视图的部分内容
    func resizableSnapshotViewFromRect(_ rect: CGRect, afterScreenUpdates afterUpdates: Bool, withCapInsets capInsets: UIEdgeInsets) -> UIView

当`afterScreenUpdates`参数值为`true`时，这两个方法能够强制视图立刻更新内容，同时返回更新后的视图内容。在 push 或 presentation 中，如果 toVC 是 CollectionViewController 并且需要对 visibleCells 进行动画，此时动画控制器里是无法获取到的，因为此时 collectionView 还未向数据源询问内容，执行此方法后能够达成目的。UIView 的`layoutIfNeeded()`也能要求立即刷新布局达到同样的效果。

<a name="Chapter5.1.2"/> 
<h4 id="Chapter5.1.2">Mask 动画</h4>

![MaskAnimtion](https://github.com/seedante/iOS-ViewController-Transition-Demo/blob/master/Figures/MaskAnimtion.gif?raw=true)

左边的动画教程：[How To Make A View Controller Transition Animation Like in the Ping App](http://www.raywenderlich.com/86521/how-to-make-a-view-controller-transition-animation-like-in-the-ping-app)；右边动画的开源地址：[BubbleTransition](https://github.com/andreamazz/BubbleTransition.git)。

Mask 动画往往在视觉上令人印象深刻，这种动画通过使用一种特定形状的图形作为 mask 截取当前视图内容，使得当前视图只表现出 mask 图形部分的内容，在 PS 界俗称「遮罩」。UIView 有个属性`maskView`可以用来遮挡部分内容，但这里的效果并不是对`maskView`的利用；CALayer 有个对应的属性`mask`，而 CAShapeLayer 这个子类搭配 UIBezierPath 类可以实现各种不规则图形。这种动画一般就是 mask + CAShapeLayer + UIBezierPath 的组合拳搞定的，实际上实现这种圆形的形变是很简单的，只要发挥你的想象力，可以实现任何形状的形变动画。

这类转场动画在转场过程中对 toView 使用 mask 动画，不过，右边的这个动画实际上并不是上面的组合来完成的，它的真相是这样：

![Truth behind BubbleTransition](https://github.com/seedante/iOS-ViewController-Transition-Demo/blob/master/Figures/Truth%20behind%20BubbleTransition.gif?raw=true)

这个开发者实在是太天才了，这个手法本身就是对 mask 概念的应用，效果卓越，但方法却简单到难以置信。关于使用 mask + CAShapeLayer + UIBezierPath 这种方法实现 mask 动画的方法请看我的[这篇文章](http://www.jianshu.com/p/3c925a1609f8)。

<a name="Chapter5.1.3"/> 
<h4 id="Chapter5.1.3">高性能动画框架</h4>

有些动画使用 UIView 的动画 API 难以实现，或者难以达到较好的性能，又或者两者皆有，幸好我们还有其他选择。[StartWar](https://yalantis.com/blog/uidynamics-uikit-or-opengl-3-types-of-ios-animations-for-the-star-wars/) 使用更底层的 OpenGL 框架来解决性能问题以及 Objc.io 在探讨转场这个话题时[使用 GPUImage 定制动画](http://objccn.io/issue-5-3/)都是这类的典范。在交互控制器章节中提到过，官方只能对 UIView 动画 API 实现的转场动画实施完美的交互控制，这也不是绝对的，接下来我们就来挑战这个难题。

<a name="Chapter5.2"/> 
<h3 id="Chapter5.2">自定义容器控制器转场</h3>

压轴环节我们将实现这样一个效果：

![ButtonTransition](https://github.com/seedante/iOS-ViewController-Transition-Demo/blob/master/Figures/CustomContainerVCButtonTransition.gif?raw=true)
![ContainerVC Interacitve Transition](https://github.com/seedante/iOS-ViewController-Transition-Demo/blob/master/Figures/ContainerVCTransition.mov.gif?raw=true)

Demo 地址：[CustomContainerVCTransition](https://github.com/seedante/iOS-ViewController-Transition-Demo/tree/master/CustomContainerVCTransition)。

分析一下思路，这个控制器和 UITabBarController 在行为上比较相似，只是 TabBar 由下面跑到了上面。我们可以使用 UITabBarController 子类，然后打造一个伪 TabBar 放在顶部，原来的 TabBar 则隐藏，行为上完全一致，使用 UITabBarController 子类的好处是可以减轻实现转场的负担，不过，有时候这样的子类不是你想要的，UIViewController 子类能够提供更多的自由度，好吧，一个完全模仿 UITabBarController 行为的 UIViewController 子类，实际上我没有想到非得这样做的原因，但我想肯定有需要定制自己的容器控制器的场景，这正是本节要探讨的。Objc.io 也讨论过[这个话题](http://objccn.io/issue-12-3/)，文章的末尾把实现交互控制当做作业留了下来。珠玉在前，我就站在大牛的肩上继续这个话题吧。Objc.io 的这篇文章写得较早使用了 Objective-C 语言，如果要读者先去读这篇文章再继续读本节的内容，难免割裂，所以本节还是从头讨论这个话题吧，最终效果如上面所示，在自定义的容器控制器中实现交互控制切换子视图，也可以通过填充了 UIButton 的 ButtonTabBar 来实现 TabBar 一样行为的 Tab 切换，在通过手势切换页面时 ButtonTabBar 会实现渐变色动画。ButtonTabBar 有很大扩展性，改造或是替换为其他视图还是有很多应用场景的。

这章剩下的内容绝大多数人用不上，而且很占篇幅，我放到另外一个页面去了，如有兴趣，请来这里阅读：[自定义容器控制器转场](https://github.com/seedante/iOS-Note/wiki/Custom-Container-View-Controller-Transition)。

<a name="Chapter6"/> 
<h2 id="Chapter6">尾声：转场动画的设计</h2>

虽然我不是设计师，但还是想在结束之前聊一聊我对转场动画设计的看法。动画的使用无疑能够提升应用的体验，但仅限于使用了合适的动画。

除了一些加载动画可以炫酷华丽极尽炫技之能事，绝大部分的日常操作并不适合使用过于炫酷或复杂的动画，比如 [VCTransitionsLibrary](https://github.com/ColinEberhardt/VCTransitionsLibrary#using-an-interaction-controller) 这个库里的大部分效果。该库提供了多达10种转场效果，从技术上讲，大部分效果都是针对 transform 进行动画，如果你对这些感兴趣或是恰好有这方面的使用需求，可以学习这些效果的实现，从代码角度看，封装技巧也很值得学习，这个库是学习转场动画的极佳范例；不过从使用效果上看，这个库提供的效果像 PPT 里提供的动画效果一样，绝大部分都应该避免在日常操作中使用。不过作为开发者，我们应该知道技术实现的手段，即使这些效果并不适合在绝大部分场景中使用。

场景转换的目的是过渡到下一个场景，在操作频繁的日常场景中使用复杂的过场动画容易造成视觉疲劳，这种情景下使用简单的动画即可，实现起来非常简单，更多的工作往往是怎么把它们与其他特性更好地结合起来，正如 [FDFullscreenPopGesture](https://github.com/forkingdog/FDFullscreenPopGesture.git) 做的那样。除了日常操作，也会遇到一些特殊的场景需要定制复杂的转场动画，这种复杂除了动画效果本身的复杂，这需要掌握相应的动画手段，也可能涉及转场过程的配合，这需要对转场机制比较熟悉。比如 [StarWars](https://github.com/Yalantis/StarWars.iOS)，这个转场动画在视觉上极其惊艳，一出场便获得上千星星的青睐，它有贴合星战内涵的创意设计和惊艳的视觉表现，以及优秀的性能优化，如果要评选年度转场动画甚至是史上最佳，我会投票给它；而我在本文里实现的范例，从动画效果来讲，都是很简单的，可以预见本文无法吸引大众的转发，压轴环节里的自定义容器控制器转场也是如此，但是后者需要熟知转场机制才能实现。从这点来看，转场动画在实际使用中走向两个极端：日常场景中的转场动画十分简单，实现难度很低；特定场景的转场动画可能非常复杂，不过实现难度并不能一概而论，正如我在案例分析一节里指出的几个案例那样。

希望本文能帮助你。






