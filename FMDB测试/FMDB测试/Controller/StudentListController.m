//
//  StudentListController.m
//  FMDB测试
//
//  Created by 姚胜龙 on 17/2/7.
//  Copyright © 2017年 姚胜龙. All rights reserved.
//

#import "StudentListController.h"
#import "Student.h"
#import "StudentManager.h"
#import "StudentInfoCell.h"

typedef NS_ENUM(NSInteger, AlertTextFieldTag) {
    AlertTextFieldStudentNameTag = 10,
    AlertTextFieldStudentIdTag,
    AlertTextFieldStudentScoreTag
};

static NSString *const kStudentInfoCell = @"StudentInfoCell";

@interface StudentListController () {
    Student *addStu;//添加的学生
}

@property (nonatomic, strong) NSMutableArray *students;
@property (nonatomic, assign) AlertTextFieldTag textFieldTag;

@end

@implementation StudentListController

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    //清除所有学生数据
    [[StudentManager shareManager] clearAllStudents];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"FMDBTestDemo";
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc]
                        initWithImage:[[UIImage imageNamed:@"back_navigation"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]
                                style:UIBarButtonItemStylePlain
                               target:self
                               action:@selector(back:)];
    self.navigationItem.leftBarButtonItem = backItem;
    UIBarButtonItem *insertItem = [[UIBarButtonItem alloc]
                                 initWithImage:[[UIImage imageNamed:@"mine_profile"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]
                                 style:UIBarButtonItemStylePlain
                                 target:self
                                 action:@selector(insertAStudent:)];
    self.navigationItem.rightBarButtonItem = insertItem;
    //获取所有的学生
    self.students = [[StudentManager shareManager] findAllStudents];
    //register cell
    [self.tableView registerNib:[UINib nibWithNibName:kStudentInfoCell bundle:nil] forCellReuseIdentifier:kStudentInfoCell];
    //初始化添加学生的全局变量
    addStu = [Student new];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.students.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    StudentInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:kStudentInfoCell];
    Student *student = (Student *)self.students[indexPath.row];
    [cell configCellWithStudent:student];

    return cell;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
//        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {

    }   
}

#pragma mark - Table view delegate

- (NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath {

    __weak typeof(self) weakSelf = self;
    UITableViewRowAction *deleteAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:@"删除" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        NSLog(@"删除数据");
        [weakSelf.students removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationLeft];
        Student *student = (Student *)weakSelf.students[indexPath.row];
        [[StudentManager shareManager] deleteStudentWithStudentId:student.studentId];
    }];
    deleteAction.backgroundColor = [UIColor redColor];

    UITableViewRowAction *addAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:@"标记" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        NSLog(@"标记成功");
    }];
    addAction.backgroundColor = [UIColor orangeColor];
    return @[addAction, deleteAction];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 80.0;
}

#pragma mark - Button Action

- (void)insertAStudent:(id)sender {
    __weak typeof(self) weakSelf = self;
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"手动录入" message:@"请输入学生姓名、学号、考试分数" preferredStyle:UIAlertControllerStyleAlert];
    [alertVC addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder = @"学生姓名";
        textField.tag = AlertTextFieldStudentNameTag;
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textDidchanged:) name:UITextFieldTextDidChangeNotification object:textField];
    }];
    [alertVC addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder = @"学生学号";
        textField.tag = AlertTextFieldStudentIdTag;
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textDidchanged:) name:UITextFieldTextDidChangeNotification object:textField];
    }];
    [alertVC addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder = @"学生成绩";
        textField.tag = AlertTextFieldStudentScoreTag;
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textDidchanged:) name:UITextFieldTextDidChangeNotification object:textField];
    }];
    //取消
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextFieldTextDidChangeNotification object:nil];
    }];
    [alertVC addAction:cancelAction];
    //确定
    UIAlertAction *confirmAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [[StudentManager shareManager] insertStudent:addStu];
        [self.students addObject:addStu];
        [weakSelf.tableView reloadData];
        [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextFieldTextDidChangeNotification object:nil];
    }];
    confirmAction.enabled = NO;
    [alertVC addAction:confirmAction];
    [self presentViewController:alertVC animated:YES completion:nil];
}

- (void)back:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Notification 
- (void)textDidchanged:(NSNotification *)notification {
    UITextField *textField = (UITextField *)notification.object;
    NSInteger textFieldTag = textField.tag;
    UIAlertController *alertVC = (UIAlertController *)self.presentedViewController;//拿到弹出的Alertcontroller
    if (alertVC) {
        if (textFieldTag == AlertTextFieldStudentNameTag) {
            UITextField *stuNameTextField = [alertVC.textFields objectAtIndex:0];
            if (stuNameTextField.text.length > 0) {
                addStu.name = stuNameTextField.text;
            }
            else {
                NSLog(@"学生名称为空");
            }
        } else if (textFieldTag == AlertTextFieldStudentIdTag) {
            UITextField *stuIdTextField = [alertVC.textFields objectAtIndex:1];
            if (stuIdTextField.text.length > 0) {
                addStu.studentId = stuIdTextField.text;
            }
            else {
                NSLog(@"学生名称为空");
            }
        } else if (textFieldTag == AlertTextFieldStudentScoreTag) {
            UITextField *stuScoreTextField = [alertVC.textFields objectAtIndex:2];
            if (stuScoreTextField.text.length > 0) {
                addStu.score = stuScoreTextField.text;
            }
        }
        else {
            NSLog(@"无效的tag");
        }
        if (addStu.name.length > 0
            && addStu.studentId.length > 0 && addStu.score.length > 0) {
            UIAlertAction *confirmAction = alertVC.actions.lastObject;
            confirmAction.enabled = YES;
        }
    }
}

@end
