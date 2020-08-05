//
//  YSNewsPageController.h
//  YaSha-iOS
//
//  Created by 方鹏俊 on 2017/9/29.
//

#import <WMPageController/WMPageController.h>
#import "YSCommonPageController.h"
typedef void(^refreshFunctionBlock)();
@interface YSNewsPageController : YSCommonPageController
@property (nonatomic,strong) refreshFunctionBlock refreshBlock;
@end
