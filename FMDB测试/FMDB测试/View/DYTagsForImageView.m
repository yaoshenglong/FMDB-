//
//  DYTagsForImageView.m
//  FMDB测试
//
//  Created by 姚胜龙 on 17/2/10.
//  Copyright © 2017年 姚胜龙. All rights reserved.
//

#import "DYTagsForImageView.h"
#import "TagItemView.h"
#import "Constants.h"

#define MaxVelocity 1000
//static NSInteger kReusableItemCount = 3;

@interface DYTagsForImageView () {
    UITapGestureRecognizer *viewTapGesture;//单击手势
    //item 的大小
    CGSize itemSize;
    //圆点位置
    CGPoint circlePoint;
    // item的数量
    NSInteger itemCount;
    //item的下标值
    NSInteger currentIndex;
    //下一个item
    TagItemView *nextItem;

    //测试滑动手势
    UIPanGestureRecognizer *panGesture;
}

@property (nonatomic, strong) NSMutableSet *resuableItems;

@end

@implementation DYTagsForImageView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        viewTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewDidTap:)];
//        panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGesture:)];
        itemSize = frame.size;
        currentIndex = 0;
        [self addGestureRecognizer:viewTapGesture];
//        [self addGestureRecognizer:panGesture];
        self.backgroundColor = [UIColor redColor];
    }
    return self;
}

//从重用池获取itemTag
- (id)dequeueReusableItemWithIdentifer:(NSString *)identifer {
    __block TagItemView *reuseableItem = nil;
    [self.resuableItems enumerateObjectsUsingBlock:^(id  _Nonnull obj, BOOL * _Nonnull stop) {
        TagItemView *item = (TagItemView *)obj;
        if (item && [item.reuserIdentifier isEqualToString:identifer]) {
            reuseableItem = item;
            *stop = YES;
        }
    }];
    //如果成功找到了可重用的item 那么就要移除重用池中的item
    if (reuseableItem) {
        [self.resuableItems removeObject:reuseableItem];
    }
    NSLog(@"重用了");
    //返回item
    return reuseableItem;
}

//初始刷新页面
- (void)willMoveToSuperview:(UIView *)newSuperview {
    [super willMoveToSuperview:newSuperview];
    [self reloadData];
}

#pragma mark - privite methods
- (void)reloadData {
    itemCount = [self.dataSource numberOfItemInView:self];
    TagItemView *tagView = [self.dataSource itemAtView:self itemForViewAtIndex:0];
    [tagView setFrame:CGRectMake(100, 100, self.frame.size.width/3.0, self.frame.size.height/3.0)];
    NSLog(@"%@", tagView);
    [self addSubview:tagView];
}

#pragma mark - 懒加载
- (NSMutableSet *)resuableItems {
    if (!_resuableItems) {
        _resuableItems = [NSMutableSet set];
    }
    return _resuableItems;
}

#pragma mark - GestureRecognizer Action
- (void)viewDidTap:(UITapGestureRecognizer *)tapGesture {

    NSLog(@"点击了");

}
- (void)panGesture:(UIPanGestureRecognizer *)pan {
    //获取最上面的cell
    TagItemView *itemView = [self.subviews lastObject];
    // 获取拖拽过程中的手指坐标
    CGPoint touchedPoint = [pan locationInView:self];
    // 获取拖拽速度（每秒移动的像素，有 x方向和 y方向的分速度）
    CGPoint velocity = [pan velocityInView:self];
    // 记录最后拖拽结束时视图的移动方向，松手后让视图沿着此方向移动直到移动到屏幕外
    CGFloat swipeAngle = 0.0;
    // 监听拖拽状态，拖拽开始
    if (pan.state == UIGestureRecognizerStateBegan) {
        // 获取刚拖拽时手指触碰的坐标
        circlePoint = [pan locationInView:itemView];
        // 判断拖拽方向，是偏上还是偏下，用来判断下一个 cell显示上一条数据还是下一条数据（上翻还是下翻）
        // 如果偏上，获取上一条数据
        if (velocity.y < 0) {
            // 如果当前下标为 0，下一个 cell显示的还是第一条数据，否则数组越界crash
            // 此段代码可简化（按照下翻的情况下的处理）
            if (currentIndex == 0) {
                // 获取第一条数据
                nextItem = [self.dataSource itemAtView:self  itemForViewAtIndex:0];
                [nextItem setFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
                [self addSubview:nextItem];
                // 把 cell移动到最上面（可以自己体会效果，注释掉看看）
                [self bringSubviewToFront:itemView];
            } else {
                // 如果当前下标不为 0，获取上一条数据
                nextItem = [self.dataSource itemAtView:self itemForViewAtIndex:--currentIndex];
                [nextItem setFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
                [self addSubview:nextItem];
                // 把正在拖拽的视图移动到最上面，下一个 cell放下面
                [self bringSubviewToFront:itemView];
            }
        } else {
            // 如果当前下标对应最后一条数据
            if (currentIndex == itemCount - 1) {
                // 先对下标做“--”处理，然后获取数据的时候都统一做“++”操作，上面的上翻也可以这样简化
                currentIndex--;
            }
            // 下一个cell显示下一条数据，如果当前是最后一条数据，由于上面的判断做了“--”，所以这里直接“++”
            nextItem = [self.dataSource itemAtView:self itemForViewAtIndex:++currentIndex];
            [nextItem setFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
            [self addSubview:nextItem];
            // 把正在拖拽的视图移动到最上面，下一个 cell放下面
            [self bringSubviewToFront:itemView];
        }
    }
    [itemView setFrame:CGRectMake(touchedPoint.x - circlePoint.x, touchedPoint.y - circlePoint.y, itemView.frame.size.width, itemView.frame.size.height)];
    // 监听拖拽结束
    if (pan.state == UIGestureRecognizerStateEnded) {
        if (velocity.x) {
            // 获取拖拽结束时视图移动角度
            swipeAngle = atan(velocity.y / velocity.x);
        }
        // 判断视图拖拽结束时移动速度，如果速度快则翻页，否则不翻页，最上面的视图还是刚才拖拽的视图
        if (velocity.y > MaxVelocity || velocity.y < -MaxVelocity || velocity.x > MaxVelocity || velocity.x < -MaxVelocity) {
            // 翻页
            // 给视图加延时动画
            [UIView animateWithDuration:0.3f animations:^{
                // 判断移动方向
                if (velocity.y > 0) {
                    // 右下方向
                    if (velocity.x > 0) {
                        [itemView setCenter:CGPointMake(kWidth * 3 / 2.0f, kHeight / 2.0f + kWidth * tan(swipeAngle))];
                    } else {
                        // 左下方向
                        [itemView setCenter:CGPointMake(-kWidth / 2.0f, kHeight / 2.0f - kWidth * tan(swipeAngle))];
                    }
                } else {
                    // 右上方向
                    if (velocity.x > 0) {
                        [itemView setCenter:CGPointMake(kWidth * 3 / 2.0f, kHeight / 2.0f + kWidth * tan(swipeAngle))];
                    } else {
                        // 左上方向
                        [itemView setCenter:CGPointMake(-kWidth / 2.0f, kHeight / 2.0f - kWidth * tan(swipeAngle))];
                    }
                }
            } completion:^(BOOL finished) {
                // 动画结束时让当前的 cell从父视图中移除，并放进重用池
                [self.resuableItems addObject:itemView];
                [itemView removeFromSuperview];
            }];
        } else {
            // 不翻页
            [UIView animateWithDuration:0.3f animations:^{
                // 让当前视图回到原来的位置
                [itemView setFrame:CGRectMake(0, 0, itemView.frame.size.width, itemView.frame.size.height)];
                if (currentIndex) {
                    // 同时恢复当前视图数据的下标，可以考虑放到 block外（动画开始前，可以自己试试看）
                    if (velocity.y < 0) {
                        currentIndex--;
                    } else {
                        currentIndex++;
                    }
                }
            } completion:^(BOOL finished) {
                // 动画结束后，让刚才在下面显示的下一个 cell从父视图中移除，并放进重用池
                [self.resuableItems addObject:nextItem];
                [nextItem removeFromSuperview];
            }];
        }
    }

}

@end
