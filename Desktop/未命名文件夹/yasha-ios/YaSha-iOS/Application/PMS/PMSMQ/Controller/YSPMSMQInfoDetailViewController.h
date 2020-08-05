//
//  YSPMSMQInfoDetailViewController.h
//  YaSha-iOS
//
//  Created by 方鹏俊 on 2017/12/13.
//  Copyright © 2017年 亚厦装饰股份有限公司. All rights reserved.
//

#import "YSCommonTableViewController.h"
#import "YSMQInfoModel.h"
@interface YSPMSMQInfoDetailViewController : YSCommonTableViewController

@property (nonatomic, strong) NSString *projectId;
@property (nonatomic,strong) YSMQInfoModel *infoModel;

@end
