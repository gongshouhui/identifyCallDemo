//
//  YSAddressBookHelper.h
//  YaSha-iOS
//
//  Created by mHome on 2017/6/30.
//
//

#import <Foundation/Foundation.h>

enum : NSUInteger {
     ABHelperCanNotConncetToAddressBook,
     ABHelperExistSpecificContact,
     ABHelperNotExistSpecificContact
} ;

typedef NSUInteger ABHelperCheckExistResultType;

@interface YSAddressBookHelper : NSObject


// 添加联系人
// name 　　　　-> 联系人姓名
// phoneNum    -> 电话号码
// label　　　　-> 电话号码的标签备注
+ (BOOL)addContactName:(NSString*)name phoneNum:(NSString*)num withLabel:(NSString*)label;

// 查询指定号码是否已存在于通讯录
// 返回值：
//　　ABHelperCanNotConncetToAddressBook -> 连接通讯录失败（iOS6之后访问通讯录需要用户许可）
//　　ABHelperExistSpecificContact　　　　-> 号码已存在
//　　ABHelperNotExistSpecificContact　　-> 号码不存在
+ (ABHelperCheckExistResultType)existPhone:(NSString*)phoneNum;

@end
