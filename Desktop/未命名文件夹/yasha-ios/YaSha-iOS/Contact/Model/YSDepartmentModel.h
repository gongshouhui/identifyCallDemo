//
//  YSDepartmentModel.h
//  YaSha-iOS
//
//  Created by YaSha_Tom on 2018/4/14.
//  Copyright © 2018年 亚厦装饰股份有限公司. All rights reserved.
//

#import <Realm/Realm.h>

@interface YSDepartmentModel : RLMObject
@property NSString *showContact;//是否显示部门下面人的联系方式1显示0不显示，null显示
@property NSString *companyId;
@property NSString *createTime;
@property NSString *creator;
@property NSString *delFlag;
@property NSString *id;
@property NSString *isPublic;
@property NSString *name;
@property NSString *num;
@property NSString *pNum;
@property NSString *pid;
@property NSInteger sortNo;// 排序号
@property NSString *status;
@property NSString *syn;
@property NSString *synTime;
@property NSString *type;
@property NSString *updateTime;
@property NSString *updator;
@property BOOL isSelected;

@end
