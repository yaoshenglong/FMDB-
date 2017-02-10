//
//  JWScrollView
//  yiapp
//
//  Created by yi23 on 15/12/2.
//  Copyright © 2015年 yi23. All rights reserved.
//


#import "JWScrollView.h"
#import "NSTimer+Addition.h"
#import "RectExt.h"
@interface JWScrollView () <UIScrollViewDelegate>

@property (nonatomic , strong) NSMutableArray *contentViews;


@property (nonatomic , strong) NSTimer *animationTimer;
@property (nonatomic , assign) NSTimeInterval animationDuration;

@property (nonatomic) CGPoint scrollViewStartPosPoint;
@property (nonatomic) int     scrollDirection;
@end

@implementation JWScrollView

- (void)setTotalPagesCount:(NSInteger (^)(void))totalPagesCount
{
    
    self.currentPageIndex = 0;
    _totalPageCount = totalPagesCount();
    if (_totalPageCount > 0) {
        if (self.isnumberPage==YES) {
            _pageControl.hidden = YES;
        }
        if (self.isnumberPage==YES) {
            _numberPageLabel.hidden = NO;
        }
        else{
            _numberPageLabel.hidden = YES;
        }
        if (_totalPageCount > 1) {
            self.scrollView.scrollEnabled = YES;
        }
        else {
            self.scrollView.scrollEnabled = NO;
        }
        _pageControl.numberOfPages = (int)self.totalPageCount ;
        _numberPageLabel.text = [NSString stringWithFormat:@"%d/%ld",1,(long)_totalPageCount];
        [self configContentViews];
        [self.animationTimer resumeTimerAfterTimeInterval:self.animationDuration];
    }
}

- (id)initWithFrame:(CGRect)frame animationDuration:(NSTimeInterval)animationDuration
{
    self = [self initWithFrame:frame];
    if (animationDuration > 0.0) {
        self.animationTimer = [NSTimer scheduledTimerWithTimeInterval:(self.animationDuration = animationDuration)
                                                               target:self
                                                             selector:@selector(animationTimerDidFired:)
                                                             userInfo:nil
                                                              repeats:YES];
        [self.animationTimer pauseTimer];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.autoresizesSubviews = YES;
        self.scrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
        self.scrollView.autoresizingMask = 0xFF;
        self.scrollView.contentMode = UIViewContentModeCenter;
        self.scrollView.contentSize = CGSizeMake(3 * CGRectGetWidth(self.scrollView.frame), CGRectGetHeight(self.scrollView.frame));
        self.scrollView.delegate = self;
        self.scrollView.contentOffset = CGPointMake(CGRectGetWidth(self.scrollView.frame), 0);
        self.scrollView.pagingEnabled = YES;
        [self addSubview:self.scrollView];
        self.currentPageIndex = 0;
        _pageControl = [[StyledPageControl alloc] initWithFrame:CGRectMake(([UIScreen mainScreen].bounds.size.width -150)/2, self.bottom - 20, 150, 20)];
        [_pageControl setPageControlStyle:PageControlStyleStrokedCircle];
        [self addSubview:_pageControl];
    }
    return self;
}
- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        self.autoresizesSubviews = YES;
        self.scrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
        self.scrollView.autoresizingMask = 0xFF;
        self.scrollView.contentMode = UIViewContentModeCenter;
        self.scrollView.contentSize = CGSizeMake(3 * CGRectGetWidth(self.scrollView.frame), CGRectGetHeight(self.scrollView.frame));
        self.scrollView.delegate = self;
        self.scrollView.contentOffset = CGPointMake(CGRectGetWidth(self.scrollView.frame), 0);
        self.scrollView.pagingEnabled = YES;
        [self addSubview:self.scrollView];
        self.currentPageIndex = 0;
        _pageControl = [[StyledPageControl alloc] initWithFrame:CGRectMake(([UIScreen mainScreen].bounds.size.width-150)/2, self.bottom - 20, 150, 20)];
        [_pageControl setPageControlStyle:PageControlStyleStrokedCircle];
        [self addSubview:_pageControl];

    }
    return self;
}
- (void)xibinitself {
    
    self.autoresizesSubviews = YES;
    self.scrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
    self.scrollView.autoresizingMask = 0xFF;
    self.scrollView.showsHorizontalScrollIndicator = NO;
    self.scrollView.directionalLockEnabled = YES;
    self.scrollView.contentMode = UIViewContentModeCenter;
    self.scrollView.contentSize = CGSizeMake(3 * CGRectGetWidth(self.scrollView.frame), CGRectGetHeight(self.scrollView.frame));
    self.scrollView.showsVerticalScrollIndicator = false;
    self.scrollView.delegate = self;
    self.scrollView.contentOffset = CGPointMake(CGRectGetWidth(self.scrollView.frame), 0);
    self.scrollView.pagingEnabled = YES;
    self.scrollView.backgroundColor = [UIColor whiteColor];
    [self addSubview:self.scrollView];
    self.currentPageIndex = 0;
    _pageControl = [[StyledPageControl alloc] initWithFrame:CGRectMake(([UIScreen mainScreen].bounds.size.width-150)/2, self.bottom - 20, 150, 20)];
    [_pageControl setPageControlStyle:PageControlStyleStrokedCircle];
    [self addSubview:_pageControl];
}

- (NSInteger)getValidNextPageIndexWithPageIndex:(NSInteger)currentPageIndex;
{
    if(currentPageIndex == -1) {
        
        return self.totalPageCount - 1;
        
    } else if (currentPageIndex == self.totalPageCount) {
        return 0;
    } else {
        return currentPageIndex;
    }
}



- (void)configContentViews
{
    _pageControl.currentPage = (int)_currentPageIndex;
    [self.scrollView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    [self setScrollViewContentDataSource];
//------------------------------------------------
    NSInteger counter = 0;

    for (UIView *contentView in self.contentViews) {
        contentView.userInteractionEnabled = YES;
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(contentViewTapAction:)];
        [contentView addGestureRecognizer:tapGesture];
        CGRect rightRect = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
        rightRect.origin = CGPointMake(((CGRectGetWidth(self.scrollView.frame)) * counter++), 0);
        contentView.frame = rightRect;
        [self.scrollView addSubview:contentView];
    }
    [_scrollView setContentOffset:CGPointMake(_scrollView.frame.size.width, 0)];
}

/**
 *  设置scrollView的content数据源，即contentViews
 */
- (void)setScrollViewContentDataSource
{
    NSInteger previousPageIndex = [self getValidNextPageIndexWithPageIndex:self.currentPageIndex - 1];
    NSInteger rearPageIndex = [self getValidNextPageIndexWithPageIndex:self.currentPageIndex + 1];
    if (self.contentViews == nil) {
        self.contentViews = [@[] mutableCopy];
    }
    [self.contentViews removeAllObjects];
    UIView *view1 = [[UIView alloc] initWithFrame:CGRectZero];
    UIView *view2 = [[UIView alloc]initWithFrame:CGRectZero];
    UIView *view3 = [[UIView alloc]initWithFrame:CGRectZero];
    if (self.fetchContentViewAtIndex!=nil) {
        view1 = self.fetchContentViewAtIndex(previousPageIndex);
        view2 = self.fetchContentViewAtIndex(_currentPageIndex);
        view3 =  self.fetchContentViewAtIndex(rearPageIndex);
    }
    [self.contentViews addObject:view1];
    [self.contentViews addObject:view2];
    [self.contentViews addObject:view3];
}


#pragma mark -
#pragma mark - UIScrollViewDelegate

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    self.scrollViewStartPosPoint = scrollView.contentOffset;
    self.scrollDirection = 0;
    [self.animationTimer pauseTimer];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (decelerate) {
        self.scrollDirection =0;
    }
    [self.animationTimer resumeTimerAfterTimeInterval:self.animationDuration];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView.contentOffset.y>0||scrollView.contentOffset.y<0) {
        self.scrollView.userInteractionEnabled = NO;
    }
    else{
        self.scrollView.userInteractionEnabled = YES;
    }
    if (self.scrollDirection == 0){//we need to determine direction
        //use the difference between positions to determine the direction.
        if (abs((int)(self.scrollViewStartPosPoint.x-scrollView.contentOffset.x))<
            abs((int)(self.scrollViewStartPosPoint.y-scrollView.contentOffset.y))){
            //Vertical Scrolling
            self.scrollDirection = 1;
        } else {
            //Horitonzal Scrolling
            self.scrollDirection = 2;
        }
    }
    //Update scroll position of the scrollview according to detected direction.
    if (self.scrollDirection == 1) {
        scrollView.contentOffset = CGPointMake(self.scrollViewStartPosPoint.x,scrollView.contentOffset.y);
    } else if (self.scrollDirection == 2){
        scrollView.contentOffset = CGPointMake(scrollView.contentOffset.x,self.scrollViewStartPosPoint.y);
    }
    
    int contentOffsetX = scrollView.contentOffset.x;
    if(contentOffsetX >= ( 2 * CGRectGetWidth(scrollView.frame))) {
        self.currentPageIndex = [self getValidNextPageIndexWithPageIndex:self.currentPageIndex + 1];
//        NSLog(@"next，当前页:%ld",self.currentPageIndex);
        [self configContentViews];

    }
    if(contentOffsetX <= 0) {
        self.currentPageIndex = [self getValidNextPageIndexWithPageIndex:self.currentPageIndex - 1];
//     NSLog(@"previous，当前页:%ld",self.currentPageIndex);
        [self configContentViews];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    self.scrollDirection =0;
    [scrollView setContentOffset:CGPointMake(CGRectGetWidth(scrollView.frame), 0) animated:YES];
}

#pragma mark -
#pragma mark - 响应事件

- (void)animationTimerDidFired:(NSTimer *)timer
{
    CGPoint newOffset = CGPointMake(self.scrollView.contentOffset.x + CGRectGetWidth(self.scrollView.frame), self.scrollView.contentOffset.y);
    [self.scrollView setContentOffset:newOffset animated:YES];
}

- (void)contentViewTapAction:(UITapGestureRecognizer *)tap
{
    if (self.TapActionBlock) {
        self.TapActionBlock(self.currentPageIndex);
    }
}





- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event]; // always forward touchesBegan -- there's no way to forward it later
    //    if (_isHorizontalScroll)
    //        return; // UIScrollView is in charge now
    //    if ([touches count] == [[event touchesForView:self] count]) { // initial touch
    //        _originalPoint = [[touches anyObject] locationInView:self];
    //        _currentChild = [self honestHitTest:_originalPoint withEvent:event];
    //        _isMultitouch = NO;
    //    }
    //    _isMultitouch |= ([[event touchesForView:self] count] > 1);
    //    [_currentChild touchesBegan:touches withEvent:event];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    [super touchesMoved:touches withEvent:event];
    //    if (!_isHorizontalScroll && !_isMultitouch) {
    //        CGPoint point = [[touches anyObject] locationInView:self];
    //        if (fabsf(_originalPoint.x - point.x) > kThresholdX && fabsf(_originalPoint.y - point.y) < kThresholdY) {
    //            _isHorizontalScroll = YES;
    //            [_currentChild touchesCancelled:[event touchesForView:self] withEvent:event]
    //        }
    //    }
    //    if (_isHorizontalScroll)
    //        [super touchesMoved:touches withEvent:event]; // UIScrollView only kicks in on horizontal scroll
    //    else
    //        [_currentChild touchesMoved:touches withEvent:event];
}

@end
