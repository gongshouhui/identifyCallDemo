//
//  YSPhoneAddressBookModel.h
//  YaSha-iOS
//
//  Created by mHome on 2016/11/28.
//  Copyright © 2016年 方鹏俊. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YSPhoneAddressBookModel : NSObject

@property (nonatomic  ,copy) NSString *name;

@property (nonatomic ,copy) NSString *tel;

@property (nonatomic ,assign) int recordID;

@end
