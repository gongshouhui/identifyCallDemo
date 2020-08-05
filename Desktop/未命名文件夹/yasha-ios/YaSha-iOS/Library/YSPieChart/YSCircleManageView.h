//
//  YSCircleManageView.h
//  YaSha-iOS
//
//  Created by YaSha_Tom on 2017/11/4.
//

#import <UIKit/UIKit.h>
#import "YSCircleView.h"

@interface YSCircleManageView : UIView

-(instancetype)initWithFrame:(CGRect)frame;
-(void)loadDataArray:(NSArray *)dataArray withType:(MYHCircleManageViewType)type;

@end
