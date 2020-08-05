//
//  YSHRManaHomeGViewController.m
//  YaSha-iOS
//
//  Created by GZl on 2019/4/3.
//  Copyright © 2019 亚厦装饰股份有限公司. All rights reserved.
//

#import "YSHRManaHomeGViewController.h"
#import "YSApplicationBannerView.h"
#import "YSApplicationCell.h"
#import "YSHRMAttendanceViewController.h"//部门考勤

#import "YSHRManagerHGViewController.h"//我的团队
#import "YSHRMDPerformanceViewController.h"//部门绩效
#import "YSHRMDHTrainingViewController.h"//部门培训

#import "YSHRMTDeptTreeModel.h"//部门树
#import "YSNetManagerCache.h"

static NSString *const fileNameStr = @"deptTreeName.xml";

static NSString *const reuseIdentifierHRMHeader = @"ApplicationHRMCycleView";
static NSString *const reuseHRMIdentifier = @"ApplicationHRMCell";

@interface YSHRManaHomeGViewController ()<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UIGestureRecognizerDelegate>
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSString *imageName;
@property (nonatomic, strong) NSMutableArray *deptModelArray;

@end

@implementation YSHRManaHomeGViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [TalkingData trackPageBegin:@"团队"];
}

//设置统计离开该模块
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [TalkingData trackPageEnd:@"团队"];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"团队";
    [self.tableView removeFromSuperview];
    [self hideMJRefresh];
    
    [self loadSubViews];
    [self getDatasourceArray];
    [self doNetworking];

}

- (void)loadSubViews {
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.itemSize = CGSizeMake(87*kWidthScale, 87*kHeightScale);
    flowLayout.sectionInset = UIEdgeInsetsMake(0, (kSCREEN_WIDTH-(87*kWidthScale*4))/4, 8, 8);
    flowLayout.minimumLineSpacing = 0;
    flowLayout.minimumInteritemSpacing = 0;
    flowLayout.headerReferenceSize = CGSizeMake(kSCREEN_WIDTH, 147*(kSCREEN_WIDTH/375.0));
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
    
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, kTopHeight, kSCREEN_WIDTH, kSCREEN_HEIGHT-kTopHeight) collectionViewLayout:flowLayout];
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    self.collectionView.backgroundColor = [UIColor whiteColor];
    self.collectionView.indicatorStyle = UIScrollViewIndicatorStyleBlack;
    [self.collectionView registerClass:[YSApplicationBannerView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:reuseIdentifierHRMHeader];
    [self.collectionView registerClass:[YSApplicationCell class] forCellWithReuseIdentifier:reuseHRMIdentifier];
    [self.view addSubview:self.collectionView];
    
}

- (void)getDatasourceArray {
    [self.dataSourceArray addObjectsFromArray:[YSDataManager getApplicationsData:@[
                                                                                   @{@"id": @"0",
                                                                                     @"name": @"我的团队",
                                                                                     @"imageName": @"hr_Man_check_Gicon",
                                                                                     @"className": @"YSHRManagerHGViewController"},
                                                                                   @{@"id": @"1",
                                                                                     @"name": @"部门考勤",
                                                                                     @"imageName": @"hr_Mana_perfor_Gicon",
                                                                                     @"className": @"YSHRMAttendanceViewController"},
                                                                                   @{@"id": @"2",
                                                                                     @"name": @"部门绩效",
                                                                                     @"imageName": @"hr_Mana_training_Gicon",
                                                                                     @"className": @"YSHRMDPerformanceViewController"},
                                                                                   
                                                                                   @{@"id":@"3",
                                                                                     @"name":@"部门培训",                      @"imageName":@"hr_Mana_pay_Gicon",
                                                                                     @"className": @"YSHRMDHTrainingViewController"}]]];
    
}

- (void)doNetworking {
    [super doNetworking];
     [self.view bringSubviewToFront:self.navView];
    [YSNetManager ys_request_GETWithUrlString:[NSString stringWithFormat:@"%@%@",YSDomain,getDeptTree] isNeedCache:NO parameters:nil successBlock:^(id response) {
        [QMUITips hideAllToastInView:self.view animated:NO];
        DLog(@"我的团队部门树:%@",response);
        if ([response[@"code"] integerValue] == 1) {
            self.deptModelArray = [NSMutableArray arrayWithArray:[YSDataManager getTeamAllDeptTreeData:response]];
            
            DLog(@"存储的部门树:%@", [YSNetManagerCache ys_httpCacheWithUrlString:[NSString stringWithFormat:@"%@%@",YSDomain,getDeptTree] parameters:nil]);
        }
    } failureBlock:^(NSError *error) {
        [QMUITips hideAllToastInView:self.view animated:NO];
    } progress:nil];
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataSourceArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    YSApplicationCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseHRMIdentifier forIndexPath:indexPath];
    YSApplicationModel *cellModel = self.dataSourceArray[indexPath.row];
    cell.managerModel = cellModel;
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    UICollectionReusableView *supplementaryView;
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        YSApplicationBannerView *applicationBannerView = (YSApplicationBannerView *)[collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:reuseIdentifierHRMHeader forIndexPath:indexPath];
        
        applicationBannerView.imageView.image = [UIImage imageNamed:!_imageName ? @"23423asd" : _imageName];
        
        supplementaryView = applicationBannerView;
    }
    return supplementaryView;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    YSApplicationModel *model = self.dataSourceArray[indexPath.row];
    Class someClass = NSClassFromString(model.className);
    UIViewController *viewController = [[someClass alloc] init];
    [self.navigationController pushViewController:viewController animated:YES];
    
}

- (NSMutableArray *)deptModelArray {
    if (!_deptModelArray) {
        _deptModelArray = [NSMutableArray new];
    }
    return _deptModelArray;
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
