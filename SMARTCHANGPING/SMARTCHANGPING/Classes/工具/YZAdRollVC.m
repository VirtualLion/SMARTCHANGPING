//
//  YZAdRollVC.m
//  YZADRollDemo
//
//  Created by 韩云智 on 16/6/21.
//  Copyright © 2016年 YZ. All rights reserved.
//

#import "YZAdRollVC.h"

@interface YZAdRollVC ()<UICollectionViewDelegateFlowLayout,UICollectionViewDataSource,UICollectionViewDelegate>

@property (nonatomic, strong) UICollectionView * collectionView;

@property (nonatomic, strong) NSTimer * timer;

@property (nonatomic, assign) BOOL isTimer;

typedef void(^block)(NSInteger);
@property (nonatomic, copy) block selectBlock;

typedef BOOL(^cellBlock)(UIImageView *,id,UIView *,NSInteger);
@property (nonatomic, copy) cellBlock cellImageViewBlock;

@property (nonatomic, assign) float contentOffsetX;

@end

@implementation YZAdRollVC
#pragma mark ----- init 【S】
- (instancetype)initWithFrame:(CGRect)frame  didSelectAtItem:(void (^)(NSInteger item)) selectBlock  cellWebImage:(BOOL (^)(UIImageView * cellImageView, id content, UIView * cellContentView, NSInteger item)) cellImageViewBlock
{
    self = [super init];
    if (self) {
        _selectBlock = selectBlock;
        _cellImageViewBlock = cellImageViewBlock;
        _rollView = [[UIView alloc]initWithFrame:frame];
        _dataSource = [[NSMutableArray alloc]init];
        _num = 0;
        _timerOffset = 3;
        _timerInterval = 3;
        _isScrollWithSign = NO;
        [self createCollectionView];
    }
    return self;
}

- (void)dealloc{
    [_timer invalidate];
    _timer = nil;
}

- (void)createCollectionView{
    UICollectionViewFlowLayout * flowLayout = [[UICollectionViewFlowLayout alloc]init];
    flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    flowLayout.minimumLineSpacing = 0.0;
    flowLayout.minimumInteritemSpacing = 0.0;
    flowLayout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
    
    _collectionView = [[UICollectionView alloc]initWithFrame:_rollView.bounds collectionViewLayout:flowLayout];
    _collectionView.delegate=self;
    _collectionView.dataSource=self;
    
    [_collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"cellid"];
    
    _collectionView.showsVerticalScrollIndicator = NO;
    _collectionView.showsHorizontalScrollIndicator = NO;
    _collectionView.pagingEnabled = YES;
    _collectionView.bounces = NO;
    
    _collectionView.backgroundColor = [UIColor clearColor];
    [_rollView addSubview:_collectionView];
    
    _timer = [NSTimer scheduledTimerWithTimeInterval:0.01 target:self selector:@selector(timerFired:) userInfo:nil repeats:YES];
    [_timer setFireDate:[NSDate distantFuture]];
    _isTimer = NO;
}

- (void)setDataSource:(NSMutableArray *)dataSource{
    if (dataSource && ![dataSource isEqualToArray:_dataSource]) {
        [_dataSource removeAllObjects];
        [_dataSource addObjectsFromArray:dataSource];
        [_collectionView reloadData];
        if (_isTimer) {
            [self beginTimer];
        }
        if (_pageControl) {
            _pageControl.numberOfPages = _dataSource.count;
            _pageControl.currentPage = _num<_dataSource.count?_num:0;
        }
        if (_dataSource.count>1) {
            [_collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:1 inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:NO];
        }
    }
}

- (void)setTimerOffset:(float)timerOffset{
    if (timerOffset != 0) {
        _timerOffset = timerOffset;
    }
}

- (void)setTimerInterval:(float)timerInterval{
    if (timerInterval >= 0) {
        _timerInterval = timerInterval;
    }
}
#pragma mark ----- init 【E】

#pragma mark ----- NSTimer 【S】
- (void)letTimerRun{
    _isTimer = YES;
    [self beginTimer];
}

- (void)letTimerStop{
    [self endTimer];
    _isTimer = NO;
}

- (void)beginTimer{
    if (_isTimer) {
        [_timer setFireDate:[NSDate dateWithTimeIntervalSinceNow:_timerInterval]];
    }
}

- (void)endTimer{
    if (_isTimer) {
        [_timer setFireDate:[NSDate distantFuture]];
    }
}

- (void)timerFired:(NSTimer *)timer{
    
    if (_dataSource.count > 1) {
        if (_collectionView.contentOffset.x >= _collectionView.bounds.size.width * 2
            ||
            _collectionView.contentOffset.x <= 0) {
            _num = _collectionView.contentOffset.x>0?[self next:_num]:[self prior:_num];
            [self toMiddleWithcollectionView:_collectionView];
            [self beginTimer];
        }else {
            CGPoint point =  _collectionView.contentOffset;
            point.x += _timerOffset;
            _collectionView.contentOffset = point;
        }
    }
}
#pragma mark ----- NSTimer 【E】

#pragma mark ----- UIPageControl 【S】
- (void)letPageControlRun{
    _pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, _collectionView.bounds.size.height - 20, _collectionView.bounds.size.width, 20)];
    _pageControl.numberOfPages = _dataSource.count;
    _pageControl.currentPage = _num<_dataSource.count?_num:0;
    _pageControl.hidesForSinglePage = YES;
    _pageControl.backgroundColor = [UIColor colorWithWhite:0 alpha:0.3];
    [_pageControl addTarget:self action:@selector(pageControlChanged:) forControlEvents:UIControlEventValueChanged];
    [_rollView addSubview:_pageControl];
    [_rollView bringSubviewToFront:_pageControl];
}

- (void)pageControlChanged:(UIPageControl *)pageControl{
    _num = pageControl.currentPage;
    [self toMiddleWithcollectionView:_collectionView];
    [self beginTimer];
}
#pragma mark ----- UIPageControl 【E】

#pragma mark ----- number 【S】
- (NSInteger)prior:(NSInteger)num{
    if (num == 0) {
        return _dataSource.count?_dataSource.count-1:0;
    }else {
        return num - 1;
    }
}

- (NSInteger)next:(NSInteger)num{
    if (num == _dataSource.count - 1) {
        return 0;
    }else {
        return _dataSource.count?num+1:0;
    }
}
#pragma mark ----- number 【E】

#pragma mark ----- UICollectionView 【S】
#pragma mark -- UICollectionViewDataSource
//定义展示的Section的个数
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

//定义展示的UICollectionViewCell的个数
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _dataSource.count>1?3:_dataSource.count;
}

//每个UICollectionView展示的内容
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cellid" forIndexPath:indexPath];
    
    switch (indexPath.item) {
        case 0:
            [self cell:cell num:[self prior:_num]];
            break;
        case 1:
            [self cell:cell num:_num];
            break;
        case 2:
            [self cell:cell num:[self next:_num]];
            break;
            
        default:
            break;
    }
    
    return cell;
}

- (void)cell:(UICollectionViewCell *)cell num:(NSInteger)num{
    if (![cell.backgroundView isKindOfClass:[UIImageView class]]) {
        cell.backgroundView = [[UIImageView alloc]init];
    }
    id image = _dataSource[num];
    if (_cellImageViewBlock&&_cellImageViewBlock((id)cell.backgroundView, image, cell.contentView, num)) {
        
    }else {
        [(id)cell.backgroundView setImage:[image isKindOfClass:[UIImage class]]?image:[image image]];
//        [(id)cell.backgroundView sd_setImageWithURL:[NSURL URLWithString:[image slide_img_url]] placeholderImage:[UIImage imageNamed:PLACEHOLDER_IMG]];
    }
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return collectionView.bounds.size;
}

#pragma mark --UICollectionViewDelegate
//UICollectionView被选中时调用的方法
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (_selectBlock) {
        _selectBlock(_num);
    }
}

//返回这个UICollectionView是否可以被选择
-(BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (void)toMiddleWithcollectionView:(UICollectionView *)collectionView{
    
    NSInteger num = _num;
    switch (_dataSource.count) {
        default:
        {
            UICollectionViewCell * cell2 = [collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:2 inSection:0]];
            [self cell:cell2 num:[self next:num]];
            UICollectionViewCell * cell1 = [collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:1 inSection:0]];
            [self cell:cell1 num:num];
        }
            
        case 1:
        {
            UICollectionViewCell * cell0 = [collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:0]];
            [self cell:cell0 num:[self prior:num]];
        }
        case 0:
            ;
    }
    
    if (_pageControl) {
        _pageControl.currentPage = num;
    }
    
    if (_dataSource.count>1) {
        [collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:1 inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:NO];
    }
}

- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView{
    if (_isScrollWithSign) {
        _contentOffsetX = scrollView.contentOffset.x;
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    UICollectionView * collectionView = (id)scrollView;
    
    if (collectionView.contentOffset.x >= collectionView.bounds.size.width * 3 / 2) {
        _num = [self next:_num];
    }else if (collectionView.contentOffset.x <= collectionView.bounds.size.width / 2) {
        _num = [self prior:_num];
    }
    
    if (_isScrollWithSign) {
        if (collectionView.contentOffset.x >= _contentOffsetX) {
            if (_timerOffset<0) {
                _timerOffset = -_timerOffset;
            }
        }else{
            if (_timerOffset>0) {
                _timerOffset = -_timerOffset;
            }
        }
    }
    
    [self toMiddleWithcollectionView:collectionView];
    
    [self beginTimer];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    if (_pageControl) {
        UICollectionView * collectionView = (id)scrollView;
        
        if (collectionView.contentOffset.x >= collectionView.bounds.size.width * 3 / 2) {
            _pageControl.currentPage = [self next:_num];
        }else if (collectionView.contentOffset.x <= collectionView.bounds.size.width / 2) {
            _pageControl.currentPage = [self prior:_num];
        }else {
            _pageControl.currentPage = _num;
        }
    }
}
#pragma mark ----- UICollectionView 【E】

@end
