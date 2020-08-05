//
//  YSFlowPMSContractInfoViewModel.h
//  YaSha-iOS
//
//  Created by 罗罗诺亚索隆 on 2019/3/21.
//  Copyright © 2019 亚厦装饰股份有限公司. All rights reserved.
//

#import "YSBaseBussinessFlowViewModel.h"

NS_ASSUME_NONNULL_BEGIN
typedef NS_ENUM(NSInteger, MQFlowContractType) {
    MQFlowContractMain,//施工主合同
    MQFlowContractConstruction,//幕墙合同管理
    MQFlowContractAssessment,//施工考核协议
    MQFlowContractRecord,//备案合同
};//四个合同大类  ，每个合同大类都有补充协议，即八个流程，每个流程又分为评审l阶段流程和盖章阶段流程，即总共16个了流程
@interface YSFlowPMSContractInfoViewModel : YSBaseBussinessFlowViewModel
/**可编辑字段,用于view层kvo监听刷新数据*/
@property (nonatomic,strong) NSString *reviewRemark;
- (void)turnOtherViewControllerWith:(UIViewController *)viewController andIndexPath:(NSIndexPath *)indexPath;
@end

NS_ASSUME_NONNULL_END
