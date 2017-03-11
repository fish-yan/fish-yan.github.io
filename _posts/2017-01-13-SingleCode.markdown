---
layout:     post
title:      "Swift中10个简单易用的单行代码，提高效率，晋升逼格"
subtitle:   "Swift"
date:       2016-12-25 22:00:00
author:     "FishYan"
header-img: "img/blog-header.png"
tags:
    - iOS
    - Swift
---


![这里写图片描述](http://img.blog.csdn.net/20160630210549019)

我们不知道有多少人真的对这些单行代码印象深刻，但我认为，这能激励大家去了解更多有关于函数式编程的内容。

- 1 数组中的每个元素乘以2

特别简单，尤其是使用map解决的话。

```swift
(1...1024).map{$0 * 2}
``` 

- 2 数组中的元素求和

虽然这里使用reduce和加号运算符，借助了加号运算符是函数这样一个事实，但解决办法是显而易见的，我们可以看到 reduce更具创意的用法。

```swift
(1...1024).reduce(0,combine: +)
 
```
- 3 验证在字符串中是否存在指定单词

让我们使用 filter来验证tweet中是否包含选定的若干关键字中的一个：

```swift
let words = ["Swift","iOS","cocoa","OSX","tvOS"]
let tweet = "This is an example tweet larking about Swift"
let valid = !words.filter({tweet.containsString($0)}).isEmpty
valid //true
```
还有更好的写法：
```swift
words.contains(tweet.containsString)
``` 

方式更简洁，还有这一个：

```swift
tweet.characters
.split(" ")
.lazy
.map(String.init)
.contains(Set(words).contains)
```
- 4 读取文件

像其他语言一样，通过简单的内置来读取文件到数组中是不可能，但我们可以结合使用 split 和 map创造一些不需要for循环的简短代码：


```swift
let path = NSBundle.mainBundle().pathForResource("test", ofType: "txt")
let lines = try? String(contentsOfFile: path!).characters.split{$0 == "\n"}.map(String.init)
if let lines=lines {
    lines[0] // O! for a Muse of fire, that would ascend
    lines[1] // The brightest heaven of invention!
    lines[2] // A kingdom for a stage, princes to act
    lines[3] // And monarchs to behold the swelling scene.
}
```

map和字符串构造函数的最后一步把我们的数组字符转换为字符串。

- 5 祝你生日快乐！

这将显示生日快乐歌到控制台，通过map以及范围和三元运算符的简单使用。

```swift
let name = "uraimo"
(1...4).forEach{print("Happy Birthday " + (($0 == 3) ? "dear \(name)":"to You"))}
```
- 6 过滤数组中的数字

在这种情况下，我们需要使用提供的过滤函数分区一个序列。许多语言除了拥有常用的map、flatMap、reduce、filter等，还有正好能做这件事的 partitionBy 函数，Swift如你所知没有类似的东西（NSPredicate提供的可以过滤的NSArray函数在这里不是我们所需要的）。

因此，我们可以用 partitionBy 函数扩展 SequenceType 来解决这个问题，我们将使用 partitionBy 函数来分区整型数组：

```swift
extension SequenceType{
        typealias Element = Self.Generator.Element
        func partitionBy(fu: (Element)->Bool)->([Element],[Element]){
        var first=[Element]()
        var second=[Element]()
        for el in self {
        if fu(el) {
        first.append(el)
    }else{
        second.append(el)
        }
    }
        return (first,second)
    }
}
let part = [82, 58, 76, 49, 88, 90].partitionBy{$0 < 60}
part // ([58, 49], [82, 76, 88, 90])
```

不是真正的单行代码。那么，我们是否可以使用过滤器来改善它？

```swift
extension SequenceType{
    func anotherPartitionBy(fu: (Self.Generator.Element)->Bool)->([Self.Generator.Element],[Self.Generator.Element]){
        return (self.filter(fu),self.filter({!fu($0)}))
    }
}
let part2 = [82, 58, 76, 49, 88, 90].anotherPartitionBy{$0 < 60}
part2 // ([58, 49], [82, 76, 88, 90])
 
```
稍微好了一点，但它遍历了序列两次，并且试图把它变成单行代码删除闭包功能将会导致太多重复的东西（过滤函数和数组会在两个地方使用）。

我们是否使用单个数据流建立一些能够将初始序列转换为分区元组的东西？是的，我们可以用 reduce。

```swift
var part3 = [82, 58, 76, 49, 88, 90].reduce( ([],[]), combine: {
    (a:([Int],[Int]),n:Int) -> ([Int],[Int]) in
    (n<60) ? (a.0+[n],a.1) : (a.0,a.1+[n])
})
part3 // ([58, 49], [82, 76, 88, 90])
```
我们在这里构建了包含两个分区的结果元组，一次一个元素，使用过滤函数测试初始序列中的每个元素，并根据过滤结果追加该元素到第一或第二分区数组中。

最后得到真正的单行代码，但要注意这样一个事实，即分区数组通过追加被构建，实际上会使其比前两个实施方式要慢。

- 7 获取并解析XML Web服务

上面的有些语言不依赖外部库，并默认提供多个选项来处理XML（例如Scala虽然笨拙但“本地”地支持XML解析成对象），但Foundation只提供了SAX解析器NSXMLParser，并且正如你可能已经猜到的那样，我们不打算使用它。

有几个替代的开源库，我们可以在这种情况下使用，其中一些用C或Objective-C编写，其他为纯Swift。

这次，我们打算使用纯Swift的AEXML：

```swift
let xmlDoc = try? AEXMLDocument(xmlData: NSData(contentsOfURL: NSURL(string:"https://www.ibiblio.org/xml/examples/shakespeare/hen_v.xml")!)!)
if let xmlDoc=xmlDoc {
    var prologue = xmlDoc.root.children[6]["PROLOGUE"]["SPEECH"]
    prologue.children[1].stringValue // Now all the youth of England are on fire,
    prologue.children[2].stringValue // And silken dalliance in the wardrobe lies:
    prologue.children[3].stringValue // Now thrive the armourers, and honour's thought
    prologue.children[4].stringValue // Reigns solely in the breast of every man:
    prologue.children[5].stringValue // They sell the pasture now to buy the horse,
}
```

- 8 在数组中查找最小（或最大）值

我们有各种方法来找到序列中的最小和最大值，其中有 minElement 和maxElement 函数：

```swift
//Find the minimum of an array of Ints
[10,-22,753,55,137,-1,-279,1034,77].sort().first
[10,-22,753,55,137,-1,-279,1034,77].reduce(Int.max, combine: min)
[10,-22,753,55,137,-1,-279,1034,77].minElement()
//Find the maximum of an array of Ints
[10,-22,753,55,137,-1,-279,1034,77].sort().last
[10,-22,753,55,137,-1,-279,1034,77].reduce(Int.min, combine: max)
[10,-22,753,55,137,-1,-279,1034,77].maxElement()
```

- 9 埃拉托斯特尼筛法

埃拉托斯特尼筛法用于查找所有的素数直到给定的上限n。

从小于n的所有整数序列开始，算法删除所有整数的倍数，直到只剩下素数。并且为了加快执行速度，我们实际上并不需要检查每个整数的倍数，我们止步于n的平方根就可以了。

根据这一定义首次执行可能是这样的：

```swift
var n = 50
var primes = Set(2...n)
(2...Int(sqrt(Double(n)))).forEach{primes.subtractInPlace((2*$0).stride(through:n, by:$0))}
primes.sort()
```

我们使用外部范围来迭代我们要检查的整数，并且对于每一个整数我们使用 stride(through:Int by:Int)计算出数字的倍数的序列。那些序列然后从Set中减去，Set用所有从2到n的整数初始化。

但正如你所看到的，为了实际移除倍数，我们使用外部可变Set，导致了附带后果。

为了消除附带后果，正如我们通常应该做的那样，我们会先计算所有序列，用倍数的单一数组来flatMap它们，并从初始Set中删除这些整数。

```swift
var sameprimes = Set(2...n)
sameprimes.subtractInPlace((2...Int(sqrt(Double(n))))
.flatMap{ (2*$0).stride(through:n, by:$0)})
sameprimes.sort()
```

方式更清洁，使用flatMap的一个很好的例子以生成扁平化的嵌套数组。

- 10 其他：通过解构元组交换

最后一点，并非每个人都知道的是，和其他有tuple类型的语言一样，元组可以用来执行紧凑的变量交换：

```swift
var a=1,b=2
(a,b) = (b,a)
a //2
b //1
```
好了，正如所料，Swift和其他语言一样富有表现力。
