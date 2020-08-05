//
//  YSSummaryViewController.m
//  YaSha-iOS
//
//  Created by YaSha_Tom on 2019/1/8.
//  Copyright © 2019年 亚厦装饰股份有限公司. All rights reserved.
//

#import "YSSummaryViewController.h"
#import "YSFlowCustomDetailController.h"
#import "YSCrystalBallView.h"
#import "YSSummaryModel.h"
#import "YSFlowListModel.h"
#import "YSAttendanceDetailCell.h"
#import "YSFlowTripFormListViewController.h"
#import "YSFlowTripChangeViewController.h"
#import "YSFlowDetailPageController.h"
@interface YSSummaryViewController ()
@property (nonatomic,strong) YSCrystalBallView *headerView;
@property (nonatomic,strong) YSSummaryModel *model;
@property (nonatomic,strong) NSMutableDictionary *parameterDic;
@property (nonatomic,strong) NSString *yearStr;
/**10:请假;20:出差;30:因公外出;40:加班;50:忘记打卡;70或者80:迟到早退;110:旷工*/
@property (nonatomic,strong) NSString *typeStr;
@end

@implementation YSSummaryViewController
- (NSMutableDictionary *)parameterDic {
    if (!_parameterDic) {
        _parameterDic = [NSMutableDictionary dictionary];
    }
    return _parameterDic;
}
- (YSCrystalBallView *)headerView
{
    if (!_headerView) {
        _headerView = [[YSCrystalBallView alloc]init];
        _headerView.backgroundColor = [UIColor whiteColor];
    }
    return _headerView;
}
- (void)initTableView {
    [super initTableView];
    self.yearStr = [NSString stringWithFormat:@"%ld",[[[NSDate date] dateByAddingHours:8] year]];
    self.tableView.backgroundColor = kGrayColor(238);
    self.headerView.frame = CGRectMake(0, 0, kSCREEN_WIDTH, 375*kHeightScale);
    self.tableView.tableHeaderView = self.headerView;
    [self attendanceDetailsDoNetworking];
    [self.parameterDic setObject:[NSString stringWithFormat:@"%ld",[[[NSDate date] dateByAddingHours:8] year]] forKey:@"year"];
    [self.parameterDic setObject:@"10" forKey:@"type"];
    [self doNetworking];
    if (@available(iOS 11, *)) {
        self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
    if (self.teamDic) {
        self.yearStr = [[self.teamDic objectForKey:@"year"] substringToIndex:4];
        [self.headerView.yearButton setTitle:self.yearStr forState:(UIControlStateNormal)];
        [self.parameterDic setObject:self.yearStr forKey:@"year"];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.typeStr = @"10";
    //通知中心是个单例
    NSNotificationCenter *notiCenter = [NSNotificationCenter defaultCenter];
    
    // 注册一个监听事件。第三个参数的事件名， 系统用这个参数来区别不同事件。
    [notiCenter addObserver:self selector:@selector(receiveNotification:) name:@"attendanceType" object:nil];
    
    [notiCenter addObserver:self selector:@selector(selectPerfYear:) name:@"selectPerfYear" object:nil];
}

- (void)receiveNotification:(NSNotification *)noti {
    [self.parameterDic setObject:noti.object forKey:@"type"];
    self.typeStr = noti.object;
    [self doNetworking];
}
- (void)selectPerfYear:(NSNotification *)noti {
    [self.parameterDic setObject:noti.object forKey:@"year"];
    self.yearStr = noti.object;
    [self attendanceDetailsDoNetworking];
    [self doNetworking];
}

- (void)attendanceDetailsDoNetworking {
    
    [QMUITips showLoadingInView:self.view];
    NSDictionary *paramDic = [NSDictionary new];
    if (self.teamDic) {
        paramDic = @{@"no":[self.teamDic objectForKey:@"no"]};
    }
    [YSNetManager ys_request_GETWithUrlString:[NSString stringWithFormat:@"%@%@/%@",YSDomain,getPersonAtdYearRecord,self.yearStr] isNeedCache:NO parameters:paramDic successBlock:^(id response) {
        [QMUITips hideAllTipsInView:self.view];
        DLog(@"汇总统计数据:%@", response[@"data"]);
        if (![response[@"data"] isEqual:[NSNull null]]) {
            [QMUITips hideAllToastInView:self.view animated:YES];
            self.model = [YSSummaryModel yy_modelWithJSON:response[@"data"]];
            [self.headerView setHeaderData:self.model];
            
        }else {
            [self.headerView setHeaderData:nil];
        }
    } failureBlock:^(NSError *error) {
        [QMUITips hideAllToastInView:self.view animated:YES];
    } progress:nil];
}
- (void)doNetworking{
    
    [QMUITips showLoadingInView:self.view];
    if (self.teamDic) {
        [self.parameterDic setObject:[self.teamDic objectForKey:@"no"] forKey:@"no"];
    }
    [YSNetManager ys_request_GETWithUrlString:[NSString stringWithFormat:@"%@%@/%ld",YSDomain,getPersonAtdDetailsByType,(long)self.pageNumber] isNeedCache:NO parameters:self.parameterDic successBlock:^(id response) {
        [QMUITips hideAllTipsInView:self.view];
        DLog(@"请假,因公外出,出差详情%@",response);
        self.pageNumber == 1 ? [self.dataSourceArray removeAllObjects] : nil;
        [self.dataSourceArray addObjectsFromArray:[YSDataManager getAttendanceDetailData:response]];
        self.tableView.mj_footer.state = [YSDataManager getAttendanceDetailData:response].count < 15 ? MJRefreshStateNoMoreData : MJRefreshStateIdle;
        [self.tableView reloadData];
        [self.tableView.mj_header endRefreshing];
        [self showImage:@"考勤空缺页"];
    } failureBlock:^(NSError *error) {
        [QMUITips hideAllToastInView:self.view animated:YES];
    } progress:nil];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 7;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.dataSourceArray.count == 0) {
        return self.dataSourceArray.count;
    }else {
        return self.dataSourceArray.count+1;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        YSAttendanceDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:@"YSAttendanceDetailCell"];
        if (cell == nil) {
            cell = [[NSBundle mainBundle]loadNibNamed:@"YSAttendanceDetailCell" owner:self options:nil].firstObject;
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.attendTypeLb.text = @"类型";
        cell.timeLb.text = @"时间";
        YSSummaryModel *model = self.dataSourceArray[0];

        if (model.type == 40) {
            cell.dayLb.text = @"";
        }else {
            cell.dayLb.text = @"时长";
        }
        return cell;
    }
    YSSummaryModel *model = self.dataSourceArray[indexPath.row-1];
    YSAttendanceDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:@"YSAttendanceDetailCell"];
    if (cell == nil) {
        cell = [[NSBundle mainBundle]loadNibNamed:@"YSAttendanceDetailCell" owner:self options:nil].firstObject;
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell setModel:model];
    
    return cell;
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        return;
    }
    YSSummaryModel *model = self.dataSourceArray[indexPath.row-1];
    
    if (model.type==70 || model.type == 80) {// 迟到早退 跳转打卡时间
        [[NSNotificationCenter defaultCenter] postNotificationName:@"YSJumpClockTimeVC" object:nil  userInfo:@{@"YSChoseTime":[YSUtility timestampSwitchTime:model.sdate andFormatter:@"yyyy-MM-dd"]}];
    }else if (model.type == 110) {// 旷工 跳转记录页面
        [[NSNotificationCenter defaultCenter] postNotificationName:@"YSAttendanceVC" object:nil userInfo:@{@"YSChoseTime":model.absenteeismTime}];
    }else {
        [QMUITips showLoadingInView:self.view];
        [YSNetManager ys_request_GETWithUrlString:[NSString stringWithFormat:@"%@%@/%@",YSDomain,getFlowInfo,model.billCode] isNeedCache:NO parameters:@{@"type":self.typeStr} successBlock:^(id response) {
            DLog(@"流程详情%@",response);
            if ([response[@"code"] integerValue] == 1) {
                YSFlowListModel *cellModel = [[ YSFlowListModel alloc]init];
                cellModel.businessKey = response[@"data"][@"businessKey"];
                cellModel.processDefinitionKey = response[@"data"][@"processDefinitionKey"];
                cellModel.processInstanceId = response[@"data"][@"processInstanceId"];
                if ([YSUtility cancelNullData:cellModel.businessKey].length < 1 ||[YSUtility cancelNullData:cellModel.processDefinitionKey].length < 1 || [YSUtility cancelNullData:cellModel.processInstanceId].length < 1) {
                    [QMUITips hideAllToastInView:self.view animated:YES];
                    [QMUITips showError:@"获取流程信息失败" inView:self.view hideAfterDelay:0.6];
                    return ;
                }
                if ([self.typeStr isEqualToString:@"20"]) {//出差流程
                    //YSFlowTripFormListViewController
                    //YSFlowTripChangeViewController
                     YSFlowModel *flowModel = [YSUtility getFlowModelWithProcessDefinitionKey:cellModel.processDefinitionKey];
                    YSFlowDetailPageController *flowDetailPageController = [[YSFlowDetailPageController alloc] init];
                      flowDetailPageController.flowType = YSFlowTypeNone;
                    //获得plist文件数据model
                    flowDetailPageController.flowModel = flowModel;
                    //获得流程列表数据model
                    flowDetailPageController.cellModel = cellModel;
                     [self.navigationController pushViewController:flowDetailPageController animated:YES];
                    
                }else{
                    YSFlowCustomDetailController *flowCustomDetailController = [[YSFlowCustomDetailController alloc]init];
                    flowCustomDetailController.cellModel = cellModel;
                    flowCustomDetailController.attendanceJumpStr = @"跳转";
                    [self.navigationController pushViewController:flowCustomDetailController animated:YES];
                }
                
            }
            [QMUITips hideAllToastInView:self.view animated:YES];
        } failureBlock:^(NSError *error) {
            [QMUITips hideAllToastInView:self.view animated:YES];
        } progress:nil];
    }
    
}


//无数据显示图片
- (void)showImage:(NSString *)imageName{
    
    if (self.dataSourceArray.count != 0) {
        self.tableView.tableFooterView = [[UIView alloc] initWithFrame:(CGRectZero)];
        return;
    }
    
    UIView *imgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kSCREEN_WIDTH, 300*kHeightScale)];
    [self.view addSubview:imgView];
    UIImageView *img = [[UIImageView alloc]init];
    img.frame = CGRects((kSCREEN_WIDTH-(119*kWidthScale))/2, 60*kHeightScale, 119*kWidthScale, 119*kHeightScale);
    img.image = [UIImage imageNamed:imageName];
    [imgView addSubview:img];
    
    self.tableView.tableFooterView = imgView;
}


- (void)dealloc {
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
