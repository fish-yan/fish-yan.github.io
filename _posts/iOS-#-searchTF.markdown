---
layout:     post
title:      "自定义搜索框"
subtitle:   "通过将汉字转换为拼音进行分组,排序,查询,筛选."
date:       2015-12-03 22:00:00
author:     "FishYan"
header-img: "img/blog-header.png"
 catalog:    true
tags:
    - iOS
    - 搜索
---

## 通过将汉字转换为拼音进行分组,排序,查询,筛选.
- 搜索框为TextField,
- 思路是: 将全国各地的城市都转换为拼音,取到地名的首字母,按首字母进行分组,排序.
- 关键点: 利用textField的代理方法和通知的结合使用来实现再输入框中的值改变都会做搜索和刷新页面操作.(textfield本身没有这个代理方法)

下面上代码,看注释就行.

```Objc
//
//  SearchViewController.m
//  Search
//
//  Created by 薛焱 on 16/1/12.
//  Copyright © 2016年 薛焱. All rights reserved.
//

#import "SearchViewController.h"
#import <PinYin4Objc.h>

@interface SearchViewController ()<UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *searchTextField;
@property (weak, nonatomic) IBOutlet UITableView *cityTableView;
@property (nonatomic, strong) NSMutableDictionary *dataDict;//存储数据的字典
@property (nonatomic, strong) NSMutableDictionary *dataSource;//同样也是存储数据的字典,跟上面一样,后面有用
@property (nonatomic, strong) NSMutableArray *perfixArray;//存储首字母的数组(索引)
@property (nonatomic, strong) NSMutableArray *perfixSource;//存储首字母的数组(索引)
@end

@implementation SearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
	//初始化
    self.perfixArray = [NSMutableArray array];
    self.perfixSource = [NSMutableArray array];
    self.dataDict = [NSMutableDictionary dictionary];
    self.dataSource = [NSMutableDictionary dictionary];
    //设置索引的颜色(可忽略)
    self.cityTableView.sectionIndexColor = UIColorFromRGB(0x0f2ee8);
    self.cityTableView.sectionIndexBackgroundColor = [UIColor clearColor];
    self.searchTextField.delegate = self;
    //让页面出现时就弹出键盘
    [self.searchTextField becomeFirstResponder];
    [self readDataFromLocal];
    // Do any additional setup after loading the view.
}
//从plist文件中读取数据,数据有点坑,看看就好,不想看的知道里面存的是什么就好(最后的self.dataDict和self.dataSource都是字典key值为城市名首字母,value值为该首字母对应的城市名数组,数组中存的是城市名,同样self.perfixSource 和 self.perfixArray都存的是城市首字母)
- (void)readDataFromLocal{
    NSString *path = [[NSBundle mainBundle]pathForResource:@"Area" ofType:@"plist"];
    NSDictionary *dict = [[NSDictionary alloc]initWithContentsOfFile:path];
    NSMutableArray *dataArray = [NSMutableArray array];
    for (NSString *key in dict) {
        for (NSString *province in dict[key]) {
            for (NSString *cityKey in dict[key][province]) {
                NSDictionary *cityDict = dict[key][province];
                for (NSString *cityName in cityDict[cityKey]) {
                    
                    NSString *cityNameEN = [self changeEnglishToChinese:cityName withSeparator:@""];
                    NSString *perfix = [[cityNameEN substringToIndex:1] uppercaseString];
                    if (![self.perfixArray containsObject:perfix]) {
                        [self.perfixArray addObject:perfix];
                    }
                    [dataArray addObject:cityName];
                }
            }
        }
    }
    for (NSString *perfix in self.perfixArray) {
        NSMutableArray *cityArray = [NSMutableArray array];
        for (NSString *cityName in dataArray) {
            NSString *cityNameEN = [self changeEnglishToChinese:cityName withSeparator:@""];
            if ([cityNameEN hasPrefix:[perfix lowercaseString]]) {
                [cityArray addObject:cityName];
            }
        }
        [self.dataDict setObject:cityArray forKey:perfix ];
    }
    
    self.perfixArray = [NSMutableArray arrayWithArray:[self.perfixArray sortedArrayUsingSelector:@selector(compare:)]];
    self.dataSource = self.dataDict;
    self.perfixSource = self.perfixArray;
}

- (IBAction)cancleButtonAction:(UIButton *)sender {
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
//tableView的代理方法就不用多解释了吧.
#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.perfixArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.dataDict[self.perfixArray[section]] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"searchCell" forIndexPath:indexPath];
    cell.textLabel.text = self.dataDict[self.perfixArray[indexPath.section]][indexPath.row];
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *sectionView = [[UIView alloc]init];
    UILabel *indexLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 0, [UIScreen mainScreen].bounds.size.width, 23.5)];
    sectionView.backgroundColor = UIColorFromRGB(0xf8f8f8);
    indexLabel.text = self.perfixArray[section];
    [sectionView addSubview:indexLabel];
    return sectionView;
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    return self.perfixArray;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 38;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 23.5;
}
#pragma mark - textField代理方法
//开始编辑的时候
- (void)textFieldDidBeginEditing:(UITextField *)textField{
//添加通知用来监听textfield的变化
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(textFieldDidChange:) name:UITextFieldTextDidChangeNotification object:self.searchTextField];
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
//结束编辑的时候移除通知
    [[NSNotificationCenter defaultCenter]removeObserver:self name:UITextFieldTextDidChangeNotification object:self.searchTextField];
}
//通知方法
- (void)textFieldDidChange:(NSNotification *)note{
//判断是否输入内容了
    if (self.searchTextField.text.length > 0) {
    //将self.dataDict, self.perfixArray重新初始化备用
        self.dataDict = [NSMutableDictionary dictionary];
        self.perfixArray = [NSMutableArray array];
        //遍历出城市名
        for (NSString *perfix in self.dataSource) {
            NSMutableArray *mArray = [NSMutableArray array];
            NSString *index;//index为首字母
            for (NSString *cityName in self.dataSource[perfix]) {
                //将城市名转换为拼音
                NSString *cityNameEN =[self changeEnglishToChinese:cityName withSeparator:@""];
                //这个是为了将城市名的每一个字都分开,在输入城市名首字母的时候也可以查到对应城市
                NSString *cityNameEN1 = [self changeEnglishToChinese:cityName withSeparator:@"!"];
                NSArray *perfixArray = [cityNameEN1 componentsSeparatedByString:@"!"];
                NSMutableString *perfixString = [NSMutableString string];
                for (NSString *str in perfixArray) {
                //城市名每个字的首字母拼起来
                    [perfixString appendString:[str substringToIndex:1]];
                }
                //输入内容转换为拼音
                NSString *searchTextEN = [self changeEnglishToChinese:self.searchTextField.text withSeparator:@""];
                //判断搜索结果
                if ([cityNameEN hasPrefix:searchTextEN] || [perfixString hasPrefix:searchTextEN]) {
                    
                    index = [[cityNameEN substringToIndex:1] uppercaseString];
                    //将搜索到的内容重新加入数组
                    [mArray addObject:cityName];
                }
            }
            //如果该分组不为空将其加入到字典中index为首字母
            if (index != nil) {
            //搜索后新的self.perfixArray 和 self.dataDict
                [self.perfixArray addObject:index];
                [self.dataDict setObject:mArray forKey:index];
            }
        }
    }else{
    //如果textfield中没有输入内容则显示全部内容,
        self.dataDict = self.dataSource;
        self.perfixArray = self.perfixSource;
    }
    //刷新页面
    [self.cityTableView reloadData];
}
//将汉字转换为拼音的方法
- (NSString *)changeEnglishToChinese:(NSString *)cityName withSeparator:(NSString *)separator{
    HanyuPinyinOutputFormat *outputFormat=[[HanyuPinyinOutputFormat alloc] init];
    [outputFormat setToneType:ToneTypeWithoutTone];
    [outputFormat setVCharType:VCharTypeWithV];
    [outputFormat setCaseType:CaseTypeLowercase];
    NSString *cityNameEN =[PinyinHelper toHanyuPinyinStringWithNSString:cityName withHanyuPinyinOutputFormat:outputFormat withNSString:separator];
    return cityNameEN;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
```



效果图:
![这里写图片描述](/img/blog/searchTF/searchTF.gif)

[完整Demo](https://github.com/757094197/Search)

[关于pod导入PinYin4Objc的方法见](http://blog.csdn.net/fish_yan_/article/details/50483282)