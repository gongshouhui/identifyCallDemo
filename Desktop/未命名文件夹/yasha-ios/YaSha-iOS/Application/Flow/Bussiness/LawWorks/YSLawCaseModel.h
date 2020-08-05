//
//  YSLawCaseModel.h
//  YaSha-iOS
//
//  Created by 罗罗诺亚索隆 on 2019/3/7.
//  Copyright © 2019 亚厦装饰股份有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface YSLawCaseModel : NSObject
@property (nonatomic,strong) NSArray *lawsuitDeptList;
/**并行节点的时候当前节点号*/
@property (nonatomic,assign) NSInteger nodeNow;
/**原告方*/
@property (nonatomic,strong) NSString *prosecutionPerson;
@property (nonatomic,strong) NSString *defense;
@property (nonatomic,strong) NSString *thirdPerson;
@property (nonatomic,strong) NSString *trialStr;
@property (nonatomic,strong) NSString *litigationTypeStr;
@property (nonatomic,strong) NSString *causeNo;
@property (nonatomic,strong) NSString *court;
@property (nonatomic,strong) NSString *caseExplan;
@property (nonatomic,strong) NSString *causeOfAction;

@property (nonatomic,strong) NSString *courtDate;
@property (nonatomic,strong) NSString *buessyType;
@property (nonatomic,strong) NSString *buessyTypeStr;;
@property (nonatomic,strong) NSString *natureCaseStr;
@property (nonatomic,strong) NSString *decorateType;
@property (nonatomic,strong) NSString *decorateTypeStr;
@property (nonatomic,strong) NSString *electricalTypeStr;
@property (nonatomic,strong) NSString *curtainTypeStr;
@property (nonatomic,strong) NSString *explainOther;
@property (nonatomic,strong) NSString *lawsuitPerson;
@property (nonatomic,strong) NSString *phone;
@property (nonatomic,strong) NSString *contact;
@property (nonatomic,strong) NSString *operatorPhone;

@property (nonatomic,strong) NSString *involvedDept;
@property (nonatomic,assign) double principal;
@property (nonatomic,assign) double interest;
@property (nonatomic,assign) double penalSum;
@property (nonatomic,assign) double otherAmount;
@property (nonatomic,assign) double acceptAmount;
@property (nonatomic,assign) double totalAmount;
@property (nonatomic,assign) BOOL  freeze;
@property (nonatomic,assign) double freezeAmount;
@property (nonatomic,strong) NSString *projectName;
@property (nonatomic,strong) NSString *proStartDate;
@property (nonatomic,strong) NSString *proEndDate;
@property (nonatomic,strong) NSString *manager;
@property (nonatomic,assign) double contractAmount;
/**提交资料部门负责人 可编辑*/
@property (nonatomic,assign) BOOL lawsuitEdit;
/**诉讼承办人 可编辑*/
@property (nonatomic,assign) BOOL operatorEdit;
@end

NS_ASSUME_NONNULL_END
