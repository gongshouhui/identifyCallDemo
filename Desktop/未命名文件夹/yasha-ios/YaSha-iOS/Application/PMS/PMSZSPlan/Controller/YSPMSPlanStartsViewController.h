//
//  YSPMSPlanStartsViewController.h
//  YaSha-iOS
//
//  Created by YaSha_Tom on 2017/10/16.
//

#import "YSCommonListViewController.h"

@interface YSPMSPlanStartsViewController : YSCommonListViewController

@property (nonatomic, strong) NSString *type;
@property (nonatomic, strong) NSString *titleName;
@property (nonatomic, strong) NSString *code;
@property (nonatomic, strong) NSString *proManagerId;

@property (nonatomic, copy) void(^refreshPlanInfoBlock)();

@end
