//
//  YSPMSMQInfoViewController.m
//  YaSha-iOS
//
//  Created by YaSha_Tom on 2018/1/29.
//  Copyright © 2018年 亚厦装饰股份有限公司. All rights reserved.
//

#import "YSPMSMQInfoViewController.h"
#import "YSPMSMQInfoDetailViewController.h"
#import "YSPMSMQUnitInfoViewController.h"
#import "YSPMSMQPeopleInfoViewController.h"
#import "YSPMSMQFinanceInfoViewController.h"
#import "YSPMSInfoDetailHeaderCell.h"
#import "YSMQInfoModel.h"

@interface YSPMSMQInfoViewController ()
@property (nonatomic, strong) NSArray *titleArray;
@property (nonatomic, strong) NSArray *informationDataArray;
@property (nonatomic, strong) NSString *projectName;
@property (nonatomic, strong) NSDictionary *toNextPageDic;
@property (nonatomic,strong) YSMQInfoModel *infoModel;
@end

static NSString *cellHeaderIdentifier = @"PMSInfoDetailHeaderCell";

@implementation YSPMSMQInfoViewController

- (void)initTableView {
    [super initTableView];
    self.title = @"项目信息详情";
    
    [self.tableView registerClass:[YSPMSInfoDetailHeaderCell class] forCellReuseIdentifier:cellHeaderIdentifier];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self doNetworking];
}
- (void)doNetworking {
    [YSNetManager ys_request_GETWithUrlString:[NSString stringWithFormat:@"%@%@/%@",YSDomain,getBaseInfoDeatilAppMQ,self.projectId] isNeedCache:NO parameters:nil successBlock:^(id response) {
       
        [QMUITips hideAllToastInView:self.view animated:YES];
        if ([response[@"code"] isEqual:@1]) {
            self.infoModel = [YSMQInfoModel yy_modelWithJSON:response[@"data"]];
            //self.toNextPageDic = response[@"data"];
            [self handleData];
            [self.tableView cyl_reloadData];
        }
        
    } failureBlock:^(NSError *error) {
        DLog(@"error = %@",error);
    } progress:nil];
}

- (void)handleData {
    NSMutableArray *proGeneralArr = [NSMutableArray array];
    [proGeneralArr addObject:@{@"工程名称":_infoModel.projectName?_infoModel.projectName:@"-"}];
    [proGeneralArr addObject:@{@"项目编码":_infoModel.code?_infoModel.code:@"-"}];
    [proGeneralArr addObject:@{@"项目地址":[NSString stringWithFormat:@"%@%@%@%@",_infoModel.province,_infoModel.city,_infoModel.area,_infoModel.address]}];
    [proGeneralArr addObject:@{@"所属公司":_infoModel.companyName?_infoModel.companyName:@"-"}];
    [proGeneralArr addObject:@{@"所属区域":_infoModel.regionStr?_infoModel.regionStr:@"-"}];
    [proGeneralArr addObject:@{@"所属部门":_infoModel.deptStr?_infoModel.deptStr:@""}];
    [proGeneralArr addObject:@{@"执行经理":_infoModel.proManName}];
    [proGeneralArr addObject:@{@"项目所属年份":[YSUtility timestampSwitchTime:_infoModel.belongTime andFormatter:@"yyyy"]}];
    [proGeneralArr addObject:@{@"项目性质":_infoModel.proNatureName?_infoModel.proNatureName:@"-"}];
    [proGeneralArr addObject:@{@"是否归入决收部":_infoModel.isNeverAcceptDept?[_infoModel.isNeverAcceptDept isEqualToString:@"10"]?@"是":@"否":@"--"}];
    [proGeneralArr addObject:@{@"计价方式":_infoModel.contFormName?_infoModel.contFormName:@"-"}];
    [proGeneralArr addObject:@{@"项目合同价":[NSString stringWithFormat:@"%@ %@",_infoModel.contCurrency,[YSUtility thousandsFormat:_infoModel.contPrice]]}];
    [proGeneralArr addObject:@{@"NC编码":_infoModel.ncCode?_infoModel.ncCode:@"-"}];
    [proGeneralArr addObject:@{@"计划开工日期":_infoModel.planStart?[YSUtility timestampSwitchTime:_infoModel.planStart andFormatter:@"YYYY-MM-dd"]:@"-"}];
    [proGeneralArr addObject:@{@"计划竣工日期":_infoModel.planEnd?[YSUtility timestampSwitchTime:_infoModel.planEnd andFormatter:@"YYYY-MM-dd hh:mm"]:@"-"}];
    [proGeneralArr addObject:@{@"计划总工期（天）":_infoModel.timeLimit?_infoModel.timeLimit:@"-"}];
    
    
    [proGeneralArr addObject:@{@"施工状态":_infoModel.proStatusName?_infoModel.proStatusName:@"-"}];
    [proGeneralArr addObject:@{@"结算状态":_infoModel.balanceStatus?_infoModel.balanceStatus:@"-"}];
    [proGeneralArr addObject:@{@"维保状态":_infoModel.maintenanceStatus?_infoModel.maintenanceStatus:@"-"}];
    [proGeneralArr addObject:@{@"收款状态":_infoModel.gatherStatus?_infoModel.gatherStatus:@"-"}];
    [self.dataSourceArray addObject:proGeneralArr];
    //
    NSArray *pointArr = @[ @"单位信息", @"项目人员",@"职能人员"];
    [self.dataSourceArray addObject:pointArr];
    
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return self.dataSourceArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.dataSourceArray[section] count];
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        YSPMSInfoDetailHeaderCell *cell = [tableView dequeueReusableCellWithIdentifier:cellHeaderIdentifier];
        if (!cell) {
            cell = [[YSPMSInfoDetailHeaderCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellHeaderIdentifier];
        }
        
        cell.dic = self.dataSourceArray[indexPath.section][indexPath.row];
        
        return cell;
    } else {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"Cell"];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        cell.textLabel.text = self.dataSourceArray[indexPath.section][indexPath.row];
        cell.textLabel.font = [UIFont systemFontOfSize:16];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        return cell;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        UIView *view = [[UIView alloc]init];
        UILabel *projectLabel = [[UILabel alloc]init];
        projectLabel.textAlignment = NSTextAlignmentCenter;
        projectLabel.font = [UIFont systemFontOfSize:17];
        projectLabel.textColor = kUIColor(51, 51, 51, 1.0);
        projectLabel.numberOfLines = 0;
        projectLabel.adjustsFontSizeToFitWidth = YES;
        projectLabel.text = self.infoModel.name;
        [view addSubview:projectLabel];
        [projectLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.mas_equalTo(0);
            make.size.mas_equalTo(CGSizeMake(kSCREEN_WIDTH-80*kWidthScale, 80*kHeightScale));
        }];
        return view;
    }else{
        return nil;
    }
    
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return 80*kHeightScale;
    }else{
        return 0.01;
    }
}
- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewAutomaticDimension;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 1) {
        if (indexPath.row == 0) {//单位详情
            YSPMSMQUnitInfoViewController *unitInfoView = [[YSPMSMQUnitInfoViewController alloc]initWithStyle:UITableViewStyleGrouped];
            unitInfoView.projectId = self.projectId;
            [self.navigationController pushViewController:unitInfoView animated:YES];
        }else if (indexPath.row == 1) {//项目人员
            YSPMSMQPeopleInfoViewController *peopleInfoView = [[YSPMSMQPeopleInfoViewController alloc]initWithStyle:UITableViewStyleGrouped];
            peopleInfoView.projectId = self.projectId;
            peopleInfoView.type = 0;
            [self.navigationController pushViewController:peopleInfoView animated:YES];
        }else if (indexPath.row == 2) {//职能人员
            YSPMSMQPeopleInfoViewController *peopleInfoView = [[YSPMSMQPeopleInfoViewController alloc]initWithStyle:UITableViewStyleGrouped];
            peopleInfoView.projectId = self.projectId;
            peopleInfoView.type = 1;
            [self.navigationController pushViewController:peopleInfoView animated:YES];
            //财务
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
