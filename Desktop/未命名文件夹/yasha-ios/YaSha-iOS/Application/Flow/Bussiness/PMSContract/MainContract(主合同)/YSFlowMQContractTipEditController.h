//
//  YSFlowMQContractTipEditController.h
//  YaSha-iOS
//
//  Created by 罗罗诺亚索隆 on 2019/3/25.
//  Copyright © 2019 亚厦装饰股份有限公司. All rights reserved.
//

#import "YSCommonViewController.h"

NS_ASSUME_NONNULL_BEGIN
typedef void(^EditSuccessBlock)(NSString *editContent);
@interface YSFlowMQContractTipEditController : YSCommonViewController
@property (nonatomic,strong) NSString *content;
@property (nonatomic,strong) NSString *contractId;
/**修改类型(管理合同1，备案合同2，考核协议3，主合同其他)*/
@property (nonatomic,strong) NSString *opt;
@property (nonatomic,strong) EditSuccessBlock editBlock;
@end

NS_ASSUME_NONNULL_END
