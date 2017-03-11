---
layout:     post
title:      "Swift编程规范之 Coding Style"
subtitle:   "Swift"
date:       2016-12-28 22:00:00
author:     "FishYan"
header-img: "img/blog-header.png"
tags:
    - iOS
    - Swift
---

Coding Style

## 1 General

- 1.1 尽可能地使用let来代替var。

- 1.2 尽可能地使用 map, filter, reduce的组合来进行集合的转换等操作，并且尽可能地避免使用带有副作用的闭包。

```swift
// PREFERRED
let stringOfInts = [1, 2, 3].flatMap { String($0) }
// ["1", "2", "3"]
// NOT PREFERRED
var stringOfInts: [String] = []
for integer in [1, 2, 3] {
    stringOfInts.append(String(integer))
}
// PREFERRED
let evenNumbers = [4, 8, 15, 16, 23, 42].filter { $0 % 2 == 0 }
// [4, 8, 16, 42]
// NOT PREFERRED
var evenNumbers: [Int] = []
for integer in [4, 8, 15, 16, 23, 42] {
    if integer % 2 == 0 {
        evenNumbers(integer)
    }
}
```
- 1.3 尽可能地显式声明不方便进行类型推测的变量或者常量的类型名。

- 1.4 如果你的函数需要返回多个参数，那么尽可能地使用Tuple来代替inout参数。如果你会多次使用某个元组，那么应该使用typealias设置别名。如果返回的参数超过三个，那么应该使用结构体或者类来替代。

```swift
func pirateName() -> (firstName: String, lastName: String) {
    return ("Guybrush", "Threepwood")
}
let name = pirateName()
let firstName = name.firstName
let lastName = name.lastName
```
- 1.5 在创建delegates/protocols的时候需要小心所谓的保留环(retain cycles)，这些属性需要被声明为weak。

- 1.6 在闭包中直接调用self可能会导致保留环，可以使用capture list 在这种情况下:

```swift
myFunctionWithClosure() { [weak self] (error) -> Void in
    // you can do this
    self?.doSomething()
    // or you can do this
    guard let strongSelf = self else {
        return
    }
    strongSelf.doSomething()
}
```
- 1.7 不要使用 labeled breaks。

- 1.8 不要在控制流逻辑判断的时候加上圆括号

```swift
// PREFERRED
if x == y {
    /* ... */
}
// NOT PREFERRED
if (x == y) {
    /* ... */
}
```
- 1.9 避免在使用enum的时候写出全名

```swift
// PREFERRED
imageView.setImageWithURL(url, type: .person)
// NOT PREFERRED
imageView.setImageWithURL(url, type: AsyncImageView.Type.person)
```
- 1.10 在写类方法的时候不能用简短写法，应该使用类名.方法名，这样能够保证代码的可读性

```swift
// PREFERRED
imageView.backgroundColor = UIColor.whiteColor()
// NOT PREFERRED
imageView.backgroundColor = .whiteColor()
```
- 1.11 在非必要的时候不要写self.。

- 1.12 在编写某个方法的时候注意考虑下这个方法是否有可能被复写，如果不可能被复写那么应该使用final修饰符。还要注意加上final之后也会导致无法在测试的时候进行复写，所以还是需要综合考虑。一般而言，加上final修饰符后会提高编译的效率，所以应该尽可能地使用该修饰符。

- 1.13 在使用譬如else, catch等等类似的语句的时候，将关键字与花括号放在一行，同样遵循1TBS style规范，这边列出了常见的if/else 以及 do/catch 示范代码。

```swift
if someBoolean {
    // do something
} else {
    // do something else
}
do {
    let fileContents = try readFile("filename.txt")
} catch {
    print(error)
}
```
## 2 Access Modifiers

- 2.1 在需要的时候应该将访问修饰符放在关键字的第一位。

```swift
// PREFERRED
private static let kMyPrivateNumber: Int
// NOT PREFERRED
static private let kMyPrivateNumber: Int
```
- 2.2 访问修饰符不应该单独放一行：

```swift
// PREFERRED
public class Pirate {
    /* ... */
}
// NOT PREFERRED
public
class Pirate {
    /* ... */
}
```
- 2.3 一般来说，不要显式地写默认的 internal访问修饰符。

- 2.4 如果某个变量需要在测试的时候被使用到，那么应该标识为internal来保证@testable import ModuleName。这里需要注意的是，对于某些应该被声明为private的变量因为测试用途而声明为了internal，那么应该在注释里特别地注明。

```swift
/**
 This variable defines the pirate's name.
 - warning: Not `private` for `@testable`.
 */
let pirateName = "LeChuck"
```
## 3 Custom Operators:自定义操作符

尽可能地选用命名函数来代替自定义操作符。如果你打算引入一个自定义的操作符，那么一定要有非常充分的理由来说明为啥要讲一个新的操作符引入到全局作用域，而不是使用其他一些可替代的方式。你也可以选择去复写一些现有的操作符，譬如==来适应一些新的类型，不过要保证你添加的用法一定要与语义相符。譬如== 应该只能用于表示相等性测试并且返回一个布尔值。

## 4 Switch Statements and enums

- 4.1 在使用枚举类型作为switch的参数的时候，避免引入default关键字，而应该将没有使用的情形放到下面然后使用break关键字来避免被执行。

- 4.2 Swift中默认会在每个case的结尾进行break，因此没必要的时候不需要显式地声明break关键字。

- 4.3 The case statements should line up with the switch statement itself as per default Swift standards.

- 4.4 When defining a case that has an associated value, make sure that this value is appropriately labeled as opposed to just types (e.g. case Hunger(hungerLevel: Int) instead of case Hunger(Int)).
```swift
enum Problem {
    case attitude
    case hair
    case hunger(hungerLevel: Int)
}
func handleProblem(problem: Problem) {
    switch problem {
    case .attitude:
        print("At least I don't have a hair problem.")
    case .hair:
        print("Your barber didn't know when to stop.")
    case .hunger(let hungerLevel):
        print("The hunger level is \(hungerLevel).")
    }
}
```
- 4.5 优先使用譬如case 1, 2, 3:这样的列表表达式而不是使用fallthrough关键字。

- 4.6 如果你添加了一个默认的case并且该case不应该被使用，那么应该在default情形下抛出异常。
```swift
func handleDigit(digit: Int) throws {
    case 0, 1, 2, 3, 4, 5, 6, 7, 8, 9:
        print("Yes, \(digit) is a digit!")
    default:
        throw Error(message: "The given number was not a digit.")
}
```
## 5 Optionals

- 5.1 只应该在 @IBOutlet中使用隐式地未包裹的Options。否则其他情况下就应该使用Non-Optional或者正常的Optional的变量。虽然有时候你能保证某个变量肯定非nil，不过这样用的话还是比较安全并且能保证上下一致性。

The only time you should be using implicitly unwrapped optionals is withs. In every other case, it is better to use a non-optional or regular optional variable. Yes, there are cases in which you can probably "guarantee" that the variable will never be nil when used, but it is better to be safe and consistent.

- 5.2 不要使用 as! 或者 try!.

- 5.3 如果你只是打算判断存放在Optional中的值是否为空，那么你应该直接与nil进行判断而不是使用if let语句将值取出来。

```swift
// PREFERERED
if someOptional != nil {
    // do something
}
// NOT PREFERRED
if let _ = someOptional {
    // do something
}
```
- 5.4 不要使用 unowned。你可以将unowned当做对于weak变量的隐式解包，虽然有时候unowned与weak相比有小小地性能提升，不过还是不建议进行使用。

```swift
// PREFERRED
weak var parentViewController: UIViewController?
// NOT PREFERRED
weak var parentViewController: UIViewController!
unowned var parentViewController: UIViewController
```
- 5.5 当对Optionals进行解包的时候，使用与Optionals变量一致的变量名

```swift
guard let myVariable = myVariable else {
    return
}
```
## 6 Protocols

在实现协议的时候，大体上有两种代码组织方式：

使用 // MARK: 来注释你的专门用于实现协议中规定的方法

在你的类或者结构体实现之外使用一个扩展来存放实现代码，不过要保证在一个源文件中

不过需要注意的是，如果你是使用了Extension方式，那么定义在Extension中的方法是无法被子类复写的，这样可能会无法进行测试。

## 7 Properties

- 7.1 如果是定义一个只读的需要经过计算的属性，那么不需要声明 get {}
```swift
var computedProperty: String {
    if someBool {
        return "I'm a mighty pirate!"
    }
    return "I'm selling these fine leather jackets."
}
```
- 7.2 在使用 get {}, set {}, willSet, 以及 didSet, 注意块的缩进

- 7.3 尽管你可以在willSet/didSet以及 set方法中使用自定义的名称，不过建议还是使用默认的newValue/oldValue 变量名
```swift
var computedProperty: String {
    get {
        if someBool {
            return "I'm a mighty pirate!"
        }
        return "I'm selling these fine leather jackets."
    }
    set {
        computedProperty = newValue
    }
    willSet {
        print("will set to \(newValue)")
    }
    didSet {
        print("did set from \(oldValue) to \(newValue)")
    }
}
```
- 7.4 将任何类常量设置为static

```swift
class MyTableViewCell: UITableViewCell {
    static let kReuseIdentifier = String(MyTableViewCell)
    static let kCellHeight: CGFloat = 80.0
}
```
- 7.5 可以使用如下方式便捷地声明一个单例变量：

```swift
class PirateManager {
    static let sharedInstance = PirateManager()
    /* ... */
}
```
## 8 Closures:闭包

- 8.1 如果闭包中的某个参数的类型是显而易见的，那么可以避免声明类型。不过有时候为了保证可读性与一致性，还是会显示声明参数类型。

```swift
// omitting the type
doSomethingWithClosure() { response in
    print(response)
}
// explicit type
doSomethingWithClosure() { response: NSURLResponse in
    print(response)
}
// using shorthand in a map statement
[1, 2, 3].flatMap { String($0) }
```
- 8.2 在参数列表中，如果是使用了捕获变量或者声明了非Void的返回值，那么应该将参数列表写在一个圆括号里，其他情况下则可以省略圆括号。

```swift
// parentheses due to capture list
doSomethingWithClosure() { [weak self] (response: NSURLResponse) in
    self?.handleResponse(response)
}
// parentheses due to return type
doSomethingWithClosure() { (response: NSURLResponse) -> String in
    return String(response)
}
```swift
- 8.3 如果你是将闭包声明为一个类型，那么除非该类型为Optional或者该闭包是另一个闭包的参数，否则不需要使用圆括号进行包裹。不过需要用圆括号来标注参数列表，并且使用Void来指明没有任何结果返回。

```swift
let completionBlock: (success: Bool) -> Void = {
    print("Success? \(success)")
}
let completionBlock: () -> Void = {
    print("Completed!")
}
let completionBlock: (() -> Void)? = nil
```
- 8.4 尽可能地将参数名与左括号放在一行，不过要避免打破每行最长160个字符的限制。

Keep parameter names on same line as the opening brace for closures when possible without too much horizontal overflow (i.e. ensure lines are less than 160 characters).

- 8.5 尽可能地使用 trailing closure表达式，除非需要显示地声明闭包参数的外部参数名。

```swift
// trailing closure
doSomething(1.0) { parameter1 in
    print("Parameter 1 is \(parameter1)")
}
// no trailing closure
doSomething(1.0, success: { parameter1 in
    print("Success with \(parameter1)")
}, failure: { parameter1 in
    print("Failure with \(parameter1)")
})
```
## 9 Arrays

- 9.1 一般来说，避免使用下标直接访问某个数组，而应该使用类似于.first、.last这样的访问器进行访问。另外，应该优先使用for item in items语法来替代for i in 0..

- 9.2 永远不要使用+= 或者 +运算符来增加或者连接数组，应该使用.append() 或者 .appendContentsOf() 方法。如果你想定义一个从其他数组生成的不可变数组，那么应该使用let关键字，即： let myNewArray = arr1 + arr2, 或者 let myNewArray = [arr1, arr2].flatten()。

## 10 Error Handling

假设某个函数 myFunction 需要去返回一个String类型，不过有可能会在某个点抛出异常，一般来说会将该函数的返回值设置为String?：

Example:
```swift
func readFile(withFilename filename: String) -> String? {
    guard let file = openFile(filename) else {
        return nil
    }
    let fileContents = file.read()
    file.close()
    return fileContents
}
func printSomeFile() {
    let filename = "somefile.txt"
    guard let fileContents = readFile(filename) else {
        print("Unable to open file \(filename).")
        return
    }
    print(fileContents)
}
```
不过作为异常处理的角度，我们应该使用Swift的try-catch表达式，这样能显式地知道错误点：

```swift
struct Error: ErrorType {
    public let file: StaticString
    public let function: StaticString
    public let line: UInt
    public let message: String
    public init(message: String, file: StaticString = #file, function: StaticString = #function, line: UInt = #line) {
        self.file = file
        self.function = function
        self.line = line
        self.message = message
    }
}
```
Example usage:

```swift
func readFile(withFilename filename: String) throws -> String {
    guard let file = openFile(filename) else {
        throw Error(message: "Unable to open file named \(filename).")
    }
    let fileContents = file.read()
    file.close()
    return fileContents
}
func printSomeFile() {
    do {
        let fileContents = try readFile(filename)
        print(fileContents)
    } catch {
        print(error)
    }
}
```
总而言之，如果某个函数可能会出错，并且出错的原因不能显式地观测到，那么应该优先抛出异常而不是使用一个Optional作为返回值。

## 11 Using guard Statements

- 11.1 一般来说，我们会优先使用所谓的"early return"策略来避免if表达式中的多层嵌套的代码。在这种情况下使用guard语句能够有效地提升代码的可读性。

```swift
// PREFERRED
func eatDoughnut(atIndex index: Int) {
    guard index >= 0 && index < doughnuts else {
        // return early because the index is out of bounds
        return
    }
    let doughnut = doughnuts[index]
    eat(doughnut)
}
// NOT PREFERRED
func eatDoughnuts(atIndex index: Int) {
    if index >= 0 && index < donuts.count {
        let doughnut = doughnuts[index]
        eat(doughnut)
    }
}
```
- 11.2 在对Optional类型进行解包的时候，优先使用 guard 语句来避免if语句中较多的缩进。

```swift
// PREFERRED
guard let monkeyIsland = monkeyIsland else {
    return
}
bookVacation(onIsland: monkeyIsland)
bragAboutVacation(onIsland: monkeyIsland)
// NOT PREFERRED
if let monkeyIsland = monkeyIsland {
    bookVacation(onIsland: monkeyIsland)
    bragAboutVacation(onIsland: monkeyIsland)
}
// EVEN LESS PREFERRED
if monkeyIsland == nil {
    return
}
bookVacation(onIsland: monkeyIsland!)
bragAboutVacation(onIsland: monkeyIsland!)
```
- 11.3 在决定是要用if表达式还是guard表达式进行Optional类型解包的时候，最重要的点就是要保证代码的可读性。很多时候要注意因时而变，因地制宜：

```swift
// an `if` statement is readable here
if operationFailed {
    return
}
// a `guard` statement is readable here
guard isSuccessful else {
    return
}
// double negative logic like this can get hard to read - i.e. don't do this
guard !operationFailed else {
    return
}
```
- 11.4 当需要进行多可能性处理的时候，应该优先使用if表达式而不是guard表达式。
```swift
// PREFERRED
if isFriendly {
    print("Hello, nice to meet you!")
} else {
    print("You have the manners of a beggar.")
}
// NOT PREFERRED
guard isFriendly else {
    print("You have the manners of a beggar.")
    return
}
print("Hello, nice to meet you!")
```
- 11.5 一般来说，guard应该被用于需要直接退出当前上下文的情形。而对于下面这种两个条件互不干扰的情况，应该使用两个if而不是两个guard。

```swift
if let monkeyIsland = monkeyIsland {
    bookVacation(onIsland: monkeyIsland)
}
if let woodchuck = woodchuck where canChuckWood(woodchuck) {
    woodchuck.chuckWood()
}
```
- 11.6 有时候我们会碰到要用guard语句进行多个optionals解包的情况，一般而言，对于复杂的错误处理的Optional类型需要将其拆分到多个单个表达式中。

```swift
// combined because we just return
guard let thingOne = thingOne,
    let thingTwo = thingTwo,
    let thingThree = thingThree else {
    return
}
// separate statements because we handle a specific error in each case
guard let thingOne = thingOne else {
    throw Error(message: "Unwrapping thingOne failed.")
}
guard let thingTwo = thingTwo else {
    throw Error(message: "Unwrapping thingTwo failed.")
}
guard let thingThree = thingThree else {
    throw Error(message: "Unwrapping thingThree failed.")
}
```
- 11.7 不要将guard表达式强行缩写到一行内。

```swift
// PREFERRED
guard let thingOne = thingOne else {
    return
}
// NOT PREFERRED
guard let thingOne = thingOne else { return }
```