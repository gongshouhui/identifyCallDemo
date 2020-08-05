//
//  YSPMSMQConstructionPlanInfoViewController.m
//  YaSha-iOS
//
//  Created by YaSha_Tom on 2018/3/5.
//  Copyright © 2018年 亚厦装饰股份有限公司. All rights reserved.
//

#import "YSPMSMQConstructionPlanInfoViewController.h"
#import "YSPMSMQPlanInfoViewController.h"
#import "YSPMSProgressBarView.h"
#import "YSPMSPlanPieChartView.h"
#import "YSPMSMQPlanStartsViewController.h"
#import "YSPMSMQPlanProgressViewController.h"
#import "YSPMSPlanInfoModel.h"

@interface YSPMSMQConstructionPlanInfoViewController ()<YSPMSPlanPieChartViewDelegate>

@property (nonatomic, strong) NSArray *oneTitleArray;
@property (nonatomic, strong) NSString *titleNameStr;
@property (nonatomic, strong) NSArray *twoTitleArry;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) NSMutableArray *PieChartArray;
@property (nonatomic, strong) NSMutableArray *delayPieChartArray;
@property (nonatomic, strong) NSMutableArray *delayDayTitleArray;
@property (nonatomic, strong) NSMutableArray *controlPointsPieChartArray;
@property (nonatomic, strong) YSPMSProgressBarView *PMSProgressBarView;
@property (nonatomic, strong) YSPMSPlanPieChartView *PMSPlanPieChartView;


@end

@implementation YSPMSMQConstructionPlanInfoViewController

- (void)setNavigationItemsIsInEditMode:(BOOL)isInEditMode animated:(BOOL)animated {
    [super setNavigationItemsIsInEditMode:isInEditMode animated:animated];
    
}

- (UIEdgeInsets)tableViewInitialContentInset {
    return UIEdgeInsetsMake(0, 0, kBottomHeight+kTopHeight, 0);
}
- (void)initTableView {
    [super initTableView];
    self.titleNameStr = @"开工延期";
    [self hideMJRefresh];
    self.title = _titleName;
    self.twoTitleArry = @[@"3日内需执行任务",
                          @"未开工任务",
                          @"进行中任务",
                          @"已完工任务",
                          @"措施任务",
                          @"里程碑任务"];
    self.PieChartArray = [NSMutableArray array];
    self.delayPieChartArray = [NSMutableArray array];
    self.controlPointsPieChartArray = [NSMutableArray array];
    self.delayDayTitleArray = [NSMutableArray array];
    self.tableView.estimatedSectionHeaderHeight = 0;
    self.tableView.estimatedSectionFooterHeight = 0;
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"PlanInfoCell"];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(CircleViewSectionClick:) name:@"CircleViewSectionClick" object:nil];
    [self doNetworking];
    
}

- (void)doNetworking {
    [super doNetworking];
    [YSNetManager ys_request_GETWithUrlString:[NSString stringWithFormat:@"%@%@/%@",YSDomain, getPlanInfoDetailMQ, self.code] isNeedCache:NO parameters:nil successBlock:^(id response) {
        DLog(@"=======%@",response);
        [QMUITips hideAllToastInView:self.view animated:YES];
        if ([response[@"code"] integerValue] == 1) {
            YSPMSPlanInfoModel *model = [YSPMSPlanInfoModel yy_modelWithJSON:response[@"data"]];
            [self dealWithData:model];
        }
        
    } failureBlock:^(NSError *error) {
        DLog(@"=======%@",error);
        [self ys_showNetworkError];
    } progress:nil];
}
- (void)dealWithData:(YSPMSPlanInfoModel *)model {
    //开工延期(饼图用)
    //以后用字典，或者重组模型
    [self.delayPieChartArray removeAllObjects];
    [self.delayPieChartArray addObject:[NSString stringWithFormat:@"%d",model.commencementOfDelayNormal]];//开工延期正常
    [self.delayPieChartArray addObject:[NSString stringWithFormat:@"%d",model.commencementOfDelayToFifteen]];//开工延期0~15
    [self.delayPieChartArray addObject:[NSString stringWithFormat:@"%d",model.commencementOfDelayToThirty]];//开工延期15~30
     [self.delayPieChartArray addObject:[NSString stringWithFormat:@"%d",model.commencementOfDelayMoreThirty]];//开工延期30~
    self.PieChartArray = self.delayPieChartArray;
    DLog(@"--------%@",self.delayPieChartArray);
    
    //完工延期（饼图用）
    [self.controlPointsPieChartArray removeAllObjects];
    [self.controlPointsPieChartArray addObject:[NSString stringWithFormat:@"%d",model.completionDelayNormal]];
    [self.controlPointsPieChartArray addObject:[NSString stringWithFormat:@"%d",model.completionDelayToFifteen]];
    [self.controlPointsPieChartArray addObject:[NSString stringWithFormat:@"%d",model.completionDelayToThirty]];
    [self.controlPointsPieChartArray addObject:[NSString stringWithFormat:@"%d",model.completionDelayMoreThirty]];
    
   
    [self.tableView cyl_reloadData];
}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return  self.twoTitleArry.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return  286*kHeightScale;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *backView = [[UIView alloc] init];
    backView.backgroundColor = [UIColor whiteColor];
    backView.frame = CGRectMake(0, 0, kSCREEN_WIDTH, 48*kHeightScale);
   
        
    self.PMSPlanPieChartView = [[YSPMSPlanPieChartView alloc]initWithFrame:CGRectMake(0, 0, kSCREEN_WIDTH, 248*kHeightScale)];
    [self.PMSPlanPieChartView.controlPointsButton setTitle:@"完工延期" forState:UIControlStateNormal];
    [self.PMSPlanPieChartView.delayButton setTitle:@"开工延期" forState:UIControlStateNormal];
    self.PMSPlanPieChartView.delegate = self;
        
    [self.PMSPlanPieChartView creatPieChart:[self.PieChartArray copy] andDelayTitleArray:[self.delayDayTitleArray copy]];
    [backView addSubview:self.PMSPlanPieChartView];
   
    return backView;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PlanInfoCell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"PlanInfoCell"];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textLabel.font = [UIFont systemFontOfSize:15];
    cell.textLabel.textColor = kUIColor(51, 51, 51, 1);
    cell.textLabel.text = self.twoTitleArry[indexPath.row];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    YSPMSMQPlanStartsViewController *PMSPlanStartsViewController = [[YSPMSMQPlanStartsViewController alloc]initWithStyle:UITableViewStyleGrouped];
    PMSPlanStartsViewController.refreshPlanInfoBlock = ^{
        [self doNetworking];
    };
    PMSPlanStartsViewController.code = self.code;
    PMSPlanStartsViewController.proManagerId = self.proManagerId;
    switch (indexPath.row) {
        case 0:
            PMSPlanStartsViewController.type = @"1";
            PMSPlanStartsViewController.titleName = @"3日内需跟踪任务";
            break;
        case 1:
            PMSPlanStartsViewController.type = @"2";
            PMSPlanStartsViewController.titleName = @"未开工任务";
            break;
        case 2:
            PMSPlanStartsViewController.type = @"3";
            PMSPlanStartsViewController.titleName = @"进行中任务";
            break;
        case 3:
            PMSPlanStartsViewController.type = @"4";
            PMSPlanStartsViewController.titleName = @"已完工任务";
            break;
        case 4:
            PMSPlanStartsViewController.type = @"5";
            PMSPlanStartsViewController.titleName = @"措施任务";
            break;
        case 5:
            PMSPlanStartsViewController.type = @"6";
            PMSPlanStartsViewController.titleName = @"里程碑任务";
            break;
        default:
            break;
            
    }

        [self.navigationController pushViewController:PMSPlanStartsViewController animated:YES];

}

#pragma mark - YSPMSPlanPieChartViewDelegate switch点击事件代理事件
- (void)constructionInfoButtonDidClick:(UIButton *)button {
    //[self switchPieChart:button];
    self.PieChartArray = self.delayPieChartArray;
    self.titleNameStr = button.titleLabel.text;
    DLog(@"=============%@",self.PieChartArray);
    [self.PMSPlanPieChartView creatPieChart:[self.PieChartArray copy] andDelayTitleArray:[self.delayDayTitleArray copy]];
}
- (void)controlPointsButtonDidClick:(UIButton *)button {
    
    self.PieChartArray = self.controlPointsPieChartArray;
    self.titleNameStr = button.titleLabel.text;
    DLog(@"=============%@",self.PieChartArray);
    [self.PMSPlanPieChartView creatPieChart:[self.PieChartArray copy] andDelayTitleArray:[self.delayDayTitleArray copy]];
    
}


#pragma mark - CYLTableViewPlaceHolderDelegate

- (BOOL)enableScrollWhenPlaceHolderViewShowing {
    return YES;
}

- (UIView *)makePlaceHolderView {
    return [YSUtility NoDataView:@"无数据"];
}


#pragma mark -  通知相关方法
- (void)CircleViewSectionClick:(NSNotification *)noti
{
    NSInteger type = [noti.userInfo[@"type"] integerValue];
    YSPMSMQPlanStartsViewController *PMSPlanStartsViewController = [[YSPMSMQPlanStartsViewController alloc]initWithStyle:UITableViewStyleGrouped];
    PMSPlanStartsViewController.refreshPlanInfoBlock = ^{
        [self doNetworking];
    };
    PMSPlanStartsViewController.code = self.code;
    PMSPlanStartsViewController.proManagerId = self.proManagerId;
    switch (type) {
        case 0:
            PMSPlanStartsViewController.titleName = [NSString stringWithFormat:@"%@%@",self.titleNameStr,@"正常"];
            if ([self.titleNameStr isEqual:@"开工延期"]) {
                PMSPlanStartsViewController.type = @"7";
            }else{
                PMSPlanStartsViewController.type = @"11";
            }
            break;
        case 9:
            PMSPlanStartsViewController.titleName = [NSString stringWithFormat:@"%@%@",self.titleNameStr,@"0~15%"];
            if ([self.titleNameStr isEqual:@"开工延期"]) {
                PMSPlanStartsViewController.type = @"8";
            }else{
                PMSPlanStartsViewController.type = @"12";
            }
            break;
        case 10:
            PMSPlanStartsViewController.titleName = [NSString stringWithFormat:@"%@%@",self.titleNameStr,@"15~30%"];
            if ([self.titleNameStr isEqual:@"开工延期"]) {
                PMSPlanStartsViewController.type = @"9";
            }else{
                PMSPlanStartsViewController.type = @"13";
            }
            break;
        case 11:
            PMSPlanStartsViewController.titleName = [NSString stringWithFormat:@"%@%@",self.titleNameStr,@"30%以上"];
            if ([self.titleNameStr isEqual:@"开工延期"]) {
                PMSPlanStartsViewController.type = @"10";
            }else{
                PMSPlanStartsViewController.type = @"14";
            }
            break;
            
        default:
            break;
    }
    [self.navigationController pushViewController:PMSPlanStartsViewController animated:YES];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
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
