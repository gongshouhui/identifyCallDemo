//
//  YSCommonBussinessFlowInfoController.h
//  YaSha-iOS
//
//  Created by 罗罗诺亚索隆 on 2019/3/4.
//  Copyright © 2019 亚厦装饰股份有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YSFlowFormModel.h"
#import "YSFlowDetailsHeaderView.h"
#import "YSFlowDetailsConerNavView.h"
#import "YSFlowRecordListCell.h"
#import "LCSelectMenuView.h"
#import "YSFlowFormHeaderView.h"
#import "YSFlowFormBottomView.h"
#import "YSBaseBussinessFlowViewModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface YSCommonBussinessFlowInfoController : UIViewController
@property (nonatomic,strong)  YSBaseBussinessFlowViewModel *viewModel;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) YSFlowFormHeaderView *flowFormHeaderView;
@property (nonatomic, strong) YSFlowFormBottomView *flowFormBottomView;
@property (nonatomic,strong) YSFlowDetailsHeaderView *functionHeaderView;
//滑动时覆盖在导航栏位置的视图
@property (nonatomic,strong) YSFlowDetailsConerNavView *coverNavView;
/**选择菜单栏*/
@property (nonatomic,strong) LCSelectMenuView *selectMenu;
@property (nonatomic,strong) UIView *navView;
@property (nonatomic, assign) YSFlowType flowType;    // 待办类型
@property (nonatomic, strong) YSFlowListModel *flowModel;

//查看附言更多
@property (nonatomic,assign) BOOL postscriptSeeMore;
/**转阅记录查看更多按钮是否点击*/
@property (nonatomic,assign) BOOL turnSeeMore;
- (instancetype)initWithFlowType:(YSFlowType)type andFlowInfo:(YSFlowListModel *)flowModel;
- (void)doNetworking;
- (void)monitorAction;
- (void)markSectionHeaderLocation;
@end

NS_ASSUME_NONNULL_END
