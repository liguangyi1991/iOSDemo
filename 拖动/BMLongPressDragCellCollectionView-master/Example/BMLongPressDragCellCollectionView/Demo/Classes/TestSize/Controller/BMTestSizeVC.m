
//
//  BMLongPressDragCellCollectionViewVC.m
//  BMLongPressDragCellCollectionViewDemo
//
//  Created by __liangdahong on 2017/7/21.
//  Copyright © 2017年 https://liangdahong.com All rights reserved.
//

#import "BMTestSizeVC.h"
#import "BMTestSizeCell.h"
#import "BMLongPressDragCellCollectionView.h"

#define WIDTH  [[UIScreen mainScreen] bounds].size.width
#define HEIGHT [[UIScreen mainScreen] bounds].size.height

@interface BMTestSizeVC () <BMLongPressDragCellCollectionViewDelegate, BMLongPressDragCellCollectionViewDataSource>

@property (nonatomic, strong) BMLongPressDragCellCollectionView *collectionView; // collectionView
@property (strong, nonatomic) NSMutableArray *dataSourceArray;

@end

static NSString *reuseIdentifier = @"forCellWithReuseIdentifier";

@implementation BMTestSizeVC

#pragma mark - 生命周期

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.collectionView];
}

#pragma mark - getters setters

- (BMLongPressDragCellCollectionView *)collectionView{
    if (_collectionView == nil) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.scrollDirection = self.collectionViewScrollDirection;

        _collectionView = [[BMLongPressDragCellCollectionView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT) collectionViewLayout:layout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;

        _collectionView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        layout.minimumLineSpacing        = arc4random_uniform(20)+1;
        layout.minimumInteritemSpacing   = arc4random_uniform(20)+1;
        
        if (self.dataSource.count > 1) {
            layout.headerReferenceSize = CGSizeMake(100, 100);
        }
        
        if (self.collectionViewScrollDirection == UICollectionViewScrollDirectionVertical) {
            _collectionView.alwaysBounceVertical = YES;
        } else {
            _collectionView.alwaysBounceHorizontal = YES;
        }
        [_collectionView registerNib:[UINib nibWithNibName:NSStringFromClass(BMTestSizeCell.class) bundle:nil] forCellWithReuseIdentifier:reuseIdentifier];
        _collectionView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    }
    return _collectionView;
}

#pragma mark - 系统delegate

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return self.dataSource.count;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [self.dataSource[section] count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    BMTestSizeCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    cell.label.text = _dataSource[indexPath.section][indexPath.item][@"title"];
    return cell;
}

- (NSArray<NSArray<id> *> *)dataSourceWithDragCellCollectionView:(__kindof BMLongPressDragCellCollectionView *)dragCellCollectionView {
    return self.dataSource;
}


- (void)dragCellCollectionView:(__kindof BMLongPressDragCellCollectionView *)dragCellCollectionView newDataArrayAfterMove:(NSArray<NSArray<id> *> *)newDataArray {
    self.dataSource = [newDataArray mutableCopy];
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return [self.dataSource[indexPath.section][indexPath.item][@"size"] CGSizeValue];
}

@end
