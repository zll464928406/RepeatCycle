//
//  RepeatCycleView.h
//  RepeatCycle
//
//  Created by 张令林 on 2016/11/17.
//  Copyright © 2016年 personer. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RepeatCycleView : UIView

//图片数组
@property (nonatomic,strong) NSArray *imgArray;
//点击每个图片的block
@property (nonatomic,copy) void (^imageClick)(NSInteger num);

@end
