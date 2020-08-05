//
//  YSHRMTrainingChartView.h
//  YaSha-iOS
//
//  Created by GZl on 2019/5/5.
//  Copyright © 2019 亚厦装饰股份有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface YSHRMTrainingChartView : UIView

//Y轴标题
@property (nonatomic, strong) UILabel *titleLabel;
//X轴标题
@property (nonatomic, strong) UILabel *bottomLabel;
/** 点数据 */
@property (nonatomic,strong) NSArray *dataArrOfPoint;
/** Y轴坐标数据 */
@property (nonatomic, strong) NSArray *dataArrOfY;
/** X轴坐标数据 */
@property (nonatomic, strong) NSArray *dataArrOfX;

@end

NS_ASSUME_NONNULL_END
