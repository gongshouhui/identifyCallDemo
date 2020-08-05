//
//  YSFlowDetailsHeaderView.h
//  YaSha-iOS
//
//  Created by YaSha_Tom on 2018/7/30.
//  Copyright © 2018年 亚厦装饰股份有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YSFlowFormModel.h"


@interface YSFlowDetailsHeaderView : UIView
//关联流程的按钮
@property (nonatomic,strong) UIButton *flowButton;
//关联文档的按钮
@property (nonatomic,strong) UIButton *documentButton;
//流程视图的按钮
@property (nonatomic,strong) UIButton *chartButton;

@property (nonatomic, strong) YSFlowFormHeaderModel *headerModel;

@end
