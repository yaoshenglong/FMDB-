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
    self.title = @"FMDB练习";
}

#pragma mark - Button Action

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

//插入冲突的数据
- (IBAction)conflictInsert:(id)sender {

}

//查询某个学生
- (IBAction)queryOne:(id)sender {

}

//查询所有的学生
- (IBAction)queryAll:(id)sender {

}

//删除一个
- (IBAction)deleteOne:(id)sender {

}

//删除所有的
- (IBAction)deleteAll:(id)sender {

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
