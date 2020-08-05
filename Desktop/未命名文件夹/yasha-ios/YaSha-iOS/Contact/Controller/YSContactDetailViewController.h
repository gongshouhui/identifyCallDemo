//
//  YSContactDetailViewController.h
//  YaSha-iOS
//
//  Created by 方鹏俊 on 2018/1/8.
//  Copyright © 2018年 亚厦装饰股份有限公司. All rights reserved.
//

#import "YSCommonTableViewController.h"
#import "YSContactModel.h"

typedef enum : NSUInteger {
    /** 来自内部通讯录 */
    YSContactDetailInner,
    /** 来自外部通讯录 */
    YSContactDetailOuter,
    /** 来自手机通讯录 */
    YSContactDetailAddress,
    /** 来自常用通讯录 */
    YSContactDetailCommon,
} YSContactDetailType;

@interface YSContactDetailViewController : YSCommonTableViewController

@property (nonatomic, strong) YSContactModel *contactModel;
@property (nonatomic, assign) YSContactDetailType contactDetailType;

@end
