//
//  YSSystemMessageView.m
//  YaSha-iOS
//
//  Created by YaSha_Tom on 2018/6/6.
//  Copyright © 2018年 亚厦装饰股份有限公司. All rights reserved.
//

#import "YSSystemMessageView.h"
#import "YSTagButton.h"
@interface YSSystemMessageView()

@property (nonatomic, strong) UIImageView *headImage;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, strong) UILabel *contentLabel;
@property (nonatomic, strong) YSTagButton *numButton;

@end

@implementation YSSystemMessageView
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self initUI];
    }
    return self;
}

- (void)initUI {
    _jumpSubject = [RACSubject subject];
    self.headImage = [[UIImageView alloc]init];
    self.headImage.image = [UIImage imageNamed:@"消息_icon"];
    [self addSubview:self.headImage];
    [self.headImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.mas_centerY);
        make.left.mas_equalTo(self.mas_left).offset(10*kWidthScale);
        make.size.mas_equalTo(CGSizeMake(48*kWidthScale, 48*kWidthScale));
    }];
    
    self.titleLabel = [[UILabel alloc]init];
    self.titleLabel.text = @"消息通知";
    self.titleLabel.font = [UIFont systemFontOfSize:15];
    [self addSubview:self.titleLabel];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.headImage.mas_right).offset(10*kWidthScale);
        make.top.mas_equalTo(self.mas_top).offset(11*kHeightScale);
    }];
    
    self.timeLabel = [[UILabel alloc]init];
    self.timeLabel.text = @" ";
    self.timeLabel.font = [UIFont systemFontOfSize:13];
    self.timeLabel.textColor = kGrayColor(178);
    self.timeLabel.textAlignment = NSTextAlignmentRight;
    [self addSubview:self.timeLabel];
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.mas_top).offset(15*kHeightScale);
        make.right.mas_equalTo(self.mas_right).offset(-15*kWidthScale);
    }];
    
   
    self.numButton = [[YSTagButton alloc]init];
    self.numButton.tagContentEdgeInsets = UIEdgeInsetsMake(1, 5, 1, 5);
    self.numButton.layer.masksToBounds = YES;
    self.numButton.layer.cornerRadius = 8*kWidthScale;
    [self.numButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.numButton.titleLabel.font = [UIFont systemFontOfSize:12];
    [self.numButton setContentCompressionResistancePriority:UILayoutPriorityDefaultHigh forAxis:(UILayoutConstraintAxisHorizontal)];
    [self.numButton setContentHuggingPriority:(UILayoutPriorityDefaultHigh) forAxis:(UILayoutConstraintAxisHorizontal)];
    [self addSubview:self.numButton];
    [self.numButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.mas_right).offset(-15*kWidthScale);
        make.top.mas_equalTo(self.timeLabel.mas_bottom).offset(8*kHeightScale);
    }];
    
    self.contentLabel = [[UILabel alloc]init];
    self.contentLabel.text = @"暂无消息通知";
    self.contentLabel.font = [UIFont systemFontOfSize:14];
    self.contentLabel.textColor = kGrayColor(136);
    [self.contentLabel setContentCompressionResistancePriority:UILayoutPriorityDefaultLow forAxis:(UILayoutConstraintAxisHorizontal)];
    [self.contentLabel setContentHuggingPriority:(UILayoutPriorityDefaultLow) forAxis:(UILayoutConstraintAxisHorizontal)];
    [self addSubview:self.contentLabel];
    [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.headImage.mas_right).offset(10*kWidthScale);
        make.top.mas_equalTo(self.titleLabel.mas_bottom).offset(8*kHeightScale);
        make.right.mas_equalTo(_numButton.mas_left).mas_equalTo(-10);
    }];
};

- (void)setSystemMessageData:(NSDictionary *)dic andTotalNum:(NSString *)total {
    self.numButton.hidden = NO;
    [self.numButton setTitle:[NSString stringWithFormat:@"%@",total] forState:UIControlStateNormal];
    self.numButton.backgroundColor = [UIColor redColor];
    NSString *typeStr;
    DLog(@"========%@",dic[@"noticeType"]);
    if ([dic[@"noticeType"] intValue] == 1) {
        typeStr = @"流程知会 : ";
    }else if ([dic[@"noticeType"] intValue] == 2) {
        typeStr = @"办结提醒 : ";
    }else if ([dic[@"noticeType"] intValue] == 3) {
        typeStr = @"系统提醒 : ";
    }else {
        typeStr = @"系统待办 : ";
    }
    self.contentLabel.text = [NSString stringWithFormat:@"%@%@",typeStr,dic[@"title"]];
    self.timeLabel.text = [YSUtility timestampSwitchTime:dic[@"createTime"] andFormatter:@"HH:mm:ss"];
    
}
- (void)setReadSystemMessageData:(NSString *)str andTotalNum:(NSString *)total {
    self.numButton.hidden = YES;
    self.contentLabel.text = str;
    self.timeLabel.text = @" ";
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.jumpSubject sendNext:nil];
    
}
/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

@end
