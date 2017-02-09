//
//  DemoCollectionViewCell.m
//  FMDB测试
//
//  Created by 姚胜龙 on 17/2/9.
//  Copyright © 2017年 姚胜龙. All rights reserved.
//

#import "DemoCollectionViewCell.h"

@implementation DemoCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
}
- (void)configCellWithName:(NSString *)name {
    self.nameLabel.text = name;
}

- (void)setSelected:(BOOL)selected {
    [super setSelected:selected];
    self.selectBtn.selected = selected;
}

- (IBAction)selectItem:(id)sender {

}

@end
