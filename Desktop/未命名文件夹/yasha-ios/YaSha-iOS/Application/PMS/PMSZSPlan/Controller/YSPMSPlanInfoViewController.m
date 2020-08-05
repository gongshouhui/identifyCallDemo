//
//  YSPMSPlanInfoViewController.m
//  YaSha-iOS
//
//  Created by YaSha_Tom on 2017/12/13.
//  Copyright © 2017年 亚厦装饰股份有限公司. All rights reserved.
//

#import "YSPMSPlanInfoViewController.h"
#import "YSPMSProgressBarView.h"
#import "YSPMSPlanPieChartView.h"
#import "YSPMSPlanStartsViewController.h"
#import "YSPMSPlanProgressViewController.h"
#import "YSPMSPlanInfoModel.h"


@interface YSPMSPlanInfoViewController ()<YSPMSPlanPieChartViewDelegate>

@property (nonatomic, strong) NSArray *oneTitleArray;
@property (nonatomic, strong) NSMutableArray *oneContentArray;
@property (nonatomic, strong) NSString *graphicProgress;
@property (nonatomic, strong) NSArray *twoTitleArry;
@property (nonatomic, strong) NSMutableArray *twoContentArray;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) NSMutableArray *PieChartArray;
@property (nonatomic, strong) NSMutableArray *delayPieChartArray;
@property (nonatomic, strong) NSMutableArray *delayDayTitleArray;
@property (nonatomic, strong) NSMutableArray *controlPointsPieChartArray;
@property (nonatomic, strong) YSPMSProgressBarView *PMSProgressBarView;
@property (nonatomic, strong) YSPMSPlanPieChartView *PMSPlanPieChartView;

@end

@implementation YSPMSPlanInfoViewController

- (void)setNavigationItemsIsInEditMode:(BOOL)isInEditMode animated:(BOOL)animated {
    [super setNavigationItemsIsInEditMode:isInEditMode animated:animated];
   
}
- (void)initTableView {
    [super initTableView];
     self.title = _titleName;
    self.oneTitleArray = @[@"计划时间",
                           @"实际开工时间"
//                           ,
//                           @"完工剩余"
                           ];
    self.twoTitleArry = @[//@"开工延期任务",
                          //@"完工延期任务",
                          @"3日内需执行任务",
                          //@"延期控制点任务",
                          @"未开工任务",
                          @"进行中任务",
                          @"已完工任务",
                          @"控制点任务"];

    self.oneContentArray = [NSMutableArray array];
    self.twoContentArray = [NSMutableArray array];
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
    
    [YSNetManager ys_request_GETWithUrlString:[NSString stringWithFormat:@"%@%@/%@",YSDomain, getPlanInfoDetail, self.code] isNeedCache:NO parameters:nil successBlock:^(id response) {
        DLog(@"=======%@",response);
        [QMUITips hideAllToastInView:self.view animated:YES];
        if ([response[@"code"] integerValue] == 1) {
            
            self.graphicProgress = response[@"data"][@"graphicProgress"];
            YSPMSPlanInfoModel *model = [YSPMSPlanInfoModel yy_modelWithJSON:response[@"data"]];
            [self dealWithData:model];
        }
        
    } failureBlock:^(NSError *error) {
        DLog(@"=======%@",error);
        [self ys_showNetworkError];
    } progress:nil];
}
- (void)dealWithData:(YSPMSPlanInfoModel *)model {
    
    [self.oneContentArray removeAllObjects];
    [self.twoContentArray removeAllObjects];
    [self.oneContentArray addObject:[NSString stringWithFormat:@"%@-%@",[YSUtility timestampSwitchTime:model.planStartDate andFormatter:@"yyyy.MM.dd"],[YSUtility timestampSwitchTime:model.planEndDate andFormatter:@"yyyy.MM.dd"]]];
    DLog(@"=======%@",model.actualStartDate);
    if (model.actualStartDate == nil) {
        [self.oneContentArray addObject:@"未开工"];
    }else{
        [self.oneContentArray addObject:[YSUtility timestampSwitchTime:model.actualStartDate andFormatter:@"yyyy.MM.dd"]];
    }
//    if (model.outDayNumber < 0) {
//        self.oneTitleArray = @[@"计划时间",
//                               @"实际开工时间",
//                              @"完工延期"
//                               ];
//        [self.oneContentArray addObject:[NSString stringWithFormat:@"%d天",abs(model.outDayNumber) - 1]];
//    }else{
//        self.oneTitleArray = @[@"计划时间",
//                               @"实际开工时间",
//                               @"完工剩余"];
//        [self.oneContentArray addObject:[NSString stringWithFormat:@"%d天",abs(model.outDayNumber)]];
//    }
    

    [self.twoContentArray addObject:[NSString stringWithFormat:@"%d",model.threeTrackTask]];
    [self.twoContentArray addObject:[NSString stringWithFormat:@"%d",model.notStartedTask]];
    [self.twoContentArray addObject:[NSString stringWithFormat:@"%d",model.processingTask]];
    [self.twoContentArray addObject:[NSString stringWithFormat:@"%d",model.completedTask]];
    [self.twoContentArray addObject:[NSString stringWithFormat:@"%d",model.controlPointTask]];
    DLog(@"======%@",self.oneContentArray);
    
    //施工任务(饼图用)
    //以后用字典，或者重组模型
    [self.delayPieChartArray removeAllObjects];
    [self.delayPieChartArray addObject:[NSString stringWithFormat:@"%d",model.normalCount]];//正常
    [self.delayPieChartArray addObject:[NSString stringWithFormat:@"%d",model.startExtensionTask]];//开工延期
    [self.delayPieChartArray addObject:[NSString stringWithFormat:@"%d",model.completionExtension]];//完工延期
    self.PieChartArray = self.delayPieChartArray;
    DLog(@"--------%@",self.delayPieChartArray);
    
    //控制点（饼图用）
    [self.controlPointsPieChartArray removeAllObjects];
    [self.controlPointsPieChartArray addObject:[NSString stringWithFormat:@"%d",model.pointNormalCount]];
    [self.controlPointsPieChartArray addObject:[NSString stringWithFormat:@"%d",model.extensionCompletedTask]];
    
    [self.delayDayTitleArray addObject:@"正常"];
    [self.delayDayTitleArray addObject:[NSString stringWithFormat:@"延期<%@天",model.fiveDay]];
    [self.delayDayTitleArray addObject:[NSString stringWithFormat:@"延期%@~%@天",model.fiveDay,model.tenDay]];
    [self.delayDayTitleArray addObject:[NSString stringWithFormat:@"延期>%@天",model.tenDay]];
    [self.tableView cyl_reloadData];
}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return section == 0 ? self.oneTitleArray.count : self.twoTitleArry.count;
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
        self.PMSProgressBarView.progressValue = [self.graphicProgress intValue] >= 10 ? [NSString stringWithFormat:@"0.%@",self.graphicProgress] :[NSString stringWithFormat:@"0.0%@",self.graphicProgress] ;
        [self.PMSProgressBarView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(progressBarViewDidClick)]];
        self.PMSProgressBarView.progressLabel.text = [NSString stringWithFormat:@"%@%@",self.graphicProgress.length > 0 ? self.graphicProgress : @"0",@"%"];
        [backView addSubview:self.PMSProgressBarView];
    }else{
        
        self.PMSPlanPieChartView = [[YSPMSPlanPieChartView alloc]initWithFrame:CGRectMake(0, 0, kSCREEN_WIDTH, 248*kHeightScale)];
        self.PMSPlanPieChartView.delegate = self;
        
        [self.PMSPlanPieChartView creatPieChart:[self.PieChartArray copy] andDelayTitleArray:[self.delayDayTitleArray copy]];
        [backView addSubview:self.PMSPlanPieChartView];
    }
    return backView;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"PlanInfoCell"];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textLabel.font = [UIFont systemFontOfSize:15];
    cell.textLabel.textColor = kUIColor(51, 51, 51, 1);
    DLog(@"======%@",self.oneContentArray);
    if (indexPath.section == 0) {
        cell.textLabel.text = self.oneTitleArray[indexPath.row];
        if ( self.oneContentArray.count > 0) {
            cell.detailTextLabel.text = self.oneContentArray[indexPath.row];
        }
    }else{
        cell.textLabel.text = self.twoTitleArry[indexPath.row];
        if (self.twoContentArray.count > 0) {
            cell.detailTextLabel.text = self.twoContentArray[indexPath.row];
        }
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 1) {
        YSPMSPlanStartsViewController *PMSPlanStartsViewController = [[YSPMSPlanStartsViewController alloc]initWithStyle:UITableViewStyleGrouped];
        PMSPlanStartsViewController.refreshPlanInfoBlock = ^{
            [self doNetworking];
        };
        PMSPlanStartsViewController.code = self.code;
        PMSPlanStartsViewController.proManagerId = self.proManagerId;
        switch (indexPath.row) {
            case 0:
                PMSPlanStartsViewController.type = @"5";
                PMSPlanStartsViewController.titleName = @"3日内需跟踪任务";
                break;
            case 1:
                PMSPlanStartsViewController.type = @"4";
                PMSPlanStartsViewController.titleName = @"未开工任务";
                break;
            case 2:
                PMSPlanStartsViewController.type = @"2";
                PMSPlanStartsViewController.titleName = @"进行中任务";
                break;
            case 3:
                PMSPlanStartsViewController.type = @"6";
                PMSPlanStartsViewController.titleName = @"已完工任务";
                break;
            case 4:
                PMSPlanStartsViewController.type = @"7";
                PMSPlanStartsViewController.titleName = @"控制点任务";
                break;
            default:
                break;
                
        }
        if (![self.twoContentArray[indexPath.row] isEqual:@"0"]) {
            [self.navigationController pushViewController:PMSPlanStartsViewController animated:YES];
        }else{
            [QMUITips showInfo:@"暂无任务数据" inView:self.view  hideAfterDelay:1];
        }
    }
}



#pragma mark - 区头点击方法
- (void)progressBarViewDidClick {
    YSPMSPlanProgressViewController *PMSPlanProgressViewController = [[YSPMSPlanProgressViewController alloc]initWithStyle:UITableViewStyleGrouped];
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
#pragma mark - YSPMSPlanPieChartViewDelegate 代理事件
- (void)constructionInfoButtonDidClick:(UIButton *)button {
    //[self switchPieChart:button];
    self.PieChartArray = self.delayPieChartArray;
    DLog(@"=============%@",self.PieChartArray);
    [self.PMSPlanPieChartView creatPieChart:[self.PieChartArray copy] andDelayTitleArray:[self.delayDayTitleArray copy]];
}
- (void)controlPointsButtonDidClick:(UIButton *)button {
    
    self.PieChartArray = self.controlPointsPieChartArray;
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
    if (type == YSConstructionProgressNomal) {
        return;
    }
    
    YSPMSPlanStartsViewController *PMSPlanStartsViewController = [[YSPMSPlanStartsViewController alloc]initWithStyle:UITableViewStyleGrouped];
    PMSPlanStartsViewController.refreshPlanInfoBlock = ^{
        [self doNetworking];
    };
    PMSPlanStartsViewController.code = self.code;
    PMSPlanStartsViewController.proManagerId = self.proManagerId;
    switch (type) {
        case 1:
            PMSPlanStartsViewController.type = @"1";
            PMSPlanStartsViewController.titleName = @"开工延期任务";
            break;
        case 3:
            PMSPlanStartsViewController.type = @"3";
            PMSPlanStartsViewController.titleName = @"完工延期任务";
            break;
        case 8:
            PMSPlanStartsViewController.type = @"8";
            PMSPlanStartsViewController.titleName = @"延期控制点任务";
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


@end
