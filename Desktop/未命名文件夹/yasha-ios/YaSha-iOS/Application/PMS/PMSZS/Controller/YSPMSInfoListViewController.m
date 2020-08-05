//
//  YSPMSInfoListViewController.m
//  YaSha-iOS
//
//  Created by YaSha_Tom on 2018/1/26.
//  Copyright © 2018年 亚厦装饰股份有限公司. All rights reserved.
//

#import "YSPMSInfoListViewController.h"
#import "YSPMSInfoListModel.h"
#import "YSPMSInfoListCell.h"
#import "YSPMSInfoViewController.h"
#import "YSSingleton.h"
#import "YSACLModel.h"

@interface YSPMSInfoListViewController ()

@property (nonatomic, assign) NSInteger pageNumber;
@property (nonatomic, strong) NSMutableArray *dataSourceArray;
@property (nonatomic, strong) NSString *projectId;
@property (nonatomic, strong) NSMutableDictionary *payload;
@property (nonatomic, assign) BOOL zsResults;
@property (nonatomic, assign) BOOL zsOperationResults;
@property (nonatomic, strong) NSString *stateInfo;

@end

static NSString *cellIdentifier = @"PMSListCell";

@implementation YSPMSInfoListViewController
- (NSMutableDictionary *)payload {
    if (!_payload) {
        _payload = [NSMutableDictionary dictionary];
    }
    return _payload;
}
- (instancetype)initWithStyle:(UITableViewStyle)style{
    if (self = [super initWithStyle:style]) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(searchAndFilter:) name:@"searchPMS" object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(searchAndFilter:) name:@"filterPMS" object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(resetPMSPayload) name:@"resetPMSPayload" object:nil];
        //基本参数设置
        self.zsResults = [YSUtility checkDatabaseSystemSn:Infomanagement andModuleSn:ZSAllPriCompanyModel andCompanyId:ZScompanyId andPermissionValue:ZSAllPriCompanyPermissionValue];
        self.zsOperationResults = [YSUtility checkDatabaseSystemSn:Infomanagement andModuleSn:ZSModuleIdentification andCompanyId:ZScompanyId andPermissionValue:ZSStatusPermissionValue];
        [self.payload setValue:@"0001K310000000000ABV" forKey:@"priCompanyId"];
        [self.payload setValue:_zsResults ? @"true" : @"false" forKey:@"isAllPriCompany"];
        [self.payload setValue:_zsOperationResults?@"":@"30" forKey:@"auditStatusStr"];
    }
    return self;
}
- (void)initTableView {
    [super initTableView];
    [self.tableView registerClass:[YSPMSInfoListCell class] forCellReuseIdentifier:cellIdentifier];
    //种类设置
    if (_PMSInfoType == AutotrophyInfo) {
        _stateInfo = @"zyxm";
    }else if (_PMSInfoType == CheckInfo) {
        _stateInfo = @"khxm";
    }else{
        _stateInfo = @"hzxm";
    }
    [self.payload setValue:_stateInfo forKey:@"proNature"];
    [self doNetworking];
    
}
- (UIEdgeInsets)tableViewInitialContentInset {
    return UIEdgeInsetsMake(0, 0, kTopHeight+kBottomHeight+40*kHeightScale, 0);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // 滑动tableView时隐藏键盘
    self.tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
}
#pragma mark -  搜索回调
- (void)searchAndFilter:(NSNotification *)notification {
    DLog(@"---------%@",notification.userInfo);
    [self resetPMSPayload];
    for (int i = 0; i < notification.userInfo.allKeys.count; i ++) {
    [self.payload setValue:notification.userInfo.allValues[i] forKey:notification.userInfo.allKeys[i]];
    }
    DLog(@"=======%@",self.payload);
    self.pageNumber = 1;
    [self doNetworking];
}

- (void)resetPMSPayload {
    NSString *searchStr = self.payload[@"name"];//搜索字段不清空
    [_payload removeAllObjects];
    [_payload setObject:@"0001K310000000000ABV" forKey:@"priCompanyId"];
    [_payload setObject:_zsResults ? @"true" : @"false" forKey:@"isAllPriCompany"];
    [_payload setObject:_stateInfo forKey:@"proNature"];
    [_payload setObject:_zsOperationResults?@"":@"30"forKey:@"auditStatusStr"];
    [_payload setValue:searchStr forKey:@"name"];
    self.pageNumber = 1;
    [self doNetworking];
}
- (void)doNetworking {
    NSString *urlString = [NSString stringWithFormat:@"%@%@/%zd", YSDomain, getBaseInfoListApp, self.pageNumber];
    DLog(@"%@",_payload);
    [YSNetManager ys_request_GETWithUrlString:urlString isNeedCache:NO parameters:_payload successBlock:^(id response) {
        DLog(@"获取项目列表:%@",response);
        if (self.pageNumber==1) {
            [self.dataSourceArray removeAllObjects];
        }
        [self.dataSourceArray addObjectsFromArray:[YSDataManager getPMSInfoListData:response]];
        self.tableView.mj_footer.state = [YSDataManager getPMSInfoListData:response].count < 15 ? MJRefreshStateNoMoreData : MJRefreshStateIdle;
        [self ys_reloadData];
        [self.tableView.mj_header endRefreshing];
    } failureBlock:^(NSError *error) {
        DLog(@"error:%@", error);
    } progress:nil];
    
}
#pragma mark - UITableViewDatasource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSourceArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    YSPMSInfoListCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[YSPMSInfoListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    YSPMSInfoListModel *cellModel = self.dataSourceArray[indexPath.row];
    [cell setCellModel:cellModel];
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"hidePMSKeyboard" object:nil];
    YSPMSInfoListModel *model = self.dataSourceArray[indexPath.row];
    YSPMSInfoViewController *PMSInfoViewController = [[YSPMSInfoViewController alloc] initWithStyle:UITableViewStyleGrouped];
    PMSInfoViewController.projectId = model.id;
    [self.navigationController pushViewController:PMSInfoViewController animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 97*kHeightScale;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.01;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return nil;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
