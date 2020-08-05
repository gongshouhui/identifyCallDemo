//
//  YSPMSMQUnitInfoViewController.m
//  YaSha-iOS
//
//  Created by YaSha_Tom on 2018/1/29.
//  Copyright © 2018年 亚厦装饰股份有限公司. All rights reserved.
//

#import "YSPMSMQUnitInfoViewController.h"
#import "YSPMSUnitTableViewCell.h"
#import "YSPMSUnitInfoModel.h"

@interface YSPMSMQUnitInfoViewController ()

//@property (nonatomic, strong) NSArray *dataSourceArray;
//@property (nonatomic, assign) NSInteger pageNumber;
//@property (nonatomic, strong) NSMutableArray *contentArray;
@property (nonatomic, strong) NSMutableArray *unitInfoArray;

@end

@implementation YSPMSMQUnitInfoViewController

- (void)initTableView {
    [super initTableView];
    self.title = @"单位信息";
    [self.tableView registerClass:[YSPMSUnitTableViewCell class] forCellReuseIdentifier:@"UnitInfoCell"];
//    self.contentArray = [NSMutableArray array];
    self.unitInfoArray = [NSMutableArray array];
    [self doNetworking];
}

- (void)doNetworking {
    [YSNetManager ys_request_GETWithUrlString:[NSString stringWithFormat:@"%@%@/%@/%zd", YSDomain, getCompanysListAppMQ, self.projectId, self.pageNumber] isNeedCache:NO parameters:nil successBlock:^(id response) {
        NSArray *arr = [YSDataManager getPMSUnitInfoData:response];
        if (self.pageNumber == 1) {
            [self.dataSourceArray removeAllObjects];
        }
        if (arr.count != 0) {
            [self.dataSourceArray addObjectsFromArray:arr];
        }
        self.tableView.mj_footer.state = [YSDataManager getPMSInfoListData:response].count < 15 ? MJRefreshStateNoMoreData : MJRefreshStateIdle;
        
        [self ys_reloadData];
        [self.tableView.mj_header endRefreshing];
        
    } failureBlock:^(NSError *error) {
        
    } progress:nil];
}

- (void)handleData:(NSArray *)arr {
    for (NSDictionary *dic in arr) {
        YSPMSUnitInfoModel *model = [YSPMSUnitInfoModel yy_modelWithJSON:dic];
        [self.unitInfoArray addObject:model];
        
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return self.dataSourceArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    YSPMSUnitInfoModel *model = self.dataSourceArray[section];
    return model.comPersons.count > 0 ? model.comPersons.count : 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.01;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return nil;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    YSPMSUnitTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UnitInfoCell" forIndexPath:indexPath];
    if (!cell) {
        cell = [[YSPMSUnitTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"UnitInfoCell"];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    YSPMSUnitInfoModel *model = self.dataSourceArray[indexPath.section];
    [cell setUnitInfoCellData:model andUinitInfoArr:model.comPersons andIndexPath:indexPath];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    YSPMSUnitInfoModel *model = self.dataSourceArray[indexPath.section];
    return [tableView fd_heightForCellWithIdentifier:@"UnitInfoCell" cacheByIndexPath:indexPath configuration:^(YSPMSUnitTableViewCell *cell) {
        YSPMSUnitInfoModel *model = self.dataSourceArray[indexPath.section];
        cell.twoTitleLabel.text = model.name;
        
    }] - (model.comPersons.count > 0 ? 0: 50);
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  
    YSPMSUnitInfoModel *model = self.dataSourceArray[indexPath.section];
    if (model.comPersons.count) {
        NSString *callPhone = [NSString stringWithFormat:@"telprompt://%@", model.comPersons[indexPath.row][@"mobile"]];
        NSString *versionPhone = [[UIDevice currentDevice] systemVersion];
        if ([versionPhone compare:@"10.2"options:NSNumericSearch] ==NSOrderedDescending || [versionPhone compare:@"10.2"options:NSNumericSearch] ==NSOrderedSame) {
            /// 大于等于10.0系统使用此openURL方法
            
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:callPhone] options:@{}completionHandler:nil];
        }else{
            
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:callPhone]];
        }
    }
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
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
