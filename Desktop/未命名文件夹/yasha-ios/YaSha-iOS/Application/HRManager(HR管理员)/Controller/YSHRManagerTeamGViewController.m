//
//  YSHRManagerTeamGViewController.m
//  YaSha-iOS
//
//  Created by GZl on 2019/3/26.
//  Copyright © 2019 亚厦装饰股份有限公司. All rights reserved.
//

#import "YSHRManagerTeamGViewController.h"
#import "YSManagerTeamHeaderView.h"
#import "YSHRMTCompileTableViewCell.h"
#import "YSHRMTCompileDetailViewController.h"
#import "YSNetManagerCache.h"
#import "YSTeamCompilePostModel.h"
#import "YSHRMTDeptTreeViewController.h"
#import "YSRightToLeftTransition.h"
#import "YSHRManagerSearchSGViewController.h"


@interface YSHRManagerTeamGViewController ()
@property (nonatomic, strong) NSMutableDictionary *dataDic;

@end

@implementation YSHRManagerTeamGViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"编制";
    
    [self loadSubViews];
    // 获取统计数据
    [self getAuthorizedTotalNetwork];
    [self refershTeamDataWithType:(RefreshStateTypeHeader)];
    
}
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self ys_showManagerScreenBar];

}
- (void)initTableView {
    [super initTableView];
    [self.tableView registerClass:[YSHRMTCompileTableViewCell class] forCellReuseIdentifier:@"GHMTCell"];
    self.tableView.rowHeight = 48*kHeightScale;
    self.tableView.separatorInset = UIEdgeInsetsMake(0, 16*kWidthScale, 0, 16*kHeightScale);
    
}

- (void)layoutTableView {
    self.tableView.frame = CGRectMake(0, kTopHeight+182*kHeightScale, kSCREEN_WIDTH, kSCREEN_HEIGHT-kTopHeight-kBottomHeight-182*kHeightScale);
}

- (void)loadSubViews {
    self.view.backgroundColor = [UIColor whiteColor];
    YSManagerTeamHeaderView *headerView = [[YSManagerTeamHeaderView alloc] initWithFrame:(CGRectMake(0, kTopHeight, kSCREEN_WIDTH, 182*kHeightScale))];
    headerView.tag = 1351;
    NSDictionary *dataDic = [YSNetManagerCache ys_httpCacheWithUrlString:[NSString stringWithFormat:@"%@%@",YSDomain,getDeptTree] parameters:nil];
    if (!self.deptName && 0 != [[dataDic objectForKey:@"data"] count]) {
        NSDictionary *deptTreeDic = [dataDic objectForKey:@"data"][0];
        self.deptName = [deptTreeDic objectForKey:@"name"];
    }
    headerView.titLab.text = self.deptName;
    YSWeak;
    headerView.choseSequenceBlock = ^(NSInteger index) {
        YSStrong;
        [strongSelf.tableView scrollRectToVisible:(CGRectMake(0, 0, 0.1, 0.1)) animated:NO];
        // 0~5 全部~其他
        switch (index) {
            case 0:
            {//全部
                [strongSelf.dataDic removeObjectForKey:@"post"];
            }
                break;
            case 1:
                {//M序列
                    [strongSelf.dataDic setObject:@"M" forKey:@"post"];
                }
                break;
            case 2:
            {//P序列
                [strongSelf.dataDic setObject:@"P" forKey:@"post"];
            }
                break;
            case 3:
            {//M序列
                [strongSelf.dataDic setObject:@"A" forKey:@"post"];
            }
                break;
            case 4:
            {//M序列
                [strongSelf.dataDic setObject:@"O" forKey:@"post"];
            }
                break;
            case 5:
            {//其他
                [strongSelf.dataDic setObject:@"other" forKey:@"post"];
            }
                break;
            default:
                break;
        }
        [weakSelf refershTeamDataWithType:(RefreshStateTypeHeader)];
    };
    [self.view addSubview:headerView];
}

// 获取统计数据
- (void)getAuthorizedTotalNetwork {
    [QMUITips showLoadingInView:self.view];
    [self.view bringSubviewToFront:self.navView];
    NSDictionary *paramDic = [NSDictionary dictionaryWithObject:self.deptIds forKey:@"deptIds"];
    [YSNetManager ys_request_GETWithUrlString:[NSString stringWithFormat:@"%@%@", YSDomain, getAuthorizedStrengthTotal] isNeedCache:NO parameters:paramDic successBlock:^(id response) {
        [QMUITips hideAllToastInView:self.view animated:YES];
        DLog(@"编制详情统计:%@", response);
        if (1==[[response objectForKey:@"code"] integerValue]) {
            YSManagerTeamHeaderView *headerView = [self.view viewWithTag:1351];
            [headerView upNumberDataWith:response[@"data"]];
        }
        [self.tableView reloadData];
    } failureBlock:^(NSError *error) {
        [QMUITips hideAllToastInView:self.view animated:YES];
        
    } progress:nil];
}
- (void)doNetworking {
    [super doNetworking];
    [self.view bringSubviewToFront:self.navView];
    [self.dataDic setValue:self.deptIds forKey:@"deptIds"];
    [self.dataDic setObject:@(self.pageNumber) forKey:@"pageIndex"];
    [self.dataDic setObject:@kPageSize forKey:@"pageSize"];
    [YSNetManager ys_request_GETWithUrlString:[NSString stringWithFormat:@"%@%@", YSDomain, getAuthorizedStrengthList] isNeedCache:NO parameters:self.dataDic successBlock:^(id response) {
        [QMUITips hideAllToastInView:self.view animated:YES];
        DLog(@"团队编制列表:%@", response);
        if (![[response objectForKey:@"data"] isEqual:[NSNull class]]) {
            NSMutableArray *responseArray = [NSMutableArray arrayWithCapacity:0];
            for (NSDictionary *dic in [[response objectForKey:@"data"] objectForKey:@"list"]) {
                YSTeamCompilePostModel *model = [YSTeamCompilePostModel yy_modelWithJSON:dic];
                [responseArray addObject:model];
            }
            if (self.refreshType == RefreshStateTypeHeader) {
                self.dataSourceArray = [NSMutableArray arrayWithArray:responseArray];
            }else {
                [self.dataSourceArray addObjectsFromArray:responseArray];
            }
            if (responseArray.count < kPageSize) {
                [self.tableView.mj_footer endRefreshingWithNoMoreData];
            }else {
                [self.tableView.mj_footer resetNoMoreData];
            }
            
        }
        [self.tableView reloadData];
    } failureBlock:^(NSError *error) {
        [QMUITips hideAllToastInView:self.view animated:YES];

    } progress:nil];
}

- (void)refershTeamDataWithType:(RefreshStateType)type {
    self.refreshType = type;
    if (type == RefreshStateTypeHeader) {
        self.pageNumber = 1;
    }else {
        self.pageNumber++;
    }
    [self doNetworking];
}

#pragma mark--tableViewDelegate
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    YSHRMTCompileTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"GHMTCell" forIndexPath:indexPath];
    cell.complieModel = self.dataSourceArray[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    YSTeamCompilePostModel *model = self.dataSourceArray[indexPath.row];
    YSHRMTCompileDetailViewController *detailVC = [YSHRMTCompileDetailViewController new];
    detailVC.deptIds = model.pkDept;
    detailVC.postName = model.postName;
    [self.navigationController pushViewController:detailVC animated:YES];
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
        weakSelf.deptName = model.point_name;
        YSManagerTeamHeaderView *headerView = [self.view viewWithTag:1351];
        headerView.titLab.text = model.point_name;
        [headerView upNumberDataWith:nil];
        [weakSelf getAuthorizedTotalNetwork];
        [weakSelf refershTeamDataWithType:(RefreshStateTypeHeader)];
    };
    [self presentViewController:deptVC animated:YES completion:nil];
}

- (void)clickedSeachBarAction {
    YSHRManagerSearchSGViewController *searchVC = [YSHRManagerSearchSGViewController new];
    searchVC.placeholderStr = @"请输入岗位名称";
    searchVC.searchURLStr = getAuthorizedStrengthList;
    searchVC.searchVCType = TeamHRSearchTypeCompile;
    searchVC.searchParamStr = @"keyWord";
    searchVC.paramDic = [NSMutableDictionary dictionaryWithObject:self.deptIds forKey:@"deptIds"];
    [self.navigationController pushViewController:searchVC animated:YES];
}

#pragma mark--setter&&getter
- (NSMutableDictionary *)dataDic {
    if (!_dataDic) {
        _dataDic = [NSMutableDictionary new];
    }
    return _dataDic;
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
