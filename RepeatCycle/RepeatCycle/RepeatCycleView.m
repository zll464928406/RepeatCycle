//
//  RepeatCycleView.m
//  RepeatCycle
//
//  Created by 张令林 on 2016/11/17.
//  Copyright © 2016年 personer. All rights reserved.
//

#import "RepeatCycleView.h"
#import "RepeatCycleCollectionViewCell.h"

#define kSeed 8

static NSString *repeatCyclyCellid = @"repeatCyclyCellid";


@interface RepeatCycleView () <UICollectionViewDelegate,UICollectionViewDataSource>

@property (nonatomic,weak) UICollectionView *collectionView;
@property (nonatomic,weak) UIPageControl *pageControl;
@property (nonatomic, strong) NSTimer* timer;

@end


@implementation RepeatCycleView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self setUpUI];
    }
    return self;
}

- (void)setUpUI
{
    //添加UICollectionView
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.itemSize = CGSizeMake(self.bounds.size.width, self.bounds.size.height);
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    layout.minimumLineSpacing = 0;
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:self.bounds collectionViewLayout:layout];
    [self addSubview:collectionView];
    //设置数据源
    collectionView.delegate = self;
    collectionView.dataSource = self;
    //设置属性
    collectionView.bounces = NO;
    collectionView.showsVerticalScrollIndicator = NO;
    collectionView.showsHorizontalScrollIndicator = NO;
    collectionView.pagingEnabled = YES;
    self.collectionView = collectionView;
    [collectionView registerClass:[RepeatCycleCollectionViewCell class] forCellWithReuseIdentifier:repeatCyclyCellid];
    
    //添加分页
    UIPageControl *pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, self.bounds.size.height-30, self.bounds.size.width, 20)];
    pageControl.numberOfPages = self.imgArray.count;
    pageControl.currentPage = 0;
    pageControl.pageIndicatorTintColor = [UIColor whiteColor];
    pageControl.currentPageIndicatorTintColor = [UIColor blackColor];
    [self addSubview:pageControl];
    self.pageControl = pageControl;
}

#pragma mark - 数据源方法
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.imgArray.count*2*kSeed;
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    RepeatCycleCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:repeatCyclyCellid forIndexPath:indexPath];
    cell.imageName = self.imgArray[indexPath.row%self.imgArray.count];
    
    return cell;
}

#pragma mark - 代理方法
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    self.imageClick(indexPath.row);
}
// 滚动动画结束的时候调用
- (void)scrollViewDidEndScrollingAnimation:(UIScrollView*)scrollView
{
    // 手动调用减速完成的方法
    [self scrollViewDidEndDecelerating:self.collectionView];
}

// 监听手动减速完成(停止滚动)
- (void)scrollViewDidEndDecelerating:(UIScrollView*)scrollView
{
    // x 偏移量
    CGFloat offsetX = scrollView.contentOffset.x;
    NSInteger page = offsetX / self.bounds.size.width;
    // 获取某一组有多少行
    NSInteger itemsCount = [self.collectionView numberOfItemsInSection:0];
    if (page == 0)
    { // 第一页
        self.collectionView.contentOffset = CGPointMake(offsetX + self.imgArray.count * kSeed * self.bounds.size.width, 0);
    }
    else if (page == itemsCount - 1)
    { // 最后一页
        self.collectionView.contentOffset = CGPointMake(offsetX - self.imgArray.count * kSeed * self.bounds.size.width, 0);
    }
}
//滚动的位置
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat offsetX = scrollView.contentOffset.x;
    CGFloat page = offsetX / self.bounds.size.width + 0.5;
    page = (NSInteger)page % self.imgArray.count;
    // 设置当前的页码
    self.pageControl.currentPage = page;
}
//开始拖拽的时候把定时器修改为很久以后才开始
-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    self.timer.fireDate = [NSDate distantFuture];
}
//结束拖拽的时候把定时器修改为立马开始
-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    self.timer.fireDate = [NSDate dateWithTimeIntervalSinceNow:2];
}
#pragma mark - 添加定时器
-(NSTimer *)timer
{
    if (_timer == nil)
    {
        NSTimer *timer = [NSTimer timerWithTimeInterval:2 target:self selector:@selector(updateTimer) userInfo:nil repeats:YES];
        _timer = timer;
    }
    return _timer;
}

//定时器执行的方法
- (void)updateTimer
{
    NSIndexPath* indexPath = [self.collectionView indexPathsForVisibleItems].lastObject;
    // 根据当前页 创建下一页的位置
    NSIndexPath* nextPath = [NSIndexPath indexPathForItem:indexPath.item + 1 inSection:indexPath.section];
    [self.collectionView scrollToItemAtIndexPath:nextPath atScrollPosition:UICollectionViewScrollPositionLeft animated:YES];
}
//去掉定时器,如果计时器在运行循环中 根本不会调用dealloc方法,所以不在dealloc里面去掉
-(void)removeFromSuperview
{
    [super removeFromSuperview];
    [self.timer invalidate];
}
#pragma mark - 设置数组的时候设置一些元素
-(void)setImgArray:(NSArray *)imgArray
{
    _imgArray = imgArray;
    self.pageControl.numberOfPages = self.imgArray.count;
    [self.collectionView reloadData];
    //当传入数据的时候一定会调用这个方法
    [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
}


@end
