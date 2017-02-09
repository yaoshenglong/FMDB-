//
//  DYCustomTagView.m
//  yiapp
//
//  Created by 姚胜龙 on 17/2/9.
//  Copyright © 2017年 yi23. All rights reserved.
//

#import "DYCustomTagView.h"
#import "UIView+DYCircleAnimation.h"
#import "Constants.h"

static CGFloat padding = 5.0;
static CGFloat headImgWidth = 11.5;
static CGFloat viewHeight = 23.0;
static CGFloat circleRedius = 11.5;

@interface DYCustomTagView ()

@property (nonatomic, strong) UILabel *textLabel;
@property (nonatomic, strong) UIImageView *triangleHeadImgView;//头部三角形
@property (nonatomic, strong) UIImageView *circleImgView;//圆点
@property (nonatomic, strong) NSTimer *timer;

@end

@implementation DYCustomTagView

- (void)dealloc {
    _timer = nil;
}

- (instancetype)initWithMessage:(NSString *)message
            direction:(TriangleHeadDirection)direction
         withPosition:(CGPoint)position
{
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor clearColor];//RGBACOLOR(0, 0, 0, 0.4);
        //计算宽度
        NSDictionary *dic = @{NSFontAttributeName : [UIFont systemFontOfSize:12]};
        CGFloat width = [message sizeWithAttributes:dic].width + 2 * padding;
        self.textLabel.text = message;
        self.circleImgView.image = [UIImage imageNamed:@"tag_circle"];
         //label
        if (direction == TriangleHeadDirectionLeft) {
            self.triangleHeadImgView.image = [UIImage imageNamed:@"tag_head"];
            self.frame = CGRectMake((position.x - width - headImgWidth), (position.y - circleRedius), (width + headImgWidth + circleRedius), viewHeight);
            self.circleImgView.frame = CGRectMake(width, 0, circleRedius * 2, circleRedius * 2);
            self.textLabel.frame = CGRectMake(0, 0, width, viewHeight);
            //imgView
            self.triangleHeadImgView.frame = CGRectMake(width, 0, headImgWidth, viewHeight);
            [self bringSubviewToFront:self.triangleHeadImgView];
        }
        else {
            self.triangleHeadImgView.image = [UIImage imageNamed:@"tag_head_left"];
            self.frame = CGRectMake((position.x - circleRedius), (position.y - circleRedius), (width + headImgWidth + circleRedius), viewHeight);
            self.circleImgView.frame = CGRectMake(0, 0, circleRedius * 2, circleRedius * 2);
            self.textLabel.frame = CGRectMake((circleRedius + headImgWidth), 0, width, viewHeight);
            //imgView
            self.triangleHeadImgView.frame = CGRectMake(circleRedius, 0, headImgWidth, viewHeight);
            [self bringSubviewToFront:self.triangleHeadImgView];
        }
    }
    self.circleImgView.layer.cornerRadius = circleRedius;
    self.circleImgView.layer.masksToBounds = YES;
    _timer =  [NSTimer scheduledTimerWithTimeInterval:2.0 target:self selector:@selector(showMoireAnimation:) userInfo:nil repeats:YES];
    return self;
}

#pragma mark - Action
- (void)showMoireAnimation:(NSTimer *)timer {
    [self.circleImgView showCircleAnimationLayerWithColor:kColor(0, 0, 0, .2) andScale:1.5f];
}

#pragma mark - Properity get methods

- (UILabel *)textLabel {
    if (!_textLabel) {
        _textLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _textLabel.font = [UIFont systemFontOfSize:12];
        _textLabel.textAlignment = NSTextAlignmentCenter;
        _textLabel.textColor = [UIColor whiteColor];
        _textLabel.backgroundColor = kColor(0, 0, 0, 0.5);
        _textLabel.userInteractionEnabled = YES;
        [self addSubview:_textLabel];
    }
    return _textLabel;
}

- (UIImageView *)triangleHeadImgView {
    if (!_triangleHeadImgView) {
        _triangleHeadImgView = [[UIImageView alloc] initWithFrame:CGRectZero];
        _triangleHeadImgView.userInteractionEnabled = YES;
        _triangleHeadImgView.contentMode = UIViewContentModeScaleToFill;
        [self addSubview:_triangleHeadImgView];
    }
    return _triangleHeadImgView;
}

- (UIImageView *)circleImgView {
    if (!_circleImgView) {
        _circleImgView = [[UIImageView alloc] initWithFrame:CGRectZero];
        _circleImgView.userInteractionEnabled = YES;
        _circleImgView.contentMode = UIViewContentModeScaleToFill;
        [self addSubview:_circleImgView];
    }
    return _circleImgView;
}

@end
