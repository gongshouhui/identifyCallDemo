//
//  YSPMSMQPlanInfoViewController.m
//  YaSha-iOS
//
//  Created by YaSha_Tom on 2018/3/1.
//  Copyright © 2018年 亚厦装饰股份有限公司. All rights reserved.
//

#import "YSPMSMQPlanInfoViewController.h"
#import "YSPMSProgressBarView.h"
#import "YSPMSMQPlanPieChartView.h"
#import "YSPMSMQPlanStartsViewController.h"
#import "YSPMSMQPlanProgressViewController.h"
#import "YSPMSPlanInfoModel.h"
#import "YSMQPlanTitleCell.h"

@interface YSPMSMQPlanInfoViewController ()

@property (nonatomic, strong) NSArray *oneTitleArray;
@property (nonatomic, strong) NSMutableArray *oneContentArray;
@property (nonatomic, strong) NSString *graphicProgress;
@property (nonatomic, strong) NSString *planGraphicProgress;
@property (nonatomic, strong) NSArray *twoTitleArry;
@property (nonatomic, strong) NSMutableArray *twoContentArray;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) NSMutableArray *PieChartArray;
@property (nonatomic, strong) NSMutableArray *delayPieChartArray;
@property (nonatomic, strong) NSMutableArray *delayDayTitleArray;
@property (nonatomic, strong) NSMutableArray *controlPointsPieChartArray;
@property (nonatomic, strong) YSPMSProgressBarView *PMSProgressBarView;
@property (nonatomic, strong) YSPMSMQPlanPieChartView *PMSPlanPieChartView;

@end

@implementation YSPMSMQPlanInfoViewController

- (void)setNavigationItemsIsInEditMode:(BOOL)isInEditMode animated:(BOOL)animated {
    [super setNavigationItemsIsInEditMode:isInEditMode animated:animated];
    
}
- (void)initTableView {
    [super initTableView];
    self.title = _titleName;
    self.oneTitleArray = @[@"计划时间",
                           @"计划工期",
                           @"项目经理",
                           @"项目性质",
                           @"管理部门"
                           ];
    self.oneContentArray = [NSMutableArray array];
    self.twoContentArray = [NSMutableArray array];
    self.PieChartArray = [NSMutableArray array];
    self.delayPieChartArray = [NSMutableArray array];
    self.controlPointsPieChartArray = [NSMutableArray array];
    self.delayDayTitleArray = [NSMutableArray array];
    self.tableView.estimatedSectionHeaderHeight = 0;
    self.tableView.estimatedSectionFooterHeight = 0;
//    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"PlanInfoCell"];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(CircleViewSectionClick:) name:@"CircleViewSectionClick" object:nil];
    [self doNetworking];
    
}

- (void)doNetworking {
//   [super doNetworking];
    DLog(@"--------%@",self.code);
    [YSNetManager ys_request_GETWithUrlString:[NSString stringWithFormat:@"%@%@/%@",YSDomain, getPlanInfoDetailMQ, self.code] isNeedCache:NO parameters:nil successBlock:^(id response) {
        DLog(@"=======%@",response);
       [QMUITips hideAllToastInView:self.view animated:YES];
        self.graphicProgress = response[@"data"][@"graphicProgress"];
        self.planGraphicProgress =response[@"data"][@"planGraphicProgress"];
        YSPMSPlanInfoModel *model = [YSPMSPlanInfoModel yy_modelWithJSON:response[@"data"]];
        [self dealWithData:model];

    } failureBlock:^(NSError *error) {
        DLog(@"=======%@",error);
        [self ys_showNetworkError];
    } progress:nil];
}
- (void)dealWithData:(YSPMSPlanInfoModel *)model {
    
    [self.oneContentArray removeAllObjects];
    [self.twoContentArray removeAllObjects];
    [self.oneContentArray addObject:[NSString stringWithFormat:@"%@-%@",[YSUtility timestampSwitchTime:model.planStartDate andFormatter:@"yyyy.MM.dd"],[YSUtility timestampSwitchTime:model.planEndDate andFormatter:@"yyyy.MM.dd"]]];
  
    [self.oneContentArray addObject:[NSString stringWithFormat:@"%@天",model.planDuration == nil ?  @"0":model.planDuration]];
    [self.oneContentArray addObject:model.proManagerName];
    [self.oneContentArray addObject:model.proNatureStr];
    [self.oneContentArray addObject:model.deptsInfo];
   
    [self.tableView reloadData];
}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return section == 0 ? self.oneTitleArray.count : 0;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return section == 0 ? 50*kHeightScale : 286*kHeightScale;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *backView = [[UIView alloc] init];
    backView.backgroundColor = [UIColor whiteColor];
    backView.frame = CGRectMake(0, 0, kSCREEN_WIDTH, 48*kHeightScale);
    if (section == 0) {
        self.PMSProgressBarView = [[YSPMSProgressBarView alloc]initWithFrame:CGRectMake(0, 0, kSCREEN_WIDTH, 48*kHeightScale)];
        self.PMSProgressBarView.progressValue =[NSString stringWithFormat:@"%.2f",[self.planGraphicProgress floatValue]/100.0];
        self.PMSProgressBarView.progressLabel.text = [NSString stringWithFormat:@"%@%@",self.planGraphicProgress,@"%"];
        [backView addSubview:self.PMSProgressBarView];
    }else{
        
        self.PMSPlanPieChartView = [[YSPMSMQPlanPieChartView alloc]initWithFrame:CGRectMake(0, 0, kSCREEN_WIDTH, 248*kHeightScale)];
        [self.PMSPlanPieChartView showActualPercentage: self.graphicProgress];
        [backView addSubview:self.PMSPlanPieChartView];
    }
    return backView;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    YSMQPlanTitleCell *cell = [tableView dequeueReusableCellWithIdentifier:@"YSMQPlanTitleCell"];
    if (cell == nil) {
        cell = [[NSBundle mainBundle] loadNibNamed:@"YSMQPlanTitleCell" owner:self options:nil].firstObject;
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.titleLb.text = self.oneTitleArray[indexPath.row];
    if ( self.oneContentArray.count > 0) {
       cell.detailLb.text = self.oneContentArray[indexPath.row];
    }
    return cell;
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
    YSPMSMQPlanProgressViewController *PMSPlanProgressViewController = [[YSPMSMQPlanProgressViewController alloc]initWithStyle:UITableViewStyleGrouped];
    PMSPlanProgressViewController.refreshBlock = ^{
        [self doNetworking];
        if (self.refreshPlanListBlock) {//在进度计划有修改就刷新列表
            self.refreshPlanListBlock();
        }
    };
    PMSPlanProgressViewController.code = self.code;
    PMSPlanProgressViewController.id = self.id;
    [self.navigationController pushViewController:PMSPlanProgressViewController animated:YES];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


@end
