---
layout:     post
title:      "7. Swift 构造和析构"
subtitle:   "Swift"
date:       2018-06-24 22:00:00
author:     "FishYan"
header-img: "img/blog-header.png" 
catalog:    true
tags:
    - iOS
    - Swift
---

在类，结构体，枚举的使用之前必须要进行构造过程，其中类需要通过析构过程来释放资源，结构体和枚举不需要。swift 的构造过程和 OC 的构造过程又有一些不同，swift 的构造过程不需要返回值。

## 构造器

构造器的一般形式
```Swift
init() {
    // 在此处执行构造过程
}
```

### 1.默认构造器

如果结构体和类所有属性都具有默认值，同时没有自定义构造器，那么系统将提供一个默认构造器来进行初始化工作。

```swift
// 类的默认构造器
class ShoppingListItem {
    var name: String?
    var quantity = 1
    var purchased = false
}
var item = ShoppingListItem()

// 结构体的逐一成员构造器
struct Size {
    var width = 0.0, height = 0.0
}
let twoByTwo = Size(width: 2.0, height: 2.0)
```

### 2.自定义构造器

swift 中自定义构造器要比 oc 中方便，不需要返回值。

```swift
// 类
class ShoppingListItem {
    var name: String?
    var quantity = 1
    var purchased = false
    init(name: String, quantity: Int, purchased: Bool = false) {
        //...
    }
}
var item = ShoppingListItem(name: "baihe", quantity: 3)

// 结构体
struct Size {
    var width = 0.0, height = 0.0
    init(width: Float, height: Float = 0.0) {
        //...
    }
}
let twoByTwo = Size(width: 10, height: 10)

```

### 3.指定构造器(designated)、便利构造器(convenience)、必要构造器(required)

**指定构造器(designated):**

指定构造器默认不带关键字，一个类或结构体中可以有一个或多个指定构造器。并且在指定构造器中需要保证所有未初始化的属性都要初始化。

**便利构造器(convenience):**

便利构造器是作为指定构造器的补充，为使用提供方便。在构造器前加上 ```conveniece``` 关键字，便利构造器不能被子类重写或者 super 的形式调用，

**必要构造器(required):**

必要构造器在构造器前加 ```required```关键字，表明此构造器子类必须实现。

### 4.构造器代理

构造器代理可以使用其他的构造器来完成自身的部分构造过程。其中类实现构造器代理必须采用便利构造器的形式。

```swift
// 类
class ShoppingListItem {
    var name: String?
    var quantity = 1
    var purchased = false

    init(name: String) {

    }

    convenience init(name: String, quantity: Int, purchased: Bool = false) {
        self.init(name: name)
        //
    }
}
var item = ShoppingListItem(name: "baihe", quantity: 3)

// 结构体
struct Size {
    var width = 0.0, height = 0.0
    init(width: Float) {
        
    }
    init(width: Float, height: Float = 0.0) {
        self.init(width: width)
        //...
    }
}
let twoByTwo = Size(width: 10, height: 10)

```

为了简化指定构造器和便利构造器之间的调用关系，Swift 采用以下三条规则来限制构造器之间的代理调用：

- 规则 1 ：指定构造器必须调用其直接父类的的指定构造器。

- 规则 2 ：便利构造器必须调用同类中定义的其它构造器。

- 规则 3 ：便利构造器必须最终导致一个指定构造器被调用。


### 5.构造器的继承和重写

结构体不能被继承，只有类才可以被继承，这是类与结构体差别中的一点。

子类在没有自己的构造器的情况下，将自动继承父类所有的构造器方法。

子类在实现自己的构造器或者继承父类构造器的时候需要调用父类的指定构造器，并且默认不会继承父类的构造器，这可以防止子类错误的使用父类的构造器创建一个不完整的实例。

子类在继承或者重写父类构造器时，都需要加上```override```关键字。override修饰符会让编译器去检查父类中是否有相匹配的指定构造器，并验证构造器参数是否正确。

同时，上面提到便利构造器不能被重写，即使在子类中写了一个和父类便利构造器一样的方法，这个方法也是只属于这个子类，而不是重写父类的方法，因此方法前面不要加 ```override```。

```swift
// 类
class SubShoppingListItem: ShoppingListItem {
    override init(name: String) {
        super.init(name: name)
    }

    init(name: String, quantity: Int, purchased: Bool = false) {
        super.init(name: name)
    }
}
```

## 析构

通常 swift 采用自动引用计数（ARC），释放资源的时候是不需要我们手动去清理内存。但是还有一些特殊的情况需要我们在释放资源的时候去清理内存，比如常见的通知的创建，都知道通知创建后不会自动释放，需要我们在合适的时机手动释放掉通知的资源。

swift 中的析构器：
```swift
deinit {
    // 执行析构操作
}
```