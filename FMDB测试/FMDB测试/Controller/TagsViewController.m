//
//  TagsViewController.m
//  FMDB测试
//
//  Created by 姚胜龙 on 17/2/9.
//  Copyright © 2017年 姚胜龙. All rights reserved.
//

#import "TagsViewController.h"
#import "DYCustomTagView.h"

@interface TagsViewController ()

@end

@implementation TagsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"添加标签显示测试";
    
    DYCustomTagView *tagView1 = [[DYCustomTagView alloc]
                                 initWithMessage:@"这是耳坠装饰"
                                 direction:TriangleHeadDirectionRight
                                 withPosition:CGPointMake(195, 123+64)];
    [self.view addSubview:tagView1];
    DYCustomTagView *tagView2 = [[DYCustomTagView alloc]
                                 initWithMessage:@"孔雀鱼鳞坠饰连衣裙"
                                 direction:TriangleHeadDirectionLeft
                                 withPosition:CGPointMake(175, 250)];
    [self.view addSubview:tagView2];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

}

@end
