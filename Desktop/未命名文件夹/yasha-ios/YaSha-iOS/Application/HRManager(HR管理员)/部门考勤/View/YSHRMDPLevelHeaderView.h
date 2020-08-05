//
//  YSHRMDPLevelHeaderView.h
//  YaSha-iOS
//
//  Created by GZl on 2019/4/9.
//  Copyright © 2019 亚厦装饰股份有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <PGPickerView/PGPickerView.h>

NS_ASSUME_NONNULL_BEGIN

@interface YSHRMDPLevelHeaderView : UIView

@property (nonatomic, strong) UILabel *titLab;
@property (nonatomic, copy) NSString *currentSelectedYear;

@property (nonatomic,strong) QMUIButton *yearButton;
@property(nonatomic,copy) void (^selectYearBlock)(NSString *currentSelectedYear);
@property(nonatomic,copy) void (^choseSequenceBlock)(NSInteger index);

// 1绩效等级 2奖励信息
- (instancetype)initWithFrame:(CGRect)frame withType:(NSInteger)type;

// 部门培训使用这个创建
- (instancetype)initWithFrame:(CGRect)frame withMenuArray:(NSArray*)titleArray;

- (void)upLevelBtnViewdataWith:(NSDictionary*)dataDic;

@end

@interface YSHRMDPLevelBtnView : UIView

@property (nonatomic, strong) UILabel *numberLab;
@property (nonatomic, strong) UILabel *nameLab;
@property (nonatomic, strong) UIButton *backBtn;
@property (nonatomic, strong) UILabel *lineLab;


@end

@interface YSCutomQuarterPickerView : UIView


@property(nonatomic,copy) void (^choseTimeBlock)(NSString * _Nullable   timeStr);



@end

NS_ASSUME_NONNULL_END
