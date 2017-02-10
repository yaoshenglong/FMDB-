//
//  TagItemView.m
//  FMDB测试
//
//  Created by 姚胜龙 on 17/2/10.
//  Copyright © 2017年 姚胜龙. All rights reserved.
//

#import "TagItemView.h"

@implementation TagItemView

- (instancetype)initWithReusableIdentifier:(NSString *)identifier {
    self = [super init];
    if (self) {
        //重用标示符
        self.reuserIdentifier = identifier;
        self.backgroundColor = [UIColor orangeColor];
    }
    return self;
}

@end
