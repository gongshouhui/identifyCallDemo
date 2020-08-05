//
//  YSHRMDHTrainingViewController.m
//  YaSha-iOS
//
//  Created by GZl on 2019/4/9.
//  Copyright © 2019 亚厦装饰股份有限公司. All rights reserved.
//

#import "YSHRMDHTrainingViewController.h"
#import "YSHRMDTrainingGTableViewCell.h"
#import "YSHRMDTraiHeaderView.h"
#import "YSHRMDPLevelHeaderView.h"
#import "YSHRMDTrainGTableViewCell.h"
#import "YSNetManagerCache.h"
#import "YSHRMTTrainingModel.h"
#import "YSHRMTDeptTreeViewController.h"
#import "YSRightToLeftTransition.h"
#import "YSDeptTreePointModel.h"
#import "YSHRManagerSearchSGViewController.h"

@interface YSHRMDHTrainingViewController ()
@property (nonatomic, assign) BOOL isDetail;//是否点击查看
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, copy) NSString *currentSelectedYear;
@property (nonatomic, strong) NSMutableDictionary *paramDic;
@property (nonatomic, assign) RefreshStateType refreshType;
@property (nonatomic, assign) NSInteger season;//季度
@property (nonatomic, strong) YSHRMTTrainingModel *traintModel;


@end

@implementation YSHRMDHTrainingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"部门培训";
    self.isDetail = NO;
    self.navigationItem.rightBarButtonItems = @[[self lt_customBackItemWithTarget:self action:@selector(clickedScreenBarAction) withImgName:@"screenYSHGR"]];
    self.deptIds = @"";
    // 从本地取部门信息
    NSDictionary *dataDic = [YSNetManagerCache ys_httpCacheWithUrlString:[NSString stringWithFormat:@"%@%@",YSDomain,getDeptTree] parameters:nil];
    if (0 != [[dataDic objectForKey:@"data"] count]) {
        NSDictionary *deptTreeDic = [dataDic objectForKey:@"data"][0];
        self.deptNameStr = [deptTreeDic objectForKey:@"name"];
    }
    [self loadSubViews];

    [self refershTrainDataWith:RefreshStateTypeHeader];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.titleView.titleLabel.textColor = [UIColor whiteColor];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage gradientImageWithBounds:CGRectMake(0, 0, kSCREEN_WIDTH, kTopHeight) andColors:@[[UIColor colorWithHexString:@"#546AFD"],[UIColor colorWithHexString:@"#2EC1FF"]] andGradientType:1]  forBarMetrics:UIBarMetricsDefault];
}

- (void)loadSubViews {
    YSWeak;
    YSHRMDPLevelHeaderView *headerView = [[YSHRMDPLevelHeaderView alloc] initWithFrame:(CGRectMake(0, kTopHeight, kSCREEN_WIDTH, 56*kHeightScale)) withMenuArray:@[@"第一季度", @"第二季度", @"第三季度", @"第四季度"]];
    headerView.tag = 5536;
    headerView.backgroundColor = [UIColor whiteColor];
    headerView.titLab.text = self.deptNameStr;
    headerView.selectYearBlock = ^(NSString * _Nonnull currentSelectedYear) {
        YSStrong;
        [strongSelf handleChoseTimeWith:currentSelectedYear];
        [strongSelf refershTrainDataWith:(RefreshStateTypeHeader)];
    };
    [self.view addSubview:headerView];
    [self handleChoseTimeWith:headerView.currentSelectedYear];
}

-(void)layoutTableView {
    self.tableView.frame = CGRectMake(0, 56*kHeightScale+kTopHeight, kSCREEN_WIDTH, kSCREEN_HEIGHT-56*kHeightScale-kTopHeight-kBottomHeight);
}

- (void)initTableView {
    [super initTableView];
    [self.tableView registerClass:[YSHRMDTrainingGTableViewCell class] forCellReuseIdentifier:@"traingCellID"];
    [self.tableView registerClass:[YSHRMDTrainGTableViewCell class] forCellReuseIdentifier:@"trainDetailCell"];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerClass:[YSHRMDTraiHeaderView class] forHeaderFooterViewReuseIdentifier:@"headerTrainHeader"];
        if (@available(iOS 11.0, *)) {
            self.tableView.estimatedRowHeight = 0;
            self.tableView.estimatedSectionFooterHeight = 0;
            self.tableView.estimatedSectionHeaderHeight = 0;
        }else{
            self.automaticallyAdjustsScrollViewInsets = NO;
        }
        
    YSWeak;
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf.tableView.mj_header endRefreshing];
        [weakSelf.tableView.mj_footer endRefreshing];
        [weakSelf refershTrainDataWith:(RefreshStateTypeHeader)];
    }];
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        [weakSelf.tableView.mj_header endRefreshing];
        [weakSelf.tableView.mj_footer endRefreshing];
        [weakSelf refershTrainDataWith:(RefreshStateTypeFooter)];
    }];
}

// 处理所选择的时间
- (void)handleChoseTimeWith:(NSString*)timeStr {
    self.currentSelectedYear = [timeStr substringToIndex:4];
    if ([timeStr containsString:@"一"]) {
        self.season = 1;
    }else if ([timeStr containsString:@"二"]) {
        self.season = 2;
    }else if ([timeStr containsString:@"三"]) {
        self.season = 3;
    }else if ([timeStr containsString:@"四"]) {
        self.season = 4;
    }
}

- (void)getTranSummary{
    [QMUITips showLoadingInView:self.view];
    
    [self.paramDic setObject:@(kPageSize) forKey:@"pageSize"];
    [self.paramDic setObject:self.currentSelectedYear forKey:@"planYear"];
    [self.paramDic setObject:self.deptIds forKey:@"deptIds"];
    [self.paramDic setObject:@(self.season) forKey:@"season"];
    
    [YSNetManager ys_request_GETWithUrlString:[NSString stringWithFormat:@"%@%@",YSDomain,getTrainForTeam] isNeedCache:NO parameters:self.paramDic successBlock:^(id response) {
        [QMUITips hideAllTipsInView:self.view];
        DLog(@"团队培训信息:%@", response);
        if ([response[@"code"] integerValue] == 1) {
            NSArray *dataArray = [YSDataManager getTeamMyAllTrainingData:response[@"data"][@"trainingDetail"]];
            if (self.refreshType == RefreshStateTypeHeader) {
                self.traintModel = [YSHRMTTrainingModel yy_modelWithJSON:response[@"data"]];
                self.dataArray = [NSMutableArray arrayWithArray:dataArray];
            }else {
                [self.dataArray addObjectsFromArray:dataArray];
            }
            if (dataArray.count < kPageSize) {
                [self.tableView.mj_footer endRefreshingWithNoMoreData];
            }else {
                [self.tableView.mj_footer resetNoMoreData];
            }
        }
        [self.tableView reloadData];
    } failureBlock:^(NSError *error) {
        [QMUITips hideAllTipsInView:self.view];

    } progress:nil];
}

#pragma mark--refreshData
- (void)refershTrainDataWith:(RefreshStateType)type {
    self.refreshType = type;
    if (type == RefreshStateTypeHeader) {
        [self.paramDic setObject:@(1) forKey:@"pageIndex"];
    }else {
        NSInteger pageIndex = [[self.paramDic objectForKey:@"pageIndex"] integerValue]+1;
        [self.paramDic setObject:@(pageIndex) forKey:@"pageIndex"];
    }
    [self getTranSummary];
}

#pragma mark--tableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // 两个分区 第一个分区3个cell
    return 2;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 3;
    }else {
        return self.dataArray.count;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            return 290*kHeightScale;
        }else if (indexPath.row == 1){
            return 219*kHeightScale;
        }else {
            if (!self.isDetail) {
                return 219*kHeightScale;
            }else {
                return 330*kHeightScale;
            }
        }
    }else {
        return 47*kHeightScale;
    }
}
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        
        YSHRMDTrainingGTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"traingCellID" forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.schematicImg.hidden = YES;
        [cell.backTopView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(343*kWidthScale, 126*kHeightScale));
        }];
        if (indexPath.row == 0) {
            cell.backBottomView.hidden = NO;
            cell.trainingCourse = self.traintModel.trainingCourse;
        }else if (indexPath.row == 1){
            cell.backBottomView.hidden = YES;
            cell.courseDevelop = self.traintModel.courseDevelop;
        }else if (indexPath.row == 2) {
            cell.backBottomView.hidden = YES;
            cell.schematicImg.hidden = NO;
            if (self.isDetail) {
                cell.schematicImg.image = [UIImage imageNamed:@"hrmdTrinSDownImg"];
                [cell.backTopView mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.size.mas_equalTo(CGSizeMake(343*kWidthScale, 256*kHeightScale));
                }];
            }else {
                cell.schematicImg.image = [UIImage imageNamed:@"hrmdTrinSUpImg"];
            }
            cell.complete = self.traintModel.complete;
        }
        return cell;
    }else {
        YSHRMDTrainGTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"trainDetailCell" forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.detailModel = self.dataArray[indexPath.row];
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0 && indexPath.row == 2) {
        YSHRMDTrainingGTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        self.isDetail = !self.isDetail;
        if (self.isDetail) {
            cell.schematicImg.image = [UIImage imageNamed:@"hrmdTrinSDownImg"];
            [cell.backTopView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.size.mas_equalTo(CGSizeMake(343*kWidthScale, 256*kHeightScale));
            }];
        }else {
            cell.schematicImg.image = [UIImage imageNamed:@"hrmdTrinSUpImg"];
            [cell.backTopView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.size.mas_equalTo(CGSizeMake(343*kWidthScale, 126*kHeightScale));
            }];
        }
        [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:NO];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 1) {
        return 80*kHeightScale;
    }else {
        return 0.01;
    }
}

- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section == 1) {
        YSHRMDTraiHeaderView *headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"headerTrainHeader"];

        return headerView;
    }
    return nil;
}

#pragma mark--setter&&getter
- (NSMutableArray *)dataArray {
    if (!_dataArray) {
        _dataArray = [NSMutableArray new];
    }
    return _dataArray;
}
- (NSMutableDictionary *)paramDic {
    if (!_paramDic) {
        _paramDic = [NSMutableDictionary new];
    }
    return _paramDic;
}

#pragma mark--配置导航条
// 点击导航条上的组织筛选按钮
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
        weakSelf.deptNameStr = model.point_name;
        YSHRMDPLevelHeaderView *headerView = (YSHRMDPLevelHeaderView *)[weakSelf.view viewWithTag:5536];
        headerView.titLab.text = model.point_name;
        weakSelf.deptIds = model.point_id;
        [weakSelf refershTrainDataWith:(RefreshStateTypeHeader)];
    };
    [self presentViewController:deptVC animated:YES completion:nil];
}
// 点击导航条上搜索按钮
- (void)clickedSeachBarAction {
    YSHRManagerSearchSGViewController *searchVC = [YSHRManagerSearchSGViewController new];
    NSMutableDictionary *paramDic = [NSMutableDictionary new];
    [paramDic setObject:self.deptIds forKey:@"deptIds"];
    [paramDic setObject:@1 forKey:@"pageIndex"];
    searchVC.placeholderStr = @"请输入姓名/工号";
//    searchVC.searchURLStr = @"";//暂时没有搜索功能
//    searchVC.searchParamStr = @"";//keyword / keyWord
    searchVC.paramDic = paramDic;
    [self.navigationController pushViewController:searchVC animated:YES];
}
- (void)temaBack {
    [self.navigationController popViewControllerAnimated:YES];
}
- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

- (UIBarButtonItem *)lt_customBackItemWithTarget:(id)target action:(SEL)action withImgName:(NSString*)imgName{
    UIImage *image =UIImageMake(imgName) ;
    UIImage *backImage = [image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    return [[UIBarButtonItem alloc] initWithImage:backImage style:UIBarButtonItemStyleDone target:target action:action];
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
