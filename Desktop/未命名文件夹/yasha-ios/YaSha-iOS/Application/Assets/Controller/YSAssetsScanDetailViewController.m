//
//  YSAssetsScanDetailViewController.m
//  YaSha-iOS
//
//  Created by 方鹏俊 on 2017/12/12.
//  Copyright © 2017年 亚厦装饰股份有限公司. All rights reserved.
//

#import "YSAssetsScanDetailViewController.h"
#import "YSAssetsDetailView.h"
#import "YSAssetsDetailListViewController.h"
#import "YSAssetsDetailViewController.h"
#import "YSAssetsDetailModel.h"

@interface YSAssetsScanDetailViewController ()

@property (nonatomic, strong) YSAssetsDetailView *assetsDetailView;
@property (nonatomic, strong) UIScrollView *scrollView;

@end

@implementation YSAssetsScanDetailViewController

- (void)setNavigationItemsIsInEditMode:(BOOL)isInEditMode animated:(BOOL)animated {
    [super setNavigationItemsIsInEditMode:isInEditMode animated:animated];
    self.title = _titleString;
}

- (void)initSubviews {
    [super initSubviews];
    _scrollView = [[UIScrollView alloc] init];
    _scrollView.contentSize = CGSizeMake(kSCREEN_WIDTH, kSCREEN_HEIGHT);
    [self.view addSubview:_scrollView];
    [_scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.bottom.right.mas_equalTo(self.view);
    }];
    _assetsDetailView = [[YSAssetsDetailView alloc] init];
    [_scrollView addSubview:_assetsDetailView];
    [self doNetworking];
}

- (void)backToScan:(NSString *)checkInventoryId {
    [self updateStatus:checkInventoryId];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)finishCheck:(NSString *)checkInventoryId {
    [self updateStatus:checkInventoryId];
    for (UIViewController *viewController in self.rt_navigationController.rt_viewControllers) {
        DLog(@"%@", viewController);
        if ([viewController isKindOfClass:[YSAssetsDetailListViewController class]]) {
            [self.navigationController popToViewController:viewController animated:YES];
        }
    }
}

- (void)updateStatus:(NSString *)checkInventoryId {
    NSString *urlString = [NSString stringWithFormat:@"%@%@/%@/YQR", YSDomain, updateCheckInventory, checkInventoryId];
    NSDictionary *payload = @{
                              @"info": @"扫码盘点"
                              };
    [YSNetManager ys_request_POSTWithUrlString:urlString isNeedCache:NO parameters:payload successBlock:^(id response) {
        DLog(@"%@", response);
        [QMUITips hideAllToastInView:self.view animated:YES];
        if ([response[@"data"] integerValue] == 1) {
            [self.navigationController popViewControllerAnimated:YES];
        }
    } failureBlock:^(NSError *error) {
        DLog(@"error:%@", error);
    } progress:nil];
}

- (void)doNetworking {
    NSString *urlString = [NSString stringWithFormat:@"%@%@/%@/%@", YSDomain, getScanAccount, _id, _checkId];
    [YSNetManager ys_request_GETWithUrlString:urlString isNeedCache:NO parameters:nil successBlock:^(id response) {
        DLog(@"资产详情:%@", response);
        if ([response[@"code"] integerValue] == 1) {
            YSAssetsDetailModel *cellModel = [YSAssetsDetailModel yy_modelWithJSON:response[@"data"]];
            if (_isCheck) {
                [_assetsDetailView setSearchWithCellModel:cellModel];
                [[_assetsDetailView.retryButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
                    [self backToScan:response[@"data"][@"checkInventoryId"]];
                }];
            } else {
                if ([cellModel.scanType isEqual:@"BZPD"]) {
                    [_assetsDetailView setErrorStatusWithCellModel:cellModel];
                    [[_assetsDetailView.retryButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
                        [self backToScan:response[@"data"][@"checkInventoryId"]];
                    }];
                } else if ([cellModel.scanType isEqual:@"WZC"]) {
                    [_assetsDetailView setErrorStatus];
                    [[_assetsDetailView.retryButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
                        [self backToScan:response[@"data"][@"checkInventoryId"]];
                    }];
                } else {
                    [_assetsDetailView setCellModel:cellModel];
                    [[_assetsDetailView.confirmButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
                        [self backToScan:response[@"data"][@"checkInventoryId"]];
                    }];
                    [[_assetsDetailView.finishButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
                        [self finishCheck:response[@"data"][@"checkInventoryId"]];
                    }];
                }
            }
        }
    } failureBlock:^(NSError *error) {
        [QMUITips showError:@"搜不到任何结果，请重新扫描" inView:self.view hideAfterDelay:1];
        DLog(@"error:%@", error);
    } progress:nil];
}

@end
