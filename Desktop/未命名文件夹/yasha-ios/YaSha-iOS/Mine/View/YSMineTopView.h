//
//  YSMineTopView.h
//  YaSha-iOS
//
//  Created by 方鹏俊 on 17/3/27.
//
//

#import <UIKit/UIKit.h>
#import "YSPersonalInformationModel.h"

@interface YSMineTopView : UIView


@property (nonatomic, strong) UIButton *avatarButton;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UIImageView *genderImageView;

@property (nonatomic, strong) YSPersonalInformationModel *model;

@end
