//
//  YSManagerPositionHGViewController.m
//  YaSha-iOS
//
//  Created by GZl on 2019/3/27.
//  Copyright © 2019 亚厦装饰股份有限公司. All rights reserved.
//

#import "YSManagerPositionHGViewController.h"
#import "YSClockTimeTableViewCell.h"
#import "YSFormDatePickerCell.h"
#import "YSFormRowModel.h"
#import "YSHRManagerSelectYear.h"
#import "YSManagerPositionHeaderView.h"
#import "YSMangEntryPosityTableViewCell.h"
#import "YSPosittionSectionHeaderVIew.h"
#import "YSHRManagerHGViewController.h"
#import "YSHRManagerInfoHGViewController.h"
#import "YSNetManagerCache.h"
#import "YSHRMTDeptTreeViewController.h"
#import "YSHRManagerSearchSGViewController.h"
#import "YSRightToLeftTransition.h"
#import "YSContactModel.h"

@interface YSManagerPositionHGViewController ()
@property (nonatomic,strong)NSString *timeStr;
@property (nonatomic, strong) YSManagerPositionHeaderView *headerView;
@property (nonatomic, strong) NSMutableDictionary *paramDic;


@end

@implementation YSManagerPositionHGViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.timeStr = [NSString stringWithFormat:@"%ld",[[[NSDate date] dateByAddingHours:8] year]];

    if (self.positionType == PositionVCTypeEntry) {
        self.title = @"入职";
    }else if (self.positionType == PositionVCTypeLeave) {
        self.title = @"离职";
    }
    [self loadSubViews];
    
    [self refershTeamDataWithType:(RefreshStateTypeHeader)];

}
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self ys_showManagerScreenBar];
}
- (void)loadSubViews {
    YSWeak;
    YSHRManagerSelectYear *yearView = [[YSHRManagerSelectYear alloc] initWithFrame:(CGRectMake(0, kTopHeight, kSCREEN_WIDTH, 64*kHeightScale)) withTitle:self.deptName];
    yearView.tag = 2019204;
    yearView.selectYearBlock = ^(NSString * _Nonnull currentSelectedYear) {
        weakSelf.timeStr = currentSelectedYear;
        [weakSelf refershTeamDataWithType:(RefreshStateTypeHeader)];
    };
    [self.view addSubview:yearView];
}

- (void)layoutTableView {
    self.tableView.frame = CGRectMake(0, kTopHeight+64*kHeightScale, kSCREEN_WIDTH, kSCREEN_HEIGHT-kTopHeight-kBottomHeight-64*kHeightScale);
}
- (void)initTableView {
    [super initTableView];
    [self hideMJRefresh];
    self.tableView.separatorInset = UIEdgeInsetsMake(0, 16*kWidthScale, 0, 16*kWidthScale);
    self.headerView = [[YSManagerPositionHeaderView alloc] initWithFrame:(CGRectMake(0, 0, kSCREEN_WIDTH, 34*kHeightScale))];
    [self.tableView registerClass:[YSMangEntryPosityTableViewCell class] forCellReuseIdentifier:@"entryCELLID"];
    self.tableView.tableHeaderView = self.headerView;
    self.tableView.backgroundColor = [UIColor whiteColor];
    
    YSWeak;
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf.tableView.mj_header endRefreshing];
        [weakSelf.tableView.mj_footer endRefreshing];
        [weakSelf refershTeamDataWithType:RefreshStateTypeHeader];
    }];
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        [weakSelf.tableView.mj_header endRefreshing];
        [weakSelf.tableView.mj_footer endRefreshing];
        [weakSelf refershTeamDataWithType:RefreshStateTypeFooter];
    }];
    
}
- (void)doNetworking {
    [super doNetworking];
    [self.view bringSubviewToFront:self.navView];
    if (self.positionType == PositionVCTypeEntry) {
        [self.paramDic setObject:self.timeStr forKey:@"entryYear"];
    }else if (self.positionType == PositionVCTypeLeave) {
        [self.paramDic setObject:self.timeStr forKey:@"leaveYear"];
    }
    [self.paramDic setObject:self.deptIds forKey:@"deptIds"];
    [self.paramDic setObject:@(kPageSize) forKey:@"pageSize"];
    [self.paramDic setObject:@(self.pageNumber) forKey:@"pageIndex"];
    [YSNetManager ys_request_GETWithUrlString:[NSString stringWithFormat:@"%@%@",YSDomain, getAnnualList] isNeedCache:NO parameters:self.paramDic successBlock:^(id response) {
        [QMUITips hideAllToastInView:self.view animated:YES];
        DLog(@"入/离职====%@",response);
        if (1==[[response objectForKey:@"code"] integerValue]) {
            NSMutableArray *dataArray = [NSMutableArray arrayWithArray:[YSDataManager getTeamMyAllAuthorizedData:[response objectForKey:@"data"]]];
            [self handelDataAddModelImgWith:dataArray];
            if (self.refreshType == RefreshStateTypeHeader) {
                [self.tableView scrollRectToVisible:CGRectMake(0, 0, 0.1, 0.1) animated:NO];
                // 总数目
                NSString *number = [NSString stringWithFormat:@"%@", [[response objectForKey:@"data"] objectForKey:@"total"]];
                if ([number isEqual:[NSNull null]] || number == nil) {
                    self.headerView.numberLab.text = @"0";
                }else {
                    self.headerView.numberLab.text = number;
                }
                
                self.dataSourceArray = [NSMutableArray arrayWithArray:dataArray];
            }else {
                [self.dataSourceArray addObjectsFromArray:dataArray];
            }
            if (dataArray.count < kPageSize) {
                [self.tableView.mj_footer endRefreshingWithNoMoreData];
            }else {
                [self.tableView.mj_footer resetNoMoreData];
            }
        }
        [self.tableView reloadData];
    } failureBlock:^(NSError *error) {
        [QMUITips hideAllToastInView:self.view animated:YES];
        DLog(@"------%@",error);
    } progress:nil];
    
}

// 增加头像
- (void)handelDataAddModelImgWith:(NSMutableArray* _Nonnull)dataArray {
    [dataArray enumerateObjectsUsingBlock:^(YSTeamCompilePostModel  * compileModel, NSUInteger idx, BOOL * _Nonnull stop) {
        
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"userId = %@", compileModel.no];
        RLMResults *results = [[YSContactModel objectsWithPredicate:predicate]  sortedResultsUsingKeyPath:@"userId" ascending:YES];
        if ([results count] != 0) {
            YSContactModel *resultsModel = results[0];
            compileModel.headImage = [NSString stringWithFormat:@"%@_S.jpg", resultsModel.headImg];
        }
    }];
    
}


#pragma mark--refresh
- (void)refershTeamDataWithType:(RefreshStateType)type {
    self.refreshType = type;
    if (type == RefreshStateTypeHeader) {
        self.pageNumber = 1;
    }else {
        self.pageNumber = self.pageNumber+1;
    }
    [self doNetworking];
}


#pragma mark--tableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 50;
}

- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    YSPosittionSectionHeaderVIew *sectionView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"headerPoID"];
    if (!sectionView) {
        sectionView = [[YSPosittionSectionHeaderVIew alloc] initWithReuseIdentifier:@"headerPoID"];
        [sectionView updateConstraintsAndDataWithType:self.positionType+1];
    }
    return sectionView;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.dataSourceArray.count;
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50*kHeightScale;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    YSMangEntryPosityTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"entryCELLID" forIndexPath:indexPath];
    if (self.positionType == PositionVCTypeEntry) {
        // 入职
        cell.postEntyModel = self.dataSourceArray[indexPath.row];
    }else {
        // 离职
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.postLeaveModel = self.dataSourceArray[indexPath.row];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.positionType == PositionVCTypeEntry) {
        YSHRManagerInfoHGViewController *infoVC = [YSHRManagerInfoHGViewController new];
        infoVC.userNo = [self.dataSourceArray[indexPath.row] no];
        [self.navigationController pushViewController:infoVC animated:YES];
    }
}

- (void)clickedScreenBarAction {
    
    NSDictionary *dataDic = [YSNetManagerCache ys_httpCacheWithUrlString:[NSString stringWithFormat:@"%@%@",YSDomain,getDeptTree] parameters:nil];
    if (0 == [[dataDic objectForKey:@"data"] count]) {
        [QMUITips showInfo:@"无部门可选" inView:self.view hideAfterDelay:0.5];
        return;
    }
    YSHRMTDeptTreeViewController *deptVC = [YSHRMTDeptTreeViewController new];
    deptVC.view.backgroundColor = [UIColor colorWithHexString:@"#000000" alpha:0.4];
    //    deptVC.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    // 自定义的模态动画
    deptVC.modalPresentationStyle = UIModalPresentationCustom;
    deptVC.transitioningDelegate = [YSRightToLeftTransition sharedYSTransition];
    
    deptVC.deptArray = [NSMutableArray arrayWithArray:[dataDic objectForKey:@"data"]];
    YSWeak;
    deptVC.choseDeptTreeBlock = ^(YSDeptTreePointModel * _Nonnull model) {
        weakSelf.deptIds = model.point_id;
        weakSelf.deptName = model.point_name;
        YSHRManagerSelectYear *yearView = [weakSelf.view viewWithTag:2019204];
        yearView.titlLab.text = model.point_name;
        [weakSelf.tableView scrollRectToVisible:(CGRectMake(0, 0, 0.1, 0.1)) animated:NO];
        [weakSelf refershTeamDataWithType:(RefreshStateTypeHeader)];
    };
    [self presentViewController:deptVC animated:YES completion:nil];
}

- (void)clickedSeachBarAction {
    YSHRManagerSearchSGViewController *searchVC = [YSHRManagerSearchSGViewController new];
    searchVC.placeholderStr = @"请输入姓名/岗位名称";
    searchVC.searchURLStr = getAnnualList;
    searchVC.searchVCType = TeamHRSearchTypePosition;
    searchVC.searchParamStr = @"keyWord";
    NSMutableDictionary *paramDic = [NSMutableDictionary new];
    if (self.positionType == PositionVCTypeEntry) {
        [paramDic setObject:self.timeStr forKey:@"entryYear"];
    }else if (self.positionType == PositionVCTypeLeave) {
        [paramDic setObject:self.timeStr forKey:@"leaveYear"];
    }
    [paramDic setObject:self.deptIds forKey:@"deptId"];
    searchVC.paramDic = paramDic;
    [self.navigationController pushViewController:searchVC animated:YES];
}


#pragma mark--setter&&getter
- (NSMutableDictionary *)paramDic {
    if (!_paramDic) {
        _paramDic = [NSMutableDictionary new];
    }
    return _paramDic;
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
