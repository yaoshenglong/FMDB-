//
//  TagsViewController.m
//  FMDB测试
//
//  Created by 姚胜龙 on 17/2/9.
//  Copyright © 2017年 姚胜龙. All rights reserved.
//

#import "TagsViewController.h"
#import "DYCustomTagView.h"
#import "JWScrollView.h"
#import "Constants.h"
#import "DYTagsForImageView.h"
#import "TagItemView.h"

@interface TagsViewController ()<DYTagsForImageViewDataSource, UIScrollViewDelegate>

@property (weak, nonatomic) IBOutlet JWScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIImageView *bgImageView;

@property (nonatomic, strong) DYTagsForImageView *tagForImageView;
@property (nonatomic, strong) NSArray *testColorArray;

@property (nonatomic, strong) UIScrollView *screenScrollView;

@end

@implementation TagsViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO];
}

- (void)viewDidLoad {
    [super viewDidLoad];
//    self.title = @"添加标签显示测试";
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"back_navigation"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(back:)];
    self.navigationItem.leftBarButtonItem = backItem;

//    DYCustomTagView *tagView1 = [[DYCustomTagView alloc]
//                                 initWithMessage:@"这是耳坠装饰"
//                                 direction:TriangleHeadDirectionLeft
//                                 withPosition:CGPointMake(195, 123+64)
//                                 tapTagBlock:^(UITapGestureRecognizer *gesture, NSString *message) {
//                                     NSLog(@"回调1___%@", message);
//                                 }];
//    [self.view addSubview:tagView1];

//    DYCustomTagView *tagView2 = [[DYCustomTagView alloc]
//                           initWithMessage:@"孔雀鱼鳞坠饰连衣裙"
//                                 direction:TriangleHeadDirectionRight
//                              withPosition:CGPointMake(175, 250)
//                               tapTagBlock:^(UITapGestureRecognizer *gesture, NSString *message) {
//                                   NSLog(@"回调2 __ %@", message);
//                                 }];
//    [self.view addSubview:tagView2];

    [self setupScrollView];
//    _testColorArray = @[[UIColor blackColor],[UIColor blueColor], [UIColor greenColor],[UIColor grayColor], [UIColor orangeColor]];
//    [self.view addSubview:self.tagForImageView];


}

#pragma mark - DYTagsForImageViewDataSource
- (NSInteger)numberOfItemInView:(DYTagsForImageView *)view {
    return _testColorArray.count;
}

- (TagItemView *)itemAtView:(DYTagsForImageView *)view itemForViewAtIndex:(NSInteger)index {
    static NSString *itemIdentifer = @"ItemID";
    TagItemView *tagItem = [view dequeueReusableItemWithIdentifer:itemIdentifer];
    if (!tagItem) {
        tagItem = [[TagItemView alloc] initWithReusableIdentifier:itemIdentifer];
    }
    [tagItem setBackgroundColor:_testColorArray[index]];
    return tagItem;
}

- (void)setupScrollView {
//    __weak typeof(self) weakSelf = self;
//    [self.scrollView xibinitself];
//    self.scrollView.fetchContentViewAtIndex = ^UIView *(NSInteger pageIndex){
//        return [weakSelf setupScrollContentView:pageIndex];
//    };
//    self.scrollView.totalPagesCount = ^NSInteger(void) {
//        return 4;//暂时写死
//    };
//    self.scrollView.TapActionBlock = ^(NSInteger pageIndex) {
//        NSLog(@"点击了————%ld", pageIndex);
//    };
    NSArray *imgArray = @[@"new_user_guide_1",@"new_user_guide_2",@"new_user_guide_3",@"new_user_guide_4"];
    _screenScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, kWidth, kHeight)];
    _screenScrollView.pagingEnabled = YES;
    _screenScrollView.delegate = self;
    _screenScrollView.contentSize = CGSizeMake(kWidth * imgArray.count, kHeight);
    _screenScrollView.showsVerticalScrollIndicator = NO;
    _screenScrollView.showsHorizontalScrollIndicator = NO;
    [self.view addSubview:_screenScrollView];
    //创建imageView
    for (NSInteger i = 0; i < imgArray.count; i ++) {
        UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(kWidth * i, 0, kWidth, kHeight)];
        NSString *imgName = [NSString stringWithFormat:@"new_user_guide_%ld", (i + 1)];
        imgView.contentMode = UIViewContentModeScaleAspectFill;
        imgView.image = [UIImage imageNamed:imgName];
        imgView.userInteractionEnabled = YES;
        [_screenScrollView addSubview:imgView];
    }
}

- (UIView *)setupScrollContentView:(NSInteger)pageIndex {

    UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kWidth, kHeight)];
    imgView.userInteractionEnabled = YES;
//    [imgView sd_]
    NSString *imageName = [NSString stringWithFormat:@"new_user_guide_%ld", pageIndex+1];
    imgView.image = [UIImage imageNamed:imageName];
    return imgView;
}

- (DYTagsForImageView *)tagForImageView {

    if (!_tagForImageView) {
        _tagForImageView = [[DYTagsForImageView alloc] initWithFrame:self.view.frame];
        self.tagForImageView.dataSource = self;
        [self.view addSubview:self.tagForImageView];
    }
    return _tagForImageView;
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    NSLog(@"将要拖拽");
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    NSInteger currentPage = scrollView.contentOffset.x / kWidth;
    NSLog(@"scrollView 停: currentPage== %ld", currentPage);
}

#pragma mark - Button Action
- (void)back:(UIBarButtonItem *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

}

@end
