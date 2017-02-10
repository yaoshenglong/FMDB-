//
//  DYTagsForImageView.h
//  FMDB测试
//
//  Created by 姚胜龙 on 17/2/10.
//  Copyright © 2017年 姚胜龙. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Constants.h"
#import "TagItemView.h"

@class DYTagsForImageView;
@protocol  DYTagsForImageViewDataSource<NSObject>

@required
- (NSInteger)numberOfItemInView:(DYTagsForImageView *)view;
- (TagItemView *)itemAtView:(DYTagsForImageView *)view itemForViewAtIndex:(NSInteger)index;

@end

@interface DYTagsForImageView : UIView

@property (nonatomic, weak) id<DYTagsForImageViewDataSource> dataSource;

- (id)dequeueReusableItemWithIdentifer:(NSString *)identifer;

@end
