//
//  TagItemView.h
//  FMDB测试
//
//  Created by 姚胜龙 on 17/2/10.
//  Copyright © 2017年 姚胜龙. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TagItemView : UIView

@property (nonatomic, strong) NSString *reuserIdentifier;//重用标示

- (instancetype)initWithReusableIdentifier:(NSString *)identifier;

@end
