//
//  YSSalaryLoginController.m
//  YaSha-iOS
//
//  Created by 蘑菇加 on 2017/11/23.
//

#import "YSSalaryLoginController.h"
#import "UIImage+YSImage.h"
#import "YSForgetPasswordController.h"
#import "YSSalaryDetailController.h"
#import "YSSalaryDetailModel.h"
@interface YSSalaryLoginController ()
@property (nonatomic,strong) UITextField *textField;
@property (nonatomic,strong) UIButton *forgetBtn;
@property (nonatomic,strong) UIButton *queryBtn;

@end

@implementation YSSalaryLoginController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    //修改左侧按钮图片
    [self.navigationController.navigationBar setBackgroundImage:[[UIImage alloc]init] forBarMetrics:(UIBarMetricsDefault)];
    [TalkingData trackPageBegin:@"薪资条"];
}

//设置统计离开该模块
- (void)viewWillDisappear:(BOOL)animated {
      [super viewWillDisappear:animated];
    [TalkingData trackPageEnd:@"薪资条"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self setUpUI];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldDidChange) name:UITextFieldTextDidChangeNotification object:nil];
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}
- (BOOL)shouldHideKeyboardWhenTouchInView:(UIView *)view{
    return YES;
}
- (void)setUpUI {
    //背景图
    UIImageView *backGroundIV = [[UIImageView alloc]init];
    backGroundIV.image = [UIImage imageNamed:@"工资条底面1"];
    [self.view addSubview:backGroundIV];
    [backGroundIV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
    //
    UILabel *titleLb = [[UILabel alloc]init];
    titleLb.text = @"我的薪资条";
    titleLb.font = [UIFont systemFontOfSize:25];
    titleLb.textColor = [UIColor whiteColor];
    [self.view addSubview:titleLb];
    [titleLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(105*kHeightScale);
        make.centerX.mas_equalTo(0);
    }];
    //密码图标
    UIImageView *secIV = [[UIImageView alloc]init];
    secIV.image = [UIImage imageNamed:@"工资条密码"];
    [self.view addSubview:secIV];
    [secIV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(57*kWidthScale);
        make.top.mas_equalTo(titleLb.mas_bottom).mas_equalTo(67*kHeightScale);
        make.width.mas_equalTo(14*kWidthScale);
        make.height.mas_equalTo(16*kHeightScale);
    }];
    
    self.textField = [[UITextField alloc]init];
    self.textField.textColor = [UIColor whiteColor];
    self.textField.secureTextEntry = YES;
    self.textField.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.textField.placeholder = @"请输入门户登录密码";
	NSMutableAttributedString *placeholderStr = [[NSMutableAttributedString alloc]initWithString:self.textField.placeholder attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15],NSForegroundColorAttributeName:kUIColor(255, 255, 255, 0.5)}];
	self.textField.attributedPlaceholder = placeholderStr;
//    [self.textField setValue:kUIColor(255, 255, 255, 0.5) forKeyPath:@"_placeholderLabel.textColor"];//修改颜色
//    [self.textField setValue:[UIFont systemFontOfSize:15] forKeyPath:@"_placeholderLabel.font"];//修改字体 ios13kvc取不到了
    [self.view addSubview:self.textField];
    [self.textField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(secIV.mas_centerY);
        make.left.mas_equalTo(secIV.mas_right).mas_equalTo(10);
        make.height.mas_equalTo(20*kHeightScale);
        make.right.mas_equalTo(-15);
    }];
    
    //lineView
    UIView *lineView = [[UIView alloc]init];
    lineView.backgroundColor = kUIColor(255, 255, 255, 0.2);
    [self.view addSubview:lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(38*kWidthScale);
        make.right.mas_equalTo(-38*kWidthScale);
        make.height.mas_equalTo(1);
        make.top.mas_equalTo(self.textField.mas_bottom).mas_equalTo(10);
    }];
    
    //忘记密码
    self.forgetBtn = [UIButton buttonWithType:UIButtonTypeCustom];
	self.forgetBtn.hidden = YES;
    [self.forgetBtn addTarget:self action:@selector(forgetSecturyAction) forControlEvents:UIControlEventTouchUpInside];
    [self.forgetBtn setTitle:@"忘记密码" forState:UIControlStateNormal];
    [self.forgetBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.forgetBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    [self.view addSubview:self.forgetBtn];
    [self.forgetBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(lineView.mas_bottom).mas_equalTo(10);
        make.right.mas_equalTo(-38);
    }];
    
    //查询按钮
    self.queryBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.queryBtn.enabled = NO;
    [self.queryBtn setBackgroundImage:[UIImage new] forState:UIControlStateDisabled];
    [self.queryBtn setBackgroundImage:[UIImage imageWithColor:kThemeColor] forState:UIControlStateNormal];
    [self.queryBtn addTarget:self action:@selector(queryAction) forControlEvents:UIControlEventTouchUpInside];
    [self.queryBtn setTitle:@"查询" forState:UIControlStateNormal];
    [self.queryBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.queryBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    self.queryBtn.layer.masksToBounds = YES;
    self.queryBtn.layer.cornerRadius = 44*kHeightScale*0.5;
    self.queryBtn.layer.borderWidth = 1;
    self.queryBtn.layer.borderColor = [UIColor whiteColor].CGColor;
    [self.view addSubview:self.queryBtn];
    [self.queryBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_forgetBtn.mas_bottom).mas_equalTo(30);
        make.left.mas_equalTo(38*kWidthScale);
        make.right.mas_equalTo(-38*kWidthScale);
        make.height.mas_equalTo(44*kHeightScale);
    }];
}

#pragma mark - 查询工资
- (void)queryAction{
	
    [QMUITips showLoading:@"查询中..." inView:self.view];
    NSString *enString = [YSUtility encryptString:self.textField.text];
    
    NSDictionary *dic = @{
                          @"encodeContext": enString
                          };
    [YSNetManager ys_request_GETWithUrlString:[NSString stringWithFormat:@"%@%@",YSDomain,getSalaryDetailApi] isNeedCache:NO parameters:dic successBlock:^(id response) {
        DLog(@"查询薪资:%@", response);
        [QMUITips hideAllToastInView:self.view animated:YES];
        if ([response[@"code"] integerValue] == 1) {
            YSSalaryDetailModel *model = [YSSalaryDetailModel yy_modelWithDictionary:response[@"data"]];
            YSSalaryDetailController *vc = [[YSSalaryDetailController alloc]init];
            vc.salaryModel = model;
            [self.navigationController pushViewController:vc animated:YES];
        }else{
            [QMUITips showError:response[@"msg"] inView:self.view hideAfterDelay:2.0];
        }
       
        
    } failureBlock:^(NSError *error) {
        [QMUITips hideAllToastInView:self.view animated:YES];
    } progress:nil];
}
- (void)forgetSecturyAction{
    YSForgetPasswordController *vc = [[YSForgetPasswordController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}
#pragma mark - 通知相关方法
- (void)textFieldDidChange{
    if (self.textField.text.length > 0) {
        self.queryBtn.enabled = YES;
        self.queryBtn.layer.borderColor = kThemeColor.CGColor;
    }else{
        self.queryBtn.enabled = NO;
        self.queryBtn.layer.borderColor = [UIColor whiteColor].CGColor;
    }
}


- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
