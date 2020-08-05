//
//  YSContactAddressBookModel.h
//  YaSha-iOS
//
//  Created by 方鹏俊 on 2018/1/19.
//Copyright © 2018年 亚厦装饰股份有限公司. All rights reserved.
//

#import <Realm/Realm.h>

@interface YSContactAddressBookModel : RLMObject
/** 联系人姓名*/
@property NSString *name;

@end

// This protocol enables typed collections. i.e.:
// RLMArray<YSContactAddressBookModel *><YSContactAddressBookModel>
RLM_ARRAY_TYPE(YSContactAddressBookModel)
