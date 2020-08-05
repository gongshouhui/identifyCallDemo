//
//  YSHRYearSelectedView.h
//  YaSha-iOS
//
//  Created by 罗罗诺亚索隆 on 2019/1/18.
//  Copyright © 2019 亚厦装饰股份有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
typedef void(^HRYearSelectBlock)(NSString *year);
@interface YSHRYearSelectedView : UIView
@property (nonatomic,strong) HRYearSelectBlock selectBlock;
@property (nonatomic,strong) NSString *currentSelectedYear;
@end

NS_ASSUME_NONNULL_END
