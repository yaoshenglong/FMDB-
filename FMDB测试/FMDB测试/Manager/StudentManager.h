//
//  StudentManager.h
//  FMDB测试
//
//  Created by 姚胜龙 on 17/2/7.
//  Copyright © 2017年 姚胜龙. All rights reserved.
//

#import <Foundation/Foundation.h>
@class Student;
@interface StudentManager : NSObject

+ (StudentManager *)shareManager;
//创建数据库
- (void)createDatabase;

- (void)insertStudent:(Student *)student;
- (void)addStudentWithStudentId:(NSString *)studentId;
- (void)deleteStudentWithStudentId:(NSString *)studentId;
- (NSArray *)findStudentWithId:(NSString *)studentId;
- (BOOL)isStudentExist:(NSString *)studentId;
- (NSMutableArray *)findAllStudents;

- (void)clearAllStudents;

@end
