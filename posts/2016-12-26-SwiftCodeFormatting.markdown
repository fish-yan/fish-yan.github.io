---
layout:     post
title:      "Swift编程规范之 Code Formatting"
subtitle:   "Swift"
date:       2016-12-26 22:00:00
author:     "FishYan"
header-img: "img/blog-header.png" 
catalog:    true
tags:
    - iOS
    - Swift
---

# Swift编程规范之 Code Formatting

## Code Formatting:代码格式化

- 1 使用4个空格来代替Tabs

- 2 避免过长的行，可以在XCode中进行设置单行最大长度：(Xcode->Preferences->Text Editing->Page guide at column: 160 is helpful for this)

- 3 保证每个文件结尾都存在一个新行 Ensure that there is a newline at the end of every file.

- 4 避免无意义的尾随空格: (Xcode->Preferences->Text Editing->Automatically trim trailing whitespace + Including whitespace-only lines).

- 5 避免将单独的左花括号放置到一行，我们参考了：1TBS style。
```swift
class SomeClass {
    func someMethod() {
        if x == y {
            /* ... */
        } else if x == z {
            /* ... */
        } else {
            /* ... */
        }
    }
    /* ... */
}
```
- 6 在写变量的类型声明、字典类型的键、函数参数、协议的声明或者父类的时候，不要在冒号前添加空格。

```swift
// specifying type
let pirateViewController: PirateViewController
// dictionary syntax (note that we left-align as opposed to aligning colons)
let ninjaDictionary: [String: AnyObject] = [
    "fightLikeDairyFarmer": false,
    "disgusting": true
]
// declaring a function
func myFunction<t, u: someprotocol where t.relatedtype == u>(firstArgument: U, secondArgument: T) {
    /* ... */
}
// calling a function
someFunction(someArgument: "Kitten")
// superclasses
class PirateViewController: UIViewController {
    /* ... */
}
// protocols
extension PirateViewController: UITableViewDataSource {
    /* ... */
}</t, u: someprotocol where t.relatedtype == u>
```
- 7 一般来说，逗号后面都要跟随一个空格。

```swift
let myArray = [1, 2, 3, 4, 5]
```
- 8 在二元操作符譬如+, ==, 或者 ->的前后需要加上空格，但是对于( 、`)的前后不需要加空格。

```swift
let myValue = 20 + (30 / 2) * 3
if 1 + 1 == 3 {
    fatalError("The universe is broken.")
}
func pancake() -> Pancake {
    /* ... */
}
```
- 9 我们默认使用Xcode推荐的格式化风格(CTRL-I) ，在声明某个函数的时候会多行排布参数。

```swift
ode indentation for a function declaration that spans multiple lines
func myFunctionWithManyParameters(parameterOne: String,
                                  parameterTwo: String,
                                  parameterThree: String) {
    // Xcode indents to here for this kind of statement
    print("\(parameterOne) \(parameterTwo) \(parameterThree)")
}
// Xcode indentation for a multi-line `if` statement
if myFirstVariable > (mySecondVariable + myThirdVariable)
    && myFourthVariable == .SomeEnumValue {
    // Xcode indents to here for this kind of statement
    print("Hello, World!")
}
```
- 10 在调用多参数函数的时候，会把多个参数放置到单独的行中：
```swift
someFunctionWithManyArguments(
    firstArgument: "Hello, I am a string",
    secondArgument: resultFromSomeFunction()
    thirdArgument: someOtherLocalVariable)
```
- 11 对于大型的数组或者字典类型，应该将其分割到多行内，[ 与 ]类比于花括号进行处理。对于闭包而言也应该同样适合于该规则。

```swift
someFunctionWithABunchOfArguments(
    someStringArgument: "hello I am a string",
    someArrayArgument: [
        "dadada daaaa daaaa dadada daaaa daaaa dadada daaaa daaaa",
        "string one is crazy - what is it thinking?"
    ],
    someDictionaryArgument: [
        "dictionary key 1": "some value 1, but also some more text here",
        "dictionary key 2": "some value 2"
    ],
    someClosure: { parameter1 in
        print(parameter1)
    })
```
- 12 尽可能地使用本地变量的方式来避免多行的判断语句。

```swift
// PREFERRED
let firstCondition = x == firstReallyReallyLongPredicateFunction()
let secondCondition = y == secondReallyReallyLongPredicateFunction()
let thirdCondition = z == thirdReallyReallyLongPredicateFunction()
if firstCondition && secondCondition && thirdCondition {
    // do something
}
// NOT PREFERRED
if x == firstReallyReallyLongPredicateFunction()
    && y == secondReallyReallyLongPredicateFunction()
    && z == thirdReallyReallyLongPredicateFunction() {
    // do something
}
```