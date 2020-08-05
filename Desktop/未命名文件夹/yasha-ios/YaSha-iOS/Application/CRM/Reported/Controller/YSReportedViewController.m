//
//  YSReportedViewController.m
//  YaSha-iOS
//
//  Created by YaSha_Tom on 2018/12/19.
//  Copyright © 2018年 亚厦装饰股份有限公司. All rights reserved.
//

#import "YSReportedViewController.h"
#import <ZYSideSlipFilterController.h>
#import <ZYSideSlipFilterRegionModel.h>
#import <SideSlipBaseTableViewCell.h>
#import "SideSlipCommonTableViewCell.h"
#import "SideSlipSearchTableViewCell.h"
#import "YSReportedTableViewCell.h"
#import "CommonItemModel.h"
#import "AddressModel.h"
#import "YSReportedInfoViewController.h"
#import "YSReporetModel.h"
#import "YSTrackingPageViewController.h"
#import "YSReportedNewAddViewController.h"//添加报备/评估
#import "YSReportedEditTableViewCell.h"
#import "YSRepotedDetailRecordNoViewController.h"//有备案号的详情
#import "YSRetoredModifyGViewController.h"//修改页面

@interface YSReportedViewController ()<UISearchBarDelegate,  SWTableViewCellDelegate>
@property (nonatomic, strong) ZYSideSlipFilterController *sideSlipFilterController;
@property (nonatomic, strong) NSMutableDictionary *payload;
@property (nonatomic, strong) NSArray *filterArray;
@end

@implementation YSReportedViewController
- (NSMutableDictionary *)payload {
    if (!_payload) {
        _payload = [NSMutableDictionary dictionary];
    }
    return _payload;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"报备/评估";
    //营销报备 去掉新增
//    self.navigationItem.rightBarButtonItem = [QMUINavigationButton barButtonItemWithImage:UIImageMake(@"选项添加") position:QMUINavigationButtonPositionRight target:self action:@selector(clickedAddCRMAction:)];
    @weakify(self);
    [[[NSNotificationCenter defaultCenter] rac_addObserverForName:@"refreshCRMList" object:nil] subscribeNext:^(id x) {
        @strongify(self);
        self.pageNumber = 1;
        [self doNetworking];
    }];
}
- (void)initTableView {
    [super initTableView];
    //接口文档的枚举列表，前面5位是项目阶段，后面的是单据状态
    self.filterArray = @[@"10", @"20", @"30", @"40", @"50", @"10", @"20", @"30", @"60", @"40", @"50"];
    self.pageNumber = 1;
    [self.tableView registerClass:[YSReportedEditTableViewCell class] forCellReuseIdentifier:@"editCellID"];
    [self ys_shouldShowSearchBaraAndScreening];
    [self doNetworking];
}
- (void)doNetworking {
    [QMUITips showLoadingInView:self.view];
    NSString *urlString = [NSString stringWithFormat:@"%@%@/%zd", YSDomain, getPageProReportListApi, self.pageNumber];
    [YSNetManager ys_request_GETWithUrlString:urlString isNeedCache:NO parameters:self.payload successBlock:^(id response) {
        DLog(@"获取项目列表:%@",response);
        [QMUITips hideAllTipsInView:self.view];
        if (self.pageNumber==1) {
            [self.dataSourceArray removeAllObjects];
        }
        [self.dataSourceArray addObjectsFromArray:[YSDataManager getReporedlistData:response]];
        self.tableView.mj_footer.state = [YSDataManager getReporedlistData:response].count < 15 ? MJRefreshStateNoMoreData : MJRefreshStateIdle;
        [self ys_reloadData];
        [self.tableView.mj_header endRefreshing];
    } failureBlock:^(NSError *error) {
        [self.tableView.mj_footer endRefreshing];
        [QMUITips hideAllToastInView:self.view animated:NO];
        DLog(@"error:%@", error);
    } progress:nil];
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSourceArray.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 84*kHeightScale;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    //.@"editCellID"
    YSReporetModel *model = self.dataSourceArray[indexPath.row];
//只有创建人为自己的时候 才有侧滑权限
    if ([[YSUtility getUID] isEqualToString:model.creator]) {
        YSReportedEditTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"editCellID" forIndexPath:indexPath];
        cell.delegate = self;
        if ([model.flowStatus isEqualToString:@"10"]) {
            // 未提交 有删除跟修改的按钮
            cell.rightUtilityButtons = [self loadRightBtnArrayWith:2];
        }else if ([model.flowStatus isEqualToString:@"30"] || [model.flowStatus isEqualToString:@"40"] || [model.flowStatus isEqualToString:@"60"]) {
            // 输入中(30)/驳回(40)/已审核(60) 修改的按钮
            cell.rightUtilityButtons = [self loadRightBtnArrayWith:1];
        }else{
            cell.rightUtilityButtons = nil;
        }
        [cell setReporedData:model];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
 
    YSReportedTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell == nil) {
        cell = [[YSReportedTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    [cell setReporedData:model];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (NSArray *)loadRightBtnArrayWith:(int)number {
    NSMutableArray *rightUtilityButtons = [NSMutableArray new];
    [rightUtilityButtons sw_addUtilityButtonWithColor:
     [UIColor colorWithHexString:@"#F5A623"] title:@"修改"];
    if (number == 2) {
        [rightUtilityButtons sw_addUtilityButtonWithColor:
         [UIColor colorWithHexString:@"#F73035"] title:@"删除"];
    }
    
    return rightUtilityButtons;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    YSReporetModel *model = self.dataSourceArray[indexPath.row];
    if ([model.bizStatusStr isEqualToString:@"备案阶段"]||[model.bizStatusStr isEqualToString:@"评估阶段"]) {
        YSAssessmentInfoModel *modelInfo = model.proAssessmentInfo;
        if (modelInfo && [modelInfo.assessmentResult isEqualToString:@"1"]) {
            YSTrackingPageViewController *reportedViewController = [[YSTrackingPageViewController alloc]init];
            reportedViewController.id  = model.id;;
            [self.navigationController pushViewController:reportedViewController animated:YES];
        }else {
            if ([YSUtility judgeIsEmpty:model.proAssessmentInfo.recordNo]) {
                // 无备案号
                YSReportedInfoViewController *reportedViewController = [[YSReportedInfoViewController alloc]init];
                
                reportedViewController.id  = model.id;;
                [self.navigationController pushViewController:reportedViewController animated:YES];
            }else {
                // 有备案号
                YSRepotedDetailRecordNoViewController *infoPageVC = [YSRepotedDetailRecordNoViewController new];
                infoPageVC.billid = model.id;
                [self.navigationController pushViewController:infoPageVC animated:YES];
            }
        }
    }else {
        YSTrackingPageViewController *reportedViewController = [[YSTrackingPageViewController alloc]init];
        
        reportedViewController.id  = model.id;;
        [self.navigationController pushViewController:reportedViewController animated:YES];
    }
    
}
#pragma mark--新增报备/评估
- (void)clickedAddCRMAction:(QMUINavigationButton*)sender {
    YSReportedNewAddViewController *addVC = [YSReportedNewAddViewController new];
    [self.navigationController pushViewController:addVC animated:YES];
}

#pragma mark--SWTableViewDelegate
- (void)swipeableTableViewCell:(SWTableViewCell *)cell didTriggerRightUtilityButtonWithIndex:(NSInteger)index {
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    YSReporetModel *model = self.dataSourceArray[indexPath.row];
    
    if ([model.flowStatus isEqualToString:@"30"] || [model.flowStatus isEqualToString:@"40"] || [model.flowStatus isEqualToString:@"60"]) {
        // 输入/驳回/已审批 只有一个修改按钮
        if ([YSUtility judgeIsEmpty:model.proAssessmentInfo.recordNo]) {
            //无备案号
            YSRetoredModifyGViewController *modeifyVC = [YSRetoredModifyGViewController new];
            modeifyVC.id = model.id;
            [self.navigationController pushViewController:modeifyVC animated:YES];
            
        }else {
            // 有备案号
            YSRepotedDetailRecordNoViewController *infoPageVC = [YSRepotedDetailRecordNoViewController new];
            infoPageVC.billid = model.id;
            infoPageVC.isEdit = YES;
            [self.navigationController pushViewController:infoPageVC animated:YES];
        }

    }else if ([model.flowStatus isEqualToString:@"10"]){
        // 未提交 有删除跟修改的按钮
        switch (index) {
            case 0:
                {//修改
                    if ([YSUtility judgeIsEmpty:model.proAssessmentInfo.recordNo]) {
                        //无备案号
                        YSRetoredModifyGViewController *modeifyVC = [YSRetoredModifyGViewController new];
                        modeifyVC.id = model.id;
                        [self.navigationController pushViewController:modeifyVC animated:YES];
                        
                    }else {
                        // 有备案号
                        YSRepotedDetailRecordNoViewController *infoPageVC = [YSRepotedDetailRecordNoViewController new];
                        infoPageVC.billid = model.id;
                        infoPageVC.isEdit = YES;
                        [self.navigationController pushViewController:infoPageVC animated:YES];
                    }
                }
                break;
            case 1:
            {//删除
                QMUIAlertController *alertVC = [QMUIAlertController alertControllerWithTitle:@"" message:[NSString stringWithFormat:@"您确定删除-%@吗?", model.projectName] preferredStyle:(QMUIAlertControllerStyleActionSheet)];
                QMUIAlertAction *action1 = [QMUIAlertAction actionWithTitle:@"确认删除" style:(QMUIAlertActionStyleDefault) handler:^(QMUIAlertAction *action) {
                    [QMUITips showLoadingInView:self.view];
                    [YSNetManager ys_request_GETWithUrlString:[NSString stringWithFormat:@"%@%@/%@", YSDomain, delProReport, model.id] isNeedCache:NO parameters:nil successBlock:^(id response) {
                        DLog(@"评估列表删除:%@", response);
                        [QMUITips hideAllToastInView:self.view animated:NO];
                        if (1 == [[response objectForKey:@"code"] integerValue]) {
                            [self.dataSourceArray removeObject:model];
                            [self.tableView reloadData];
                        }else {
                            [QMUITips showError:[response objectForKey:@"msg"] inView:self.view hideAfterDelay:1.5];
                        }
                    } failureBlock:^(NSError *error) {
                        [QMUITips hideAllToastInView:self.view animated:NO];
                    } progress:nil];
                }];
                QMUIAlertAction *action2 = [QMUIAlertAction actionWithTitle:@"取消" style:(QMUIAlertActionStyleCancel) handler:^(QMUIAlertAction *action) {
                    
                }];
                action1.buttonAttributes = @{NSForegroundColorAttributeName:[UIColor colorWithHexString:@"#FF5257"], NSFontAttributeName:[UIFont fontWithName:@"PingFangSC-Medium" size:Multiply(16)]};
                action2.buttonAttributes = @{NSForegroundColorAttributeName:[UIColor colorWithHexString:@"#666F83"], NSFontAttributeName:[UIFont fontWithName:@"PingFangSC-Medium" size:Multiply(18)]};
                [alertVC addAction:action1];
                [alertVC addAction:action2];
                [alertVC showWithAnimated:YES];
                
            }
                break;
            default:
                break;
        }
    }
    // 点过按钮之后 侧滑按钮没有回去
    [self.tableView reloadData];
}
#pragma mark 搜索右侧按钮点击事件
/** 监控筛选按钮 */
- (void)monitorFiltButton {
    DLog(@"可以获取到筛选条件");
    YSWeak;
    if (!_sideSlipFilterController) {
        _sideSlipFilterController = [[ZYSideSlipFilterController alloc] initWithSponsor:self resetBlock:^(NSArray *dataList) {
            for (ZYSideSlipFilterRegionModel *model in dataList) {
                for (CommonItemModel *itemModel in model.itemList) {
                    [itemModel setSelected:NO];
                }
                model.selectedItemList = nil;
            }
            [weakSelf.payload removeAllObjects];
            [weakSelf doNetworking];
        } commitBlock:^(NSArray *dataList) {
            [weakSelf.payload removeAllObjects];
            for (ZYSideSlipFilterRegionModel *model in dataList) {
                for (CommonItemModel *commonItemModel in model.selectedItemList) {
                    switch ([dataList indexOfObject:model]) {
                        case 0:
                        {
                            NSString *str = weakSelf.payload[@"bizStatusStr"];
                            NSInteger index = [commonItemModel.itemId integerValue];
                            NSString *filterString = weakSelf.filterArray[index];
                            if (!str.length) {
                                str = [NSString stringWithFormat:@"%@",filterString];
                            }else{
                                str = [NSString stringWithFormat:@"%@,%@",str,filterString];
                            }
                            [weakSelf.payload setObject:str forKey:@"bizStatusStr"];
                            break;
                        }
                        case 1:
                        {
                            NSString *str = weakSelf.payload[@"flowStatusStr"];
                            NSInteger index = [commonItemModel.itemId integerValue];
                            NSString *filterString = weakSelf.filterArray[index];
                            if (!str.length) {
                                str = [NSString stringWithFormat:@"%@",filterString];
                            }else{
                                str = [NSString stringWithFormat:@"%@,%@",str,filterString];
                            }
                            [weakSelf.payload setObject:str forKey:@"flowStatusStr"];
                            break;
                        }
                    }
                }
            }
            [weakSelf.sideSlipFilterController dismiss];
            [weakSelf.tableView.mj_header beginRefreshing];
            [weakSelf doNetworking];
        }];
        _sideSlipFilterController.animationDuration = .3f;
        _sideSlipFilterController.sideSlipLeading = 0.15*kSCREEN_WIDTH;
        _sideSlipFilterController.dataList = [self packageDataList];
        [_sideSlipFilterController.navigationController setNavigationBarHidden:NO];
        
    }
    [_sideSlipFilterController show];
}
/** 设置ZYSideSlipFilterController的数据源 */
- (NSArray *)packageDataList {
    NSMutableArray *dataArray = [NSMutableArray array];
    [dataArray addObject:[self commonFilterRegionModelWithKeyword:@"项目阶段" index:0 selectionType:BrandTableViewCellSelectionTypeMultiple]];
    [dataArray addObject:[self commonFilterRegionModelWithKeyword:@"单据状态" index:1 selectionType:BrandTableViewCellSelectionTypeMultiple]];

    return [dataArray mutableCopy];
}

- (ZYSideSlipFilterRegionModel *)commonFilterRegionModelWithKeyword:(NSString *)keyword index:(NSInteger)index selectionType:(CommonTableViewCellSelectionType)selectionType {
    ZYSideSlipFilterRegionModel *model = [[ZYSideSlipFilterRegionModel alloc] init];
    model.containerCellClass = @"SideSlipCommonTableViewCell";
    model.regionTitle = keyword;
    model.customDict = @{REGION_SELECTION_TYPE:@(selectionType)};
    switch (index) {
        case 0:
        {
            model.itemList = @[[self createItemModelWithTitle:@"备案阶段" itemId:@"0" selected:NO],
                               [self createItemModelWithTitle:@"评估阶段" itemId:@"1" selected:NO],
                               [self createItemModelWithTitle:@"报名资审" itemId:@"2" selected:NO],
                               [self createItemModelWithTitle:@"投标阶段" itemId:@"3" selected:NO],
                               [self createItemModelWithTitle:@"结束阶段" itemId:@"4" selected:NO]
                               ];
            
            break;
        }
        case 1:
        {
            model.itemList = @[[self createItemModelWithTitle:@"未提交" itemId:@"5" selected:NO],
                               [self createItemModelWithTitle:@"审批中" itemId:@"6" selected:NO],
                               [self createItemModelWithTitle:@"输入中" itemId:@"7" selected:NO],
                               [self createItemModelWithTitle:@"已审批" itemId:@"8" selected:NO],
                               [self createItemModelWithTitle:@"驳回" itemId:@"9" selected:NO],
                               [self createItemModelWithTitle:@"终止" itemId:@"10" selected:NO]
                               ];
            break;
        }
    }
    return model;
}

- (ZYSideSlipFilterRegionModel *)searchFilterRegionModel:(NSString *)title {
    ZYSideSlipFilterRegionModel *model = [[ZYSideSlipFilterRegionModel alloc] init];
    model.containerCellClass = @"SideSlipSearchTableViewCell";
    model.regionTitle = title;
    return model;
}

- (CommonItemModel *)createItemModelWithTitle:(NSString *)itemTitle itemId:(NSString *)itemId selected:(BOOL)selected {
    CommonItemModel *model = [[CommonItemModel alloc] init];
    model.addressType = 4;
    model.itemId = itemId;
    model.itemName = itemTitle;
    model.selected = selected;
    return model;
}

#pragma mark - searchBar 代理方法
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    [self.payload setObject:searchText forKey:@"projectName"];
    [self doNetworking];
}
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [self.view endEditing:YES]; //实现该方法是需要注意view需要是继承UIControl而来的
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
