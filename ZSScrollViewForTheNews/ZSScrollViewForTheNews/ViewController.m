//
//  ViewController.m
//  ZSScrollViewForTheNews
//
//  Created by 周松 on 17/1/19.
//  Copyright © 2017年 周松. All rights reserved.
//

#import "ViewController.h"
#import "ChannelLabel.h"
#import "ChannelScrollView.h"

@interface ViewController ()<UICollectionViewDelegate,UICollectionViewDataSource>

//频道的scrollView
@property (nonatomic,strong) ChannelScrollView *channelScrollView;

//新闻内容的collectionView
@property (nonatomic,strong) UICollectionView *newsCollection;

//频道label的数组
@property (nonatomic,strong) NSMutableArray *channelLabelArray;

//频道数据
@property (nonatomic,strong) NSArray *channelDataArray;

//当前label的索引
@property (nonatomic,assign) NSInteger currentIndex;

//设置流水布局
@property (nonatomic,strong) UICollectionViewFlowLayout *flowLayout;

@end

@implementation ViewController
#pragma mark --懒加载
- (NSMutableArray *)channelLabelArray{
    if (_channelLabelArray == nil) {
        _channelLabelArray = [NSMutableArray array];
    }
    return _channelLabelArray;
}

- (UIScrollView *)channelScrollView{
    if (_channelScrollView == nil) {
        _channelScrollView = [[ChannelScrollView alloc]initWithFrame:CGRectMake(0, 30, ScreenWidth, ITEMHEIGHT)];
        self.channelScrollView.backgroundColor = [UIColor whiteColor];
        _channelScrollView.contentSize = CGSizeMake(ITEMWIDTH * self.channelDataArray.count, 0);
        _channelScrollView.bounces = YES;
        [self.view addSubview:_channelScrollView];
    }
    return _channelScrollView;
}

- (UICollectionView *)newsCollection{
    if (_newsCollection  == nil) { 
        _newsCollection = [[UICollectionView alloc]initWithFrame:CGRectMake(0, ITEMWIDTH, self.view.bounds.size.width, 300) collectionViewLayout:self.flowLayout];
        _newsCollection.pagingEnabled = YES;
        [self.view addSubview:_newsCollection];
    }
    return _newsCollection;
}

- (UICollectionViewFlowLayout *)flowLayout{
    if (_flowLayout == nil) {
        _flowLayout = [[UICollectionViewFlowLayout alloc]init];
        [_flowLayout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
    }
    return _flowLayout;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    //注册collectionView
    [self.newsCollection registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"newsCell"];
    self.newsCollection.delegate = self;
    self.newsCollection.dataSource = self;
    [self setupUI];
}
//布局完成后调用
- (void)viewDidLayoutSubviews{
    self.flowLayout.itemSize = self.newsCollection.bounds.size;
    self.flowLayout.minimumLineSpacing = 0;
}

///初始化控件及数据
- (void)setupUI{
    //初始化频道
    self.channelDataArray =  @[@"推荐", @"热点", @"北京", @"搞笑", @"视频" , @"娱乐",  @"体育" ,  @"科技" , @"涨知识",@"社会",@"历史",@"互联网",@"财经",@"房产"];
    
    //创建label
    CGFloat labelX = 0;
    CGFloat labelY = 0;
    CGFloat labelW = ITEMWIDTH;
    CGFloat labelH = self.channelScrollView.bounds.size.height;
    for (int i = 0; i < self.channelDataArray.count; i ++) {
        ChannelLabel *label = [[ChannelLabel alloc]init];
        //将label添加到可变数组中
        [self.channelLabelArray addObject:label];
        
        label.frame = CGRectMake(labelX + i * labelW, labelY, labelW, labelH);
        
        //设置文字
        label.text = self.channelDataArray[i];
        
        [self.channelScrollView addSubview:label];
        
        label.tag = i;
        //添加手势
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapLabel:)];
        [label addGestureRecognizer:tap];
        //开启用户交互
        label.userInteractionEnabled = YES;
        if (i == 0) {
            label.textColor = [UIColor colorWithRed:62/255 green:120/255 blue:255/255 alpha:1.0];
            label.scale = 1;
        }
        
    }
    //设置channelScrollView的滚动范围
    self.channelScrollView.contentSize = CGSizeMake(self.channelLabelArray.count * labelW, self.channelScrollView.bounds.size.height);
    
    
}
#pragma mark --UICollectionViewDelegate,UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.channelDataArray.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"newsCell" forIndexPath:indexPath];
    CGFloat red = arc4random_uniform(256)/255.f;
    CGFloat green = arc4random_uniform(256)/255.f;
    CGFloat blue = arc4random_uniform(256)/255.f;
    cell.backgroundColor = [UIColor colorWithRed:red green:green blue:blue alpha:1.0];
    
    return cell;
}

///label的点击手势
- (void)tapLabel:(UITapGestureRecognizer *)tap{
    NSInteger index = tap.view.tag;
    //如果本次点击的label和上一次点击的label不一样,就让上一次的label颜色变成黑色,大小不发生改变
    if (index != self.currentIndex) {
        
        ChannelLabel *currentLabel = self.channelLabelArray[self.currentIndex];
        currentLabel.scale = 0;
        currentLabel.textColor = [UIColor blackColor];
    }
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:index inSection:0];
    //新闻界面滚动
    [self.newsCollection scrollToItemAtIndexPath:indexPath atScrollPosition:0 animated:NO];
    self.currentIndex = index;
    
    //使label停在中间的位置
    [self labelToCenter];
}

///正在滚动的方法
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    //获取偏移量
    CGFloat offsetX = self.newsCollection.contentOffset.x;
    NSInteger itemCount = offsetX / self.newsCollection.bounds.size.width;
    //当前频道在屏幕的位置
    CGFloat rightPageLeftDelta = offsetX - itemCount *ScreenWidth;
    CGFloat progress = rightPageLeftDelta / ScreenWidth;
    
    CGFloat rightScale = offsetX / self.newsCollection.bounds.size.width - itemCount;
    CGFloat leftScale = 1 - rightScale;
    //左侧的label
    ChannelLabel *leftLabel = self.channelLabelArray[itemCount];
    leftLabel.scale = leftScale;
    leftLabel.textColor = [UIColor colorWithRed:62/255 green:120/255 blue:255/255 alpha:1.0];
    leftLabel.fillColor = [UIColor blackColor];
    leftLabel.progress = progress;
    
    if (itemCount == self.channelDataArray.count - 1) {
        return;
    }
    //右侧的label
    ChannelLabel *rightLabel = self.channelLabelArray[itemCount + 1];
    rightLabel.scale = rightScale;
    rightLabel.textColor = [UIColor blackColor];
    rightLabel.fillColor = [UIColor colorWithRed:62/255 green:120/255 blue:255/255 alpha:1.0];
    rightLabel.progress = progress;
    //重新赋值
    self.currentIndex = itemCount;
}

//滚动停止的方法
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    //获取dangqianlabel的索引
    self.currentIndex = scrollView.contentOffset.x / self.newsCollection.bounds.size.width;
    [self labelToCenter];
}

///使label停在中间的位置
- (void)labelToCenter{
    //获取当前的label
    ChannelLabel *currentLabel = self.channelLabelArray[self.currentIndex];
    //获取label的中心点x
    CGFloat currentLabelCenterX = currentLabel.center.x;
    
    CGFloat offsetX = currentLabelCenterX - self.newsCollection.bounds.size.width / 2;
    //如果点击label在屏幕中心点的左侧,频道不能向左移动(第一页)
    if (offsetX <= 0) {
        return;
    }
    
    //当点击的label中心点的x在屏幕中心点的右侧(最后一页),
    if (offsetX > (self.channelScrollView.contentSize.width - self.channelScrollView.bounds.size.width)) {
        return;
    }
    
    //使label所在的scrollView移动
    [self.channelScrollView setContentOffset:CGPointMake(offsetX, 0) animated:NO];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end




















