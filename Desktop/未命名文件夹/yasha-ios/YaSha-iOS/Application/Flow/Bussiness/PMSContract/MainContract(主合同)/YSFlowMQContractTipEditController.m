//
//  YSFlowMQContractTipEditController.m
//  YaSha-iOS
//
//  Created by 罗罗诺亚索隆 on 2019/3/25.
//  Copyright © 2019 亚厦装饰股份有限公司. All rights reserved.
//

#import "YSFlowMQContractTipEditController.h"

@interface YSFlowMQContractTipEditController ()
@property (nonatomic,strong) QMUITextView *textView;
@end

@implementation YSFlowMQContractTipEditController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.textView = [[QMUITextView alloc]init];
    [self.view addSubview:self.textView];
     self.textView.font = [UIFont systemFontOfSize:14];
     self.textView.placeholder = @"总结与风险提示";
    if (self.content) {
        self.textView.text = self.content;
    }
    [self.textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(kTopHeight);
        make.left.right.mas_equalTo(0);
        make.height.mas_equalTo(240);
    }];
    
    //底部按钮
    UIButton *submit = [UIButton buttonWithType:UIButtonTypeCustom];
    [submit setTitle:@"提交" forState:UIControlStateNormal];
    submit.backgroundColor = [UIColor colorWithHexString:@"#2A8ADB"];
    [self.view addSubview:submit];
    [submit mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.right.mas_equalTo(-15);
        make.bottom.mas_equalTo(-kBottomHeight - 30);
        make.height.mas_equalTo(50);
    }];
    YSWeak;
    [[submit rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        [weakSelf submit];
    }];
}
- (void)submit {
    NSMutableDictionary *paraDic = [NSMutableDictionary dictionary];
    [paraDic setValue:self.contractId forKey:@"contractId"];
    [paraDic setValue:self.opt forKey:@"opt"];
    [paraDic setValue:self.textView.text forKey:@"reviewRemark"];
     [QMUITips showLoadingInView:self.view];
    [YSNetManager ys_request_POSTWithUrlString:[NSString stringWithFormat:@"%@%@",YSDomain,updateMQContractInfo] isNeedCache:NO parameters:paraDic successBlock:^(id response) {
        [QMUITips hideAllToastInView:self.view animated:YES];
        if ([response[@"data"] integerValue] == 1) {
            [QMUITips showInfo:@"提交成功" inView:self.view hideAfterDelay:1.5];
            self.content = self.textView.text;
            if (self.editBlock) {
                self.editBlock(self.textView.text);
            }
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                 [self.navigationController popViewControllerAnimated:YES];
            });
           
        }
    } failureBlock:^(NSError *error) {
        
    } progress:nil];
}
@end
