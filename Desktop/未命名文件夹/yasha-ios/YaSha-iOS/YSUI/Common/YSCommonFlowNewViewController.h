//
//  YSCommonFlowNewViewController.h
//  YaSha-iOS
//
//  Created by YaSha_Tom on 2018/8/3.
//  Copyright © 2018年 亚厦装饰股份有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YSFlowListModel.h"
#import "YSFlowFormHeaderView.h"
#import "YSFlowFormBottomView.h"
#import "YSFlowFormSectionHeaderView.h"
#import "YSFlowFormListCell.h"
#import "YSFlowHandleViewController.h"
//新版自定义表单详情页
@interface YSCommonFlowNewViewController : UIViewController

@property (nonatomic, strong) YSFlowFormHeaderView *flowFormHeaderView;//流程头部视图
@property (nonatomic, strong) YSFlowFormBottomView *flowFormBottomView;//流程底部操作视图
@property (nonatomic, assign) YSFlowType flowType;    // 待办类型
@property (nonatomic, strong) YSFlowListModel *cellModel; //流程列表model

@property (nonatomic, strong) NSArray *attachArray;    // 附件列表
@property (nonatomic, strong) NSArray *subformArray;    // 附件列表

- (void)doNetworking;
- (void)monitorAction;

@end
