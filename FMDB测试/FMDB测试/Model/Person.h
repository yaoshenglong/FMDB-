//
//  Person.h
//  FMDB测试
//
//  Created by 姚胜龙 on 16/7/25.
//  Copyright © 2016年 姚胜龙. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Person : NSObject

@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *sex;
@property (nonatomic, assign) NSInteger age;
@property (nonatomic, strong) NSNumber *personId;

@end
