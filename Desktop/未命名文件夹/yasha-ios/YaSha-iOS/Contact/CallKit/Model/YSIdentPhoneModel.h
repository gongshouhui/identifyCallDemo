//
//  YSIdentPhoneModel.h
//  YaSha-iOS
//
//  Created by 方鹏俊 on 2017/11/27.
//
//

#import <Realm/Realm.h>

@interface YSIdentPhoneModel : RLMObject

@property NSString *name;
@property NSInteger phone;

@end

// This protocol enables typed collections. i.e.:
// RLMArray<YSIdentPhoneModel *><YSIdentPhoneModel>
RLM_ARRAY_TYPE(YSIdentPhoneModel)
