//
//  YSPMSMQEarilyPrePlanController.m
//  YaSha-iOS
//
//  Created by 罗罗诺亚索隆 on 2018/10/18.
//  Copyright © 2018年 亚厦装饰股份有限公司. All rights reserved.
//

#import "YSPMSMQEarilyPrePlanController.h"
#import "YSPMSMQEarilyPrePlanPresent.h"
#import "YSPMSPlanPieChartView.h"
#import "YSPMSMQEarlyPreTaskController.h"
#import "YSPMSPlanInfoViewController.h"
@interface YSPMSMQEarilyPrePlanController ()<YSPMSMQEarilyPrePlanPresentDelegate,YSPMSPlanPieChartViewDelegate>
@property (nonatomic,strong) YSPMSMQEarilyPrePlanPresent *present;
@property (nonatomic,strong) YSPMSPlanPieChartView *chartView;
@end

@implementation YSPMSMQEarilyPrePlanController
- (YSPMSPlanPieChartView *)chartView {
    if (!_chartView) {
        _chartView = [[YSPMSPlanPieChartView alloc]initWithFrame:CGRectMake(0, 0, kSCREEN_WIDTH, 286*kHeightScale)];
        _chartView.backgroundColor = [UIColor whiteColor];
        [_chartView.controlPointsButton setTitle:@"完工延期" forState:UIControlStateNormal];
        [_chartView.delayButton setTitle:@"开工延期" forState:UIControlStateNormal];
        _chartView.delegate = self;
    }
    return _chartView;
}
- (YSPMSMQEarilyPrePlanPresent *)present {
    if (!_present) {
        _present = [[YSPMSMQEarilyPrePlanPresent alloc]init];
        _present.view = self;
    }
    return _present;
}
- (void)initTableView {
    [super initTableView];
    [self hideMJRefresh];
    self.tableView.tableHeaderView = self.chartView;
}
- (void)viewDidLoad {
    [super viewDidLoad];
     self.title = @"前期进度计划管理";
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(CircleViewSectionClick:) name:@"CircleViewSectionClick" object:nil];
    [self doNetworking];
}
- (void)doNetworking {
    [super doNetworking];
    NSDictionary *payload = @{
                              @"planInfoCode":self.engineeringModel.code,
                              };
    //负责hud显示，上拉或下拉的view展示
    [self.present getListDataWithProjectCode:self.engineeringModel.code Complete:^(id  _Nonnull result, NSString * _Nonnull error) {
        [QMUITips hideAllTipsInView:self.view];
    } failure:^(NSError * _Nonnull error) {
        [QMUITips hideAllTipsInView:self.view];
    }];
    
}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return  self.present.dataArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"PlanInfoCell"];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textLabel.font = [UIFont systemFontOfSize:15];
    cell.textLabel.textColor = kUIColor(51, 51, 51, 1);
    cell.textLabel.text = self.present.dataArr[indexPath.row][@"name"];//其实这里每个cell应该对应一个p层
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    //    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    YSPMSMQEarlyPreTaskController *PMSPlanStartsViewController = [[YSPMSMQEarlyPreTaskController alloc]initWithStyle:UITableViewStyleGrouped];
    [PMSPlanStartsViewController setRefreshPrePlanBlock:^{
        [self doNetworking];
        if (self.refreshPlanListBlock) {
            self.refreshPlanListBlock();
        }
    }];
    PMSPlanStartsViewController.engineeringModel = self.engineeringModel;
    PMSPlanStartsViewController.titleName = self.present.dataArr[indexPath.row][@"name"];
    PMSPlanStartsViewController.type = [NSString stringWithFormat:@"%@",self.present.dataArr[indexPath.row][@"type"]];
    [self.navigationController pushViewController:PMSPlanStartsViewController animated:YES];
  

}
#pragma mark - YSPMSMQEarilyPrePlanPresentDelegate
- (void)earilyPrePlanPresent:(YSPMSMQEarilyPrePlanPresent *)present didGetData:(id)result {
    [self.chartView createEarlyPreparePieChart:self.present.startDelayArray andChartType:@"开工延期"];
}
#pragma mark - YSPMSPlanPieChartViewDelegate switch点击事件代理事件
- (void)constructionInfoButtonDidClick:(UIButton *)button {
   [self.chartView createEarlyPreparePieChart:self.present.startDelayArray andChartType:@"开工延期"];
}
- (void)controlPointsButtonDidClick:(UIButton *)button {
    
    [self.chartView createEarlyPreparePieChart:self.present.endDelayArray andChartType:@"完工延期"];
    
}
#pragma mark -  通知相关方法
- (void)CircleViewSectionClick:(NSNotification *)noti
{
    NSString *selectedTitle = nil;
    if (self.chartView.delayButton.selected) {
        selectedTitle = @"开工延期";
    }else{
        selectedTitle = @"完工延期";
    }
    MQTaskType type = [noti.userInfo[@"type"] integerValue];
    YSPMSMQEarlyPreTaskController *PMSPlanStartsViewController = [[YSPMSMQEarlyPreTaskController alloc]initWithStyle:UITableViewStyleGrouped];
    [PMSPlanStartsViewController setRefreshPrePlanBlock:^{
        [self doNetworking];
        if (self.refreshPlanListBlock) {
            self.refreshPlanListBlock();
        }
    }];
    PMSPlanStartsViewController.titleName = [self getTitleString:type];
     PMSPlanStartsViewController.type = [NSString stringWithFormat:@"%ld",type];
    PMSPlanStartsViewController.engineeringModel = self.engineeringModel;
    [self.navigationController pushViewController:PMSPlanStartsViewController animated:YES];
    
}
- (NSString *)getTitleString:(MQTaskType)type {
    switch (type) {
        case MQStartDelayNormalTask:
            return @"开工正常";
            break;
        case MQStartDelayProgressFifteenDelay:
            return @"开工延期0~15%";
            break;
        case MQStartDelayProgressThirtyDelay:
            return @"开工延期15~30%";
            break;
        case MQStartDelayProgressMoreThirtyDelay:
            return @"开工延期大于30%";
            break;
        case MQCompletedDelayNormalTask:
            return @"完工正常";
            break;
        case MQCompletedDelayProgressFifteenDelay:
            return @"完工延期0~15%";
            break;
        case MQCompletedDelayProgressThirtyDelay:
            return @"完工延期15~30%";
            break;
        case MQCompletedDelayProgressMoreThirtyDelay:
            return @"完工延期大于30%";
            break;
        default:
            return nil;
            break;
    }
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
@end
