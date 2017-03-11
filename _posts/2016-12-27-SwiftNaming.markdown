---
layout:     post
title:      "Swift编程规范之 Naming"
subtitle:   "Swift"
date:       2016-12-27 22:00:00
author:     "FishYan"
header-img: "img/blog-header.png"
tags:
    - iOS
    - Swift
---


- 1 Swift中不需要再使用Objective-C那样的前缀，譬如使用 GuybrushThreepwood 而不是LIGuybrushThreepwood。

- 2 对于类型名即struct, enum, class, typedef, associatedtype等等使用 PascalCase 。

 -3 对于函数名、方法名、变量名、常量、参数名等使用camelCase。

- 4 在使用首字母缩写的时候尽可能地全部大写，并且注意保证全部代码中的统一。不过如果缩写被用于命名的起始，那么就全部小写。

```swift
// "HTML" is at the start of a variable name, so we use lowercase "html"
let htmlBodyContent: String = "<p>Hello, World!</p>"
// Prefer using ID to Id
let profileID: Int = 1
// Prefer URLFinder to UrlFinder
class URLFinder {
    /* ... */
}
```
- 5 对于静态常量使用 k 前缀 + PascalCase。

```swift
class MyClassName {
    // use `k` prefix for constant primitives
    static let kSomeConstantHeight: CGFloat = 80.0
    // use `k` prefix for non-primitives as well
    static let kDeleteButtonColor = UIColor.redColor()
    // don't use `k` prefix for singletons
    static let sharedInstance = MyClassName()
    /* ... */
}
```
- 6 对于泛型或者关联类型，使用PascalCase描述泛型，如果泛型名与其他重复，那么可以添加一个Type后缀名到泛型名上。
```swift
class SomeClass<t> { /* ... */ }
class SomeClass<model> { /* ... */ }
protocol Modelable {
    associatedtype Model
}
protocol Sequence {
    associatedtype IteratorType: Iterator
}</model></t>
```
- 7 命名必须要是不模糊的并且方便表述的
```swift
// PREFERRED
class RoundAnimatingButton: UIButton { /* ... */ }
// NOT PREFERRED
class CustomButton: UIButton { /* ... */ }
```
- 8 不要使用缩写，可以选择较为简短的单词。

```swift
// PREFERRED
class RoundAnimatingButton: UIButton {
    let animationDuration: NSTimeInterval
    func startAnimating() {
        let firstSubview = subviews.first
    }
}
// NOT PREFERRED
class RoundAnimating: UIButton {
    let aniDur: NSTimeInterval
    func srtAnmating() {
        let v = subviews.first
    }
}
```
- 9 对于不是很明显的类型需要将类型信息包含在属性名中。

```swift
// PREFERRED
class ConnectionTableViewCell: UITableViewCell {
    let personImageView: UIImageView
    let animationDuration: NSTimeInterval
    // it is ok not to include string in the ivar name here because it's obvious
    // that it's a string from the property name
    let firstName: String
    // though not preferred, it is OK to use `Controller` instead of `ViewController`
    let popupController: UIViewController
    let popupViewController: UIViewController
    // when working with a subclass of `UIViewController` such as a table view
    // controller, collection view controller, split view controller, etc.,
    // fully indicate the type in the name.
    let popupTableViewController: UITableViewController
    // when working with outlets, make sure to specify the outlet type in the
    // variable name.
    @IBOutlet weak var submitButton: UIButton!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var nameLabel: UILabel!
}
// NOT PREFERRED
class ConnectionTableViewCell: UITableViewCell {
    // this isn't a `UIImage`, so shouldn't be called image
    // use personImageView instead
    let personImage: UIImageView
    // this isn't a `String`, so it should be `textLabel`
    let text: UILabel
    // `animation` is not clearly a time interval
    // use `animationDuration` or `animationTimeInterval` instead
    let animation: NSTimeInterval
    // this is not obviously a `String`
    // use `transitionText` or `transitionString` instead
    let transition: String
    // this is a view controller - not a view
    let popupView: UIViewController
    // as mentioned previously, we don't want to use abbreviations, so don't use
    // `VC` instead of `ViewController`
    let popupVC: UIViewController
    // even though this is still technically a `UIViewController`, this variable
    // should indicate that we are working with a *Table* View Controller
    let popupViewController: UITableViewController
    // for the sake of consistency, we should put the type name at the end of the
    // variable name and not at the start
    @IBOutlet weak var btnSubmit: UIButton!
    @IBOutlet weak var buttonSubmit: UIButton!
    // we should always have a type in the variable name when dealing with outlets
    // for example, here, we should have `firstNameLabel` instead
    @IBOutlet weak var firstName: UILabel!
}
```
- 10 在编写函数参数的时候，要保证每个参数都易于理解其功能。

- 11 根据 Apple's API Design Guidelines, 对于protocol，如果其描述的是正在做的事情，譬如Collection，那么应该命名为名词。而如果是用于描述某种能力，譬如Equatable, ProgressReporting，那么应该添加 able, ible, 或者 ing 这样的后缀。如果你的协议并不符合上述两种情形，那么应该直接添加一个Protocol后缀，譬如：

```swift
// here, the name is a noun that describes what the protocol does
protocol TableViewSectionProvider {
    func rowHeight(atRow row: Int) -> CGFloat
    var numberOfRows: Int { get }
    /* ... */
}
// here, the protocol is a capability, and we name it appropriately
protocol Loggable {
    func logCurrentState()
    /* ... */
}
// suppose we have an `InputTextView` class, but we also want a protocol
// to generalize some of the functionality - it might be appropriate to
// use the `Protocol` suffix here
protocol InputTextViewProtocol {
    func sendTrackingEvent()
    func inputText() -> String
    /* ... */
}
```