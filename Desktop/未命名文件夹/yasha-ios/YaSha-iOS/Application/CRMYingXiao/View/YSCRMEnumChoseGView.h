//
//  YSCRMEnumChoseGView.h
//  YaSha-iOS
//
//  Created by GZl on 2019/6/4.
//  Copyright © 2019 亚厦装饰股份有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YSCRMYXBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, YSCRMEnumChoseGViewType) {
    YSCRMEnumChoseGViewType1,//默认的 显示的是name
    YSCRMEnumChoseGViewType2,// 显示的是 projectName
};

@interface YSCRMEnumChoseGView : UIView
@property (nonatomic, strong) UIButton *cancelBtn;
@property (nonatomic, strong) UIButton *confirmBtn;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) PGPickerView *pickerView;
@property(nonatomic,copy) void (^choseEnumBlock)(YSCRMYXGEnumModel *model);
@property (nonatomic, assign) YSCRMEnumChoseGViewType type;


@end

NS_ASSUME_NONNULL_END
