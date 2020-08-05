//
//  YSPMSMQEarlyPreTaskController.m
//  YaSha-iOS
//
//  Created by 罗罗诺亚索隆 on 2018/10/23.
//  Copyright © 2018年 亚厦装饰股份有限公司. All rights reserved.
//

#import "YSPMSMQEarlyPreTaskController.h"
#import "YSPMSPlanStartsViewCell.h"
#import "YSPMSMQPlanDetailsViewController.h"
#import "YSPMSMQPlanAddPhotoViewController.h"
#import "YSPMSPlanListModel.h"
#import "QMUIPopupMenuView.h"
#import <QMUIKit.h>
#import "YSPMSMQEarlyPreHandleController.h"
#import "YSPMSMQEarlyPreTaskDetailController.h"
typedef NS_ENUM(NSUInteger, YSTaskType) {
    YSTaskTypeAll = 1,   //全部
    YSTaskTypeMine = 2   //我的
    
};

@interface YSPMSMQEarlyPreTaskController ()<SWTableViewCellDelegate,UISearchBarDelegate,UISearchControllerDelegate>
@property (nonatomic, strong) NSMutableDictionary *payload;
@property(nonatomic,assign)YSTaskType taskType;
@property(nonatomic,strong)QMUIPopupMenuView *rightPopupMenuView;
@end

@implementation YSPMSMQEarlyPreTaskController

- (QMUIPopupMenuView *)rightPopupMenuView
{
    if (!_rightPopupMenuView) {
        
        _rightPopupMenuView = [[QMUIPopupMenuView alloc] init];
        _rightPopupMenuView.automaticallyHidesWhenUserTap = YES;
        _rightPopupMenuView.maskViewBackgroundColor = UIColorMaskWhite;
        _rightPopupMenuView.maximumWidth = 120*kWidthScale;
        _rightPopupMenuView.shouldShowItemSeparator = YES;
        _rightPopupMenuView.separatorInset = UIEdgeInsetsMake(0, _rightPopupMenuView.padding.left, 0, _rightPopupMenuView.padding.right);
        YSWeak;//self - > popView  - > block -> self
        _rightPopupMenuView.items = @[
                                      [QMUIPopupMenuItem itemWithImage:nil title:@"我的" handler:^{
                                          weakSelf.pageNumber = 1;
                                          weakSelf.taskType = YSTaskTypeMine;
                                          [weakSelf doNetworking];
                                          [weakSelf.rightPopupMenuView hideWithAnimated:YES];
                                      }],
                                      [QMUIPopupMenuItem itemWithImage:nil title:@"全部" handler:^{
                                          weakSelf.pageNumber = 1;
                                          weakSelf.taskType = YSTaskTypeAll;
                                          [weakSelf doNetworking];
                                          [weakSelf.rightPopupMenuView hideWithAnimated:YES];
                                      }]
                                      ];
        
        _rightPopupMenuView.didHideBlock = ^(BOOL hidesByUserTap) {
            
        };
    }
    return _rightPopupMenuView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = self.titleName;
    self.taskType = YSTaskTypeAll; //默认是全部
    //导航栏按钮
    self.navigationItem.rightBarButtonItem = [QMUINavigationButton barButtonItemWithType:QMUINavigationButtonTypeNormal title:@"筛选" position:QMUINavigationButtonPositionRight target:self action:@selector(rightBarButtonAction:event:)];
}

- (void)viewDidAppear:(BOOL)animated {
    self.pageNumber = 1;
    [self doNetworking];
}

- (void)initTableView {
    [super initTableView];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerClass:[YSPMSPlanStartsViewCell class] forCellReuseIdentifier:@"PlanStartsCell"];
    [self ys_shouldShowSearchBar];
}

- (void)doNetworking {
    
    NSDictionary *payload = @{@"planInfoCode":self.engineeringModel.code,
                              @"keyWord":self.keyWord,
                              };
    [YSNetManager ys_request_GETWithUrlString:[NSString stringWithFormat:@"%@%@/%@/%zd/%zd",YSDomain, getMqPlanPrepareList, self.type,self.taskType, self.pageNumber] isNeedCache:NO parameters:payload successBlock:^(id response) {
        DLog(@"==========%@",response);
        if (self.pageNumber == 1) {
            [self.dataSourceArray removeAllObjects];
        }
        NSMutableArray *mutableArray = [NSMutableArray array];
        for (NSDictionary *dic  in response[@"data"]) {
            [mutableArray addObject:dic];
            [self.dataSourceArray addObject:[YSPMSPlanListModel yy_modelWithJSON:dic]];
        }
        self.tableView.mj_footer.state = mutableArray.count < 15 ? MJRefreshStateNoMoreData : MJRefreshStateIdle;
        [self ys_reloadData];
        [self.tableView.mj_header endRefreshing];
    } failureBlock:^(NSError *error) {
        DLog(@"----------%@",error);
    } progress:nil];
    
}


#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSourceArray.count;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 172;
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    YSPMSPlanStartsViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"PlanStartsCell" forIndexPath:indexPath];
    if (cell == nil) {
        cell = [[YSPMSPlanStartsViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"PlanStartsCell"];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    YSPMSPlanListModel *model = self.dataSourceArray[indexPath.row];
//#if YASHA_DEBUG == 1
//    cell.rightUtilityButtons = [self rightButtons:model.taskStatus];
//    cell.delegate = self;
//#else
//    //滑动操作
//    if (([self.engineeringModel.proManagerId isEqual:[YSUtility getUID]] || [model.mainPersonCode isEqual:[YSUtility getUID]]) && ![model.taskStatus isEqual:@"30"]) {
        cell.rightUtilityButtons = [self rightButtons:model.taskStatus];
        cell.delegate = self;
//    }
//#endif
    
    [cell  setEarlyPreparePlanCellData:model];
    return cell;
}

- (NSArray *)rightButtons:(NSString *)stateStr {
    NSMutableArray *rightUtilityButtons = [NSMutableArray new];
    
    
    if ([stateStr isEqual:@"10"]) {//未开工
        [rightUtilityButtons sw_addUtilityButtonWithColor:[UIColor redColor] title:@"开工"];
    }
    if ([stateStr isEqualToString:@"20"]) {//开工
        [rightUtilityButtons sw_addUtilityButtonWithColor:[UIColor redColor] title:@"跟踪/完工"];
    }
    return rightUtilityButtons;
}
#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    YSPMSMQEarlyPreTaskDetailController *PMSPlanDetailsViewController = [[YSPMSMQEarlyPreTaskDetailController alloc]initWithStyle:UITableViewStyleGrouped];
    YSPMSPlanListModel *model = self.dataSourceArray[indexPath.row];
    PMSPlanDetailsViewController.code = model.id;
    [self.navigationController pushViewController:PMSPlanDetailsViewController animated:YES];
}

#pragma mark - SWTableViewCellDelegate
//左滑点击事件
-(void)swipeableTableViewCell:(SWTableViewCell *)cell didTriggerRightUtilityButtonWithIndex:(NSInteger)index {
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    YSPMSPlanListModel *model = self.dataSourceArray[indexPath.row];
    
    YSPMSMQEarlyPreHandleController *handleVC = [[YSPMSMQEarlyPreHandleController alloc]init];
    [handleVC setRefreshEarlyPreBlock:^{
        [self doNetworking];
    }];
    handleVC.model = model;
    if ([model.taskStatus isEqualToString:@"10"]) {//开工
        handleVC.status = PrePareStatusStart;
        [self.navigationController pushViewController:handleVC animated:YES];
    }else{
        QMUIAlertController *alertVC = [[QMUIAlertController alloc]initWithTitle:nil message:@"请选择跟踪进度或完工！" preferredStyle:(QMUIAlertControllerStyleAlert)];
        [alertVC addAction:[QMUIAlertAction actionWithTitle:@"完工" style:QMUIAlertActionStyleDefault handler:^(QMUIAlertAction *action) {
            handleVC.status = PrePareStatusStartComplete;
            [self.navigationController pushViewController:handleVC animated:YES];
        }]];
        [alertVC addAction:[QMUIAlertAction actionWithTitle:@"跟踪" style:QMUIAlertActionStyleDestructive handler:^(QMUIAlertAction *action) {
            handleVC.status = PrePareStatusStartHold;
            [self.navigationController pushViewController:handleVC animated:YES];
        }]];
        [alertVC showWithAnimated:YES];
        
    }
    
}
#pragma mark - rightBarButtonAction
- (void)rightBarButtonAction:(UIBarButtonItem *)sender event:(UIEvent *) event {
    NSSet *allTouches = [event allTouches];    //返回与当前接收者有关的所有的触摸对象
    UITouch *touch = [allTouches anyObject];   //视图中的所有对象
    CGPoint point = [touch locationInView:touch.window]; //返回触摸点在视图中的当前坐标
    CGRect rect = [touch.view convertRect:touch.view.frame toView:touch.window];
    [self.rightPopupMenuView layoutWithTargetRectInScreenCoordinate:rect];
    [self.rightPopupMenuView showWithAnimated:YES];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
@end
