---
layout:     post
title:      "Android"
subtitle:   "Android学习"
date:       2020-06-22 22:00:00
author:     "FishYan"
header-img: "img/blog-header.png" 
catalog:    true

---

# Android 学习

## 创建工程
- MainActivity 默认主Activity 可在清单文件中修改
- activity_main.xml 布局文件
- AndroidManifest.xml 清单文件
  
## AndroidManifest 清单文件
- 应用的软件包名称，其通常与代码的命名空间相匹配。 构建项目时，Android 构建工具会使用此信息来确定代码实体的位置。 打包应用时，构建工具会使用 Gradle 构建文件中的应用 ID 来替换此值，而此 ID 则用作系统和 Google Play 上的唯一应用标识符。
- 应用的组件，包括所有 Activity、服务、广播接收器和内容提供程序。 每个组件都必须定义基本属性，例如其 Kotlin 或 Java 类的名称。 清单文件还能声明一些功能，例如其所能处理的设备配置，以及描述组件如何启动的 Intent 过滤器。
- 应用为访问系统或其他应用的受保护部分所需的权限。 如果其他应用想要访问此应用的内容，则清单文件还会声明其必须拥有的权限。
- 应用需要的硬件和软件功能，这些功能会影响哪些设备能够从 Google Play 安装应用。