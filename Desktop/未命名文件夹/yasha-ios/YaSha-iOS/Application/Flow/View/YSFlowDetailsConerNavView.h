//
//  YSFlowDetailsConerNavView.h
//  YaSha-iOS
//
//  Created by YaSha_Tom on 2018/7/30.
//  Copyright © 2018年 亚厦装饰股份有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YSFlowDetailsConerNavView : UIView
//流程标题
@property (nonatomic,strong) UILabel *titleLabel;
//返回按钮
@property (nonatomic,strong) UIButton *backButton;
//关联流程的按钮
@property (nonatomic,strong) UIButton *flowButton;
//关联文档的按钮
@property (nonatomic,strong) UIButton *documentButton;
//流程视图的按钮
@property (nonatomic,strong) UIButton *chartButton;
//申请表单
@property (nonatomic,strong) UIButton *formButton;
//附言记录
@property (nonatomic,strong) UIButton *postscriptButton;
//审批记录
@property (nonatomic,strong) UIButton *approveButton;
//转阅记录
@property (nonatomic,strong) UIButton *turnButton;

- (void)setPositioning:(NSInteger )index;
@end
