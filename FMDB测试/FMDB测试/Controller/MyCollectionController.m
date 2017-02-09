//
//  MyCollectionController.m
//  FMDB测试
//
//  Created by 姚胜龙 on 17/2/9.
//  Copyright © 2017年 姚胜龙. All rights reserved.
//

#import "MyCollectionController.h"
#import "StudentManager.h"
#import "Student.h"
#import "DemoCollectionViewCell.h"
#import "Constants.h"

static NSString *const selectAllBarTitle = @"全选";
static NSString *const cancelAllBarTitle = @"取消";

@interface MyCollectionController ()<UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSMutableSet *selectItems;//选择的
@property (nonatomic, strong) NSArray *allItems;//所有的

@end

@implementation MyCollectionController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Collection选择测试";
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithTitle:selectAllBarTitle style:UIBarButtonItemStylePlain target:self action:@selector(selectedAll:)];
    self.navigationItem.rightBarButtonItem = rightItem;
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"back_navigation"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(back:)];
    self.navigationItem.leftBarButtonItem = backItem;

    self.selectItems = [NSMutableSet set];
    self.allItems = [[StudentManager shareManager] findAllStudents];
    [self setupCollectionView];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
}

- (void)setupCollectionView {
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.minimumLineSpacing = CGFLOAT_MIN;
    layout.minimumInteritemSpacing = CGFLOAT_MIN;
    layout.itemSize = CGSizeMake(kWidth/3.0, kWidth/3.0);
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0.0, kWidth, kHeight) collectionViewLayout:layout];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    self.collectionView.allowsMultipleSelection = YES;
    [self.view addSubview:self.collectionView];
    //register cell
    [self.collectionView registerNib:[UINib nibWithNibName:@"DemoCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"DemoCollectionViewCell"];
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.allItems.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    DemoCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"DemoCollectionViewCell" forIndexPath:indexPath];
    Student *stu = (Student *)self.allItems[indexPath.row];
    [cell configCellWithName:(stu.name == nil ? @"Default" : stu.name)];
    return cell;
}

#pragma mark - UICollectionViewDelegate

- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {

    return YES;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
//    DemoCollectionViewCell *cell = (DemoCollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
    Student *stu = (Student *)self.allItems[indexPath.row];
    [self.selectItems addObject:stu];
    NSLog(@"self.selectItems == %@ count = %ld", self.selectItems, self.selectItems.count);
}

- (BOOL)collectionView:(UICollectionView *)collectionView shouldDeselectItemAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath {
//    DemoCollectionViewCell *cell = (DemoCollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
    Student *stu = (Student *)self.allItems[indexPath.row];
    if ([self.selectItems containsObject:stu]) {
        [self.selectItems removeObject:stu];
    }
    NSLog(@"self.selectItems == %@ count = %ld", self.selectItems, self.selectItems.count);
}

#pragma mark - Button Action
- (void)selectedAll:(UIBarButtonItem *)sender {
    if ([sender.title isEqualToString:selectAllBarTitle]) {
        for (int index = 0; index < self.allItems.count; index ++) {
            NSIndexPath *indexPath = [NSIndexPath indexPathForItem:index inSection:0];
            if ([self collectionView:self.collectionView shouldSelectItemAtIndexPath:indexPath]) {
                [self.collectionView selectItemAtIndexPath:indexPath animated:YES scrollPosition:UICollectionViewScrollPositionNone];
                Student *selectStu = (Student *)self.allItems[indexPath.row];
                [self.selectItems addObject:selectStu];
            }
        }
        NSLog(@"全选: %@ count= %ld", self.selectItems, self.selectItems.count);
        sender.title = cancelAllBarTitle;
    }
    else {

        for (int index = 0; index < self.allItems.count; index ++) {
            NSIndexPath *indexPath = [NSIndexPath indexPathForItem:index inSection:0];
            if ([self collectionView:self.collectionView shouldDeselectItemAtIndexPath:indexPath]) {
                [self.collectionView deselectItemAtIndexPath:indexPath animated:YES];
                Student *desSelectStu = (Student *)self.allItems[indexPath.row];
                if ([self.selectItems containsObject:desSelectStu]) {
                    [self.selectItems removeObject:desSelectStu];
                }
            }
        }
        NSLog(@"取消全选: %@", self.selectItems);
        sender.title = selectAllBarTitle;
    }
}

- (void)back:(UIBarButtonItem *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

}


@end
