//
//  YSComplaintViewController.h
//  YaSha-iOS
//
//  Created by mHome on 2017/4/21.
//
//

#import <UIKit/UIKit.h>
#import "YSAttendanceModel.h"

@interface YSComplaintViewController : UIViewController

@property (nonatomic,assign)  NSInteger pageIndex;
@property (nonatomic,strong) NSString *type;
@property (nonatomic,strong) YSAttendanceModel *model;

@end
