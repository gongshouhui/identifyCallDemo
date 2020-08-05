//
//  HisDatePicer.h
//  FWatch
//
//  Created by mac003-20130924 on 16/6/22.
//  Copyright © 2016年 newMac002. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HisDatePicer.h"
@interface HisDatePicer : UIView<UIPickerViewDataSource,UIPickerViewDelegate>
@property (nonatomic, copy)NSArray*bigArr;
@property (nonatomic, copy)NSString *Taketime;
@property (nonatomic, copy) NSString *timeStr;
@property (nonatomic, copy) UILabel *timeLabel;
@property (nonatomic, assign) id delegate;


@end
@protocol HisPickerViewDelegate <NSObject>

@optional //@optional和@required 关键字用来告诉别人这个方法是可选还是必须要实现的
-(void)hisPickerView:(HisDatePicer*)alertView;

@end
