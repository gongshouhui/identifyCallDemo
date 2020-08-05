//
//  YSHRMTWorkingViewController.m
//  YaSha-iOS
//
//  Created by GZl on 2019/4/4.
//  Copyright © 2019 亚厦装饰股份有限公司. All rights reserved.
//

#import "YSHRMTWorkingViewController.h"
#import "YSContactCell.h"//部门cell
#import "YSMangEntryPosityTableViewCell.h"//人员cell
#import "YSTeamCompilePostModel.h"
#import "YSHRManagerInfoHGViewController.h"
#import "YSNetManagerCache.h"
#import "YSHRMTDeptTreeViewController.h"
#import "YSHRManagerSearchSGViewController.h"
#import "YSRightToLeftTransition.h"


@interface YSHRMTWorkingViewController ()

@property (nonatomic, strong) UILabel *choseLab;
@property (nonatomic, strong) UILabel *numberLab;
@property (nonatomic, strong) NSMutableArray *dataPersonArray;


@end

@implementation YSHRMTWorkingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"在岗";
    [self loadSubViews];

    [self refershTeamDataWithType:(RefreshStateTypeHeader)];
}

- (void)initTableView {
    [super initTableView];
    [self.tableView registerClass:[YSContactCell class] forCellReuseIdentifier:@"deptCellID"];
    [self.tableView registerClass:[YSMangEntryPosityTableViewCell class] forCellReuseIdentifier:@"peopleCellID"];
    self.tableView.separatorInset = UIEdgeInsetsMake(0, 16*kWidthScale, 0, 16*kWidthScale);
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
//    [self ys_showManagerSearchBar];
    [self ys_showManagerScreenBar];

}

- (void)loadSubViews {
    
    UIView *headerView = [[UIView alloc] initWithFrame:(CGRectMake(0, kTopHeight, kSCREEN_WIDTH, 56*kHeightScale))];
    headerView.backgroundColor = [UIColor whiteColor];
    self.tableView.tableHeaderView = headerView;
    
    _choseLab = [[UILabel alloc] init];
    NSDictionary *dataDic = [YSNetManagerCache ys_httpCacheWithUrlString:[NSString stringWithFormat:@"%@%@",YSDomain,getDeptTree] parameters:nil];
    if (!self.deptName && 0 != [[dataDic objectForKey:@"data"] count]) {
        NSDictionary *deptTreeDic = [dataDic objectForKey:@"data"][0];
        self.deptName = [deptTreeDic objectForKey:@"name"];
    }
    _choseLab.text = self.deptName;
    _choseLab.textColor = [UIColor colorWithHexString:@"#333333"];
    _choseLab.font = [UIFont fontWithName:@"PingFangSC-Medium" size:Multiply(16)];
    [headerView addSubview:_choseLab];
    [_choseLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(0);
        make.left.mas_equalTo(16*kWidthScale);
    }];
    
    _numberLab = [[UILabel alloc] init];
    _numberLab.text = @"";
    _numberLab.textColor = [UIColor colorWithHexString:@"#474C51"];
    _numberLab.font = [UIFont fontWithName:@"PingFangSC-Medium" size:Multiply(12)];
    [headerView addSubview:_numberLab];
    [_numberLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(_choseLab.mas_bottom);
        make.left.mas_equalTo(_choseLab.mas_right).offset(13*kWidthScale);
    }];
}

- (void)doNetworking {
    [super doNetworking];
    [self.view bringSubviewToFront:self.navView];
    NSDictionary *paramDic = [NSDictionary dictionaryWithObject:self.deptIds forKey:@"deptIds"];
    [YSNetManager ys_request_GETWithUrlString:[NSString stringWithFormat:@"%@%@", YSDomain, gePostInfoList] isNeedCache:NO parameters:paramDic successBlock:^(id response) {
        [QMUITips hideAllToastInView:self.view animated:NO];
        DLog(@"团队在岗列表%@", response);
        if (1==[[response objectForKey:@"code"] integerValue]) {
            [self.dataPersonArray removeAllObjects];
            [self.dataSourceArray removeAllObjects];
            for (NSDictionary *dic in [[response objectForKey:@"data"] objectForKey:@"peopleList"]) {
                YSTeamCompilePostModel *model = [YSTeamCompilePostModel yy_modelWithJSON:dic];
                NSPredicate *predicate = [NSPredicate predicateWithFormat:@"userId = %@", model.employcode];
                RLMResults *results = [[YSContactModel objectsWithPredicate:predicate]  sortedResultsUsingKeyPath:@"userId" ascending:YES];
                if ([results count] != 0) {
                    YSContactModel *resultsModel = results[0];
                    model.headImage = [NSString stringWithFormat:@"%@_S.jpg", resultsModel.headImg];
                }
                [self.dataPersonArray addObject:model];
            }
            for (NSDictionary *dic in [[response objectForKey:@"data"] objectForKey:@"deptList"]) {
                YSTeamCompilePostModel *model = [YSTeamCompilePostModel yy_modelWithJSON:dic];
                [self.dataSourceArray addObject:model];
            }
            self.numberLab.text = [NSString stringWithFormat:@"%@人", [YSUtility cancelNullData:[[response objectForKey:@"data"] objectForKey:@"peopleCount"]]];

        }
        [self.tableView.mj_footer endRefreshingWithNoMoreData];
        [self.tableView reloadData];
    } failureBlock:^(NSError *error) {
        [QMUITips hideAllToastInView:self.view animated:NO];
    } progress:nil];
}

- (void)refershTeamDataWithType:(RefreshStateType)type {
    [self doNetworking];
}

#pragma mark--tableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 48*kHeightScale;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (self.dataPersonArray.count && self.dataSourceArray.count) {
        return 2;
    }else if (self.dataSourceArray.count || self.dataPersonArray.count) {
        // 只有部门 或者 只有人员
        return 1;
    }else {
        return 0;
    }
    
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.dataSourceArray.count && self.dataPersonArray.count) {
        if (section == 0) {
            //显示人员
            return self.dataPersonArray.count;
        }else {
            // 显示部门
            return self.dataSourceArray.count;
        }
    }else if (self.dataSourceArray.count) {
        // 只显示部门
        return self.dataSourceArray.count;
    }else if (self.dataPersonArray.count) {
        // 只显示人员
        return self.dataPersonArray.count;
    }
    return 0;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 7*kHeightScale;
}
- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *backView = [[UIView alloc] init];
    backView.backgroundColor = self.view.backgroundColor;
    return backView;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.dataSourceArray.count && self.dataPersonArray.count) {
        if (indexPath.section == 0) {
            //显示人员
            YSMangEntryPosityTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"peopleCellID" forIndexPath:indexPath];
            cell.workModel = self.dataPersonArray[indexPath.row];
            return cell;
        }else {
            //部门
            YSContactCell *cell = [tableView dequeueReusableCellWithIdentifier:@"deptCellID" forIndexPath:indexPath];
            YSTeamCompilePostModel *model = self.dataSourceArray[indexPath.row];
            cell.deptModel = model;
            /*
            if ([model.code isEqualToString:@"0"]) {
                cell.accessoryType = UITableViewCellAccessoryNone;
            }else {
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            }
             */
            return cell;
        }
    }else if (self.dataSourceArray.count) {
        // 只显示部门
        YSContactCell *cell = [tableView dequeueReusableCellWithIdentifier:@"deptCellID" forIndexPath:indexPath];
        YSTeamCompilePostModel *model = self.dataSourceArray[indexPath.row];
        cell.deptModel = model;
        /*
        if ([model.code isEqualToString:@"0"]) {
            cell.accessoryType = UITableViewCellAccessoryNone;
        }else {
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
         */
        return cell;
    }else if (self.dataPersonArray.count) {
        //只显示人员
        YSMangEntryPosityTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"peopleCellID" forIndexPath:indexPath];
        cell.workModel = self.dataPersonArray[indexPath.row];

        return cell;
    }
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.dataSourceArray.count && self.dataPersonArray.count) {
        if (indexPath.section == 0) {
            //显示人员
            YSTeamCompilePostModel *model = self.dataPersonArray[indexPath.row];
            YSHRManagerInfoHGViewController *infoVC = [[YSHRManagerInfoHGViewController alloc] init];
            infoVC.userNo = model.employcode;
            [self.navigationController pushViewController:infoVC animated:YES];
        }else {
            // 显示部门
            YSTeamCompilePostModel *model = self.dataSourceArray[indexPath.row];
            /*//不跳转页面
            self.deptName = model.name;
            self.choseLab.text = model.name;
            self.deptIds = model.pkDept;
            [self.tableView scrollRectToVisible:(CGRectMake(0, 0, 0.1, 0.1)) animated:NO];
            [self refershTeamDataWithType:(RefreshStateTypeHeader)];
             */
            //跳转新页面
            YSHRMTWorkingViewController *newVC = [YSHRMTWorkingViewController new];
            newVC.deptName = model.name;
            newVC.deptIds = model.pkDept;
            [self.navigationController pushViewController:newVC animated:YES];
            
            
        }
    }else if (self.dataSourceArray.count) {
        // 只显示部门
        YSTeamCompilePostModel *model = self.dataSourceArray[indexPath.row];
        /*//不跳转页面
        self.deptName = model.name;
        self.choseLab.text = model.name;
        self.deptIds = model.pkDept;
        [self.tableView scrollRectToVisible:(CGRectMake(0, 0, 0.1, 0.1)) animated:NO];
        [self refershTeamDataWithType:(RefreshStateTypeHeader)];
        */
        //跳转新页面
        YSHRMTWorkingViewController *newVC = [YSHRMTWorkingViewController new];
        newVC.deptName = model.name;
        newVC.deptIds = model.pkDept;
        [self.navigationController pushViewController:newVC animated:YES];
        
    }else if (self.dataPersonArray.count) {
        // 只显示人员
        YSTeamCompilePostModel *model = self.dataPersonArray[indexPath.row];
        YSHRManagerInfoHGViewController *infoVC = [[YSHRManagerInfoHGViewController alloc] init];
        infoVC.userNo = model.employcode;
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
        weakSelf.choseLab.text = model.point_name;
        [weakSelf.tableView scrollRectToVisible:(CGRectMake(0, 0, 0.1, 0.1)) animated:NO];
        [weakSelf refershTeamDataWithType:(RefreshStateTypeHeader)];
    };
    [self presentViewController:deptVC animated:YES completion:nil];
}

- (void)clickedSeachBarAction {
    YSHRManagerSearchSGViewController *searchVC = [YSHRManagerSearchSGViewController new];
    searchVC.placeholderStr = @"请输入姓名/工号";
    searchVC.searchURLStr = gePostInfoList;
    searchVC.searchVCType = TeamHRSearchTypeWork;
    searchVC.searchParamStr = @"keyWord";
    NSMutableDictionary *paramDic = [NSMutableDictionary new];
    [paramDic setObject:self.deptIds forKey:@"deptIds"];
    searchVC.paramDic = paramDic;
    [self.navigationController pushViewController:searchVC animated:YES];
}

#pragma mark--setter&&getter
- (NSMutableArray *)dataPersonArray {
    if (!_dataPersonArray) {
        _dataPersonArray = [NSMutableArray new];
    }
    return _dataPersonArray;
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
