//
//  YSNewsDetailViewController.m
//  YaSha-iOS
//
//  Created by 方鹏俊 on 2017/12/12.
//  Copyright © 2017年 亚厦装饰股份有限公司. All rights reserved.
//

#import "YSNewsDetailViewController.h"
#import "YSNewsDetailView.h"
#import "YSNewsAttachmentViewController.h"
#import "YSNewsListModel.h"
#import "YSNewsInfoCell.h"

@interface YSNewsDetailViewController ()<UITableViewDataSource, UITableViewDelegate,YSNewsDetailViewDelegate>

@property (nonatomic, strong) YSNewsDetailView *newsDetailView;
@property (nonatomic,strong) YSNewsListModel *newsModel;
@property (nonatomic, strong) NSArray *infoArray;
//弹出视图详情
@property (nonatomic, strong) UITableView *infoTableView;
@end

@implementation YSNewsDetailViewController

static NSString *cellIdentifier = @"NewsInfoCell";

- (UITableView *)infoTableView {
    if (!_infoTableView) {
        _infoTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 0, 0) style:UITableViewStyleGrouped];
        _infoTableView.scrollEnabled = NO;
        _infoTableView.backgroundColor = UIColorWhite;
        _infoTableView.dataSource = self;
        _infoTableView.delegate = self;
        _infoTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_infoTableView registerClass:[YSNewsInfoCell class] forCellReuseIdentifier:cellIdentifier];
        _infoTableView.layer.cornerRadius = 13;
    }
    return _infoTableView;
}

- (void)setNavigationItemsIsInEditMode:(BOOL)isInEditMode animated:(BOOL)animated {
    [super setNavigationItemsIsInEditMode:isInEditMode animated:animated];
    self.title = _newsType == YSNewsTypeNews ? @"新闻详情" : @"公告详情";
    if (_newsType == YSNewsTypeNotice) {
        self.navigationItem.rightBarButtonItem = [QMUINavigationButton barButtonItemWithImage:UIImageMake(@"information") position:QMUINavigationButtonPositionRight target:self action:@selector(handlePresentShowing)];
    }
}

- (void)initSubviews {
    [super initSubviews];
    [self addDetailView];
    [self doNetworking];
    
    
   
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
   
    
}

- (void)addDetailView {
    _newsDetailView = [[YSNewsDetailView alloc] init];
    _newsDetailView.delegate = self;
    [_newsDetailView setCellModel:_cellModel];
    [self.view addSubview:_newsDetailView];
    [_newsDetailView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.bottom.right.mas_equalTo(self.view);
    }];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.infoArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    YSNewsInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[YSNewsInfoCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    [cell setInfoDict:_infoArray[indexPath.row]];
    return cell;
}

#pragma mark - UITableViewDelegate



- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
        return [tableView fd_heightForCellWithIdentifier:cellIdentifier configuration:^(YSNewsInfoCell *cell) {
            [cell setInfoDict:_infoArray[indexPath.row]];
        }];
   
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.01;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return nil;
}

- (void)doNetworking {
    YSWeak;
    NSString *urlString = [NSString stringWithFormat:@"%@%@/%@", YSDomain, getNewBulletinDetailApi, _cellModel.id];
    [YSNetManager ys_request_GETWithUrlString:urlString isNeedCache:NO parameters:nil successBlock:^(id response) {
        DLog(@"新闻详情:%@", response);
        if ([response[@"code"] intValue] == 1) {
            NSDictionary *dataDict = response[@"data"];
            [weakSelf.newsDetailView setDataDict:dataDict];
            _infoArray = @[@{@"发文编号": dataDict[@"articleNo"]},
                          @{@"发文主体": dataDict[@"ownerName"]},
                          @{@"发文范围": dataDict[@"rangeName"]},
                          @{@"关键词": dataDict[@"keyword"]},
                          @{@"审批信息": dataDict[@"approveRemark"]}];
        }
    } failureBlock:^(NSError *error) {
        DLog(@"error:%@", error);
    } progress:nil];
    
    NSString *saveVisitRecordUrlString = [NSString stringWithFormat:@"%@%@/%@", YSDomain, saveVisitRecordApi, _newsType == YSNewsTypeNews ? @"1" : @"2"];
    NSDictionary *payload = @{
                              @"ip": [YSUtility getIPAddress],
                              @"id": _cellModel.id
                              };
    [YSNetManager ys_request_POSTWithUrlString:saveVisitRecordUrlString isNeedCache:NO parameters:payload successBlock:^(id response) {
        DLog(@"保存阅读记录:%@", response);
        if ([response[@"code"] intValue] == 1) {
            weakSelf.SaveVisitRecordBlock(YES);
        }
    } failureBlock:^(NSError *error) {
        DLog(@"error:%@", error);
    } progress:nil];
    
    NSString *getNewsFileUrlString = [NSString stringWithFormat:@"%@%@/%@", YSDomain, getNewsFileApi, _cellModel.id];
    [YSNetManager ys_request_GETWithUrlString:getNewsFileUrlString isNeedCache:NO parameters:nil successBlock:^(id response) {
        DLog(@"获取新闻附件:%@", response);
        if ([response[@"code"] intValue] == 1) {
            weakSelf.dataSource = [YSDataManager getNewsAttachmentListData:response];
            [weakSelf.newsDetailView setDataSourceArray:weakSelf.dataSource];
        }
    } failureBlock:^(NSError *error) {
        DLog(@"error:%@", error);
    } progress:nil];
}
#pragma YSNewsDetailViewDelegate
- (void)attachCellDidSelected:(YSNewsAttachmentModel *)attachmentModel {
    YSNewsAttachmentViewController *newsAttachmentViewController = [[YSNewsAttachmentViewController alloc] init];
    newsAttachmentViewController.attachmentModel = attachmentModel;
    [self.navigationController pushViewController:newsAttachmentViewController animated:YES];
}
- (void)handlePresentShowing {
    QMUIModalPresentationViewController *modalViewController = [[QMUIModalPresentationViewController alloc] init];
    modalViewController.contentView = self.infoTableView;
    [self presentViewController:modalViewController animated:NO completion:nil];
}

@end
