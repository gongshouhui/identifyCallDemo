//
//  YSInformationViewController.h
//  YaSha-iOS
//
//  Created by mHome on 2016/11/29.
//  Copyright © 2016年 方鹏俊. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YSInternalModel.h"
#import "YSInternalPeopleModel.h"
#import "YSSelfNVCView.h"

@interface YSInformationViewController : UIViewController

@property (nonatomic ,strong) NSString *str ;
@property (nonatomic ,strong) NSString *source;
@property (nonatomic,assign) int number;
@property (nonatomic,assign) BOOL rightBarButtonItemFlag;
@property (nonatomic,strong) NSString *id;
@property (nonatomic,strong) YSInternalModel *dataModel;
@property (nonatomic,strong) YSInternalPeopleModel *peopleModel;

@end
