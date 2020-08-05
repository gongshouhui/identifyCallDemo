//
//  YSEvaluateView.m
//  YaSha-iOS
//
//  Created by mHome on 2017/7/5.
//
//

#import "YSEvaluateView.h"

@interface YSEvaluateView ()<StarRateViewDelegate>

@end

@implementation YSEvaluateView
-(instancetype) initWithFrame:(CGRect)frame{
  
    if (self = [super initWithFrame:frame]) {
        self.frame = CGRectMake(0, kTopHeight, kSCREEN_WIDTH, 155*kHeightScale);
        self.backgroundColor = [UIColor whiteColor];
        [self initUI];
    }
    return self;
}

- (void)initUI {
    
   NSArray *array = @[@"响应速度",@"解决速度",@"服务态度"];
    for (int i = 0; i < 3; i++) {

        UILabel *responseSpeedLabel = [[UILabel alloc]init];
        responseSpeedLabel.font = [UIFont systemFontOfSize:14];
        responseSpeedLabel.text = array[i];
        responseSpeedLabel.textColor = kUIColor(51, 51, 51, 1.0);
        [self addSubview:responseSpeedLabel];
        [responseSpeedLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.mas_left).offset(16*kWidthScale);
            make.top.mas_equalTo(self.mas_top).offset(30*kHeightScale + 45*i*kHeightScale);
            make.size.mas_equalTo(CGSizeMake(60*kWidthScale, 13*kHeightScale));
        }];
    }
    
    _starRateView1 = [[StarRateView alloc] initWithFrame:CGRects(80, 23, 240, 30) numberOfStars:5 rateStyle:WholeStar isAnimation:YES delegate:self];
    _starRateView1.tag = 1;
    [self addSubview:_starRateView1];
    
    _starRateView2 = [[StarRateView alloc] initWithFrame:CGRects(80, 68, 240, 30) numberOfStars:5 rateStyle:WholeStar isAnimation:YES delegate:self];
    _starRateView2.tag = 2;
    [self addSubview:_starRateView2];
    
    
    _starRateView3 = [[StarRateView alloc] initWithFrame:CGRects(80, 111, 240, 30) numberOfStars:5 rateStyle:WholeStar isAnimation:YES delegate:self];
    _starRateView3.tag = 3;
    [self addSubview:_starRateView3];
   

}
-(void) starRateView:(StarRateView *)starRateView currentScore:(CGFloat)currentScore{
    NSString *score = [NSString stringWithFormat:@"%.0lf", currentScore*20];
    switch (starRateView.tag) {
        case 1:
        {
            self.respondSpeed = score;
        }
        case 2:
        {
            self.solveSpeed = score;
        }
        case 3:
        {
            self.serviceAttitude = score;
        }
        
    }
}
@end
