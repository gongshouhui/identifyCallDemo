//
//  YSPMSPlanTimeChooseView.h
//  YaSha-iOS
//
//  Created by YaSha_Tom on 2017/10/11.
//

#import <UIKit/UIKit.h>
//#import "YSPMSPlanTimeChooseView.h"

@interface YSPMSPlanTimeChooseView : UIView<UIPickerViewDataSource,UIPickerViewDelegate>

@property (nonatomic, copy)NSArray*bigArr;
@property (nonatomic, copy)NSString *Taketime;
@property (nonatomic, copy) NSString *timeStr;
@property (nonatomic, copy) UILabel *timeLabel;
@property (nonatomic, assign) id delegate;

@end
@protocol YSPMSPlanTimeChooseViewDelegate <NSObject>

@optional //@optional和@required 关键字用来告诉别人这个方法是可选还是必须要实现的
-(void)hisPickerView:(YSPMSPlanTimeChooseView*)alertView;

@end
