//
//  ShowAnimationView.h
//  Select
//
//  Created by YaSha_Tom on 2017/8/31.
//  Copyright © 2017年 YaSha-Tom. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ShowAnimationView : UIView

@property (nonatomic, strong) UIImageView  *showView;
@property (nonatomic, strong) UIButton *enterButton;
@property (nonatomic, strong) RACSubject *enterSubject;
@property (nonatomic, strong) UIButton *backButton;
@property (nonatomic, strong) UIView *bgView;
-(void)showViewMethods;
@end
