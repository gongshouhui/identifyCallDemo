//
//  YSFlowTenderIsChooseViewController.h
//  YaSha-iOS
//
//  Created by YaSha_Tom on 2017/11/23.
//

#import "YSCommonListViewController.h"

typedef enum : NSUInteger {
    middleMark = 10,
    unMiddleMark = 20,
} YSFlowTenderType;

@interface YSFlowTenderIsChooseViewController : YSCommonListViewController

@property (nonatomic, strong) NSString *titleName;
@property (nonatomic, assign) YSFlowTenderType  flowTenderType;
@property (nonatomic, strong) NSString *id;


@end
