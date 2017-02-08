//
//  StudentManager.m
//  FMDB测试
//
//  Created by 姚胜龙 on 17/2/7.
//  Copyright © 2017年 姚胜龙. All rights reserved.
//

#import "StudentManager.h"
#import "Student.h"
#import "FMDB.h"

static NSString *const kStudentDB = @"Students.sqlite";
static NSString *const kStudentTable = @"student";

@interface StudentManager ()

@property (nonatomic, copy) NSString *dbPathName;
@property (nonatomic, strong) FMDatabase *database;

@end

@implementation StudentManager

+ (StudentManager *)shareManager {
    static StudentManager *shareManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shareManager = [[StudentManager alloc] init];
    });
    return shareManager;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        NSInteger status = [self initStudentDBWithDBName:kStudentDB];
        if (status == -1) {
            //失败
            NSLog(@"database name 为空");
        }
        else {
            //创建数据库 或者 已经存在
        }
    }
    return self;
}

//初始化数据库
- (NSInteger)initStudentDBWithDBName:(NSString *)dbName {
    if (!dbName) {
        NSLog(@"数据库名称为空");
        return -1;//初始化数据库失败
    }
    //将数据库保存在沙盒路径下
    NSString *documentPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];;
    self.dbPathName = [documentPath stringByAppendingFormat:@"/%@", dbName];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL isExist = [fileManager fileExistsAtPath:self.dbPathName];
    [self connectDB];
    if (!isExist) {
        NSLog(@"need create database");
        return 0;//不存在需要创建
    }
    else {
        NSLog(@"database is exist");
        return 1;//已经存在
    }
}

//连接数据库
- (void)connectDB {
    if (!_database) {
        //创建
        _database = [[FMDatabase alloc] initWithPath:self.dbPathName];
    }
    if (![_database open]) {
        NSLog(@"打开数据库失败");
    }
}

//关闭数据库
- (void)closeDB {
    BOOL isClose = [_database close];
    if (isClose) {
        NSLog(@"关闭成功");
    }
}

//创建数据库
- (void)createDatabase {
    //查找数据库所有的表 并且表的名称为 kStudentDB的数据库
    NSString *query = [NSString stringWithFormat:@"select count(*) from sqlite_master where type = 'table' and name = %@", kStudentTable];
    FMResultSet *resultSet = [self.database executeQuery:query];
    [resultSet next];
    NSInteger count = [resultSet intForColumnIndex:0];
    //对count进行bool转化
    BOOL existTable = !!count;
    if (existTable) {
        //数据表已经存在 是否更新数据库
        NSLog(@"数据库已经存在");
    } else {
        //插入新的数据库 @"CREATE TABLE IF NOT EXISTS t_student (id integer PRIMARY KEY AUTOINCREMENT, name text NOT NULL, age integer NOT NULL);"
        NSString *sqlString = @"CREATE TABLE IF NOT EXISTS student (id integer PRIMARY KEY AUTOINCREMENT NOT NULL, student_id text NOT NULL, stu_name VARCHAR(20), stu_score VARCHAR(20))";
        BOOL result = [self.database executeUpdate:sqlString];
        if (!result) {
            NSLog(@"数据表创建失败");
        }
        else {
            NSLog(@"数据表创建成功");
        }
    }
}

//删除某个学生
- (void)deleteStudentWithStudentId:(NSString *)studentId {
    [self.database open];
    NSString *sqlQuery = [NSString stringWithFormat:@"DELETE FROM student WHERE student_id=%@", studentId];
    BOOL result = [self.database executeUpdate:sqlQuery];
    if (result) {
        NSLog(@"从数据库删除学生成功!");
    }
    [self.database close];
}

//插入某个学生
- (void)insertStudent:(Student *)student {
    [self.database open];
    NSMutableString *sqlQuery = [NSMutableString stringWithFormat:@"INSERT INTO student (student_id, stu_name, stu_score) VALUES(?,?,?)"];
    NSString *stuId = [NSString stringWithFormat:@"%@", student.studentId];
    NSLog(@"student = %@ %@ %@", student.name, stuId, student.score);
    BOOL result = [self.database executeUpdate:sqlQuery withArgumentsInArray:@[stuId,student.name, student.score]];
//    BOOL result = [self.database executeUpdate:sqlQuery, student.studentId, student.name, student.score];
    if (result) {
        NSLog(@"inser student succeed!");
        [self.database close];
    }
    else {
        NSLog(@"inser student failure!");
        [self.database close];
    }
}

//添加某个学生Id
- (void)addStudentWithStudentId:(NSString *)studentId {
    [self.database open];
    NSMutableString *query = [NSMutableString stringWithFormat:@"INSERT INTO student"];
    NSMutableString *keys = [NSMutableString stringWithFormat:@" ("];
    NSMutableString *values = [NSMutableString stringWithFormat:@" ( "];
    NSMutableArray *arrguments = [NSMutableArray array];
    if (studentId) {
        [keys appendString:@"student_id,"];
        [values appendString:@"?,"];
        [arrguments addObject:studentId];
    }
    [keys appendString:@")"];
    [values appendString:@")"];
    [query appendFormat:@" %@ VALUES %@", [keys stringByReplacingOccurrencesOfString:@",)" withString:@")"], [values stringByReplacingOccurrencesOfString:@",)" withString:@")"]];
    NSLog(@"query = %@", query);
    [self.database executeUpdate:query withArgumentsInArray:arrguments];
    [self.database close];
}

//清空全部数据
- (void)clearAllStudents {
    [self.database open];
    NSString *query = @"DELETE FROM student";
    BOOL result = [self.database executeUpdate:query];
    if (result) {
        NSLog(@"删除所有学生成功");
    }
    else {
         NSLog(@"删除所有学生失败");
    }
    [self.database close];
}

//查询所有的学生
- (NSMutableArray *)findAllStudents {
    [self.database open];
    NSString *sqlString = @"SELECT student_id, stu_name, stu_score FROM student";
    FMResultSet *resultSet = [self.database executeQuery:sqlString];
    NSMutableArray *array = [NSMutableArray array];
    while ([resultSet next]) {
        Student *stu = [Student new];
        stu.studentId = [resultSet stringForColumn:@"student_id"];
        stu.name = [resultSet stringForColumn:@"stu_name"];
        stu.score = [resultSet stringForColumn:@"stu_score"];
        [array addObject:stu];
    }
    [resultSet close];
    [self.database close];
    return array;
}

//查询某一个学生
- (NSArray *)findStudentWithId:(NSString *)studentId {
    [self.database open];
    NSString *sqlQuery = [NSString stringWithFormat:@"SELECT student_id FROM student WHERE student_id = %@", studentId];
    FMResultSet *resultSet = [self.database executeQuery:sqlQuery];
    NSMutableArray *array = [NSMutableArray array];
    while ([resultSet next]) {
        Student *stu = [Student new];
        stu.studentId = [resultSet stringForColumn:@"student_id"];
        [array addObject:stu];
    }
    [resultSet close];
    [self.database close];
    return array;
}

//判断这个学生是否已经存在
- (BOOL)isStudentExist:(NSString *)studentId {
    [self.database open];
    if ([self findStudentWithId:studentId].count > 0) {
        [self.database close];
        return YES;
    } else {
        [self.database close];
        return NO;
    }
}

@end
