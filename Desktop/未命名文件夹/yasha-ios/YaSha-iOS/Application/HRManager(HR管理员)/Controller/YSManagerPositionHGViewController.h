//
//  YSManagerPositionHGViewController.h
//  YaSha-iOS
//
//  Created by GZl on 2019/3/27.
//  Copyright © 2019 亚厦装饰股份有限公司. All rights reserved.
//

#import "YSManagerHRBaseViewController.h"

typedef NS_ENUM(NSInteger, PositionVCType) {
    PositionVCTypeEntry,//入职
    PositionVCTypeLeave,//离职
};

NS_ASSUME_NONNULL_BEGIN

@interface YSManagerPositionHGViewController : YSManagerHRBaseViewController
@property (nonatomic, assign) PositionVCType positionType;
@property (nonatomic, copy) NSString *deptIds;
@property (nonatomic, copy) NSString *deptName;

@end

NS_ASSUME_NONNULL_END
