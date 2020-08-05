//
//  YSHRSelpItem.h
//  YaSha-iOS
//
//  Created by 罗罗诺亚索隆 on 2019/1/23.
//  Copyright © 2019 亚厦装饰股份有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface YSHRSelpItem : NSObject
@property (nonatomic,strong) NSString *name;
/**自定义表单key*/
@property (nonatomic,strong) NSString *modelKey;
/**说明*/
@property (nonatomic,strong) NSString *remark;
@end

NS_ASSUME_NONNULL_END
