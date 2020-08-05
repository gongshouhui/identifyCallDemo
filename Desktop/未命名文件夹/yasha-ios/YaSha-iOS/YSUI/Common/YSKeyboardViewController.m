//
//  YSKeyboardViewController.m
//  YaSha-iOS
//
//  Created by 方鹏俊 on 2017/10/19.
//

#import "YSKeyboardViewController.h"

static CGFloat const kToolbarHeight = 50;

@interface YSKeyboardViewController () <QMUIKeyboardManagerDelegate>

@property (nonatomic, strong) QMUIKeyboardManager *keyboardManager;

@property (nonatomic, strong) UIControl *maskControl;
@property (nonatomic, strong) UIView *containerView;

@property (nonatomic, strong) UIView *toolbarView;
@property (nonatomic, strong) QMUIButton *cancelButton;

- (void)hide;

@end

@implementation YSKeyboardViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UIColorClear;
}

- (void)initSubviews {
    [super initSubviews];
//    self.scoreTextField.text = nil;
//    self.textView.text = nil;
    
    _maskControl = [[UIControl alloc] init];
//    _maskControl.frame = [UIScreen mainScreen].bounds;
    self.maskControl.backgroundColor = UIColorMask;
    [self.maskControl addTarget:self action:@selector(handleCancelButtonEvent:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.maskControl];
    
    _containerView = [[UIView alloc] init];
    self.containerView.backgroundColor = UIColorWhite;
    self.containerView.layer.cornerRadius = 8;
    [self.view addSubview:self.containerView];
    
    _scoreTextField = [[QMUITextField alloc] init];
    self.scoreTextField.keyboardType = UIKeyboardTypeNumberPad;
    self.scoreTextField.font = UIFontMake(16);
    self.scoreTextField.placeholder = @"请输入评分";
    self.scoreTextField.textInsets = UIEdgeInsetsMake(0, 16, 0, 0);
    [self.containerView addSubview:self.scoreTextField];
    
    _textView = [[QMUITextView alloc] init];
    self.textView.font = UIFontMake(16);
    self.textView.placeholder = @"发表你的评价...";
    self.textView.textContainerInset = UIEdgeInsetsMake(16, 12, 16, 12);
    self.textView.layer.cornerRadius = 8;
    self.textView.clipsToBounds = YES;
    [self.containerView addSubview:self.textView];
    
    _toolbarView = [[UIView alloc] init];
    self.toolbarView.backgroundColor = UIColorMake(246, 246, 246);
    self.toolbarView.qmui_borderColor = UIColorSeparator;
    self.toolbarView.qmui_borderPosition = QMUIBorderViewPositionTop;
    [self.containerView addSubview:self.toolbarView];
    
    _cancelButton = [[QMUIButton alloc] init];
    self.cancelButton.titleLabel.font = UIFontMake(16);
    [self.cancelButton setTitle:@"关闭" forState:UIControlStateNormal];
    [self.cancelButton addTarget:self action:@selector(handleCancelButtonEvent:) forControlEvents:UIControlEventTouchUpInside];
    [self.cancelButton sizeToFit];
    [self.toolbarView addSubview:self.cancelButton];
    
    _publishButton = [[QMUIButton alloc] init];
    self.publishButton.titleLabel.font = UIFontMake(16);
    [self.publishButton setTitle:@"评价" forState:UIControlStateNormal];
    YSWeak;
    [[self.publishButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        [weakSelf handleCancelButtonEvent:weakSelf.publishButton];
    }];
    [self.publishButton sizeToFit];
    [self.toolbarView addSubview:self.publishButton];
    
    _keyboardManager = [[QMUIKeyboardManager alloc] initWithDelegate:self];
    // 设置键盘只接受 self.textView 的通知事件，如果当前界面有其他 UIResponder 导致键盘产生通知事件，则不会被接受
    [self.keyboardManager addTargetResponder:self.scoreTextField];
    [self.keyboardManager addTargetResponder:self.textView];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    self.maskControl.frame = self.view.bounds;
   
    
    CGRect containerRect = CGRectFlatMake(0, CGRectGetHeight(self.view.bounds), CGRectGetWidth(self.view.bounds), 300);
    self.containerView.frame = CGRectApplyAffineTransform(containerRect, self.containerView.transform);
    
    self.toolbarView.frame = CGRectFlatMake(0, CGRectGetHeight(self.containerView.bounds) - kToolbarHeight, CGRectGetWidth(self.containerView.bounds), kToolbarHeight);
    self.cancelButton.frame = CGRectFlatMake(20, CGFloatGetCenter(CGRectGetHeight(self.toolbarView.bounds), CGRectGetHeight(self.cancelButton.bounds)), CGRectGetWidth(self.cancelButton.bounds), CGRectGetHeight(self.cancelButton.bounds));
    self.publishButton.frame = CGRectFlatMake(CGRectGetWidth(self.toolbarView.bounds) - CGRectGetWidth(self.publishButton.bounds) - 20, CGFloatGetCenter(CGRectGetHeight(self.toolbarView.bounds), CGRectGetHeight(self.publishButton.bounds)), CGRectGetWidth(self.publishButton.bounds), CGRectGetHeight(self.publishButton.bounds));
    
    self.scoreTextField.frame = CGRectMake(0, 0, CGRectGetWidth(self.containerView.bounds), 40);
    self.textView.frame = CGRectFlatMake(0, 40, CGRectGetWidth(self.containerView.bounds), CGRectGetHeight(self.containerView.bounds) - kToolbarHeight-30);
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.view endEditing:YES];
}

- (void)showInParentViewController:(UIViewController *)controller {
    
    if (IS_LANDSCAPE) {
        //        [QDUIHelper forceInterfaceOrientationPortrait];
    }
    
    // 这一句访问了self.view，触发viewDidLoad:
//    self.view.frame = controller.view.bounds;
    
     self.containerView.layer.transform = CATransform3DMakeTranslation(0,-516, 0);
    
    // 需要先布局好
    [controller.view addSubview:self.view];
    [self.view layoutIfNeeded];
    
    // 这一句触发viewWillAppear:
    [self beginAppearanceTransition:YES animated:YES];
    
    self.maskControl.alpha = 0;
    
    [UIView animateWithDuration:.25 delay:0.0 options:QMUIViewAnimationOptionsCurveOut animations:^{
        self.maskControl.alpha = 1.0;
    } completion:^(BOOL finished) {
        // 这一句触发viewDidAppear:
        [self endAppearanceTransition];
    }];
    [self.textView becomeFirstResponder];
}

- (void)hideScoreTextField {
    self.scoreTextField.frame = CGRectMake(0, 0, 0, 0);
    self.textView.frame = CGRectFlatMake(0, 40, CGRectGetWidth(self.containerView.bounds), CGRectGetHeight(self.containerView.bounds) - kToolbarHeight);
    [self.scoreTextField removeFromSuperview];
}

- (void)hide {
    // 这一句触发viewWillDisappear:
    [self beginAppearanceTransition:NO animated:YES];
    [UIView animateWithDuration:.25 delay:0.0 options:QMUIViewAnimationOptionsCurveOut animations:^{
        self.maskControl.alpha = 0.0;
    } completion:^(BOOL finished) {
        // 这一句触发viewDidDisappear:
        [self endAppearanceTransition];
        [self.view removeFromSuperview];
    }];
}

- (void)handleCancelButtonEvent:(id)sender {
    [self.scoreTextField resignFirstResponder];
    [self.textView resignFirstResponder];
}

#pragma mark - <QMUIKeyboardManagerDelegate>

- (void)keyboardWillChangeFrameWithUserInfo:(QMUIKeyboardUserInfo *)keyboardUserInfo {
    __weak __typeof(self)weakSelf = self;
    [QMUIKeyboardManager handleKeyboardNotificationWithUserInfo:keyboardUserInfo showBlock:^(QMUIKeyboardUserInfo *keyboardUserInfo) {
        [QMUIKeyboardManager animateWithAnimated:YES keyboardUserInfo:keyboardUserInfo animations:^{
            CGFloat distanceFromBottom = [QMUIKeyboardManager distanceFromMinYToBottomInView:weakSelf.view keyboardRect:keyboardUserInfo.endFrame];
            weakSelf.containerView.layer.transform = CATransform3DMakeTranslation(0, - distanceFromBottom - CGRectGetHeight(self.containerView.bounds), 0);
        } completion:NULL];
    } hideBlock:^(QMUIKeyboardUserInfo *keyboardUserInfo) {
        [weakSelf hide];
        [QMUIKeyboardManager animateWithAnimated:YES keyboardUserInfo:keyboardUserInfo animations:^{
            weakSelf.containerView.layer.transform = CATransform3DIdentity;
        } completion:NULL];
    }];
}

@end
