//
//  YSContactOuterViewController.m
//  YaSha-iOS
//
//  Created by 方鹏俊 on 2018/1/23.
//  Copyright © 2018年 亚厦装饰股份有限公司. All rights reserved.
//

#import "YSContactOuterViewController.h"

@interface YSContactOuterViewController ()

@end

@implementation YSContactOuterViewController

- (void)setNavigationItemsIsInEditMode:(BOOL)isInEditMode animated:(BOOL)animated {
    [super setNavigationItemsIsInEditMode:isInEditMode animated:animated];
    self.title = @"外部通讯录";
}

- (void)initTableView {
    [super initTableView];
    [self doNetworking];
}

- (void)doNetworking {
    NSString *urlString = [NSString stringWithFormat:@"%@%@", YSDomain, getOuterPersonsApi];
    [YSNetManager ys_request_GETWithUrlString:urlString isNeedCache:NO parameters:nil successBlock:^(id response) {
        DLog(@"获取外部通讯录:%@", response);
    } failureBlock:^(NSError *error) {
        DLog(@"error:%@", error);
    } progress:nil];
}

@end
