//
//  YSPerfInfoSubView.h
//  YaSha-iOS
//
//  Created by 方鹏俊 on 2017/10/18.
//

#import <UIKit/UIKit.h>
#import "YSPerfInfoViewController.h"
#import "YSPerfInfoModel.h"

@interface YSPerfInfoSubView : UIView

@property (nonatomic, strong) RACSubject *sendIndexSubject;
@property (nonatomic, assign) NSInteger index;
@property (nonatomic, assign) PerfInfoType perfInfoType;
@property (nonatomic, strong) YSPerfInfoModel *cellModel;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) QMUIButton *evaluaButton;

@end
