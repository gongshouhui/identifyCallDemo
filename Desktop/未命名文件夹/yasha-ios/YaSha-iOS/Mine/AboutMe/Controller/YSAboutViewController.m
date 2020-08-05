//
//  YSAboutViewController.m
//  YaSha-iOS
//
//  Created by 方鹏俊 on 2017/12/8.
//  Copyright © 2017年 亚厦装饰股份有限公司. All rights reserved.
//

#import "YSAboutViewController.h"
#import "YSAboutHeaderView.h"
#import "YSAboutLogCell.h"

@interface YSAboutViewController ()

@property (nonatomic, strong) NSString *updateString;

@end

@implementation YSAboutViewController

static NSString *aboutCellIdentifier = @"AboutLogCell";

- (void)setNavigationItemsIsInEditMode:(BOOL)isInEditMode animated:(BOOL)animated {
    [super setNavigationItemsIsInEditMode:isInEditMode animated:animated];
    self.title = @"关于";
}

- (void)initTableView {
    [super initTableView];
    [self.tableView registerClass:[YSAboutLogCell class] forCellReuseIdentifier:aboutCellIdentifier];
    [self doNetworking];
}

- (void)doNetworking {
    [super doNetworking];
    NSString *urlString = [NSString stringWithFormat:@"%@%@/1", YSDomain, getAPPVersionAPI];
    NSDictionary *dic = @{@"versionCode":[YSUtility getCurrentVersion]};
    [YSNetManager ys_request_GETWithUrlString:urlString isNeedCache:NO parameters:dic successBlock:^(id response) {
        [QMUITips hideAllTipsInView:self.view];
        DLog(@"版本更新信息:%@", response);
        if ([response[@"code"] isEqual:@1]) {
            self.dataSource = @[[NSString stringWithFormat:@"功能介绍\n\n%@", [response[@"data"][@"description"] stringByReplacingOccurrencesOfString:@"#" withString:@"\n"]]];
            [self ys_reloadData];
        }
    } failureBlock:^(NSError *error) {
        DLog(@"error:%@", error);
        [self ys_showNetworkError];
    } progress:nil];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    YSAboutLogCell *cell = [tableView dequeueReusableCellWithIdentifier:aboutCellIdentifier];
    cell = [[YSAboutLogCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:aboutCellIdentifier];
    cell.contentLabel.text = self.dataSource[indexPath.row];
    
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    YSAboutHeaderView *aboutHeaderView = [[YSAboutHeaderView alloc] init];
    return aboutHeaderView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 250*kHeightScale;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [tableView fd_heightForCellWithIdentifier:aboutCellIdentifier configuration:^(YSAboutLogCell *cell) {
        cell.contentLabel.text = self.dataSource[indexPath.row];
    }];
}

@end
