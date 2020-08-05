//
//  YSSupplyListViewController.m
//  YaSha-iOS
//
//  Created by 方鹏俊 on 2018/1/4.
//  Copyright © 2018年 亚厦装饰股份有限公司. All rights reserved.
//

#import "YSSupplyListViewController.h"
#import "YSSupplyListTableViewCell.h"
#import "YSSupplyListInfoViewController.h"

@interface YSSupplyListViewController ()

@property (nonatomic, strong) QMUIPopupMenuView *rightPopupMenuView;
@property (nonatomic, strong) NSMutableDictionary *payload;

@end

@implementation YSSupplyListViewController
- (NSMutableDictionary *)payload {
    if (!_payload) {
        _payload = [NSMutableDictionary dictionary];
    }
    return _payload;
}
- (instancetype)initWithStyle:(UITableViewStyle)style{
    if (self = [super initWithStyle:style]) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(searchAndFilter:) name:@"searchSupply" object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(searchAndFilter:) name:@"filterSupply" object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(resetPMSPayload) name:@"resetSupplyPayload" object:nil];
    }
    return self;
}
- (void)initTableView {
     [super initTableView];
    [self.payload setObject:self.SupplyType == QualifiedSupplyInfo ? @"qualified" : @"" forKey:@"status"];
    [self.payload setObject:@"0" forKey:@"isBlackList"];
    [self.tableView registerClass:[YSSupplyListTableViewCell class] forCellReuseIdentifier:@"SupplyListCell"];
    [self doNetworking];
}

- (UIEdgeInsets)tableViewInitialContentInset {
    return UIEdgeInsetsMake(0, 0, kTopHeight+kBottomHeight+40*kHeightScale, 0);
}

- (void)searchAndFilter:(NSNotification *)notification {
    [self resetPMSPayload];
    for (int i = 0; i < notification.userInfo.allKeys.count; i ++) {
        DLog(@"======%@",notification.userInfo.allKeys[i]);
        [_payload setObject:notification.userInfo.allValues[i] forKey:notification.userInfo.allKeys[i]];
    }
    self.pageNumber = 1;
    [self doNetworking];
}

- (void)resetPMSPayload {
    NSString *searchStr = self.payload[@"keyWord"];//搜索字段不清空
    [_payload removeAllObjects];
    [self.payload setObject:self.SupplyType == QualifiedSupplyInfo ? @"qualified" : @"" forKey:@"status"];
    [self.payload setObject:@"" forKey:@"keyWord"];
    [self.payload setObject:@"0" forKey:@"isBlackList"];
    [_payload setValue:searchStr forKey:@"keyWord"];
    self.pageNumber = 1;
    [self doNetworking];
}

- (void)doNetworking {
    DLog(@"------------%@",_payload);
    [QMUITips showLoadingInView:self.view];
    [YSNetManager ys_request_GETWithUrlString:[NSString stringWithFormat:@"%@%@/%zd",YSDomain,getFranInfoListApp,self.pageNumber] isNeedCache:NO parameters:_payload successBlock:^(id response) {
        DLog(@"========%@",response);
        [QMUITips hideAllToastInView:self.view animated:YES];
        self.pageNumber == 1 ? [self.dataSourceArray removeAllObjects] : nil;
        
        [self.dataSourceArray addObjectsFromArray:[YSDataManager getSupplyListData:response]];
        self.tableView.mj_footer.state = [YSDataManager getSupplyListData:response].count < 15 ? MJRefreshStateNoMoreData : MJRefreshStateIdle;
        [self ys_reloadData];
        [self.tableView.mj_header endRefreshing];
    } failureBlock:^(NSError *error) {
        DLog(@"--------%@",error);
    } progress:nil];
}


- (void)viewDidLoad {
    [super viewDidLoad];
  
}
- (void)addRightPopupMenuView {
    if (!self.rightPopupMenuView) {
        __weak __typeof(self)weakSelf = self;
        
        self.rightPopupMenuView = [[QMUIPopupMenuView alloc] init];
        self.rightPopupMenuView.automaticallyHidesWhenUserTap = YES;
        self.rightPopupMenuView.maskViewBackgroundColor = UIColorMaskWhite;
        self.rightPopupMenuView.maximumWidth = 120*kWidthScale;
        self.rightPopupMenuView.shouldShowItemSeparator = YES;
        self.rightPopupMenuView.separatorInset = UIEdgeInsetsMake(0, self.rightPopupMenuView.padding.left, 0, self.rightPopupMenuView.padding.right);
        self.rightPopupMenuView.items = @[
                                          [QMUIPopupMenuItem itemWithImage:nil title:@"收藏" handler:^{
                                              [weakSelf.rightPopupMenuView hideWithAnimated:YES];
                                          }],
                                          [QMUIPopupMenuItem itemWithImage:nil title:@"黑名单" handler:^{
                                              
                                              [weakSelf.rightPopupMenuView hideWithAnimated:YES];
                                          }]
                                          ];
        
        self.rightPopupMenuView.didHideBlock = ^(BOOL hidesByUserTap) {
            
        };
    }
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    [self.rightPopupMenuView layoutWithTargetView:_button];
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSourceArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 97*kHeightScale;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    YSSupplyListTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if (cell == nil) {
        cell = [[YSSupplyListTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"SupplyListCell"];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell setSupplyListCellData:self.dataSourceArray[indexPath.row]];
    return  cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"hidePMSKeyboard" object:nil];
    YSSupplyListInfoViewController *SupplyListInfoViewController = [[YSSupplyListInfoViewController alloc]initWithStyle:UITableViewStyleGrouped];
    SupplyListInfoViewController.model = self.dataSourceArray[indexPath.row];
    [self.navigationController pushViewController:SupplyListInfoViewController animated:YES];
}

@end
