//
//  YSMQInfoModel.h
//  YaSha-iOS
//
//  Created by 罗罗诺亚索隆 on 2018/8/22.
//  Copyright © 2018年 亚厦装饰股份有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
@interface YSMQInfoModel : NSObject
/**项目名字*/
@property (nonatomic,strong) NSString *name;
@property (nonatomic,strong) NSString *projectName;
/**项目编码*/
@property (nonatomic,strong) NSString *code;
@property (nonatomic,strong) NSString *province;
@property (nonatomic,strong) NSString *city;
@property (nonatomic,strong) NSString *area;
@property (nonatomic,strong) NSString *address;
/**项目条线*/
@property (nonatomic,strong) NSString *itemLineName;
/**所属公司*/
@property (nonatomic,strong) NSString *companyName;
/**项目所属年份*/
@property (nonatomic,strong) NSString *belongTime;
/**项目性质*/
@property (nonatomic,strong) NSString *proNatureName;
/**币种*/
@property (nonatomic,strong) NSString *contCurrency;
/**合同价格*/
@property (nonatomic,assign) CGFloat contPrice;
/**项目经理*/
@property (nonatomic,strong) NSString *proManName;
/**所属部门*/
@property (nonatomic,strong) NSString *baseInfoDept;

/**所属部门*/
@property (nonatomic,strong) NSString *deptStr;
/**工期*/
@property (nonatomic,strong) NSString *timeLimit;
/**计税方式*/
@property (nonatomic,strong) NSString *taxWayName;
/**施工状态*/
@property (nonatomic,strong) NSString *proStatusName;
/**结算状态*/
@property (nonatomic,strong) NSString *balanceStatus;
/**维保状态*/
@property (nonatomic,strong) NSString *maintenanceStatus;
/**收款状态*/
@property (nonatomic,strong) NSString *gatherStatus;


/**合同形式*/
@property (nonatomic,strong) NSString *contForm;
/**是否公建*/
@property (nonatomic,assign) NSInteger isPublic;
/**质量目标*/
@property (nonatomic,strong) NSString *qtarget;
/**合同计划开工*/
@property (nonatomic,strong) NSString *planStart;
/**合同计划竣工*/
@property (nonatomic,strong) NSString *planEnd;
/**保修期限*/
@property (nonatomic,strong) NSString *repairStr;
/**保险时间*/
@property (nonatomic,strong) NSString *proInsDate;
/**甲方单位*/
@property (nonatomic,strong) NSString *firstUnit;
/**施工范围*/
@property (nonatomic,strong) NSString *conScope;
/**合同分段工期描述*/
@property (nonatomic,strong) NSString *sectionDurationDescription;
/**合同奖励条款*/
@property (nonatomic,strong) NSString *awardClause;
/**合同处罚条款*/
@property (nonatomic,strong) NSString *penaltyClause;
/**合同付款条款*/
@property (nonatomic,strong) NSString *contractPaymentTerms;
/**合同类型*/
@property (nonatomic,strong) NSString *contFormName;
/**NC编码*/
@property (nonatomic,strong) NSString *ncCode;
/**是否归入决收部*/
@property (nonatomic,strong) NSString *isNeverAcceptDept;
/** 所属区域*/
@property (nonatomic,strong) NSString *region;
@property (nonatomic,strong) NSString *regionStr;
@end
