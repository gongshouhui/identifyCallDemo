//
//  YSHRMInfoAssetsGSView.h
//  YaSha-iOS
//
//  Created by GZl on 2019/4/4.
//  Copyright © 2019 亚厦装饰股份有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN


@interface YSHRAssetsLineView : UIView

@property (nonatomic, strong) UILabel *titLab;
@property (nonatomic, strong) UILabel *numberLab;
@property (nonatomic, strong) UILabel *lineLab;

@property (nonatomic, strong) UILabel *hiddenNumLab;


- (instancetype)initWithFrame:(CGRect)frame withType:(NSInteger)type;

@end

@interface YSHRMInfoAssetsGSView : UIView

@property (nonatomic, strong) UILabel *personLab;
@property (nonatomic, strong) UILabel *dutyLab;

@property (nonatomic, strong) UIButton *bottomBtn;

// dataArray:从上到下内部是浮点型 type:1个人 2责任
- (void)upSubViewsWith:(NSArray*)dataArray withType:(int)type;

@end

NS_ASSUME_NONNULL_END
