//
//  YSPerRemarkView.m
//  YaSha-iOS
//
//  Created by YaSha_Tom on 2017/10/25.
//

#import "YSPerRemarkView.h"

@interface YSPerRemarkView ()

@property (nonatomic, strong) UILabel *weightLabel;
@property (nonatomic, strong) UILabel *workItemLabel;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *lineLabel;


@end
@implementation YSPerRemarkView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
       
        _weightLabel = [[UILabel alloc] init];
        _weightLabel.textColor = [UIColor whiteColor];
        _weightLabel.text = @"补";
        _weightLabel.textAlignment = NSTextAlignmentCenter;
        _weightLabel.font = [UIFont systemFontOfSize:20];
        _weightLabel.backgroundColor = [UIColor colorWithRed:1.00 green:0.76 blue:0.30 alpha:1.00];
        _weightLabel.layer.masksToBounds = YES;
        _weightLabel.layer.cornerRadius = 20*kWidthScale;
        [self addSubview:_weightLabel];
        [_weightLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.mas_top).offset(10);
            make.left.mas_equalTo(self.mas_left).offset(15);
            make.size.mas_equalTo(CGSizeMake(40*kWidthScale, 40*kHeightScale));
        }];
        
        _workItemLabel = [[UILabel alloc] init];
        _workItemLabel.font = [UIFont boldSystemFontOfSize:17];
        _workItemLabel.text = @"补充说明";
        [self addSubview:_workItemLabel];
        [_workItemLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.mas_top).offset(10);
            make.left.mas_equalTo(_weightLabel.mas_right).offset(10);
            make.height.mas_equalTo(18*kHeightScale);
            make.right.mas_equalTo(self.mas_right).offset(-15);
        }];
        
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.font = [UIFont systemFontOfSize:13];
        _nameLabel.text = [YSUtility getName];
        [self addSubview:_nameLabel];
        [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(_workItemLabel.mas_bottom).offset(5);
            make.left.mas_equalTo(_weightLabel.mas_right).offset(10);
            make.height.mas_equalTo(15*kHeightScale);
            make.right.mas_equalTo(self.mas_right).offset(-15);
        }];
        
        
        
        _lineLabel = [[UILabel alloc] init];
        _lineLabel.backgroundColor = [UIColor groupTableViewBackgroundColor];
        [self addSubview:_lineLabel];
        [_lineLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(_nameLabel.mas_bottom).offset(25);
            make.left.mas_equalTo(self.mas_left);
            make.size.mas_equalTo(CGSizeMake(kSCREEN_WIDTH, 1));
            
        }];
        
        _textView = [[QMUITextView alloc] init];
        self.textView.font = UIFontMake(16);
        DLog(@"=========%d",self.perfInfoType);
        if (self.perfInfoType != 1 ) {
           self.textView.placeholder = @"请输入补充说明...";
        }else{
            self.textView.userInteractionEnabled = NO;
        }
        self.textView.textContainerInset = UIEdgeInsetsMake(16, 12, 16, 12);
        self.textView.layer.cornerRadius = 8;
        self.textView.clipsToBounds = YES;
        [self addSubview:self.textView];
        [self.textView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.lineLabel.mas_bottom).offset(3);
            make.left.mas_equalTo(self.mas_left);
            make.size.mas_equalTo(CGSizeMake(kSCREEN_WIDTH, 200*kHeightScale));
        }];
        
        
    }
    return self;
}
- (void)setViewModel:(YSPerfInfoModel *)model {
    
}

@end
