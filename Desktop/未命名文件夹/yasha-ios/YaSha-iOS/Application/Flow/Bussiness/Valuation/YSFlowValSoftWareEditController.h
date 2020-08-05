//
//  YSFlowValSoftWareEditController.h
//  YaSha-iOS
//
//  Created by 罗罗诺亚索隆 on 2019/4/26.
//  Copyright © 2019 亚厦装饰股份有限公司. All rights reserved.
//

#import "YSCommonTableViewController.h"
#import "YSFlowValuationModel.h"
#import "YSFlowValuationViewModel.h"
NS_ASSUME_NONNULL_BEGIN
typedef void(^EditSuccessBlock)(NSString *handleType,CGFloat purchMoney,NSString *lockNumber);
@interface YSFlowValSoftWareEditController : YSCommonTableViewController
@property (nonatomic,assign) ValuationEditType editType;
@property (nonatomic,strong) NSString *formId;
@property (nonatomic,strong) YSFlowSoftUpdateModel *softwareModel;
@property (nonatomic,strong) EditSuccessBlock editValuationSuccessBlock;
@end

NS_ASSUME_NONNULL_END
