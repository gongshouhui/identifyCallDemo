//
//  YSFlowFormHeaderView.h
//  YaSha-iOS
//
//  Created by 方鹏俊 on 2017/10/27.
//

#import <UIKit/UIKit.h>
#import "YSFlowFormModel.h"

@interface YSFlowFormHeaderView : UIView

@property (nonatomic, strong) YSFlowFormHeaderModel *headerModel;
@property (nonatomic, strong) UIButton *actionButton;
@property (nonatomic, strong) UILabel *lineLabel;
- (void)hiddenActionButton;
@end
