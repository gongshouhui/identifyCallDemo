//
//  YSPMSInfoViewController.m
//  YaSha-iOS
//
//  Created by YaSha_Tom on 2017/12/13.
//  Copyright © 2017年 亚厦装饰股份有限公司. All rights reserved.
//

#import "YSPMSInfoViewController.h"
#import "YSPMSInfoDetailHeaderCell.h"
#import "YSPMSInfoDetailViewController.h"
#import "YSPMSUnitInfoViewController.h"
#import "YSPMSPeopleInfoViewController.h"
#import "YSPMSFinanceInfoViewController.h"
#import "YSPMSAccessoryInfoViewController.h"
#import "YSPMSHistoryInfoViewController.h"

@interface YSPMSInfoViewController ()
@property (nonatomic, strong) NSArray *dataSourceArray;
@property (nonatomic, strong) NSArray *titleArray;
@property (nonatomic, strong) NSArray *informationDataArray;
@property (nonatomic, strong) NSString *projectName;
@property (nonatomic, strong) NSDictionary *toNextPageDic;

@end

@implementation YSPMSInfoViewController

static NSString *cellHeaderIdentifier = @"PMSInfoDetailHeaderCell";

- (void)setNavigationItemsIsInEditMode:(BOOL)isInEditMode animated:(BOOL)animated {
    [super setNavigationItemsIsInEditMode:isInEditMode animated:animated];
    self.title = @"项目信息详情";
}
- (void)initTableView {
    [super initTableView];
    _titleArray = @[@"项目编号",@"工程地址",@"项目线条",@"项目所属年份",@"项目性质",@"合同价（万元）",@"项目类型",@"项目经理",@"所属部门",@"工期（天）",@"项目状态"];
    self.dataSourceArray = @[@"信息详情", @"单位信息", @"人员信息", @"财务信息"];
    
    [self.tableView registerClass:[YSPMSInfoDetailHeaderCell class] forCellReuseIdentifier:cellHeaderIdentifier];
    [self doNetworking];
}

- (void)doNetworking {
    [YSNetManager ys_request_GETWithUrlString:[NSString stringWithFormat:@"%@%@/%@",YSDomain, getBaseInfoDeatilApp, self.projectId] isNeedCache:NO parameters:nil successBlock:^(id response) {
        DLog(@"response = %@",response);
        [self handleData:response[@"data"]];
        self.toNextPageDic = response[@"data"];
        self.projectName = response[@"data"][@"name"];
    } failureBlock:^(NSError *error) {
        DLog(@"error = %@",error);
    } progress:nil];
    
}

- (void)handleData:(NSDictionary *)response {
    self.informationDataArray = @[response[@"code"],
                                  [NSString stringWithFormat:@"%@%@%@%@",response[@"province"],response[@"city"],response[@"area"],
                                   response[@"address"]],
                                  response[@"itemLineName"],
                                  [YSUtility timestampSwitchTime:response[@"belongTime"] andFormatter:@"yyyy"],
                                  response[@"proNatureName"],
                                  [NSString stringWithFormat:@"%@ %.4f",response[@"contCurrency"],[[YSUtility cancelNullData:response[@"contPrice"]] floatValue]],
                                  response[@"proTypeStr"],
                                  response[@"proManName"],
                                  response[@"deptStr"],
                                  [YSUtility cancelNullData:response[@"timeLimit"]],
                                  response[@"proStatusName"]];
    [self.tableView cyl_reloadData];
    
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return self.titleArray.count +1;
    }else{
        return self.dataSourceArray.count ;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        YSPMSInfoDetailHeaderCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        if (!cell) {
            cell = [[YSPMSInfoDetailHeaderCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellHeaderIdentifier];
        }
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        cell.separatorInset = UIEdgeInsetsMake(0, kSCREEN_WIDTH, 0, 0);
        if (indexPath.row == 0) {
            UILabel *projectLabel = [[UILabel alloc]init];
            projectLabel.textAlignment = NSTextAlignmentCenter;
            projectLabel.font = [UIFont systemFontOfSize:17];
            projectLabel.textColor = kUIColor(51, 51, 51, 1.0);
            projectLabel.numberOfLines = 0;
            projectLabel.adjustsFontSizeToFitWidth = YES;
            projectLabel.text = self.projectName;
            [cell addSubview:projectLabel];
            [projectLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.center.mas_equalTo(cell);
                make.size.mas_equalTo(CGSizeMake(kSCREEN_WIDTH-80*kWidthScale, 80*kHeightScale));
            }];
        }else {
            cell.titleLabel.text = self.titleArray[indexPath.row-1];
            if (![self.informationDataArray[indexPath.row-1] isEqual:@""]) {
                cell.contentLabel.text =self.informationDataArray[indexPath.row-1];
            }else{
                cell.contentLabel.text = @" ";
            }
        }
        return cell;
    } else {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"Cell"];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        cell.textLabel.text = self.dataSourceArray[indexPath.row];
        cell.textLabel.font = [UIFont systemFontOfSize:16];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.01;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0 && indexPath.row != 0) {
        return [tableView fd_heightForCellWithIdentifier:cellHeaderIdentifier cacheByIndexPath:indexPath configuration:^(YSPMSInfoDetailHeaderCell *cell) {
            if (![self.informationDataArray[indexPath.row-1] isEqual:@""]) {
                cell.contentLabel.text = self.informationDataArray[indexPath.row-1] ;
            }else{
                cell.contentLabel.text = @"设置";
            }
        }]+5;
    }
    if (indexPath.section == 0 && indexPath.row == 0) {
        return 80*kHeightScale;
    }
    return 44*kHeightScale;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 1) {
        if (indexPath.row == 0) {
            YSPMSInfoDetailViewController *infoView = [[YSPMSInfoDetailViewController alloc]initWithStyle:UITableViewStyleGrouped];
            infoView.projectId = self.projectId;
            infoView.dataDiction = self.toNextPageDic;
            [self.navigationController pushViewController:infoView animated:YES];
        }else if (indexPath.row == 1) {
            YSPMSUnitInfoViewController *unitInfoView = [[YSPMSUnitInfoViewController alloc]initWithStyle:UITableViewStyleGrouped];
            unitInfoView.projectId = self.projectId;
            [self.navigationController pushViewController:unitInfoView animated:YES];
        }else if (indexPath.row == 2) {
            YSPMSPeopleInfoViewController *peopleInfoView = [[YSPMSPeopleInfoViewController alloc]initWithStyle:UITableViewStyleGrouped];
            peopleInfoView.projectId = self.projectId;
            [self.navigationController pushViewController:peopleInfoView animated:YES];
        }else if (indexPath.row == 3) {
            YSPMSFinanceInfoViewController *financeInfoView = [[YSPMSFinanceInfoViewController alloc]initWithStyle:UITableViewStyleGrouped];
            financeInfoView.projectId = self.projectId;
            [self.navigationController pushViewController:financeInfoView animated:YES];
        }else if (indexPath.row == 5) {
            YSPMSAccessoryInfoViewController *accessoryInfoView = [[YSPMSAccessoryInfoViewController alloc]initWithStyle:UITableViewStyleGrouped];
            [self.navigationController pushViewController:accessoryInfoView animated:YES];
        }else if (indexPath.row == 4) {
            YSPMSHistoryInfoViewController *historyInfoView = [[YSPMSHistoryInfoViewController alloc]initWithStyle:UITableViewStyleGrouped];
            historyInfoView.projectId = self.projectId;
            [self.navigationController pushViewController:historyInfoView animated:YES];
        }
        
    }
}



- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}
- (UIView *)makePlaceHolderView {
    return [YSUtility NoDataView:@"无数据"];
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
