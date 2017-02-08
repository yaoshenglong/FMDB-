//
//  ViewController.m
//  FMDB测试
//
//  Created by 姚胜龙 on 16/7/25.
//  Copyright © 2016年 姚胜龙. All rights reserved.
//

#import "ViewController.h"
#import "Person.h"
#import "FMDB.h"
#import "StudentListController.h"
#import "StudentManager.h"
#import "Student.h"

@interface ViewController ()

@property (nonatomic, strong) NSString *fileName;
@property (nonatomic, strong) FMDatabase *studentDb;
@property (nonatomic, strong) NSMutableArray *students;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"FMDB联系";
}

//insert data 插入数据
- (void)insertStudents {

    for (int i = 0; i < 20; i ++) {
        Person *student = (Person *)_students[i];
//        NSString *name = [NSString stringWithFormat:@"张_%d", i];
//        NSInteger age = arc4random_uniform(40);
//        [self.studentDb executeUpdate:@"INSERT INTO t_student (name, age) VALUES(?,?);", name, @(age)];
        BOOL result = [self.studentDb executeUpdate:@"INSERT INTO t_student (name, age) VALUES(?,?);", student.name, @(student.age)];
        if (result) {
            NSLog(@"插入学生成功");
        }
        else {
             NSLog(@"插入学生失败");
        }
//        [self.studentDb executeUpdate:@"INSERT INTO t_student (name, age) VALUES(%@, %ld);", student.name, student.age];
    }
}

- (void)insertAPersonWithPersonId:(NSNumber *)personId {
    
}

// delete data 删除数据
- (void)deleteStudents {

    BOOL result = [self.studentDb executeUpdate:@"DELETE FROM t_student;"];
//    BOOL result = [self.studentDb executeUpdate:@"DROP TABLE IF EXISTS t_student;"];
    if (result) {
        NSLog(@"删除表数据成功");
    }
    else {
        NSLog(@"删除失败, 创建一个学生表");
        [self.studentDb executeUpdate:@"CREATE TABLE IF NOT EXISTS t_student (id integer PRIMARY KEY AUTOINCREMENT, name text NOT NULL, age integer NOT NULL);"];
    }
}

//query data 查询数据
- (void)queryStudents {
    FMResultSet *resultSet = [self.studentDb executeQuery:@"SELECT * FROM t_student"];
    //遍历结果
    while ([resultSet next]) {
        NSInteger studentId = [resultSet intForColumn:@"id"];
        NSString *name = [resultSet stringForColumn:@"name"];
        NSInteger age = [resultSet intForColumn:@"age"];

        NSLog(@"\n studentId:%ld  name:%@  age:%ld \n", studentId, name, age);
    }
}

- (void)createStudents {

    _students = [NSMutableArray array];
    for (int i = 0; i < 20 ; i ++) {
        Person *person = [[Person alloc] init];
        person.name = [NSString stringWithFormat:@"张%d", i+1];
        person.age = 18 + i;
        person.sex = (i % 2 == 0) ? @"男" : @"女";
        person.personId = @(i+100);

        [_students addObject:person];
    }
}
- (IBAction)insert:(id)sender {
    [self insertStudents];
}
- (IBAction)query:(id)sender {
    [self queryStudents];
}
- (IBAction)delete:(id)sender {
    [self deleteStudents];
}

#pragma mark - 学生列表测试
//添加学生
- (IBAction)addAllStudents:(id)sender {
    
    [[StudentManager shareManager] createDatabase];
    for (int i = 0; i < 20; i++) {
        Student *student = [Student new];
        student.name = [NSString stringWithFormat:@"张三%d", i];
        student.score = [NSString stringWithFormat:@"%u", (arc4random() % 100)];
        student.studentId = [NSString stringWithFormat:@"20171012%d",i+1];
        [[StudentManager shareManager] insertStudent:student];
    }
}

- (IBAction)showStudentList:(UIButton *)sender {
    StudentListController *stuListVC = [[StudentListController alloc] initWithNibName:@"StudentListController" bundle:nil];
    [self.navigationController pushViewController:stuListVC animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
