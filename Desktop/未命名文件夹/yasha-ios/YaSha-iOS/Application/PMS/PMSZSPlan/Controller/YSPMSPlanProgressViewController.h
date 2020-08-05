//
//  YSPMSPlanProgressViewController.h
//  YaSha-iOS
//
//  Created by YaSha_Tom on 2017/10/16.
//

#import "YSCommonListViewController.h"
typedef void(^refreshPlanInfoBlock)();
@interface YSPMSPlanProgressViewController : YSCommonListViewController

@property (nonatomic, strong) NSString *code;
@property (nonatomic, strong) NSString *id;
@property (nonatomic, copy) refreshPlanInfoBlock refreshBlock;
@end
