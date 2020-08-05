//
//  YSNewsListViewController.h
//  YaSha-iOS
//
//  Created by 方鹏俊 on 2017/10/9.
//

#import "YSCommonListViewController.h"

typedef enum : NSUInteger {
    YSNewsTypeNews,
    YSNewsTypeNotice,
} YSNewsType;
typedef void(^refreshFunctionBlock)();
@interface YSNewsListViewController : YSCommonListViewController

@property (nonatomic, assign) YSNewsType newsType;
/**刷新工作台消息数*/
@property (nonatomic,strong) refreshFunctionBlock refreshBlock;
@end
