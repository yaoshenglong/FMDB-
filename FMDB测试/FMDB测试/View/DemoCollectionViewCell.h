//
//  DemoCollectionViewCell.h
//  FMDB测试
//
//  Created by 姚胜龙 on 17/2/9.
//  Copyright © 2017年 姚胜龙. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DemoCollectionViewCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIButton *selectBtn;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

- (void)configCellWithName:(NSString *)name;

@end
