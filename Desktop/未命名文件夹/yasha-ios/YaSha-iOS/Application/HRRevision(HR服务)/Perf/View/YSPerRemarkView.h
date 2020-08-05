//
//  YSPerRemarkView.h
//  YaSha-iOS
//
//  Created by YaSha_Tom on 2017/10/25.
//

#import <UIKit/UIKit.h>
#import "YSPerfInfoModel.h"

@interface YSPerRemarkView : UIView

@property (nonatomic, strong) QMUITextView *textView;
@property (nonatomic, assign) int perfInfoType;
@property (nonatomic, strong) YSPerfInfoModel *cellModel;

- (void)setViewModel:(YSPerfInfoModel *)model;

@end
