//
//  YSACLModel.h
//  YaSha-iOS
//
//  Created by 方鹏俊 on 2018/1/18.
//Copyright © 2018年 亚厦装饰股份有限公司. All rights reserved.
//

#import <Realm/Realm.h>

@interface YSACLModel : RLMObject

@property NSString *systemSn;
@property NSInteger permissionValue;
@property NSString *moduleSn;
@property NSString *permissionName;
@property NSString *companyId;
@end

// This protocol enables typed collections. i.e.:
// RLMArray<YSACLModel *><YSACLModel>
RLM_ARRAY_TYPE(YSACLModel)
