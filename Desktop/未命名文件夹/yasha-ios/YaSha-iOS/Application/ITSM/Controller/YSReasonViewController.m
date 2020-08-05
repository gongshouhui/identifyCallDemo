//
//  YSReasonViewController.m
//  YaSha-iOS
//
//  Created by mHome on 2017/7/5.
//
//

#import "YSReasonViewController.h"

@interface YSReasonViewController ()<UITextViewDelegate>

@end

@implementation YSReasonViewController
- (void)initSubviews {
    [super initSubviews];
    self.title = @"撤销请求";
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = kUIColor(247, 247, 247, 1.0);
    self.myOpinion = [[YSMyOpinion alloc] init];
    [self.view addSubview:self.myOpinion];
    [self.myOpinion mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.view.mas_top).offset(kTopHeight);
        make.size.mas_equalTo(CGSizeMake(kSCREEN_WIDTH, 269*kHeightScale));
    }];
    
    [self.myOpinion.submitButton addTarget:self action:@selector(submitEvent) forControlEvents:UIControlEventTouchUpInside];
    
}

- (void)submitEvent {
    if (self.myOpinion.textView.text.length > 0) {
        
        NSDictionary *payload = @{
                                  @"eventId" : self.eventId,
                                  @"type" : self.type,
                                  @"content" : self.myOpinion.textView.text
                                  };
        [YSNetManager ys_request_POSTWithUrlString:[NSString stringWithFormat:@"%@%@",YSDomain,compRevoke] isNeedCache:NO parameters:payload successBlock:^(id response) {
            DLog(@"-------%@",response);
            [QMUITips hideAllToastInView:self.view animated:YES];
            if ([response[@"data"] integerValue] == 1 ){
                self.ReturnBlock(YES);
                [self.navigationController popViewControllerAnimated:YES];
            }
        } failureBlock:^(NSError *error) {
            DLog(@"=======%@",error);
        } progress:nil];
    }else{
        [QMUITips showError:[self.type isEqual:@"0"] ? @"请填写撤销事由" : @"请填写投诉事由" inView:self.view hideAfterDelay:1];
    }
}

@end
