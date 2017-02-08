//
//  StudentInfoCell.m
//  FMDB测试
//
//  Created by 姚胜龙 on 17/2/7.
//  Copyright © 2017年 姚胜龙. All rights reserved.
//

#import "StudentInfoCell.h"
#import "Student.h"

@interface StudentInfoCell ()

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;
@property (weak, nonatomic) IBOutlet UILabel *studentNumLabel;

@end

@implementation StudentInfoCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)configCellWithStudent:(Student *)student {
    self.nameLabel.text = [NSString stringWithFormat:@"姓名:%@", student.name];
    self.studentNumLabel.text = [NSString stringWithFormat:@"学号:%@", student.studentId];
    self.scoreLabel.text = ([student.score integerValue] >= 60) ? [NSString stringWithFormat:@"成绩:%@", student.score] : @"不及格";
    self.scoreLabel.textColor = ([student.score integerValue] >= 60) ? [UIColor colorWithRed:0 green:1 blue:0 alpha:1] : [UIColor colorWithRed:1 green:0 blue:0 alpha:1];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
