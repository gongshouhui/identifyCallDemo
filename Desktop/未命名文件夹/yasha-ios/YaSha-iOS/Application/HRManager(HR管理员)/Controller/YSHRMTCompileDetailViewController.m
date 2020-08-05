//
//  YSHRMTCompileDetailViewController.m
//  YaSha-iOS
//
//  Created by GZl on 2019/4/4.
//  Copyright © 2019 亚厦装饰股份有限公司. All rights reserved.
//

#import "YSHRMTCompileDetailViewController.h"
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

@interface YSHRMTCompileDetailViewController ()

@property (nonatomic, strong) YSManagerPositionHeaderView *headerView;
@property (nonatomic, strong) NSMutableDictionary *paramDic;


@end

@implementation YSHRMTCompileDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"编制详情";
    [self.paramDic setObject:@(kPageSize) forKey:@"pageSize"];
    [self refershTeamDataWithType:(RefreshStateTypeHeader)];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
//    [self ys_showManagerScreenBar];
    [self ys_showManagerSearchBar];

}

- (void)initTableView {
    [super initTableView];
    [self hideMJRefresh];
    self.tableView.backgroundColor = [UIColor whiteColor];
    self.tableView.separatorInset = UIEdgeInsetsMake(0, 16*kWidthScale, 0, 16*kWidthScale);
    UIView *backHeaderView = [[UIView alloc] initWithFrame:(CGRectMake(0, 0, kSCREEN_WIDTH, 50*kHeightScale))];
    self.headerView = [[YSManagerPositionHeaderView alloc] initWithFrame:(CGRectMake(0, 16*kHeightScale, kSCREEN_WIDTH, 34*kHeightScale))];
    [backHeaderView addSubview:self.headerView];
    [self.tableView registerClass:[YSMangEntryPosityTableViewCell class] forCellReuseIdentifier:@"entryCELLID"];
    self.tableView.tableHeaderView = backHeaderView;
    self.tableView.backgroundColor = [UIColor whiteColor];
    
    YSWeak;
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf.tableView.mj_header endRefreshing];
        [weakSelf.tableView.mj_footer endRefreshing];
        [weakSelf refershTeamDataWithType:(RefreshStateTypeHeader)];
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
    [self.paramDic setValue:@(self.pageNumber) forKey:@"pageIndex"];
    [self.paramDic setObject:self.deptIds forKey:@"deptId"];
    [self.paramDic setObject:self.postName forKey:@"postName"];
    [YSNetManager ys_request_GETWithUrlString:[NSString stringWithFormat:@"%@%@", YSDomain, getAuthorizedStrengthDetails] isNeedCache:NO parameters:self.paramDic successBlock:^(id response) {
        DLog(@"团队编制详情:%@", response);
        [QMUITips hideAllToastInView:self.view animated:YES];
        if ([[response objectForKey:@"code"] integerValue] ==1) {
            NSMutableArray *dataArray = [NSMutableArray arrayWithArray:[YSDataManager getTeamMyAllAuthorizedData:[response objectForKey:@"data"]]];
            [self handelDataAddModelImgWith:dataArray];
            if (self.refreshType == RefreshStateTypeHeader) {
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

        [self ys_reloadData];
    } failureBlock:^(NSError *error) {
        [QMUITips hideAllToastInView:self.view animated:YES];
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

- (void)refershTeamDataWithType:(RefreshStateType)type {
    self.refreshType = type;
    if (type == RefreshStateTypeHeader) {
        self.pageNumber = 1;
    }else {
        self.pageNumber = [[self.paramDic objectForKey:@"pageIndex"] integerValue]+1;
    }
    [self doNetworking];
}

#pragma mark--tableViewDelagte
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 50*kHeightScale;
}

- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    YSPosittionSectionHeaderVIew *sectionView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"headerPoID"];
    if (!sectionView) {
        sectionView = [[YSPosittionSectionHeaderVIew alloc] initWithReuseIdentifier:@"headerPoID"];
        [sectionView updateConstraintsAndDataWithType:0];
    }
    return sectionView;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSourceArray.count;
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 48*kHeightScale;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    YSMangEntryPosityTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"entryCELLID" forIndexPath:indexPath];
    cell.compileModel = self.dataSourceArray[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    YSHRManagerInfoHGViewController *infoVC = [YSHRManagerInfoHGViewController new];
    infoVC.userNo = [self.dataSourceArray[indexPath.row] no];
    [self.navigationController pushViewController:infoVC animated:YES];
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
        [weakSelf.tableView scrollRectToVisible:(CGRectMake(0, 0, 0.1, 0.1)) animated:NO];
        weakSelf.deptIds = model.point_id;
        [weakSelf refershTeamDataWithType:(RefreshStateTypeHeader)];
    };
    [self presentViewController:deptVC animated:YES completion:nil];
}

- (void)clickedSeachBarAction {
    YSHRManagerSearchSGViewController *searchVC = [YSHRManagerSearchSGViewController new];
    searchVC.placeholderStr = @"请输入姓名/岗位名称";
    searchVC.searchURLStr = getAuthorizedStrengthDetails;
    searchVC.searchVCType = TeamHRSearchTypeCompileDetail;
    searchVC.searchParamStr = @"keyWord";
    NSMutableDictionary *paramDic = [NSMutableDictionary new];
    [paramDic setObject:self.deptIds forKey:@"deptId"];
    [paramDic setObject:self.postName forKey:@"postName"];
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
