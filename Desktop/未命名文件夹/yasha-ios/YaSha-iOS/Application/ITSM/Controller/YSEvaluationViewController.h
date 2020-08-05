//
//  YSEvaluationViewController.h
//  YaSha-iOS
//
//  Created by mHome on 2017/7/5.
//
//

#import "YSCommonViewController.h"
@class YSITSMUntreatedModel;
@class YSMyOpinion;

@interface YSEvaluationViewController : YSCommonViewController

@property (nonatomic, assign) NSInteger index;
@property (nonatomic, strong) YSITSMUntreatedModel *model;
@property (nonatomic, strong) YSMyOpinion *myOpinion;
@property (nonatomic, copy) void(^ReturnBlock)(BOOL reload);

@end
