//
//  YSLawDepartModel.h
//  YaSha-iOS
//
//  Created by 罗罗诺亚索隆 on 2019/3/8.
//  Copyright © 2019 亚厦装饰股份有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface YSLawDepartModel : NSObject
@property (nonatomic,strong) NSString *id;
@property (nonatomic,strong) NSString *receiverName;
@property (nonatomic,strong) NSString *receiverNo;
@property (nonatomic,strong) NSString *receiveData;
@property (nonatomic,strong) NSString *type;
@property (nonatomic,strong) NSString *submitDate;
@property (nonatomic,strong) NSString *planSubmitDate;
@property (nonatomic,strong) NSString *operator;
@property (nonatomic,strong) NSString *operatorPhone;
@property (nonatomic,strong) NSString *lawsuitData;
@property (nonatomic,strong) NSString *remark;
@property (nonatomic,strong) NSString *deptName;
@end

NS_ASSUME_NONNULL_END
