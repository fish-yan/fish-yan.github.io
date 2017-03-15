---
layout:     post
title:      "iOS 9 学习系列: Touch ID"
subtitle:   "iOS 9 学习系列"
date:       2016-06-22 22:00:00
author:     "FishYan"
header-img: "img/blog-header.png" 
catalog:    true
tags:
    - iOS
    - iOS 9 新特性
---

Touch ID的用法基于一个名为Local Authentication的新框架，这里不打算深入谈论它，因为你可以在苹果官方文档和WWDC session video找到更多的相关信息。此外，我的目的是演示在实际开发中如何使用它。然而，有一点是必须的，那就是当Touch ID将要用于一款应用程序时，该框架几乎要处理所有的事情。该框架提供了一个默认的视图，用来告知用户将一个手指放到iPhone的按钮上进行扫描。如果扫描失败或者用户不想使用扫描，框架允许开发者为用户提供自定义的视图来验证，并且提供一个使用应用的代替方案。该框架也允许开发则设定一个自定义的字符串描述，用于表明请求验证通过的原因。此外，它支持一系列的错误类型，这些错误都能给出错误的原因，并能给出选项供开发者在每一种情况下做出处理。错误类型是用枚举实现的：
```swift
enum LAError : Int { 
	case AuthenticationFailed 
	case UserCancel 
	case UserFallback 
	case SystemCancel 
	case PasscodeNotSet 
	case TouchIDNotAvailable 
	case TouchIDNotEnrolled
}
```
解释:

- AuthenticationFailed: 在用户没有提供正确验证的情况下返回该错误类型 例如使用一个错误的手指。
- UserCancel:在用户有意终止验证的时候返回该类型。
- UserFallback：在用户有意不使用TouchID验证并且回到自定义的输入验证方式时返回。
- SystemCancel：在这种情况下，系统终止验证处理，因为另一个应用被激活了。
- PasscodeNotSet：当用户没有在设备Settings中设定密码时返回。- TouchIDNotAvailable：设备不支持TouchID。
- TouchIDNotEnrolled：在设备支持TouchID但没有录入指纹的时候返回。

下面就做一个最简单的touchID验证跳转到下一页的test，先放上[Demo](https://github.com/fish-yan/testTouchID)

TouchID用到一个LAContext类，但事实上这个类开放的接口很少。有两个方法和两个枚举值，都需要用到
```swift
//这两个枚举的区别是第一个在没有正确验证的时候出现的输入密码的时候回跳转到与指纹相对应的密码的界面（系统的）
//第二个枚举会跳转到自定义的界面，跳转事件通过错误类型来执行
enum LAPolicy : Int {
    case DeviceOwnerAuthenticationWithBiometrics
    case DeviceOwnerAuthentication
}

//错误类型，我就不多做解释了，Demo里有。
enum LAError : Int {
    case AuthenticationFailed
    case UserCancel
    case UserFallback
    case SystemCancel
    case PasscodeNotSet
    case TouchIDNotAvailable
    case TouchIDNotEnrolled
    case TouchIDLockout
    case AppCancel
    case InvalidContext
}

//判断当前设备是否可以指纹识别，LAPolicy就是上面的枚举值
func canEvaluatePolicy(_ policy: LAPolicy,
                 error error: NSErrorPointer) -> Bool
//指纹识别，LAPolicy就是上面的枚举值，localizedReason是副标题说明，主标题为“你的app的名字+的TouchID”这个不能自定义           
func evaluatePolicy(_ policy: LAPolicy,
    localizedReason localizedReason: String,
              reply reply: (Bool,
                             NSError?) -> Void)
```
还有一个在API文档里没有，但是也会用到的属性
```swift
//是验证失败的时候弹出的alertView另外一个button的title（在验证之前弹出的alertView只有一个取消按钮的），默认为 “输入密码”
localizedFallbackTitle
```
TouchID的验证是以闭包的形式，需要注意的是，在闭包中所有关于界面的操作都需要回到主线程中进行，要不会有明显的 卡顿现象。
不多说了，上代码：
```swift
 @IBAction func nextPageAction(sender: AnyObject) {
        let context = LAContext()
        context.localizedFallbackTitle = "输入密码"//默认
        var error: NSError?
        let reasonString = "需要指纹认证进入下一页"
        if context.canEvaluatePolicy(.DeviceOwnerAuthenticationWithBiometrics, error: &error) {
            context.evaluatePolicy(.DeviceOwnerAuthenticationWithBiometrics, localizedReason: reasonString, reply: { (success: Bool, error:NSError?) in
                if success {
                    NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
                        self.performSegueWithIdentifier("next", sender: nil)
                    })
                }else{
                    switch error!.code {
                    case LAError.SystemCancel.rawValue:
                        print("系统取消指纹认证")
                    case LAError.UserCancel.rawValue:
                        print("用户取消指纹认证")
                        NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
                            self.showPasswordAlert()
                        })
                    case LAError.UserFallback.rawValue:
                        print("输入密码")
                        NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
                            self.showPasswordAlert()
                        })
                    case LAError.PasscodeNotSet.rawValue:
                        print("没有设置密码")
                    case LAError.TouchIDNotEnrolled.rawValue:
                        print("没有设置touchID")
                    case LAError.TouchIDLockout.rawValue:
                        print("touchID被锁定")
                    case LAError.AppCancel.rawValue:
                        print("应用取消")
                    case LAError.InvalidContext.rawValue:
                        print("无效")
                    case LAError.TouchIDNotAvailable.rawValue:
                        print("touchID不可用")
                    case LAError.AuthenticationFailed.rawValue:
                        print("没有正确验证")
                        
                    default:
                        print("Authentication failed")
                        NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
                            self.showPasswordAlert()
                        })
                    }
                }
                
            })
        }
    }
    
    func showPasswordAlert() {
        let alert = UIAlertController(title: "提示", message: "输入数字密码", preferredStyle: .Alert)
        let action = UIAlertAction(title: "确定", style: .Default, handler: { (alertAction:UIAlertAction) in
            self.performSegueWithIdentifier("next", sender: nil)
        })
        let action1 = UIAlertAction(title: "取消", style: .Cancel, handler: nil)
        alert.addTextFieldWithConfigurationHandler { (text:UITextField) in
            
        }
        alert.addAction(action)
        alert.addAction(action1)
        presentViewController(alert, animated: true, completion: nil)
    }
```

通过验证后才能进入下一页，只能在真机上运行，别问我为什么。

上个图看看效果

![这里写图片描述](http://img.blog.csdn.net/20160612193656594)