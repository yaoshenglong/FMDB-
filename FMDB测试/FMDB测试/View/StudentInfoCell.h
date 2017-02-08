//
//  StudentInfoCell.h
//  FMDB测试
//
//  Created by 姚胜龙 on 17/2/7.
//  Copyright © 2017年 姚胜龙. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Student;
@interface StudentInfoCell : UITableViewCell

- (void)configCellWithStudent:(Student *)student;

@end
