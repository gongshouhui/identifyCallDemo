//
//  YSSelfHelpViewController.m
//  YaSha-iOS
//
//  Created by 罗罗诺亚索隆 on 2019/1/4.
//  Copyright © 2019 亚厦装饰股份有限公司. All rights reserved.
//

#import "YSSelfHelpViewController.h"
#import "YSHRSelpItem.h"
#import "YSApplicationBannerView.h"
#import "YSApplicationCell.h"
#import "YSCommonFlowLaunchListViewController.h"
#import "YSFlowLaunchListModel.h"
#import "YSWorkOverTimeViewController.h"
#import "YSPaidLeaveWViewController.h"
#import "YSModifyLanchFlowViewController.h"
#import "YSProjectGWViewController.h"


@interface YSSelfHelpViewController ()<UICollectionViewDataSource,UICollectionViewDelegate, UIGestureRecognizerDelegate>
@property (nonatomic, strong) UICollectionView *collectionView;

@end

@implementation YSSelfHelpViewController
- (UICollectionView *)collectionView {
    if (!_collectionView) {
        
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        flowLayout.itemSize = CGSizeMake(kSCREEN_WIDTH/4.0, kSCREEN_WIDTH/4.0);
        flowLayout.minimumLineSpacing = 0;
        flowLayout.minimumInteritemSpacing = 0;
        
        flowLayout.headerReferenceSize = CGSizeMake(kSCREEN_WIDTH, 147*(kSCREEN_WIDTH/375.0));
        [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
        
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:flowLayout];
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        _collectionView.backgroundColor = [UIColor whiteColor];
        
        //        _collectionView.indicatorStyle = UIScrollViewIndicatorStyleBlack;
        [_collectionView registerClass:[YSApplicationCell class] forCellWithReuseIdentifier:@"YSApplicationCell"];
        [_collectionView registerClass:[YSApplicationBannerView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"YSApplicationBannerView"];
        
    }
    return _collectionView;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"自助服务";
    [self.view addSubview:self.collectionView];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(0);
        make.top.mas_equalTo(0);
    }];
    [self doNetworking];
    // Do any additional setup after loading the view.
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:nil];
    tapGesture.delegate = self;
    tapGesture.numberOfTouchesRequired = 1;
//    [self.view addGestureRecognizer:tapGesture];
}
-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch{
    
    DLog(@"输出=%@", NSStringFromClass([touch.view.superview class]));
    if ([NSStringFromClass([touch.view.superview class]) isEqualToString:@"YSApplicationCell"]) {
        return NO;
    }
    return YES;
    
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [TalkingData trackPageBegin:@"自助服务"];
}

//设置统计离开该模块
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [TalkingData trackPageEnd:@"自助服务"];
}
- (void)doNetworking {
    [super doNetworking];
    [YSNetManager ys_request_GETWithUrlString:[NSString stringWithFormat:@"%@%@",YSDomain,getDictionary] isNeedCache:NO parameters:nil successBlock:^(id response) {
        DLog(@"HR自助服务请求的数据:%@", response);
        if ([response[@"code"] integerValue] == 1) {
            self.dataSourceArray = [[NSArray yy_modelArrayWithClass:[YSHRSelpItem class] json:response[@"data"]] copy];
            [self.collectionView reloadData];
        }
        
    } failureBlock:^(NSError *error) {
        
    } progress:nil];
}


#pragma mark - UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataSourceArray.count;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    if (kind == UICollectionElementKindSectionHeader) {
        YSApplicationBannerView *applicationBannerView = (YSApplicationBannerView *)[collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"YSApplicationBannerView" forIndexPath:indexPath];
        applicationBannerView.imageView.image = [UIImage imageNamed:@"HR"];
         return applicationBannerView;
    }
    return nil;
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    YSApplicationCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"YSApplicationCell" forIndexPath:indexPath];
    YSHRSelpItem *cellModel = self.dataSourceArray[indexPath.row];
    [cell setSelfHelpItem:cellModel];
    return cell;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    YSHRSelpItem *selfItem = self.dataSourceArray[indexPath.row];
    YSFlowLaunchListModel *model = [[YSFlowLaunchListModel alloc]init];
    model.modelName = selfItem.name;
    model.modelKey = selfItem.modelKey;;
    if ([model.modelKey isEqualToString:@"atds_jiab_apply_flow"]) {
        //加班
        YSWorkOverTimeViewController *workVC = [YSWorkOverTimeViewController new];
        workVC.lanchModel = model;
        [self.navigationController pushViewController:workVC animated:YES];
    }else if ([model.modelKey isEqualToString:@"atds_qingj_apply_flow"]) {//请假
        YSPaidLeaveWViewController *workVC = [YSPaidLeaveWViewController new];
        workVC.lanchModel = model;
        [self.navigationController pushViewController:workVC animated:YES];
    }else if ([model.modelKey isEqualToString:@"atds_writeOff_apply_flow"]) {//修正考勤申请流程
        YSModifyLanchFlowViewController *workVC = [YSModifyLanchFlowViewController new];
        workVC.lanchModel = model;
        [self.navigationController pushViewController:workVC animated:YES];
    }else if ([model.modelKey isEqualToString:@"atds_ygwc_apply_flow"]) {
        //因公外出
        YSWorkOverTimeViewController *workVC = [YSWorkOverTimeViewController new];
        workVC.lanchModel = model;
        [self.navigationController pushViewController:workVC animated:YES];
    }else if ([model.modelKey isEqualToString:@"project_tx_apply_flow"]) {//项目调休申请
        YSProjectGWViewController *projectVC = [YSProjectGWViewController new];
        projectVC.lanchModel = model;
        [self.navigationController pushViewController:projectVC animated:YES];
    }else {
    YSHRSelpItem *selfItem = self.dataSourceArray[indexPath.row];
    YSCommonFlowLaunchListViewController *viewController = [[YSCommonFlowLaunchListViewController alloc]init];
    viewController.cellModel = model;
    viewController.remark = selfItem.remark;
    viewController.source = @"HR";
    [self.navigationController pushViewController:viewController animated:YES];
    }
}


@end
