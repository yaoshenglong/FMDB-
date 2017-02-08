//
//  Student.h
//  FMDB测试
//
//  Created by 姚胜龙 on 17/2/7.
//  Copyright © 2017年 姚胜龙. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Student : NSObject

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *sex;
@property (nonatomic, assign) NSInteger age;
@property (nonatomic, strong) NSString *score;
@property (nonatomic, strong) NSString *studentId;

@end
