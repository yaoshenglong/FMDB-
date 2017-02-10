//
//  DYTagsViewManager.m
//  FMDB测试
//
//  Created by 姚胜龙 on 17/2/10.
//  Copyright © 2017年 姚胜龙. All rights reserved.
//

#import "DYTagsViewManager.h"
#import "DYImageTagView.h"

@interface DYTagsViewManager ()

@property (nonatomic, strong) NSMutableArray *messages;
@property (nonatomic, strong) NSMutableArray *tagViews;
@property (nonatomic, strong) NSMutableArray *dataSource;

@property (nonatomic, assign) BOOL isHidden;

@end

@implementation DYTagsViewManager

- (instancetype)init {
    self = [super init];
    if (self) {
        self.isHidden = NO;
    }
    return self;
}

- (void)showTagView {
    if (!self.isHidden) {
        return;
    }
    self.isHidden = YES;
}

- (void)hiddenTagView {

}

@end
