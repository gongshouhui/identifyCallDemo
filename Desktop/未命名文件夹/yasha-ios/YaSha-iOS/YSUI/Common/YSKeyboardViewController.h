//
//  YSKeyboardViewController.h
//  YaSha-iOS
//
//  Created by 方鹏俊 on 2017/10/19.
//

#import "YSCommonViewController.h"

@interface YSKeyboardViewController : YSCommonViewController

@property (nonatomic, strong) QMUITextField *scoreTextField;
@property (nonatomic, strong) QMUITextView *textView;
@property (nonatomic, strong) QMUIButton *publishButton;

- (void)showInParentViewController:(UIViewController *)controller;
- (void)hideScoreTextField;

@end
