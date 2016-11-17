//
//  ViewController.m
//  RepeatCycle
//
//  Created by 张令林 on 2016/11/17.
//  Copyright © 2016年 personer. All rights reserved.
//

#import "ViewController.h"
#import "RepeatCycleView.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //调用初始化方法
    [self setUpUI];
}

#pragma mark 初始化方法
- (void)setUpUI
{
    self.view.backgroundColor = [UIColor whiteColor];
    
    RepeatCycleView *cycleView = [[RepeatCycleView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 200)];
    cycleView.imgArray = @[@"page1",@"page2",@"page3",];
    cycleView.imageClick = ^(NSInteger num){
        NSLog(@"点击了第%zd张图片",num);
    };
    [self.view addSubview:cycleView];
}


@end
