//
//  YSBussinessMaterialModel.h
//  YaSha-iOS
//
//  Created by 罗罗诺亚索隆 on 2019/2/19.
//  Copyright © 2019 亚厦装饰股份有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface YSBussinessMaterialModel : NSObject
/**项目编号*/
@property (nonatomic,strong) NSString *proCode;
/**项目名字*/
@property (nonatomic,strong) NSString *proName;
/**材料需求编号*/
@property (nonatomic,strong) NSString *code;
/**项目经理名字*/
@property (nonatomic,strong) NSString *managerName;
/**材料类型*/
@property (nonatomic,strong) NSString *mtrlTypeStr;
/**三级类别*/
@property (nonatomic,strong) NSString *threeTypeName;
/**是否甲供材*/
@property (nonatomic,assign) BOOL isSupply;

/**需求类别*/
@property (nonatomic,strong) NSString *requireTypeStr;

/**补料原因*/
@property (nonatomic,strong) NSString *feedReason;
/**收货人*/
@property (nonatomic,strong) NSString *receiverName;

/**收货人Mobile*/
@property (nonatomic,strong) NSString *receiverMobile;

@property (nonatomic,strong) NSString *province;
@property (nonatomic,strong) NSString *city;
@property (nonatomic,strong) NSString *area;
@property (nonatomic,strong) NSString *address;
/**备注*/
@property (nonatomic,strong) NSString *remark;


@end

NS_ASSUME_NONNULL_END
