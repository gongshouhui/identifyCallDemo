//
//  YSEMSExpenseDetailModel.h
//  YaSha-iOS
//
//  Created by 罗罗诺亚索隆 on 2018/9/6.
//  Copyright © 2018年 亚厦装饰股份有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YSEMSExpenseDetailModel : NSObject
/**申请金额*/
@property (nonatomic,assign) CGFloat applyMoney;
/**申请金额（付款申请）*/
@property (nonatomic,assign) CGFloat paymentMoney;
/**申请金额（冲账申请金额）*/
@property (nonatomic,assign) CGFloat offsetMoney;
/**申请金额（备用金申请金额）*/
@property (nonatomic,assign) CGFloat loanMoney;


/**审核数量*/
@property (nonatomic,assign) NSInteger auditedCount;
/**已冲账金额*/
@property (nonatomic,assign) CGFloat offsetVerificationMoney;
/**已付款金额，（付款申请）*/
@property (nonatomic,assign) CGFloat paidVerificationMoney;
/**已付款金额，（已冲账）*/
@property (nonatomic,assign) CGFloat offsettedVerificationMoney;

/**待审核数量*/
@property (nonatomic,assign) NSInteger unauditedCount;
/**待付款金额，（付款申请）*/
@property (nonatomic,assign) CGFloat unpaidVerificationMoney;
/**待付款金额，（待冲账）*/
@property (nonatomic,assign) CGFloat unpaidMoney;

/**未提交数量*/
@property (nonatomic,assign) NSInteger unsubmittedCount;
/**核定金额*/
@property (nonatomic,assign) CGFloat verificationMoney;

/**超出还款期*/
@property (nonatomic,assign) CGFloat totalAmount;
/**超出还款期*/
@property (nonatomic,assign) CGFloat overdueAmount;

/**还款期内*/
@property (nonatomic,assign) CGFloat loanAmount;
@end
