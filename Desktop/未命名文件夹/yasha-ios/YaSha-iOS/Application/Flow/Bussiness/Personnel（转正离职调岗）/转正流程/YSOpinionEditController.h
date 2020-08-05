//
//  YSOpinionEditController.h
//  YaSha-iOS
//
//  Created by 罗罗诺亚索隆 on 2020/1/6.
//  Copyright © 2020 亚厦装饰股份有限公司. All rights reserved.
//

#import "YSCommonTableViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface YSOpinionEditController : YSCommonTableViewController
/**申请人ID*/
@property (nonatomic,strong) NSString *applicantEmployeeCode;
@property (nonatomic,strong) NSString *bussinessId;
/**试用期时间*/
@property (nonatomic,strong) NSString *expectedDate;
/**拟转正时间*/
@property (nonatomic,strong) NSString *initiationTime;
@property (nonatomic,strong) void(^editControllerBlock)(NSString *message);
@end

NS_ASSUME_NONNULL_END
