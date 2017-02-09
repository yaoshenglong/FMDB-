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
#import "MyCollectionController.h"
#import "TagsViewController.h"

@interface ViewController ()

@property (nonatomic, strong) NSString *fileName;
@property (nonatomic, strong) FMDatabase *studentDb;
@property (nonatomic, strong) NSMutableArray *students;
@property (nonatomic, assign) BOOL isEnableAddStudents;//判断是否执行了添加学生方法

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"FMDB练习";
    self.isEnableAddStudents = NO;
}

#pragma mark - Button Action

//添加学生
- (IBAction)addAllStudents:(id)sender {
    if (!self.isEnableAddStudents) {
        self.isEnableAddStudents = YES;
        [[StudentManager shareManager] createDatabase];
        for (int i = 0; i < 20; i++) {
            Student *student = [Student new];
            student.name = [NSString stringWithFormat:@"张三%d", i];
            student.score = [NSString stringWithFormat:@"%u", (arc4random() % 100)];
            student.studentId = [NSString stringWithFormat:@"20171012%d",i+1];
            [[StudentManager shareManager] insertStudent:student];
        }
    }
    else {
        NSLog(@"已经添加了");
    }

}

//插入冲突的数据
- (IBAction)conflictInsert:(id)sender {
    Student *stu = [Student new];
    stu.name = @"bala";
    stu.studentId = @"2017101219";//这个判断一下是否已经存在
    stu.score = @"78";
    BOOL isExist = [[StudentManager shareManager] isStudentExist:stu.studentId];
    if (!isExist) {
        [[StudentManager shareManager] insertStudent:stu];
    }
    else {
        NSLog(@"该学生已经存在");
    }
}

//查询某个学生
- (IBAction)queryOne:(id)sender {
    NSString *studentId = @"2017101220";
    NSArray *aStudent = [[StudentManager shareManager] findStudentWithId:studentId];
    if (aStudent.count > 0) {
        NSLog(@"aStudent = %@", aStudent);
    }
    else {
        NSLog(@"没有找到该学生");
    }
}

//查询所有的学生
- (IBAction)queryAll:(id)sender {
    NSMutableArray *allStudents = [[StudentManager shareManager] findAllStudents];
    NSLog(@"allStudents == %@", allStudents);
}

//删除一个
- (IBAction)deleteOne:(id)sender {
    NSString *studentId = @"2017101217";
    if ([[StudentManager shareManager] isStudentExist:studentId]) {
        [[StudentManager shareManager] deleteStudentWithStudentId:studentId];
    }
    else {
        NSLog(@"没有找到这个学生");
    }
}

//删除所有的
- (IBAction)deleteAll:(id)sender {
    NSMutableArray *students = [[StudentManager shareManager] findAllStudents];
    if (students.count > 0) {
        [[StudentManager shareManager] clearAllStudents];
    }
    else {
        NSLog(@"数据库为空");
    }
    self.isEnableAddStudents = NO;
}

- (IBAction)showStudentList:(UIButton *)sender {
    StudentListController *stuListVC = [[StudentListController alloc] initWithNibName:@"StudentListController" bundle:nil];
    [self.navigationController pushViewController:stuListVC animated:YES];
}

- (IBAction)ceshi:(id)sender {
    
    MyCollectionController *collectionVC = [[MyCollectionController alloc] init];
    [self.navigationController pushViewController:collectionVC animated:YES];
}

- (IBAction)showTagsView:(id)sender {
    TagsViewController *tagsVC = [[TagsViewController alloc] initWithNibName:@"TagsViewController" bundle:nil];
    [self.navigationController pushViewController:tagsVC animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
