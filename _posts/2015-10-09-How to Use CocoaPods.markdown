---
layout:     post
title:      " CocoaPods 安装和使用教程"
subtitle:   " CocoaPods 是一款特别好用的第三方SDK管理工具，如果还没有开始使用的童鞋，一定要赶紧用起来了。"
date:       2015-10-09 22:00:00
author:     "FishYan"
header-img: "img/blog-header.png" 
catalog:    true
tags:
    - iOS
    - CocoaPods
    - iOS 开发工具
---

> 在网上看到有很多cocoapods的安装使用教程,但是写的时间都比较久远了,有部分不太完美,这些只是把网络上的收集整理简化一下,只要按照步骤操作,就能成功安装cocoapods;祝大家安装成功!

# 1. CocoaPods 的安装

## 步骤1 － 安装 RVM
```RVM``` 是干什么的这里就不解释了，后面你将会慢慢搞明白。

```
$ curl -L https://get.rvm.io | bash -s stable
```

期间可能会问你sudo管理员密码，以及自动通过homebrew安装依赖包，等待一段时间后就可以成功安装好 RVM。

然后，载入 RVM 环境
```
$ source ~/.rvm/scripts/rvm
```
很快,不显示任何变化

检查一下是否安装正确
```
$ rvm -v
```
会输出以下信息
```
rvm 1.26.11 (latest) by Wayne E. Seguin 
<wayneeseguin@gmail.com>, Michal Papis <mpapis@gmail.com> [https://rvm.io/]
```

## 步骤2 － 用 RVM 安装 Ruby 环境

```
$ rvm install 2.0.0
```
同样继续等待漫长的下载，编译过程，完成以后，Ruby, Ruby Gems 就安装好了。
漫长,漫长……

## 步骤3 － 设置 Ruby 版本

RVM 装好以后，需要执行下面的命令将指定版本的 Ruby 设置为系统默认版本
```
$ rvm 2.0.0 --default
```
同样，也可以用其他版本号，前提是你有用 rvm install 安装过那个版本
这个时候你可以测试是否正确
```
$ ruby -v
```
输出以下信息
```
ruby 2.0.0p643 (2015-02-25 revision 49749) [x86_64-darwin14.1.0]
```
```
$ gem -v
```

## 步骤4 － 安装 CocoaPods

如果你在天朝，在终端中敲入这个命令之后，会发现半天没有任何反应。原因无他，因为那堵墙阻挡了```cocoapods.org```
所以要更换一下镜像,用淘宝的镜像;
注意:以前的 ```http://ruby.taobao.org/```已经失效,需要在 ```http``` 后加上 ```s```
移除原始镜像
```
$ gem source -r https://rubygems.org/
```
安装淘宝镜像
```
$ gem source -a https://ruby.taobao.org
```
为了验证你的Ruby镜像是并且仅是taobao，可以用以下命令查看：
```
$ gem sources 
```
只有在终端中出现下面文字才表明你上面的命令是成功的：
```
*** CURRENT SOURCES ***
https://ruby.taobao.org/
```
然后输入以下命令进行安装 ```CocoaPods```
```
$ sudo gem install cocoapods
```
*-*-*-*到这里 CocoaPods 就安装完成了*-*-*-*

在安装过程中可能会出现安装失败的情况,不要担心,多试几遍就OK了/微笑


# 第二部分: CocoaPods 的使用

## 场景1:利用 CocoaPods, 在项目中导入第三方类库;

以导入 AFNetWorking 为例;
AFNetworking 类库在 [GitHub地址](https://github.com/AFNetworking/AFNetworking)



最近朋友要学cocapods就简单做了一个cocoapods的使用教程,有兴趣可以下载下来看一下,有点大.

[百度云](http://pan.baidu.com/s/1pJw4rSv)

先创建工程

在工程的更目录下创建 Podfile 空白文件 (也就是跟***.xcodeproj文件在同一个文件夹)


两种创建方法

1.用 vim 创建

在终端输入以下代码
```
vim Podfile
```
在 vim 中输入以下内容:
```
platform :iOS, '7.0'
pod "AFNetworking", "~> 2.0"
```
这些内容不是乱编出来的,在 github 上的 AFNetWorking 上都能找到,意思是 iOS 版本要求7.0以上, AFNetworking 版本是2.0

完成以后输入: wq 保存并退出,(如果左下角显示 INSIRD, 则需要先按 ESC 在输入命令)

这时候就会发现在工程文件夹中多出一个 Podfile 的文件;并且内容是上面显示的内容

2.用终端直接创建

在终端输入
```
touch Podfile
```
手动在工程所在的文件夹中找到 Podfile, 打开并输入以下内容
```
platform :ios, '7.0'
pod "AFNetworking", "~> 2.0"
```
保存并退出

下载并导入 AFNetWorking

在终端中输入以下命令
```
Pod install  
```
等待片刻~~

安装完成

注意:文件名不能错,并且一个工程中只需要一个 Podfile

找到工程文件打开***.xcworkspace ,并不是打开原来的***.xcodeproj

再打开工程的时候就会发现,工程中多了好多文件,

其中有两个target 一个是原来的 target 另一个是 Pods

第三方文件就放在 Pods target下的Pods 文件夹下

他会把第三方用到的库文件,以及其他的配置都帮你配置好,自己只需要用就可以了,
注意:在导入头文件时用导入系统头文件的方式导入(```#import <>```)


场景2:使用包含 CocoaPods类库的项目

这个一般情况遇不到,只有你下载的项目你叫老,他用的第三方版本更新,PodFile 文件过期的时候才回出现报错,一般都没有问题.

这个也比较简单,

首先也是跳转到工程所在的目录

输入以下命令
```
Pod update
```
等待结束重新运行工程就 OK 了

<<<<<<< HEAD
ranhou ock
=======
testbbbb
>>>>>>> 89e7b0db62b45234fe7530e7da6f4128751e32aa
