---
layout:     post
title:      "OC"
subtitle:   "内存管理tips"
date:       2020-06-28 22:00:00
author:     "FishYan"
header-img: "img/blog-header.png" 
catalog:    true

---

# 内存管理Tips

## Tip1. 内存分区情况
- 栈区（Stack）
  
  由编译器自动分配释放，存放函数的参数，局部变量的值等。

  栈是向低地址扩展的数据结构，是一块连续的内存区域

- 堆区（Heap）
  
  由程序员管理

  是向高地址扩展的数据结构，是不连续的内存区域

  堆区的内存是所有程序共享的，具体每个程序分配的内存大小是有系统负责

- 全局区

  程序结束后由系统释放
  
  存放全局变量和静态变量，已初始化的全局变量和静态变量在一块区域，未初始化的全局变量和静态变量在另一块儿区域。

- 常量区
  
  常量存放的区域，如常量字符串

  程序结束后由系统释放

- 代码区
  
  存放函数体的二进制代码

  程序结束后由系统释放

> 当App启动后，代码区，常量区，全局区的大小已经固定，因此指向这些区域的指针不会发生崩溃，而堆区和栈区是时刻变化的，堆区会进行创建与销毁，栈区入栈和出栈，所以指向堆区和栈区的内存地址是不确定的，可能为空，会造成野指针崩溃。

## Tip2. 关键字

- const: 常量， 被修饰的变量无法更改
> 只有 const 修饰的后面不可变
> 
> 例如：
>
> ```swift
> NSString * const a = @"1";
> a 不可变，不能对 a 再重新赋值
> 
> NSString const * b = @"2";
> * b 不能被重新赋值
> ```
> <br>

- static: 静态变量， 被修饰的变量只能被初始化一次
> static 修饰的只能初始化一次
> 
> 例如：
> ```swift
> - (void)test {
>   static int a = 1;
>   a++;
>   NSLog(@"%ld", a);
> }
> for (int i = 0; i < 5; i++) {
>   [self test];
> }
> ```
> 输出结果为2，3，4，5，6
> 在第二次执行test方法时，a 并没有重新被初始化为1

- extern:全局变量， 被修饰的变量为全局变量
> 步骤：.h 声明全局变量 -> .m 给全局变量赋值 -> 其他需要使用的地方声明。
> 
> ```swift
> 1. .h文件
> @interface test : NSObject
>
> extern NSString *str;
>
> @end
>
>2. .m文件
> @implementation test
> 
> NSString *str = @"222";
> 
> @end
> 
> 3. 另一个文件使用时：
> extern NSString * str;
> 
> NSLog(@"%@", str); // 222
>
> ```
> .

---
## Tip3.内存管理方式

- Tagged Pointer：专门用来存储小对象，如NSDate、NSNumber。Tagged Pointer 指针的值不是地址，而是真正的值
  
- NONPOINTER_ISA：指针中存放对象的相关信息，包含是否为NONPOINTER_ISA类型，是否含关联对象。是否包含c++内容或者使用ARC管理，指针地址，是否有弱引用的指针指向，是否正在被回收，是否引用散列表，引用计数。

```swift
// x86_64 架构
struct {
    uintptr_t nonpointer        : 1;  // 0:普通指针，1:优化过，使用位域存储更多信息
    uintptr_t has_assoc         : 1;  // 对象是否含有或曾经含有关联引用
    uintptr_t has_cxx_dtor      : 1;  // 表示是否有C++析构函数或OC的dealloc
    uintptr_t shiftcls          : 44; // 存放着 Class、Meta-Class 对象的内存地址信息
    uintptr_t magic             : 6;  // 用于在调试时分辨对象是否未完成初始化
    uintptr_t weakly_referenced : 1;  // 是否被弱引用指向
    uintptr_t deallocating      : 1;  // 对象是否正在释放
    uintptr_t has_sidetable_rc  : 1;  // 是否需要使用 sidetable 来存储引用计数
    uintptr_t extra_rc          : 8;  // 引用计数能够用 8 个二进制位存储时，直接存储在这里
};

// arm64 架构
struct {
    uintptr_t nonpointer        : 1;  // 0:普通指针，1:优化过，使用位域存储更多信息
    uintptr_t has_assoc         : 1;  // 对象是否含有或曾经含有关联引用
    uintptr_t has_cxx_dtor      : 1;  // 表示是否有C++析构函数或OC的dealloc
    uintptr_t shiftcls          : 33; // 存放着 Class、Meta-Class 对象的内存地址信息
    uintptr_t magic             : 6;  // 用于在调试时分辨对象是否未完成初始化
    uintptr_t weakly_referenced : 1;  // 是否被弱引用指向
    uintptr_t deallocating      : 1;  // 对象是否正在释放
    uintptr_t has_sidetable_rc  : 1;  // 是否需要使用 sidetable 来存储引用计数
    uintptr_t extra_rc          : 19;  // 引用计数能够用 19 个二进制位存储时，直接存储在这里
};
```
  
- 散列表：(引用计数表，弱引用表)
  
  > 散列表是一个sideTables的哈希映射表，其中所有的引用计数都存在这个表中（除存在NONPOINTER_ISA中的外）sideTables 包含众多sideTable，每个sideTable包含三个元素spinlock_t自旋锁，RefcountMap引用计数表，weak_table_t弱引用表

- 当一个对象访问sideTable时
  - 首先会取得对象地址，将地址进行哈希运算，与sideTabls中的sideTable个数取余，最后得到的结果就是该对象访问的sideTable
  - 在取得的sideTable中的RefcountMap表中再进行一次哈希运算，找到该对象在引用计数表中的位置
  - 如果该位置存在对应的引用计数，则对其操作，如果不存在，则创建一个对应的size_t对象，其实就是个uint无符号整型
  - 弱引用表也是一张哈希表的结构，其内部包含了每个对象对应的弱引用表weak_entry_t，而weak_entry_t是一个结构体数组，其中包含的则是每一个对象弱引用的对象所对应的指针  