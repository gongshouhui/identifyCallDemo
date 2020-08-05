//
//  YSHRJobsInfoController.h
//  YaSha-iOS
//
//  Created by YaSha_Tom on 2019/1/9.
//  Copyright © 2019年 亚厦装饰股份有限公司. All rights reserved.
//

#import "YSCommonListViewController.h"
#import "YSPersonalInformationModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface YSHRJobsInfoController : YSCommonListViewController
@property (nonatomic,strong) YSPersonalInformationModel *profileModel;
@property (nonatomic,strong) NSArray *modelArr;
@end

NS_ASSUME_NONNULL_END
