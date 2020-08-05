//
//  YSCRMYXAddTableViewCell.h
//  YaSha-iOS
//
//  Created by GZl on 2019/5/21.
//  Copyright © 2019 亚厦装饰股份有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YSCRMYXBaseModel.h"
@class YSCRMYXAddTableViewCell;

@protocol CRMYXTextFieldDelegate <NSObject>

- (void)textField:(UITextField*_Nonnull)textField inputTextFieldChangeModel:(YSCRMYXBaseModel*_Nullable)model;

@end

NS_ASSUME_NONNULL_BEGIN

@interface YSCRMYXAddTableViewCell : UITableViewCell
@property (nonatomic, strong) UIButton *accessoryBtn;//右侧按钮
@property (nonatomic, strong) UISwitch *accessorySwitch;

@property (nonatomic, strong) UITextField *rightTF;
@property (nonatomic, strong) UILabel *hiddenLab;//暂时用labe 多的话就改成textView
@property (nonatomic, strong) UILabel *leftLab;


// 营销/报备新增
@property (nonatomic, strong) YSCRMYXBaseModel *addModel;
@property (nonatomic,weak) id <CRMYXTextFieldDelegate> delegate;

// 营销/报备修改页面
@property (nonatomic, strong) YSCRMYXBaseModel *editModel;

// 异常申诉界面
@property (nonatomic, strong) YSCRMYXBaseModel *complaintFlowModel;

//修正流程
@property (nonatomic, strong) YSCRMYXBaseModel *modifyModel;

// 待删除
@property (nonatomic, strong) YSCRMYXBaseModel *workProveModel;
@property (nonatomic, strong) YSCRMYXBaseModel *passModel;

@end

NS_ASSUME_NONNULL_END
