//
//  YSPMSHistoryInfoViewController.h
//  YaSha-iOS
//
//  Created by 方鹏俊 on 2017/8/30.
//
//

#import <UIKit/UIKit.h>

@class YSPMSInfoHeaderView;

@interface YSPMSHistoryInfoViewController : UITableViewController

@property(nonatomic,strong)YSPMSInfoHeaderView *infoHeaderView;

@property (nonatomic,strong) NSString *projectId;

@end
