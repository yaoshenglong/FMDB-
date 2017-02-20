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

//因为在很多地方都需要用到，在这里我使用单利设计
+ (StudentManager *)shareManager;
//创建数据库
- (void)createDatabase;
//添加学生，传入的是学生对象
- (void)insertStudent:(Student *)student;
//添加学生，这里传入的是学生的ID
- (void)addStudentWithStudentId:(NSString *)studentId;
//通过学生的ID删除某一个学生
- (void)deleteStudentWithStudentId:(NSString *)studentId;
//根据某个ID查询该学生是否存在
- (NSArray *)findStudentWithId:(NSString *)studentId;
//这个主要是添加学生的时候，判断这个学生是否已经存在
- (BOOL)isStudentExist:(NSString *)studentId;
//查询所有的学生，并返回
- (NSMutableArray *)findAllStudents;
// 删除所有的学生
- (void)clearAllStudents;

@end
