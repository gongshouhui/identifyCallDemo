//
//  YSHRMTDeptTreeModel.h
//  YaSha-iOS
//
//  Created by GZl on 2019/4/11.
//  Copyright © 2019 亚厦装饰股份有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
@class LeaderModel;
NS_ASSUME_NONNULL_BEGIN

@interface YSHRMTDeptTreeModel : NSObject

@property (nonatomic, copy) NSString *id;//自己的id
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *pid;//父类id
@property (nonatomic, copy) NSString *postNumber;
@property (nonatomic, strong) LeaderModel *leader;
@property (nonatomic, strong) NSArray *children;//子部门
@property (nonatomic, strong) NSArray *companyChildren;//同级部门

@end

@interface LeaderModel : NSObject

@property (nonatomic, copy) NSString *no;//工号
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *userImgUrl;
@property (nonatomic, copy) NSString *userPost;//职级
@property (nonatomic, copy) NSString *jobStation;
@property (nonatomic, copy) NSString *companyId;
@property (nonatomic, copy) NSString *companyName;
@property (nonatomic, copy) NSString *deptId;
@property (nonatomic, copy) NSString *deptName;




@end

NS_ASSUME_NONNULL_END
