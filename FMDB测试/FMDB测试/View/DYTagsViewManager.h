//
//  DYTagsViewManager.h
//  FMDB测试
//
//  Created by 姚胜龙 on 17/2/10.
//  Copyright © 2017年 姚胜龙. All rights reserved.
//

#import <Foundation/Foundation.h>

@class DYImageTagView;
@interface DYTagsViewManager : NSObject

@property (nonatomic, copy) void(^tagViewBlock)(DYImageTagView *tagView);

- (void)showTagView;
- (void)hiddenTagView;

@end
