//
//  YSPerfInfoViewController.h
//  YaSha-iOS
//
//  Created by 方鹏俊 on 2017/10/18.
//

#import "YSCommonViewController.h"
#import "YSPerfListViewController.h"
#import "YSPerfListModel.h"
#import "YSPerfEvaluaListModel.h"

typedef enum : NSUInteger {
    PerfNormalInfoType,
    PerfSelfEvaluaInfoType,
    PerfReEvaluaInfoType,
    PerfExamInfoType,
} PerfInfoType;

@interface YSPerfInfoViewController : YSCommonViewController

@property (nonatomic, assign) PerfInfoType perfInfoType;

@property (nonatomic, strong) YSPerfListModel *cellModel;
@property (nonatomic, assign) PerfType perfType;
@property (nonatomic, strong) NSString *year;
@property (nonatomic, strong) YSPerfEvaluaListModel *evaluaListModel;

/** 计划审核退回/生效回调 */
@property (nonatomic, copy) void(^ReturnBlock)(YSPerfEvaluaListModel *evaluaListModel);

@end
