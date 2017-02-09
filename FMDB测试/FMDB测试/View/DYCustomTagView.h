//
//  DYCustomTagView.h
//  yiapp
//
//  Created by 姚胜龙 on 17/2/9.
//  Copyright © 2017年 yi23. All rights reserved.
//  在图片上显示标签

//遇到的问题：1、这个打标签如果很长有可能超出屏幕 2、后台返回的数据必须告诉我 标签的方向和圆点中心坐标

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, TriangleHeadDirection) {
    TriangleHeadDirectionLeft = 10,
    TriangleHeadDirectionRight
};

typedef void(^TapTagBlock)(UITapGestureRecognizer *gesture, NSString *message);

@interface DYCustomTagView : UIView

- (instancetype)initWithMessage:(NSString *)message
                      direction:(TriangleHeadDirection)direction
                   withPosition:(CGPoint)position
                    tapTagBlock:(void(^)(UITapGestureRecognizer *gesture,NSString *message))tapCallBlock;

@end
