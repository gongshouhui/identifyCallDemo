//
//  YSFlowPageController.h
//  YaSha-iOS
//
//  Created by 方鹏俊 on 2017/10/27.
//

#import "YSCommonPageController.h"
typedef void(^RefreshFunctionBlock)();
@interface YSFlowPageController : YSCommonPageController
@property (nonatomic,copy) RefreshFunctionBlock refreshBlock;
@end
