//
//  YSFlowFormBottomView.h
//  YaSha-iOS
//
//  Created by 方鹏俊 on 2017/10/27.
//

#import <UIKit/UIKit.h>
#import "YSFlowListViewController.h"
#import "YSFlowListModel.h"

@interface YSFlowFormBottomView : UIView
@property (nonatomic, strong) UIButton *handleButton;    // 处理
@property (nonatomic, strong) UIButton *transButton;    // 转阅

@property (nonatomic, strong) YSFlowListModel *cellModel;
@property (nonatomic, strong) RACSubject *sendActionSubject;

- (void)setCellModel:(YSFlowListModel *)cellModel withFlowType:(YSFlowType)flowType;

@end
