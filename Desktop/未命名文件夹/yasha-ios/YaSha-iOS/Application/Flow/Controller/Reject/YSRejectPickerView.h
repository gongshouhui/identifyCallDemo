//
//  YSRejectPickerView.h
//  YaSha-iOS
//
//  Created by 罗罗诺亚索隆 on 2018/8/27.
//  Copyright © 2018年 亚厦装饰股份有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YSRejectNodeModel.h"
typedef void(^SelectedComplete)(YSRejectNodeModel *model);
@interface YSRejectPickerView : UIView
@property (nonatomic,copy) SelectedComplete selectComplete;
@property (nonatomic,strong) UILabel *titleLabel;
@property (nonatomic,strong) NSArray *dataArray;
- (void)showPickerViewOnWindowAnimated:(BOOL)animated selectComplete:(SelectedComplete)completeBlock;
- (void)closePickerViewAnimated:(BOOL)animated;
@end
