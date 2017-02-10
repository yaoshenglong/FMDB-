//
//  DYImageTagView.h
//  FMDB测试
//
//  Created by 姚胜龙 on 17/2/10.
//  Copyright © 2017年 姚胜龙. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, ViewStatus) {
    ViewStatusHidden = 0, //影藏
    ViewStatusShow        //显示
};

@interface DYImageTagView : UIView

@property (nonatomic, copy) void (^viewStatus)(ViewStatus *status);
@property (nonatomic, assign) CGPoint locationPoint;//位置

- (instancetype)initWithMessage:(NSString *)message isLeft:(BOOL)isLeft;

- (void)startViewFlicker;
- (void)stopViewFlicker;

@end
