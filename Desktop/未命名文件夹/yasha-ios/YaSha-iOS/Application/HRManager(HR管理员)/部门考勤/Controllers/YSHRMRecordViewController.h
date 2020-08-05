//
//  YSHRMRecordViewController.h
//  YaSha-iOS
//
//  Created by GZl on 2019/4/8.
//  Copyright © 2019 亚厦装饰股份有限公司. All rights reserved.
//

#import "YSCommonViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface YSHRMRecordViewController : YSCommonViewController
@property (nonatomic, copy) NSString *deptId;
@property (nonatomic, copy) NSString *deptNameStr;
// 搜索界面需要使用的月份值
@property (nonatomic, copy) NSString *searchDateStr;



@end

NS_ASSUME_NONNULL_END
