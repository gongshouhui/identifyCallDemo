//
//  YSContactDetailHeaderView.h
//  YaSha-iOS
//
//  Created by 方鹏俊 on 2018/1/8.
//  Copyright © 2018年 亚厦装饰股份有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YSContactModel.h"
#import "YSContactDetailViewController.h"

@interface YSContactDetailHeaderView : UIView

@property (nonatomic, strong) YSContactModel *contactModel;
@property (nonatomic, strong) UIButton *avatarButton;
@property (nonatomic, strong) RACSubject *sendActionSubject;

- (void)setContactModel:(YSContactModel *)contactModel contactDetailType:(YSContactDetailType)contactDetailType;

@end
