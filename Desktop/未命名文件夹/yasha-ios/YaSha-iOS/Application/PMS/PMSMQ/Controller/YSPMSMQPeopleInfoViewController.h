//
//  YSPMSMQPeopleInfoViewController.h
//  YaSha-iOS
//
//  Created by YaSha_Tom on 2018/1/29.
//  Copyright © 2018年 亚厦装饰股份有限公司. All rights reserved.
//

#import "YSCommonListViewController.h"

@interface YSPMSMQPeopleInfoViewController : YSCommonListViewController
/**0:项目人员 1： 只能人员*/
@property (nonatomic,assign) NSInteger type;
@property (nonatomic, strong) NSString *projectId;

@end
