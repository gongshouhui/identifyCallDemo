//
//  YSCommonFlowFormListViewController.h
//  YaSha-iOS
//
//  Created by 方鹏俊 on 2017/11/3.
//

#import "YSCommonViewController.h"
#import "YSFlowListModel.h"
#import "YSFlowFormHeaderView.h"
#import "YSFlowFormBottomView.h"
#import "YSFlowFormSectionHeaderView.h"
#import "YSFlowFormListCell.h"
#import "YSFlowHandleViewController.h"
//老版业务表单详情页基类
@interface YSCommonFlowFormListViewController : YSCommonViewController

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) YSFlowFormHeaderView *flowFormHeaderView;
@property (nonatomic, strong) YSFlowFormBottomView *flowFormBottomView;

@property (nonatomic, assign) YSFlowType flowType;    // 待办类型
@property (nonatomic, strong) YSFlowListModel *cellModel;

@property (nonatomic, strong) NSArray *attachArray;    // 附件列表
@property (nonatomic, strong) NSArray *subformArray;    // 附件列表

- (void)doNetworking;
- (void)monitorAction;


extern NSString *const cellIdentifier;

@end
