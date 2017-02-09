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
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"back_navigation"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(back:)];
    self.navigationItem.leftBarButtonItem = backItem;

    DYCustomTagView *tagView1 = [[DYCustomTagView alloc]
                                 initWithMessage:@"这是耳坠装饰"
                                 direction:TriangleHeadDirectionLeft
                                 withPosition:CGPointMake(195, 123+64)
                                 tapTagBlock:^(UITapGestureRecognizer *gesture, NSString *message) {
                                     NSLog(@"回调1___%@", message);
                                 }];
    [self.view addSubview:tagView1];

    DYCustomTagView *tagView2 = [[DYCustomTagView alloc]
                           initWithMessage:@"孔雀鱼鳞坠饰连衣裙"
                                 direction:TriangleHeadDirectionRight
                              withPosition:CGPointMake(175, 250)
                               tapTagBlock:^(UITapGestureRecognizer *gesture, NSString *message) {
                                   NSLog(@"回调2 __ %@", message);
                                 }];
    [self.view addSubview:tagView2];
}


#pragma mark - Button Action
- (void)back:(UIBarButtonItem *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

}

@end
