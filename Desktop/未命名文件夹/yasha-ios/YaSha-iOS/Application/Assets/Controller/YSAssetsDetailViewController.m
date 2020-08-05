//
//  YSAssetsDetailViewController.m
//  YaSha-iOS
//
//  Created by 方鹏俊 on 2017/12/12.
//  Copyright © 2017年 亚厦装饰股份有限公司. All rights reserved.
//

#import "YSAssetsDetailViewController.h"
#import "YSAssetsDetailView.h"
#import "YSAssetsMineDetailView.h"
#import "YSAssetsDetailViewController.h"
#import "YSAssetsDetailModel.h"

@interface YSAssetsDetailViewController ()

@property (nonatomic, strong) YSAssetsDetailView *assetsDetailView;
@property (nonatomic, strong) YSAssetsMineDetailView *assetsMineDetailView;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIButton *button;

@end

@implementation YSAssetsDetailViewController

- (void)setNavigationItemsIsInEditMode:(BOOL)isInEditMode animated:(BOOL)animated {
    [super setNavigationItemsIsInEditMode:isInEditMode animated:animated];
    self.title = _titleString;
}

- (void)initSubviews {
    [super initSubviews];
    _scrollView = [[UIScrollView alloc] init];
    _scrollView.contentSize = CGSizeMake(kSCREEN_WIDTH, kSCREEN_HEIGHT+240*kHeightScale);
    [self.view addSubview:_scrollView];
    [_scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.bottom.right.mas_equalTo(self.view);
        
    }];
    if (_assetsType == AssetsTypeMine) {
        _assetsMineDetailView = [[YSAssetsMineDetailView alloc] init];
        [_scrollView addSubview:_assetsMineDetailView];
        [_assetsMineDetailView.button addTarget:self action:@selector(confirm) forControlEvents:UIControlEventTouchUpInside];
        if (self.assetStates != 104) {
            [_assetsMineDetailView.button removeFromSuperview];
        }
    } else {
        _assetsDetailView = [[YSAssetsDetailView alloc] init];
        _assetsDetailView.textView.text = _cellModel.info;
        [_scrollView addSubview:_assetsDetailView];
    }
    [self doNetworking];
}
//领用确认
- (void)confirm {
    NSString *urlString  = [NSString stringWithFormat:@"%@%@/%@",YSDomain, getUpdateMachineAccountUse, self.id];
    [YSNetManager ys_request_GETWithUrlString:urlString isNeedCache:NO parameters:nil successBlock:^(id response) {
        DLog(@"==========%@",response);
        if ([response[@"code"] intValue] == 1) {
            [_assetsMineDetailView.button removeFromSuperview];
            self.RefreshBlock(response[@"data"][@"assetsStatusStr"]);
        }
        [_scrollView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.left.bottom.right.mas_equalTo(self.view);
        }];
    } failureBlock:^(NSError *error) {
        DLog(@"__________%@",error);
    } progress:nil];
    
}

- (void)doNetworking {
    NSString *urlString = [NSString stringWithFormat:@"%@%@/%@", YSDomain, getMachineByNo, _cellModel.assetsNo];
    [YSNetManager ys_request_GETWithUrlString:urlString isNeedCache:NO parameters:nil successBlock:^(id response) {
        DLog(@"%@", response);
        YSAssetsDetailModel *cellModel = [YSAssetsDetailModel yy_modelWithJSON:response[@"data"]];
        if (_assetsType == AssetsTypeMine) {
            [_assetsMineDetailView setCellModel:cellModel];
        } else {
            [_assetsDetailView setCellModel:cellModel withReconfirm:_cellModel.reconfirm history:_history];
            _assetsDetailView.textView.text = _cellModel.info;
            [[_assetsDetailView.confirmNormalButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
                [self confirm:@"YQR"];
            }];
            [[_assetsDetailView.confirmErrorButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
                [self confirm:@"YC"];
            }];
        }
    } failureBlock:^(NSError *error) {
        DLog(@"error:%@", error);
    } progress:nil];
}

- (void)confirm:(NSString *)reconfirm {
    NSString *urlString = [NSString stringWithFormat:@"%@%@", YSDomain, updateCheckInventory];
    NSDictionary *payload = @{
                              @"id": _cellModel.id,
                              @"reconfirm": reconfirm,
                              @"info": _assetsDetailView.textView.text
                              };
    [YSNetManager ys_request_POSTWithUrlString:urlString isNeedCache:NO parameters:payload successBlock:^(id response) {
        DLog(@"%@", response);
        [QMUITips hideAllToastInView:self.view animated:YES];
        if ([response[@"data"] integerValue] == 1) {
            _cellModel.reconfirm = reconfirm;
            _cellModel.info = _assetsDetailView.textView.text;
            self.ReturnBlock(_cellModel);
            [self.navigationController popViewControllerAnimated:YES];
        }
    } failureBlock:^(NSError *error) {
        DLog(@"error:%@", error);
    } progress:nil];
}

@end
