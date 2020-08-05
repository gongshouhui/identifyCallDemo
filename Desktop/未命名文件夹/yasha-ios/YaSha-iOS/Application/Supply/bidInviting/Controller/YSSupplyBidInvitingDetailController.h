//
//  YSSupplyBidInvitingDetailController.h
//  YaSha-iOS
//
//  Created by 龚守辉 on 2018/1/2.
//  Copyright © 2018年 亚厦装饰股份有限公司. All rights reserved.
//

#import "YSCommonPageController.h"

@interface YSSupplyBidInvitingDetailController : YSCommonPageController
@property (nonatomic,strong) NSString *bidID;
@property (nonatomic,assign) BidFlowType type;
@end
