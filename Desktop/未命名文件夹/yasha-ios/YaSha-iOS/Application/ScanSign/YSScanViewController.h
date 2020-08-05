//
//  YSScanViewController.h
//  YaSha-iOS
//
//  Created by 罗罗诺亚索隆 on 2019/12/11.
//  Copyright © 2019 亚厦装饰股份有限公司. All rights reserved.
//

#import "YSCommonViewController.h"

NS_ASSUME_NONNULL_BEGIN
typedef void(^ScanBlock)(NSString *message);
@interface YSScanViewController : YSCommonViewController
@property (nonatomic,copy) ScanBlock scanBlock;
@end

NS_ASSUME_NONNULL_END
