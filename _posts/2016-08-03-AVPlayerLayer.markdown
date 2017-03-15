---
layout:     post
title:      "iOS 动画 Animation-0-4：CALayer十则示例-AVPlayerLayer"
subtitle:   "iOS 动画 Animation"
date:       2016-08-03 22:00:00
author:     "FishYan"
header-img: "img/blog-header.png" 
catalog:    true
tags:
    - iOS
    - iOS 动画
---

## AVPlayerLayer

AVPlayerLayer是建立在AVFoundation基础上的实用图层，持有一个AVPlayer，用来播放音视频媒体文件（AVPlayerItems），举例如下：
```swift
override func viewDidLoad() {
  super.viewDidLoad()
  // 1
  let playerLayer = AVPlayerLayer()
  playerLayer.frame = someView.bounds
  
  // 2
  let url = NSBundle.mainBundle().URLForResource("someVideo", withExtension: "m4v")
  let player = AVPlayer(URL: url)
  
  // 3
  player.actionAtItemEnd = .None
  playerLayer.player = player
  someView.layer.addSublayer(playerLayer)
  
  // 4
  NSNotificationCenter.defaultCenter().addObserver(self, selector: "playerDidReachEndNotificationHandler:", name: "AVPlayerItemDidPlayToEndTimeNotification", object: player.currentItem)
}
  
deinit {
  NSNotificationCenter.defaultCenter().removeObserver(self)
}
  
// 5
@IBAction func playButtonTapped(sender: UIButton) {
  if playButton.titleLabel?.text == "Play" {
    player.play()
    playButton.setTitle("Pause", forState: .Normal)
  } else {
    player.pause()
    playButton.setTitle("Play", forState: .Normal)
  }
  
  updatePlayButtonTitle()
  updateRateSegmentedControl()
}
  
// 6
func playerDidReachEndNotificationHandler(notification: NSNotification) {
  let playerItem = notification.object as AVPlayerItem
  playerItem.seekToTime(kCMTimeZero)
}
```
上述代码解释：

- 新建一个播放器图层，设置框架。
- 使用AV asset资源创建一个播放器。
- 告知命令播放器在播放完成后停止。其他选项还有暂停或自动播放下一个媒体资源。
- 注册AVPlayer通知，在一个文件播放完毕后发送通知，并在析构函数中删除作为观察者的控制器。
- 点击播放按钮时，触发控件播放AV asset并设置按钮文字。

注意这只是个入门示例，在实际项目中往往不会采用文字按钮控制播放。

AVPlayerLayer和其中创建的AVPlayer会像这样显示为AVPlayerItem实例的第一帧：

![](http://cc.cocimg.com/api/uploads/20150317/1426582828870290.png)

AVPlayerLayer还有一些附加属性：

- videoGravity设置视频显示的缩放行为。
- readyForDisplay检测是否准备好播放视频。

另一方面，AVPlayer也有不少附加属性和方法，有一个值得注意的是rate属性，对于0到1之间的播放速率，0代表暂停，1代表常速播放（1x）。

不过rate属性的设置是与播放行为联动的，也就是说调用pause()方法和把rate设为0是等价的，调用play()与把rate设为1也一样。

那快进、慢动作和反向播放呢？交给AVPlayerLayer把。rate大于1时会令播放器以相应倍速进行播放，例如rate设为2就是二倍速。

如你所想，rate为负时会让播放器以相应倍速反向播放。

然而，在以非常规速率播放之前，AVPlayerItem上会调用适当方法，验证是否能够以相应速率进行播放：
```
canPlayFastForward()对应大于1
canPlaySlowForward()对应0到1之间
canPlayReverse()对应-1
canPlaySlowReverse()对应-1到0之间
canPlayFastReverse()对应小于-1
```
绝大多数视频都支持以不同速率正向播放，可以反向播放的视频相对少一些。演示应用也包含了播放控件：

![](http://cc.cocimg.com/api/uploads/20150317/1426582797327830.png)
