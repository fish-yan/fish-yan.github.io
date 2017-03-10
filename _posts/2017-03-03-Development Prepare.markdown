---
layout:     post
title:      "1.2 UWP 应用开发准备篇 "
subtitle:   " UWP 是 Universal Windows Platform 的简写，即通用 Windows 平台。"
date:       2017-03-03 22:00:00
author:     "FishYan"
header-img: "img/blog-header.png"
tags:
    - UWP
    - Visual Sutdio 2017
---

## 1. 工具

- 一台装有 Windows 10 的电脑

- Visual Studio 2015 或者 Visual Sutdio 2017（ is coming on March 7 ）

- Windows Mobile Phone （可选）

## 2. 安装

**Windows 10 升级或安装**
 
[下载 Windows 10 ](https://www.microsoft.com/zh-cn/software-download/windows10ISO)

 Windows 10 的升级和安装这里不做介绍，相信大家都会装。不会的自己去搜教程。（哈哈...）

**Visual Studio 2015 安装**

[下载 Visual Studio 2015 ](https://www.visualstudio.com/downloads/)

1. 点击上面链接下载你需要的版本，大概就几兆。不要高兴，那只是个下载器，安装方式为在线安装，你也可以选择镜像安装。

2. 打开下载的安装工具（vs_community_CHS.exe）我下载的是社区版，免费。

3. 安装 Visual Studio 2015

    3.1 默认安装

    如果是第一次安装就不要折腾了，直接选择默认就好。

    ![安装类型](/Users/xueyan/Desktop/IC844317.png)

    3.2 自定义组件的完整列表如下所示：

   - **编程语言**
        * Visual C++ 编译器、库和工具
       * Visual F#
       * Visual Studio 的 Python 工具
   - **Windows 和 Web 开发**
       * ClickOnce 发布工具
       * Microsoft SQL Server Data Tools
       * Microsoft Web 开发人员工具
       * Visual Studio 的 PowerShell 工具
       * Silverlight 开发工具包
       * 通用 Windows 应用开发工具
       * Windows 10 工具和 SDK
       * Windows 8.1 和 Windows Phone 8.0/8.1 工具
       * Windows 8.1 工具和 SDK
   - **跨平台移动开发**
       * Xamarin (C#/.NET)
       * Apache Cordova (HTML/JavaScript)
       * 适用于 iOS/Android 的 Visual C++ 移动开发
   - **常用工具和 SDK**
       * Android 本机开发工具包（R10E，32 位）
       * Android SDK
       * Android SDK 安装程序（API 级别 19 和 21）
       * Android SDK 安装程序（API 级别 22）
       * Apache Ant (1.9.3)
       * Java SE 开发工具包 (7.0.550.13)
       * Joyent Node.js
   - **常用工具**
       * 用于 Windows 的 Git
       * Visual Studio 的 GitHub 扩展
       * Visual Studio 扩展性工具

    3.3 镜像安装

    - 下载 Visual Studio 进行脱机安装

    - 在多数情况下，你可以顺利地从下载站点安装 Visual Studio。 但是，在某些情况下，你可能希望在安装之前下载所有更新包（例如，在多台计算机或在脱机计算机上安装）。 下列步骤说明如何下载脱机安装所需的所有更新包。

    - 从 MSDN 网站将更新可执行文件下载到你文件系统中的某个位置后，请在命令提示符处执行以下命令：```<executable name> /layout```。

    - 此命令将下载用于安装的所有包。

    - 通过使用 ```/layout``` 开关，你可以下载几乎所有核心安装包，而不仅仅是下载适用于下载计算机的安装包。 此方法可为你提供在任何地方运行此更新所需的所有文件，如果你想安装原来没有安装的组件，这种方法可能会很有用。

    - 运行该命令后，系统会提示你指定下载位置。 输入位置，然后选择“下载”。

    - 当包下载成功时，你应会看到一个 Visual Studio 屏幕，其中显示安装成功!已成功获取所有指定组件。

    - 在指定的文件位置中，查找可执行文件和包文件夹。 这是需要复制到共享位置或安装媒体上的所有内容。

    > 目前，Android SDK 不支持脱机安装体验。 如果在未连接到 Internet 的计算机上安装 Android SDK 安装程序项，则安装可能失败。

    - 你现在可以从该文件位置或安装媒体运行安装。

## 3 配置

使用开发人员功能

必须先在你的电脑上启用开发人员模式，然后才可以在 Visual Studio 中打开 UWP 应用项目。 如果打开 UWP 项目，但未启用开发人员模式，“面向开发人员”设置页会自动打开。 按照下一部分中的说明操作，启用开发人员模式。

- 在要启用的设备上，转到“设置”。 依次选择“更新和安全”和“对于开发人员”。

- 选择所需的访问级别 - 若要开发 UWP 应用，请选择“开发人员模式”。

- 阅读所选设置的免责声明，然后单击“是”以接受更改。

桌面设置

![PC端设置](/Users/xueyan/Desktop/devmode-pc-options.png)

手机设置

![手机设置](/Users/xueyan/Desktop/devmode-mob.png)

部署 Windows 10 应用

使用 Windows 10 应用程序部署 (WinAppDeployCmd) 工具。 了解有关 [WinAppDeployCmd](http://msdn.microsoft.com/library/windows/apps/mt203806.aspx) 工具的详细信息。

*[了解更详细的配置内容](https://docs.microsoft.com/zh-cn/windows/uwp/get-started/enable-your-device-for-development)*

    