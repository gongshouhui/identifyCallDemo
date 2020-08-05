//
//  YSInfoQueryFunctionController.m
//  YaSha-iOS
//
//  Created by 罗罗诺亚索隆 on 2019/1/10.
//  Copyright © 2019 亚厦装饰股份有限公司. All rights reserved.
//

#import "YSInfoQueryFunctionController.h"
#import "YSInfoQueryCollectionReusableView.h"
#import "YSApplicationCell.h"
#import "YSApplicationModel.h"
@interface YSInfoQueryFunctionController ()<UICollectionViewDataSource,UICollectionViewDelegate>
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic,strong) NSDictionary *dict;
@end

@implementation YSInfoQueryFunctionController

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        flowLayout.itemSize = CGSizeMake(kSCREEN_WIDTH/4.0, kSCREEN_WIDTH/4.0);
        flowLayout.minimumLineSpacing = 0;
        flowLayout.minimumInteritemSpacing = 0;
        //flowLayout.headerReferenceSize = CGSizeMake(kSCREEN_WIDTH, 147*(kSCREEN_WIDTH/375.0));
        [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
        
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:flowLayout];
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        _collectionView.backgroundColor = [UIColor whiteColor];
//        _collectionView.indicatorStyle = UIScrollViewIndicatorStyleBlack;
        [_collectionView registerClass:[YSApplicationCell class] forCellWithReuseIdentifier:@"YSApplicationCell"];
        [_collectionView registerClass:[YSInfoQueryCollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"HeaderView"];

    }
    return _collectionView;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"信息自助";
    [self.view addSubview:self.collectionView];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(0);
        make.top.mas_equalTo(kTopHeight);
    }];
    [self getDatasourceArray];
    [self doNetworking];
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.titleView.titleLabel.textColor = [UIColor whiteColor];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage gradientImageWithBounds:CGRectMake(0, 0, kSCREEN_WIDTH, kTopHeight) andColors:@[[UIColor colorWithHexString:@"#546AFD"],[UIColor colorWithHexString:@"#2EC1FF"]] andGradientType:1]  forBarMetrics:UIBarMetricsDefault];
}
- (void)doNetworking {
    [YSNetManager ys_request_GETWithUrlString:[NSString stringWithFormat:@"%@%@",YSDomain,selfMessageHeader] isNeedCache:NO parameters:nil successBlock:^(id response) {
        DLog(@"11111流程详情%@",response);
        if ([response[@"code"] integerValue] == 1) {
            self.dict =  response[@"data"];
            [self.collectionView reloadData];
        }
    } failureBlock:^(NSError *error) {
        [QMUITips hideAllToastInView:self.view animated:YES];
    } progress:nil];

}
- (void)getDatasourceArray {
    [self.dataSourceArray addObjectsFromArray:[YSDataManager getApplicationsData:@[
                                                                                   @{@"id": @"0",
                                                                                     @"name": @"我的资料",
                                                                                     @"imageName": @"我的资料",
                                                                                     @"className": @"YSHRInfoSelfHelpController"},
                                                                                   @{@"id": @"1",
                                                                                     @"name": @"我的考勤",
                                                                                     @"imageName": @"我的考勤",
                                                                                     @"className": @"YSAttendanceNewPageController"},
                                                                                   @{@"id":@"2",
                                                                                     @"name":@"我的绩效",                      @"imageName":@"我的绩效",
                                                                                     @"className": @"YSHRPerformanceGradeController"},                                 @{@"id": @"3",
                                                                                                                                                                  @"name": @"我的培训",
                                                                                                                                                                  @"imageName": @"我的培训",
                                                                                                                                                                  @"className": @"YSHRMyTrainController"}
                                            ]]];
    
    [self.collectionView reloadData];
}
#pragma mark - UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataSourceArray.count;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    UICollectionReusableView *supplementaryView;
    if (kind == UICollectionElementKindSectionHeader) {
        YSInfoQueryCollectionReusableView *applicationBannerView = (YSInfoQueryCollectionReusableView *)[collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"HeaderView" forIndexPath:indexPath];
        if (self.dict) {
            [applicationBannerView setCollectionReusableVieData:self.dict];
        }
        supplementaryView = applicationBannerView;
    }
    return supplementaryView;
}
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    CGSize size={kSCREEN_WIDTH,226*kHeightScale};
    return size;
    
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    YSApplicationCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"YSApplicationCell" forIndexPath:indexPath];
    YSApplicationModel *cellModel = self.dataSourceArray[indexPath.row];
    [cell setCellModel:cellModel];
    return cell;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    YSApplicationModel *model = self.dataSourceArray[indexPath.row];
    Class someClass = NSClassFromString(model.className);
    UIViewController *viewController = [[someClass alloc] init];
    [self.navigationController pushViewController:viewController animated:YES];
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
