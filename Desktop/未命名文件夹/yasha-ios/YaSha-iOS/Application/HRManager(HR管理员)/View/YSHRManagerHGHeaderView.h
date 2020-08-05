//
//  YSHRManagerHGHeaderView.h
//  YaSha-iOS
//
//  Created by GZl on 2019/3/25.
//  Copyright © 2019 亚厦装饰股份有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YSTagButton.h"

NS_ASSUME_NONNULL_BEGIN

@interface YSHRManagerHGHeaderView : UIView
@property (nonatomic, strong) UILabel *titleLab;
@property (nonatomic, strong) UIImageView *headImg;
@property (nonatomic, strong) UILabel *nameLab;
@property (nonatomic, strong) UILabel *numberLab;
@property (nonatomic, strong) UILabel *briefLb;
@property (nonatomic, strong) YSTagButton *positionBtn;
@property (nonatomic, strong) UIButton *detailBtn;
@property (nonatomic, strong) QMUIButton *titBtn;


- (instancetype)initWithFrame:(CGRect)frame withType:(BOOL)isDown;

@property(nonatomic,copy) void (^choseOptionBtnBlock)(NSInteger index_btn);

- (void)upBottomNumberDataWith:(NSDictionary*)datDic;

@end



@interface CustomBtnView : UIView

@property (nonatomic, strong) UILabel *topLab;
@property (nonatomic, strong) UILabel *bottomLab;
@property (nonatomic, strong) UIButton *backBtn;


@end


NS_ASSUME_NONNULL_END
