//
//  JWScrollView.h
//  yiapp
//
//  Created by yi23 on 15/12/2.
//  Copyright © 2015年 yi23. All rights reserved.
//


#import <UIKit/UIKit.h>
#import "StyledPageControl.h"

@interface JWScrollView : UIView

@property (nonatomic , strong) UIScrollView *scrollView;
@property (nonatomic , readonly) StyledPageControl *pageControl;
@property (nonatomic , assign) BOOL isnumberPage;
@property (nonatomic , strong) UILabel *numberPageLabel;
@property (nonatomic , assign) NSInteger totalPageCount;

/**
 *  初始化
 *
 *  @param frame             frame
 *  @param animationDuration 自动滚动的间隔时长。如果<=0，不自动滚动。
 *
 *  @return instance
 */
- (id)initWithFrame:(CGRect)frame animationDuration:(NSTimeInterval)animationDuration;
- (void)xibinitself;
/**
 数据源：获取总的page个数
 **/
@property (nonatomic , copy) NSInteger (^totalPagesCount)(void);
/**
 数据源：获取第pageIndex个位置的contentView
 **/
@property (nonatomic , copy) UIView *(^fetchContentViewAtIndex)(NSInteger pageIndex);
/**
 当点击的时候，执行的block
 **/
@property (nonatomic , copy) void (^TapActionBlock)(NSInteger pageIndex);

@property (nonatomic , assign) NSInteger currentPageIndex;

@end