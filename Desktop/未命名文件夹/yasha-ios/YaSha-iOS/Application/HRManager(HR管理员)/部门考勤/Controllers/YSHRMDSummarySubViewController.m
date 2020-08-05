//
//  YSHRMDSummarySubViewController.m
//  YaSha-iOS
//
//  Created by GZl on 2019/4/9.
//  Copyright © 2019 亚厦装饰股份有限公司. All rights reserved.
//

// 请假/加班/出差等子类型
#import "YSHRMDSummarySubViewController.h"
#import "YSManagerPositionHeaderView.h"
#import "YSHRMSSubSctionHeaderAllView.h"
#import "YSHRMSSubAllTableViewCell.h"
#import "YSSummaryModel.h"
#import "YSHRManagerSearchSGViewController.h"
#import "YSHRManagerInfoHGViewController.h"
#import "YSContactModel.h"
#import "YSFlowModel.h"
#import "YSFlowDetailPageController.h"
#import "YSFlowCustomDetailController.h"

@interface YSHRMDSummarySubViewController ()
@property (nonatomic, strong) YSManagerPositionHeaderView *headerView;
@property (nonatomic,copy) NSString *urlStr;

@end

@implementation YSHRMDSummarySubViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    switch (self.titType) {
        case SummarySubVCHoliday:
            {
                self.title = @"请假";
                self.urlStr = getUserTeamLeaveDetails;
            }
            break;
        case SummarySubVCTypeWork:
            {
                self.title = @"加班";
                self.urlStr = getUserTeamWorkOvertimeDetail;
            }
            break;
        case SummarySubVCTypeOutWark:
            {
                self.title = @"因公外出";
                self.urlStr = getUserTeamBusinessTrip;
            }
            break;
        case SummarySubVCTypeBusiness:
            {
                self.title = @"出差";
                self.urlStr = getUserTeamBusinessTripDetail;
            }
            break;
        case SummarySubVCTypeLate:
            {
                self.title = @"迟到早退";
                self.urlStr = getUserTeamLateAbsenteeism;
            }
            break;
        case SummarySubVCTypeAbsenteeism:
            {
                self.title = @"旷工";
                self.urlStr = getUserTeamAbsenteeism;
            }
            break;
        default:
            break;
    }
    [self refershTeamDataWithType:(RefreshStateTypeHeader)];
    
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self ys_showManagerSearchBar];
}

- (void)initTableView {
    [super initTableView];
    UIView *headerBackView = [[UIView alloc] initWithFrame:(CGRectMake(0, 0, kSCREEN_WIDTH, 60*kHeightScale))];
    headerBackView.backgroundColor = [UIColor whiteColor];
    
    self.headerView = [[YSManagerPositionHeaderView alloc] initWithFrame:(CGRectMake(0, 16*kHeightScale, kSCREEN_WIDTH, 25*kHeightScale))];
    [headerBackView addSubview:self.headerView];
    self.tableView.tableHeaderView = headerBackView;
    
    [self.tableView registerClass:[YSHRMSSubAllTableViewCell class] forCellReuseIdentifier:@"subOtherAllCell"];
    
    self.tableView.separatorInset = UIEdgeInsetsMake(0, 16*kWidthScale, 0, 16*kWidthScale);
    [self hideMJRefresh];
    
}

- (void)doNetworking {
    [super doNetworking];
    [self.view bringSubviewToFront:self.navView];
    [YSNetManager ys_request_GETWithUrlString:[NSString stringWithFormat:@"%@%@?time=%@&pageNumber=%ld&pageSize=%d", YSDomain, self.urlStr, self.timeStr, self.pageNumber, kPageSize] isNeedCache:NO parameters:@{@"deptIds":self.deptIds} successBlock:^(id response) {
        [QMUITips hideAllToastInView:self.view animated:NO];
        DLog(@"团队请假等信息:%@", response);
        if ([response[@"code"] intValue] == 1) {
            NSMutableArray *dataArray = [NSMutableArray arrayWithArray:[YSDataManager getAttendanceDetailData:response[@"data"]]];
            // YSSummaryModel
            [self handelDataAddModelImgWith:dataArray];
            if (self.refreshType == RefreshStateTypeHeader) {
                self.dataSourceArray = [NSMutableArray arrayWithArray:dataArray];
                self.headerView.numberLab.text = [NSString stringWithFormat:@"%d", [response[@"data"][@"total"] intValue]];
            }else {
                [self.dataSourceArray addObjectsFromArray:dataArray];
            }
            if ([[YSDataManager getAttendanceDetailData:response[@"data"]] count] < kPageSize) {
                [self.tableView.mj_footer endRefreshingWithNoMoreData];
            }else {
                [self.tableView.mj_footer resetNoMoreData];
            }
            [self ys_reloadData];
        }
    } failureBlock:^(NSError *error) {
        [QMUITips hideAllToastInView:self.view animated:NO];

    } progress:nil];
}

// 增加头像
- (void)handelDataAddModelImgWith:(NSMutableArray* _Nonnull)dataArray {
    [dataArray enumerateObjectsUsingBlock:^(YSSummaryModel  * compileModel, NSUInteger idx, BOOL * _Nonnull stop) {
        
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"userId = %@", compileModel.personCode];
        RLMResults *results = [[YSContactModel objectsWithPredicate:predicate]  sortedResultsUsingKeyPath:@"userId" ascending:YES];
        if ([results count] != 0) {
            YSContactModel *resultsModel = results[0];
            compileModel.headImage = [NSString stringWithFormat:@"%@_S.jpg", resultsModel.headImg];
        }
    }];
    
}

- (void)refershTeamDataWithType:(RefreshStateType)type {
    if (type == RefreshStateTypeHeader) {
        self.pageNumber = 1;
    }else {
        self.pageNumber++;
    }
    self.refreshType = type;
    [self doNetworking];
}

#pragma mark--tableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 40*kHeightScale;
}
- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    NSInteger type = 1;
    switch (self.titType) {
        case SummarySubVCHoliday:
        {
            type = 1;
        }
            break;
        case SummarySubVCTypeOutWark:
        case SummarySubVCTypeBusiness:
        case SummarySubVCTypeAbsenteeism:
        {
            type = 2;
        }
            break;
        case SummarySubVCTypeLate:
        {
            type = 3;
        }
            break;
        case SummarySubVCTypeWork:
        {
            type = 4;
        }
            break;
        default:
            break;
    }
    YSHRMSSubSctionHeaderAllView *headerView = [[YSHRMSSubSctionHeaderAllView alloc] initWithFrame:(CGRectMake(0, 0, kSCREEN_WIDTH, 40*kHeightScale)) withViewType:type];
    headerView.backgroundColor = [UIColor whiteColor];
    return headerView;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 48*kHeightScale;
    
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.dataSourceArray.count;
}
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    YSHRMSSubAllTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"subOtherAllCell" forIndexPath:indexPath];
    // 请假 迟到早退 以及其他类型 分三种
    switch (self.titType) {
        case SummarySubVCHoliday:
        {//请假
            cell.leaveModel = self.dataSourceArray[indexPath.row];
        }
            break;
        case SummarySubVCTypeLate:
        {//迟到早退
            cell.lateModel = self.dataSourceArray[indexPath.row];
        }
            break;
        case SummarySubVCTypeWork:
        {
            cell.workModel = self.dataSourceArray[indexPath.row];
        }
             break;
        case SummarySubVCTypeBusiness:
        {
            cell.otherModel = self.dataSourceArray[indexPath.row];
        }
            break;
        case SummarySubVCTypeOutWark:
        {//因公外出
            cell.outWarkModel = self.dataSourceArray[indexPath.row];
        }
            break;
        case SummarySubVCTypeAbsenteeism:
        {//旷工
            cell.absenteeisModel = self.dataSourceArray[indexPath.row];
        }
            break;
        default:
            break;
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.titType > SummarySubVCTypeOutWark && self.titType < SummarySubVCTypeWork) {
        return;
    }
    YSSummaryModel *model = self.dataSourceArray[indexPath.row];
    // 跳转流程 只做请假/出差/因公外出-加班
    [self requestFlowInfoWtihModel:model];
    /*
    YSHRManagerInfoHGViewController *infoVC = [YSHRManagerInfoHGViewController new];
    infoVC.userNo = model.personCode;
    [self.navigationController pushViewController:infoVC animated:nil];
     */
    
}

- (void)requestFlowInfoWtihModel:(YSSummaryModel*)model {
    NSInteger codeType = 10;
    switch (self.titType) {
        case SummarySubVCHoliday:
            {//请假
                codeType = 10;
            }
            break;
        case SummarySubVCTypeBusiness:
        {//出差
            codeType = 20;
        }
            break;
        case SummarySubVCTypeOutWark:
        {//因公外出
            codeType = 30;
        }
            break;
        case SummarySubVCTypeWork:
        {//加班
            codeType = 40;
        }
            break;
        default:
            break;
    }
    [QMUITips showLoadingInView:self.view];
    [YSNetManager ys_request_GETWithUrlString:[NSString stringWithFormat:@"%@%@/%@",YSDomain,getFlowInfo,model.billCode] isNeedCache:NO parameters:@{@"type":@(codeType)} successBlock:^(id response) {
        DLog(@"流程详情%@",response);
        if ([response[@"code"] integerValue] == 1) {
            [QMUITips hideAllToastInView:self.view animated:YES];
            YSFlowListModel *cellModel = [[ YSFlowListModel alloc]init];
            cellModel.businessKey = response[@"data"][@"businessKey"];
            cellModel.processDefinitionKey = response[@"data"][@"processDefinitionKey"];
            cellModel.processInstanceId = response[@"data"][@"processInstanceId"];
            if ([YSUtility cancelNullData:cellModel.businessKey].length < 1 ||[YSUtility cancelNullData:cellModel.processDefinitionKey].length < 1 || [YSUtility cancelNullData:cellModel.processInstanceId].length < 1) {
                [QMUITips showError:@"获取流程信息失败" inView:self.view hideAfterDelay:0.6];
                return ;
            }
            if (codeType == 20) {//出差流程
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
                // YSFlowListModel
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

- (void)clickedSeachBarAction {
    
    YSHRManagerSearchSGViewController *searchVC = [YSHRManagerSearchSGViewController new];
    NSMutableDictionary *paramDic = [NSMutableDictionary new];
    [paramDic setObject:self.deptIds forKey:@"deptIds"];
    [paramDic setObject:self.timeStr forKey:@"time"];
    [paramDic setObject:@1 forKey:@"pageNumber"];
    searchVC.placeholderStr = @"请输入姓名/工号";
    searchVC.searchURLStr = self.urlStr;
    searchVC.searchVCType = self.titType+6;
    searchVC.searchParamStr = @"keyWord";
    searchVC.paramDic = paramDic;
    [self.navigationController pushViewController:searchVC animated:YES];
}

-(void)dealloc {
   
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
