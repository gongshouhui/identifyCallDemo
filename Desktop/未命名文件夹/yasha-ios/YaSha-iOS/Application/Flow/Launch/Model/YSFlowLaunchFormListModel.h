//
//  YSFlowLaunchFormListModel.h
//  YaSha-iOS
//
//  Created by 方鹏俊 on 2017/12/26.
//  Copyright © 2017年 亚厦装饰股份有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@class YSFlowLaunchFormListHeaderModel;

@interface YSFlowLaunchFormListModel : NSObject

@property (nonatomic, strong) YSFlowLaunchFormListHeaderModel *extendProcdef;

@end

@interface YSFlowLaunchFormListHeaderModel : NSObject

@property (nonatomic, strong) NSString *ownDeptName;
@property (nonatomic, strong) NSString *processDockingName;

@end

