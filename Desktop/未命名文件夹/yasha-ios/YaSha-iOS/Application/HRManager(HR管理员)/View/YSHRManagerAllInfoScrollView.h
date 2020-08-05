//
//  YSHRManagerAllInfoScrollView.h
//  YaSha-iOS
//
//  Created by GZl on 2019/4/1.
//  Copyright © 2019 亚厦装饰股份有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YSTagButton.h"

NS_ASSUME_NONNULL_BEGIN
// 我的团队 个人信息
@interface YSHRManagerAllInfoScrollView : UIView
@property (nonatomic, strong) UIImageView *headerImg;
@property (nonatomic, strong) YSTagButton *positionBtn;
@property (nonatomic, strong) UILabel *nameLab;
@property (nonatomic, strong) UILabel *breftLab;
@property (nonatomic, strong) UILabel *numberLab;
@property(nonatomic,copy) void (^clickedInfoBtnBlock)(NSInteger btn_tag);
@property(nonatomic,copy) void (^choseOtherBtnBlock)(NSInteger btn_tag);
@property (nonatomic, strong) UIButton *bottomBtn;


@end

NS_ASSUME_NONNULL_END
