//
//  YSHRManagerDetailHeaderView.m
//  YaSha-iOS
//
//  Created by GZl on 2019/3/26.
//  Copyright © 2019 亚厦装饰股份有限公司. All rights reserved.
//

#import "YSHRManagerDetailHeaderView.h"
#import "YSManagerHRHGCollectionViewCell.h"


@interface YSHRManagerDetailHeaderView ()<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>
@property (nonatomic, strong) NSDictionary *choseDic;



@end

@implementation YSHRManagerDetailHeaderView

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier withType:(ItemSizeType)itemType {
    if ([super initWithReuseIdentifier:reuseIdentifier]) {
        switch (itemType) {
            case ItemSizeTypeCompany:
                {
                    // 公司信息
                    [self loadCompanyView];
                }
                break;
            case ItemSizeTypePerson:
                {
                    // 个人信息
                    [self loadPersonViewWith:ItemSizeTypePerson];
                }
                break;
            case ItemSizeTypeMore:
                {
                    // 个人信息
                    [self loadPersonViewWith:ItemSizeTypeMore];
                }
                break;
            default:
                break;
        }
    }
    return self;
}

- (void)reloadCollectionViewWith:(NSArray*)deptArrat {
    self.dataArray = [NSMutableArray arrayWithArray:deptArrat];
    [self.collectionView reloadData];
}

- (void)reloadCollectionViewWith:(NSArray*)deptArrat withChoseArray:(nonnull NSArray *)choseArray {
    self.dataArray = [NSMutableArray arrayWithArray:deptArrat];
    // 判断是否为选中的模型 用来改变cell的描边
    self.choseDic = choseArray.count == 0 ? nil : choseArray[2];
    [self.collectionView reloadData];
}

// 滚动到指定行
- (void)scrollToItemAtIndexPath:(NSIndexPath *)indexPath withChoseArray:(nonnull NSArray *)choseArray{
    if (choseArray.count != 0) {
        [self.collectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally & UICollectionViewScrollPositionCenteredVertically animated:NO];
    }

    
}

- (void)loadCompanyView {
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.itemSize = CGSizeMake(167*kWidthScale, 72*kHeightScale);
    flowLayout.minimumInteritemSpacing = 10;
    flowLayout.sectionInset = UIEdgeInsetsMake(0, 18*kWidthScale, 0, 0);
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
    
    self.collectionView = [[UICollectionView alloc] initWithFrame:(CGRectMake(0, 0, kSCREEN_WIDTH, 80*kHeightScale)) collectionViewLayout:flowLayout];
    self.collectionView.backgroundColor = [UIColor whiteColor];
    self.collectionView.showsHorizontalScrollIndicator = NO;
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    [self.collectionView registerClass:[YSManagerHRHGCollectionViewCell class] forCellWithReuseIdentifier:@"managerCellID"];
    [self addSubview:self.collectionView];
    
}

- (void)loadPersonViewWith:(ItemSizeType)itemType {
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    if (itemType == ItemSizeTypeMore) {
        flowLayout.itemSize = CGSizeMake(167*kWidthScale, 98*kHeightScale);
    }else if (itemType == ItemSizeTypePerson) {
        flowLayout.itemSize = CGSizeMake(343*kWidthScale, 72*kHeightScale);
    }
    flowLayout.minimumInteritemSpacing = 10;
    flowLayout.sectionInset = UIEdgeInsetsMake(0, 18*kWidthScale, 0, 0);
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
    
    self.collectionView = [[UICollectionView alloc] initWithFrame:(CGRectMake(0, 0, kSCREEN_WIDTH, 80*kHeightScale)) collectionViewLayout:flowLayout];
    self.collectionView.backgroundColor = [UIColor whiteColor];
    self.collectionView.showsHorizontalScrollIndicator = NO;
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    [self.collectionView registerClass:[YSManagerHRHGCollectionViewCell class] forCellWithReuseIdentifier:@"managerCellID"];
    [self addSubview:self.collectionView];
    
}

#pragma mark--collectionView
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataArray.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    YSManagerHRHGCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"managerCellID" forIndexPath:indexPath];
    cell.companyLab.text = [self.dataArray[indexPath.row] objectForKey:@"name"];
    cell.companyLab.textColor = [UIColor colorWithHexString:@"#474C51"];
    cell.contentView.layer.borderWidth = 0;
    // 以前选中的
    if ([self.oldChoseArray containsObject:self.dataArray[indexPath.row]]) {
        cell.companyLab.textColor = [UIColor colorWithHexString:@"#1890FF"];
        cell.contentView.layer.borderWidth = 1;
    }
    // 当前选中的
    if ([self.dataArray[indexPath.row] isEqual:self.choseDic]) {
        cell.companyLab.textColor = [UIColor colorWithHexString:@"#1890FF"];
        cell.contentView.layer.borderWidth = 1;

    }
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    YSManagerHRHGCollectionViewCell *cell = (YSManagerHRHGCollectionViewCell*)[collectionView cellForItemAtIndexPath:indexPath];
    cell.contentView.layer.borderColor = [UIColor colorWithHexString:@"#1890FF"].CGColor;
    cell.contentView.layer.borderWidth = 1;
    cell.contentView.layer.cornerRadius = 4;
    if ([self.delegate respondsToSelector:@selector(didCollectionItemActionWith:)]) {
        self.choseDic = self.dataArray[indexPath.row];
        [self.delegate didCollectionItemActionWith:@[indexPath, self.dataArray[indexPath.row]]];
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
