//
//  YSFLowMQContractInfoModel.h
//  YaSha-iOS
//
//  Created by 罗罗诺亚索隆 on 2019/3/21.
//  Copyright © 2019 亚厦装饰股份有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef NS_ENUM(NSInteger, MQContractType) {
    MQContractTypeMain = 10,//施工主合同
    MQContractTypeSupplementaAgreement = 20,//施工主合同补充协议
    MQContractTypeRecords = 30,//备案合同
    MQContractTypeRecordsAgreement = 40,//备案合同补充协议
};
NS_ASSUME_NONNULL_BEGIN
@interface YSSubContractInfoModel : NSObject
@property (nonatomic,assign) MQContractType contractType;
/**评审阶段（10 评审,20 盖章）*/
@property (nonatomic,assign) NSInteger reviewStatus;
@property (nonatomic,strong) NSString *masterContractCode;
@property (nonatomic,strong) NSString *contractName;

@property (nonatomic,strong) NSString *sideLetterCode;
@property (nonatomic,strong) NSString *sideLetterName;
@property (nonatomic,assign) CGFloat contPrice;
@property (nonatomic,assign) NSInteger contractDuration;
@property (nonatomic,strong) NSString *address;
@property (nonatomic,strong) NSString *signedUnit;
@property (nonatomic,strong) NSString *signedContact;
@property (nonatomic,strong) NSString *signedUnitContact;
@property (nonatomic,strong) NSString *abnormalPayment;
@property (nonatomic,strong) NSString *advance;
@property (nonatomic,strong) NSString *ensureBackletter;
@property (nonatomic,strong) NSString *ensureCash;
@property (nonatomic,strong) NSString *paymentDescription;
@property (nonatomic,strong) NSString *qualityRequirements;
@property (nonatomic,strong) NSArray *sealMaterialsForMobile;
@end

@interface YSFLowMQContractManagementModel : NSObject
@property (nonatomic,strong) NSString *undertakerName;
@property (nonatomic,strong) NSString *contractPm;
@property (nonatomic,strong) NSString *sealName;
@property (nonatomic,strong) NSString *remark;
@property (nonatomic,strong) NSArray *crmdFileListForMobile;
@property (nonatomic,strong) NSArray *contentList;
@property (nonatomic,strong) NSString *reviewRemark;
@property (nonatomic,strong) NSString *contractId;
@end
//幕墙管理合同
@interface YSFLowMQContractSupervisionModel : NSObject
@property (nonatomic,strong) NSString *projectName;
@property (nonatomic,strong) NSString *executiveManagerName;
@property (nonatomic,strong) NSString *proNature;
@property (nonatomic,strong) NSString *masterContractNo;
@property (nonatomic,strong) NSString *contractNo;
@property (nonatomic,strong) NSString *contractName;
@property (nonatomic,strong) NSString *contractTypeStr;
@property (nonatomic,strong) NSString *signedUnit;
@property (nonatomic,strong) NSString *sideLetterCode;
@property (nonatomic,strong) NSString *sideLetterName;
@property (nonatomic,strong) NSString *signedState;
@property (nonatomic,assign) CGFloat contPrice;
@property (nonatomic,strong) NSString *payment;
@property (nonatomic,strong) NSString *contractMatterInfo;
@property (nonatomic,strong) NSString *remark;
@property (nonatomic,strong) NSArray *filePszlListForMobile;
@property (nonatomic,strong) NSArray *fileQtzlListForMobile;
@property (nonatomic,strong) NSArray *fileQtzlList;;
@property (nonatomic,strong) NSString *reviewRemark;
@property (nonatomic,strong) NSString *contractId;
@end
//幕墙施工考核协议
@interface YSFLowMQContractCheckDeal : NSObject
@property (nonatomic,strong) NSString *projectName;
@property (nonatomic,strong) NSString *executiveManagerName;
@property (nonatomic,strong) NSString *proNature;
@property (nonatomic,strong) NSString *masterContractNo;
@property (nonatomic,strong) NSString *contractNo;
@property (nonatomic,strong) NSString *contractName;
@property (nonatomic,strong) NSString *contractTypeStr;
@property (nonatomic,strong) NSString *signedUnit;
@property (nonatomic,strong) NSString *sideLetterCode;
@property (nonatomic,strong) NSString *sideLetterName;
@property (nonatomic,strong) NSString *signedState;
@property (nonatomic,strong) NSString *checkDutyPersonName;
@property (nonatomic,strong) NSString *checkDutyPersonContact;
@property (nonatomic,assign) CGFloat masterContractPrice;
@property (nonatomic,assign) CGFloat netManagementRate;
@property (nonatomic,assign) CGFloat contPrice;
@property (nonatomic,strong) NSString *payment;
@property (nonatomic,strong) NSString *contractMatterInfo;
@property (nonatomic,strong) NSString *remark;
@property (nonatomic,strong) NSArray *filePszlListForMobile;
@property (nonatomic,strong) NSArray *fileQtzlListForMobile;
@property (nonatomic,strong) NSArray *fileQtzlList;;
@property (nonatomic,strong) NSString *reviewRemark;
@property (nonatomic,strong) NSString *contractId;
@property (nonatomic,strong) NSString *buildingSide;
@property (nonatomic,strong) NSString *contractStartDate;
@property (nonatomic,strong) NSString *contractEndDate;
@property (nonatomic,assign) NSInteger contractLimit;
@property (nonatomic,strong) NSString *mainContractSettleManner;
@property (nonatomic,strong) NSString *filingContractSettleManner;

@end
@interface YSFLowMQCheckPayInfo : NSObject
/**垫资或借款提交人*/
@property (nonatomic,strong) NSString *creator;
/**垫资或借款提交日期*/
@property (nonatomic,strong) NSString *createTime;
@property (nonatomic,strong) NSString *contractId;
@property (nonatomic,strong) NSString *updator;
@property (nonatomic,strong) NSString *updateTime;
@property (nonatomic,strong) NSString *delFlag;
/**垫资或借款说明*/
@property (nonatomic,strong) NSString *content;

@end


@interface YSFLowMQContractInfoModel : NSObject
@property (nonatomic,strong) YSSubContractInfoModel *contractInfo;
@property (nonatomic,strong) YSFLowMQContractManagementModel *contractManagement;
@property (nonatomic,strong) YSFLowMQContractSupervisionModel *contractSupervision;
@property (nonatomic,strong) YSFLowMQContractCheckDeal *contractCheckDeal;
/**暂用考核协议 类 作为备案合同的的model*/
@property (nonatomic,strong) YSFLowMQContractCheckDeal *contractFiling;
@property (nonatomic,assign) BOOL isPersonelEdit;
@property (nonatomic,strong) NSArray *reviewContentList;
@property (nonatomic,strong) NSArray *contractSealMaterial;
@property (nonatomic,strong) NSArray *psFileListForMobile;
@property (nonatomic,strong) NSArray *qtzlFileListForMobile;
/**支付信息*/
@property (nonatomic,strong) NSArray *contractLoaningList;
@end

NS_ASSUME_NONNULL_END
