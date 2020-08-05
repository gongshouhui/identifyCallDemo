//
//  YSCRMChoseCurrencyView.h
//  YaSha-iOS
//
//  Created by GZl on 2019/5/27.
//  Copyright © 2019 亚厦装饰股份有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol YSCRMChoseCurrencyViewDelegate <NSObject>

- (void)didTableViewCellWith:(nullable NSString*)currencyStr;

@end


@interface YSCRMChoseCurrencyView : UIView
@property (nonatomic, strong) UILabel *titLab;

@property (nonatomic, weak) id<YSCRMChoseCurrencyViewDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
