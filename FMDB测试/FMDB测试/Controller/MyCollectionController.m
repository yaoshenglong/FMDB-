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

@interface MyCollectionController ()<UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSMutableSet *selectItems;//选择的
@property (nonatomic, strong) NSArray *allItems;//所有的

@end

@implementation MyCollectionController

- (void)viewDidLoad {
    [super viewDidLoad];

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
    NSLog(@"self.selectItems == %@", self.selectItems);
}

- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath {
//    DemoCollectionViewCell *cell = (DemoCollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
    Student *stu = (Student *)self.allItems[indexPath.row];
    if ([self.selectItems containsObject:stu]) {
        [self.selectItems removeObject:stu];
    }
    NSLog(@"self.selectItems == %@", self.selectItems);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

}


@end
