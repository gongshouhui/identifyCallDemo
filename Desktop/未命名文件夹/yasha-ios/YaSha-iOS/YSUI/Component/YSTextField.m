//
//  YSTextField.m
//  YaSha-iOS
//
//  Created by 方鹏俊 on 17/3/7.
//
//

#import "YSTextField.h"


@implementation YSTextField

- (void)setImageName:(NSString *)imageName placeholder:(NSString *)placeholder {
    self.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.contentMode =UIViewContentModeCenter;
    self.placeholder = placeholder;
    self.font = [UIFont systemFontOfSize:14];
    self.text = @"";
    
    
    UIView *backView = [[UIView alloc] init];
    [backView setFrame:CGRectMake(0, 0, 45*kWidthScale, 45*kWidthScale)];
    [backView setBackgroundColor:[UIColor clearColor]];
    
    UIImageView *iconIV = [[UIImageView alloc] init];
    [iconIV setImage:[UIImage imageNamed:imageName]];
    [backView addSubview:iconIV];
	iconIV.frame = CGRectMake(0, 0, 16*kWidthScale, 16*kWidthScale);
	iconIV.center = backView.center;
//    [iconIV mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.size.mas_equalTo(CGSizeMake(16*kWidthScale, 16*kWidthScale));
//		make.center.mas_equalTo(0);
//    }];//ios13出现bug约束布局会导致iconIV不满整个输入框
    [self setLeftView:backView];
    [self setLeftViewMode:UITextFieldViewModeAlways];
    
    UILabel *linelabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 45*kWidthScale, kSCREEN_WIDTH-50, 1)];
    self.lineLb = linelabel;
    linelabel.backgroundColor = [UIColor colorWithRed:0.85 green:0.85 blue:0.85 alpha:1.00];
    [self addSubview:linelabel];
}

- (void)setCaptchaImageName:(NSString *)imageName placeholder:(NSString *)placeholder {
    self.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.contentMode =UIViewContentModeCenter;
    self.placeholder = placeholder;
    self.font = [UIFont systemFontOfSize:14];
    self.text = @"";
    
    UIView *backView = [[UIView alloc] init];
    [backView setFrame:CGRectMake(0, 0, 45*kWidthScale, 45*kWidthScale)];
    [backView setBackgroundColor:[UIColor clearColor]];
    
    UIImageView *iconIV = [[UIImageView alloc] init];
	iconIV.frame = CGRectMake(0, 0, 16*kWidthScale, 16*kWidthScale);
	iconIV.center = backView.center;
    [iconIV setImage:[UIImage imageNamed:imageName]];
    [backView addSubview:iconIV];
//    [icon mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.size.mas_equalTo(CGSizeMake(16*kWidthScale, 16*kWidthScale));
//        make.centerX.centerY.mas_equalTo(backView);
//    }];
    
    [self setLeftView:backView];
    [self setLeftViewMode:UITextFieldViewModeAlways];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 45*kHeightScale, kSCREEN_WIDTH-140*kWidthScale-10-50, 1)];
    label.backgroundColor = [UIColor colorWithRed:0.85 green:0.85 blue:0.85 alpha:1.00];
    [self addSubview:label];
}
- (void)setImageName:(NSString *)imageName frame:(CGRect)frame backgroundFrame:(CGRect)bgframe placeholder:(NSString *)placeholder {
    self.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.contentMode =UIViewContentModeCenter;
    self.placeholder = placeholder;
    self.font = [UIFont systemFontOfSize:14];
    self.text = @"";
    
    UIView *backView = [[UIView alloc] init];
    [backView setFrame:bgframe];
    [backView setBackgroundColor:[UIColor clearColor]];
    
    UIImageView *icon = [[UIImageView alloc] init];
    [icon setImage:[UIImage imageNamed:imageName]];
    [backView addSubview:icon];
    icon.frame = frame;
    [self setLeftView:backView];
    [self setLeftViewMode:UITextFieldViewModeAlways];
}
@end
