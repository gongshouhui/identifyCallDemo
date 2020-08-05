//
//  YSReasonViewController.h
//  YaSha-iOS
//
//  Created by mHome on 2017/7/5.
//
//

#import "YSCommonViewController.h"
#import "YSMyOpinion.h"

@interface YSReasonViewController : YSCommonViewController

@property (nonatomic, strong) NSString *eventId;
@property (nonatomic, strong) NSString *type;
@property (nonatomic, strong) YSMyOpinion *myOpinion;

@property (nonatomic, copy) void(^ReturnBlock)(BOOL reload);

@end
