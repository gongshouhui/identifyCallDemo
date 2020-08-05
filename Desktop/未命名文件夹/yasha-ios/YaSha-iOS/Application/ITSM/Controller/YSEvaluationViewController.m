//
//  YSEvaluationViewController.m
//  YaSha-iOS
//
//  Created by mHome on 2017/7/5.
//
//

#import "YSEvaluationViewController.h"
#import "YSEvaluateView.h"
#import "YSITSMViewController.h"
#import "YSITSMUntreatedModel.h"
#import "YSMyOpinion.h"


@interface YSEvaluationViewController ()<UITextViewDelegate>

@property (nonatomic, strong) YSEvaluateView *evaluateView;
@property (nonatomic, strong) UITextView *textView;
@property (nonatomic, strong) UILabel *wordLabel;
@property (nonatomic, strong) UIButton *submitButton;
@property (nonatomic, strong) UILabel *instructionsLabel;


@end

@implementation YSEvaluationViewController
- (void)initSubviews {
    [super initSubviews];
   
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = [_model.visitRecord isEqual:@"1"] ? @"查看评价": @"服务评价";
    self.view.backgroundColor = [UIColor whiteColor];
    _evaluateView = [[YSEvaluateView alloc] init];
    [self.view addSubview:_evaluateView];
    [self.myOpinion mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(375*kWidthScale, 150*kHeightScale));
    }];
    self.myOpinion = [[YSMyOpinion alloc]init];
    [self.view addSubview:self.myOpinion];
    [self.myOpinion mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.view.mas_top).offset(160*kHeightScale+kTopHeight);
        make.size.mas_equalTo(CGSizeMake(375*kWidthScale, 269*kHeightScale));
    }];
    if ([_model.visitRecord isEqual:@"1"]) {
        [self getEvaluate];
        [self.myOpinion.submitButton removeFromSuperview];
    }
    [self.myOpinion.submitButton addTarget:self action:@selector(submitEvent) forControlEvents:UIControlEventTouchUpInside];
}

- (void)getEvaluate {
    NSString *urlString = [NSString stringWithFormat:@"%@%@", YSDomain, getServiceRating];
    NSDictionary *payload = @{
                              @"eventId" : _model.id
                              };
    [YSNetManager ys_request_GETWithUrlString:urlString isNeedCache:NO parameters:payload successBlock:^(id response) {
        DLog(@"获取评价:%@", response);
        [self refreshUI:response];
    } failureBlock:^(NSError *error) {
        DLog(@"error:%@", error);
    } progress:nil];
}

- (void)refreshUI:(id)diction {
    _evaluateView.starRateView1.userInteractionEnabled = NO;
    [_evaluateView.starRateView1 setCurrentScore:[diction[@"data"][@"respondSpeed"] floatValue]/20];
    
    _evaluateView.starRateView2.userInteractionEnabled = NO;
    [_evaluateView.starRateView2 setCurrentScore:[diction[@"data"][@"solveSpeed"] floatValue]/20];
    
    _evaluateView.starRateView3.userInteractionEnabled = NO;
    [_evaluateView.starRateView3 setCurrentScore:[diction[@"data"][@"serviceAttitude"] floatValue]/20];
    if ([diction[@"data"][@"remark"] isEqual:@""]) {
        [self.myOpinion.textView removeFromSuperview];
        _instructionsLabel = [[UILabel alloc]init];
        _instructionsLabel.text = @"感谢您的评价,让我们更好的为您服务！";
        _instructionsLabel.textColor = kUIColor(204, 204, 204, 1.0);
        _instructionsLabel.font = [UIFont systemFontOfSize:12];
        [self.view addSubview:_instructionsLabel];
        [_instructionsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(_evaluateView.starRateView3.mas_bottom).offset(30*kHeightScale);
            make.centerX.mas_equalTo(self.view.mas_centerX);
            make.size.mas_equalTo(CGSizeMake(216*kWidthScale, 12*kHeightScale));
        }];
        
    }else{
        self.myOpinion.textView.text = diction[@"data"][@"remark"];
        self.myOpinion.textView.userInteractionEnabled = NO;
        self.myOpinion.textView.placeholder = @"";
        _instructionsLabel = [[UILabel alloc]init];
        _instructionsLabel.text = @"感谢您的评价,让我们更好的为您服务！";
        _instructionsLabel.textColor = kUIColor(204, 204, 204, 1.0);
        _instructionsLabel.font = [UIFont systemFontOfSize:12];
        [self.view addSubview:_instructionsLabel];
        [_instructionsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.myOpinion.textView.mas_bottom).offset(10);
            make.centerX.mas_equalTo(self.view.mas_centerX);
            make.size.mas_equalTo(CGSizeMake(216*kWidthScale, 12*kHeightScale));
        }];
        [self.myOpinion.wordLabel removeFromSuperview];
    }
}

- (void)submitEvent {
    if (self.evaluateView.respondSpeed.length > 0 &&self.evaluateView.solveSpeed.length>0&&self.evaluateView.serviceAttitude.length>0) {
        NSDictionary *payload = @{
                                  @"eventId" : _model.id,
                                  @"content" : self.myOpinion.textView.text,
                                  @"respondSpeed" : self.evaluateView.respondSpeed,
                                  @"solveSpeed" : self.evaluateView.solveSpeed,
                                  @"serviceAttitude" :self.evaluateView.serviceAttitude
                                  };
        [YSNetManager ys_request_POSTWithUrlString:[NSString stringWithFormat:@"%@%@", YSDomain, saveServiceRating] isNeedCache:NO parameters:payload successBlock:^(id response) {
            [QMUITips hideAllToastInView:self.view animated:YES];
            if ([response[@"data"] integerValue] == 1) {
                self.ReturnBlock(YES);
                for (UIViewController *controller in self.rt_navigationController.rt_viewControllers) {
                    if ([controller isKindOfClass:[YSITSMViewController class]]) {
                        [self.navigationController popToViewController:controller animated:YES];
                    }
                }
            }
        } failureBlock:^(NSError *error) {
            DLog(@"========%@",error);
        } progress:nil];
    }else{
         [QMUITips showError:@"请填写完善评价内容" detailText:nil inView:self.view hideAfterDelay:2];
    }
}

@end
