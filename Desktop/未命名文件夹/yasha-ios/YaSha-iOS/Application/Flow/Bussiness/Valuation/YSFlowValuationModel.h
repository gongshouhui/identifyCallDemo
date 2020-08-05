//
//  YSFlowValuationModel.h
//  YaSha-iOS
//
//  Created by 罗罗诺亚索隆 on 2019/5/5.
//  Copyright © 2019 亚厦装饰股份有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
@interface YSFlowSoftUpdateModel : NSObject
/**"[{\"roperate\":\"delete\",\"demandTypeCode\":\"QDSJ\",\"demandTypeName\":\"清单升级\",\"upgradeContent\":\"11\",\"nodeNumber\":\"11\"}]"*/
@property (nonatomic,strong) NSArray *updatesJson;
@property (nonatomic,strong) NSArray *useMsgJson;
@property (nonatomic,strong) NSString *brandName;
@property (nonatomic,strong) NSString *softwareTypeStr;
@property (nonatomic,strong) NSString *version;
@property (nonatomic,strong) NSString *proModelStr;
@property (nonatomic,strong) NSString *serviceStr;
@property (nonatomic,strong) NSString *professionsJsonName;
@property (nonatomic,strong) NSString *remark;
@property (nonatomic,strong) NSString *lockNumber;
@property (nonatomic,assign) CGFloat purchMoney;
@property (nonatomic,strong) NSString *handleType;
@property (nonatomic,assign) NSInteger nodeNumber;
@property (nonatomic,strong) NSString *handleTypeStr;
@property (nonatomic,strong) NSString *purchaseType;
@property (nonatomic,strong) NSString *id;
@end
@interface YSFlowValuationModel : NSObject
@property (nonatomic,strong) NSString *applyMan;
@property (nonatomic,strong) NSString *applyType;
/**判断节点*/
@property (nonatomic,strong) NSString *activityName;
@property (nonatomic,assign) BOOL ifEditData;
@property (nonatomic,strong) NSString *receptionMan;
@property (nonatomic,strong) NSString *applyCompany;
@property (nonatomic,strong) NSString *applyDept;
@property (nonatomic,strong) NSString *applyTypeStr;
@property (nonatomic,assign) BOOL ifCompanyArea;
@property (nonatomic,assign) BOOL ifAssetsManager;
@property (nonatomic,assign) BOOL ifProjectUse;
@property (nonatomic,strong) NSString *accountManager;
@property (nonatomic,strong) NSString *ownProject;
@property (nonatomic,strong) NSString *applyReason;
@property (nonatomic,strong) NSString *useTimeStr;
@property (nonatomic,assign) CGFloat predictMoney;

@property (nonatomic,strong) NSString *belongCost;
@property (nonatomic,strong) NSString *receiver;
@property (nonatomic,strong) NSString *receiverPhone;
@property (nonatomic,strong) NSString *address;
@property (nonatomic,strong) NSMutableArray *valuationApplyInfos;
@property (nonatomic,strong) NSMutableArray *valuationSJApplyInfos;
@property (nonatomic,strong) NSMutableArray *valuationXGApplyInfos;
@property (nonatomic,strong) NSString *id;
@property (nonatomic,strong) NSString *purchaseType;


@end

NS_ASSUME_NONNULL_END
