//
//  YSSupplyBidDetailModel.h
//  YaSha-iOS
//
//  Created by 龚守辉 on 2018/1/8.
//  Copyright © 2018年 亚厦装饰股份有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YSNewsAttachmentModel.h"
@interface YSSupplyBidDetailModel : NSObject
/**招标材料*/
@property (nonatomic, strong) NSString *bidMtrl;
/**业务阶段*/
@property (nonatomic, strong) NSString *flowTypeStr;
/**业务阶段*/
@property (nonatomic, assign) BidFlowType flowType; //1:拟邀标  2:招标议价/合同盖章
/**招标编号*/
@property (nonatomic, strong) NSString *code;
/**项目名称*/
@property (nonatomic, strong) NSString *proName;
/**审批状态*/
@property (nonatomic, strong) NSString *auditStatusStr;
/**编辑时间*/
@property (nonatomic,strong) NSString *createTime;
/**编制人*/
@property (nonatomic, strong) NSString *creatorText;
/**项目地址*/
@property (nonatomic, strong) NSString *addressStr;
/**附件*/
@property (nonatomic,strong) NSArray *mobileFiles;
/**合同附件*/
@property (nonatomic,strong) NSArray *mobileFilesList;
/**全品合同附件*/
@property (nonatomic,strong) NSArray *mobileFilesQpList;

@property (nonatomic, strong) NSString *creator;
/**招标ID*/
@property (nonatomic, strong) NSString *id;
/**备注*/
@property (nonatomic, strong) NSString *remark;
//@property (nonatomic, strong) NSString *city;
/**项目经理*/
@property (nonatomic, strong) NSString *proManagerName;

@property (nonatomic, assign) NSInteger pmoney;

@property (nonatomic, strong) NSString *flowId;
/**工程造价*/
@property (nonatomic, strong) NSString *pmoneyStr;
@property (nonatomic, strong) NSString *payRemark;
/**是否重点项目*/
@property (nonatomic, strong) NSString *isKeyStr;
/**项目名称*/
@property (nonatomic, strong) NSString *proNameStr;

@property (nonatomic, strong) NSString *proManagerId;

@property (nonatomic, strong) NSString *province;

@property (nonatomic, strong) NSString *pcurrency;

/**采购模式*/
@property (nonatomic, strong) NSString *modelStr;

@property (nonatomic, strong) NSArray *franInfoInBaseList;

@property (nonatomic, strong) NSString *sessionId;

@property (nonatomic, assign) NSInteger isKey;
/**项目性质*/
@property (nonatomic, strong) NSString *managerModel;
@property (nonatomic, strong) NSString *contractCount;//合同盖章份数
/**全品是否盖章*/
@property (nonatomic,strong) NSString *useSealUnit;
@property (nonatomic, strong) NSString *contractType;//合同类型




//@property (nonatomic, strong) NSString *updator;
//
//@property (nonatomic, strong) NSString *cityCode;
//
//@property (nonatomic, strong) NSString *address;
//
//@property (nonatomic, strong) NSString *proCode;
//
//@property (nonatomic, strong) NSArray *bidFranList;
//
//
//@property (nonatomic, strong) NSString *areaCode;
//
//@property (nonatomic, assign) NSInteger delFlag;
//
//@property (nonatomic, strong) NSString *area;

//@property (nonatomic, strong) NSArray *bidFileList;
//
//@property (nonatomic, strong) NSString *proId;
//
//@property (nonatomic, assign) NSInteger priceBatch;
//
//@property (nonatomic, strong) NSString *provinceCode;
//
//@property (nonatomic, assign) NSInteger isBid;
//
//@property (nonatomic, assign) NSInteger updateTime;
//
//@property (nonatomic, strong) NSArray *franInfoSelectedList;
//
//@property (nonatomic, assign) NSInteger model;
//
//@property (nonatomic, assign) NSInteger auditStatus;
//

@end

