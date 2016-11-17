# RepeatCycle

>**简介**

- 循环轮播器，实现无卡顿拖拽

>**使用**

- 1、将文件夹RepeatCycle中的四个文件拖入项目中
- 2、在需要使用轮播器的文件中引入头文件
- 3、添加轮播器视图

    ```
    //添加轮播器
    RepeatCycleView *cycleView = [[RepeatCycleView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 200)];
    //添加轮播器中需要添加的图片
    cycleView.imgArray = @[@"page1",@"page2",@"page3",];
    //轮播器点击执行的block
    cycleView.imageClick = ^(NSInteger num){
        NSLog(@"点击了第%zd张图片",num);
    };
    //将轮播器添加到视图中
    [self.view addSubview:cycleView];
    ```


