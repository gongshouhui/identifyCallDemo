//
//  YSPMSMQListViewController.m
//  YaSha-iOS
//
//  Created by YaSha_Tom on 2018/2/7.
//  Copyright © 2018年 亚厦装饰股份有限公司. All rights reserved.
//

#import "YSPMSMQListViewController.h"
#import "YSPMSMQInfoViewController.h"
#import "YSPMSInfoListCell.h"
#import "YSPMSInfoListModel.h"
#import "YSACLModel.h"

@interface YSPMSMQListViewController ()
@property (nonatomic, strong) NSMutableDictionary *diction;
@property (nonatomic, strong) NSDictionary *originalDataDic;
@property (nonatomic, strong) NSString *projectId;
@property (nonatomic, strong) NSMutableDictionary *payload;
//@property (nonatomic, strong) RLMResults *mqresults;
@property (nonatomic, assign) BOOL mqresults;
@property (nonatomic, strong) NSString *stateInfo;
@end
static NSString  *cellIdentifier = @"PMSListCell";
@implementation YSPMSMQListViewController
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
        _mqresults = [YSUtility checkDatabaseSystemSn:MQInfomanagement andModuleSn:ZSAllPriCompanyModel andCompanyId:MQcompanyId andPermissionValue:ZSAllPriCompanyPermissionValue];
        [self.payload setValue:@"0001K310000000000F91" forKey:@"priCompanyId"];
        [self.payload setValue:_mqresults? @"true" : @"false" forKey:@"isAllPriCompany"];
        
       
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // 滑动tableView时隐藏键盘
    self.tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
}
- (void)initTableView {
    [super initTableView];
    [self.tableView registerClass:[YSPMSInfoListCell class] forCellReuseIdentifier:cellIdentifier];
    if (_PMSMQType == AutotrophyInfoOne) {
        _stateInfo = @"zy1";
    }else if (_PMSMQType == AutotrophyInfoTwo) {
        _stateInfo = @"zy2";
    }else{
        _stateInfo = @"kh";
    }
    [self.payload setValue:_stateInfo forKey:@"proNature"];
    [self doNetworking];
}
- (UIEdgeInsets)tableViewInitialContentInset {
    return UIEdgeInsetsMake(0, 0, kTopHeight+kBottomHeight, 0);
}
- (void)searchAndFilter:(NSNotification *)notification {
    [self resetPMSPayload];
    for (int i = 0; i < notification.userInfo.allKeys.count; i ++) {
        [self.payload setValue:notification.userInfo.allValues[i] forKey:notification.userInfo.allKeys[i]];
    }
    DLog(@"-------%@",self.payload);
    self.pageNumber = 1;
    [self doNetworking];
}

- (void)resetPMSPayload {
    NSString *searchStr = self.payload[@"name"];
    [_payload removeAllObjects];
    [_payload setObject:@"0001K310000000000F91" forKey:@"priCompanyId"];
    [_payload setObject:_mqresults ? @"true" : @"false" forKey:@"isAllPriCompany"];
    [_payload setObject:_stateInfo forKey:@"proNature"];
    [_payload setValue:searchStr forKey:@"name"];
    self.pageNumber = 1;
    [self doNetworking];
}

- (void)doNetworking {
    NSString *urlString = [NSString stringWithFormat:@"%@%@/%zd", YSDomain, getBaseInfoListAppMQ, self.pageNumber];
     DLog(@"%@", _payload);
    [QMUITips showLoadingInView:self.view];
    [YSNetManager ys_request_GETWithUrlString:urlString isNeedCache:NO parameters:_payload successBlock:^(id response) {
        DLog(@"获取项目列表:%@",response);
        [QMUITips hideAllToastInView:self.view animated:YES];
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

#pragma mark - Table view data source

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
    YSPMSMQInfoViewController *PMSMQInfoViewController = [[YSPMSMQInfoViewController alloc] initWithStyle:UITableViewStyleGrouped];
    PMSMQInfoViewController.projectId = model.id;
   
    [self.navigationController pushViewController:PMSMQInfoViewController animated:YES];
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
