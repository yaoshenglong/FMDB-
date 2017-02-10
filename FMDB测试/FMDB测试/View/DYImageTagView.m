//
//  DYImageTagView.m
//  FMDB测试
//
//  Created by 姚胜龙 on 17/2/10.
//  Copyright © 2017年 姚胜龙. All rights reserved.
//

#import "DYImageTagView.h"
#import "UIView+DYCircleAnimation.h"
#import "Constants.h"

static CGFloat padding = 5.0;
static CGFloat viewHeight = 23.0;
static CGFloat diameter = 8.0;
static CGFloat triangleWidth = 12.0;
    
@interface DYImageTagView ()

@property (nonatomic, strong) UILabel *textLabel;
@property (nonatomic, strong) UIImageView *bgImgView;
@property (nonatomic, strong) UIImageView *dotImgView;

@property (nonatomic, strong) NSTimer *timer;//timer

@end

@implementation DYImageTagView

- (void)dealloc {
    if (_timer.isValid) {
        [_timer invalidate];
    }
    _timer = nil;
}

- (instancetype)initWithMessage:(NSString *)message isLeft:(BOOL)isLeft {
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor cyanColor];
        NSDictionary *dict = @{NSFontAttributeName : [UIFont systemFontOfSize:12]};
        CGFloat textWidth = [message sizeWithAttributes:dict].width;
        self.bounds = CGRectMake(0.0, 0.0, (textWidth + padding * 2 + diameter/2.0 + triangleWidth), viewHeight);
        self.textLabel.text = message;
        self.dotImgView.image = [UIImage imageNamed:@"tag_dot"];
        //Imgview
        if (isLeft) {
            self.bgImgView.image = [[UIImage imageNamed:@"tag_bg_left"] stretchableImageWithLeftCapWidth:25 topCapHeight:10];
            self.dotImgView.frame = CGRectMake(0.0, (viewHeight - diameter) / 2.0, diameter, diameter);
            self.bgImgView.frame = CGRectMake(diameter/2.0, 0, (CGRectGetWidth(self.frame) - diameter/2.0), viewHeight);
            self.textLabel.frame = CGRectMake((CGRectGetWidth(self.frame) - padding - textWidth), 0, textWidth, viewHeight);
        }
        else {
            self.bgImgView.image = [[UIImage imageNamed:@"tag_bg_right"] stretchableImageWithLeftCapWidth:25 topCapHeight:10];
            self.dotImgView.frame = CGRectMake((CGRectGetWidth(self.frame) - diameter), (viewHeight - diameter) / 2.0, diameter, diameter);
            self.bgImgView.frame = CGRectMake(0.0, 0.0, (CGRectGetWidth(self.frame) - diameter/2), viewHeight);
            self.textLabel.frame = CGRectMake( padding, 0.0, textWidth, viewHeight);
        }
    }
    return self;
}

- (void)startViewFlicker {
    _timer =  [NSTimer scheduledTimerWithTimeInterval:2.0 target:self selector:@selector(showMoireAnimation:) userInfo:nil repeats:YES];
}

- (void)stopViewFlicker {
    if (_timer.isValid) {
        [_timer invalidate];
    }
    [self removeFromSuperview];
}

- (void)showMoireAnimation:(NSTimer *)timer {
    [self.dotImgView showCircleAnimationLayerWithColor:kColor(0, 0, 0, .3) andScale:3.0f];
}

#pragma mark - 懒加载
- (UILabel *)textLabel {
    if (!_textLabel) {
        _textLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _textLabel.textColor = [UIColor whiteColor];
        _textLabel.font = [UIFont systemFontOfSize:12];
        _textLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_textLabel];
    }
    return _textLabel;
}

- (UIImageView *)bgImgView {
    if (!_bgImgView) {
        _bgImgView = [[UIImageView alloc] initWithFrame:CGRectZero];
        _bgImgView.userInteractionEnabled = YES;
        _bgImgView.contentMode = UIViewContentModeScaleAspectFill;
        [self addSubview:_bgImgView];
    }
    return _bgImgView;
}

- (UIImageView *)dotImgView {
    if (!_dotImgView) {
        _dotImgView = [[UIImageView alloc] initWithFrame:CGRectZero];
        _dotImgView.userInteractionEnabled = YES;
        _dotImgView.contentMode =UIViewContentModeScaleAspectFill;
        [self addSubview:_dotImgView];
    }
    return _dotImgView;
}

@end
