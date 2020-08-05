//
//  YSPMSInfoHeaderView.m
//  YaSha-iOS
//
//  Created by YaSha_Tom on 2017/8/31.
//
//

#import "YSPMSInfoHeaderView.h"

@implementation YSPMSInfoHeaderView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self initUI];
    }
    return self;
}

- (void)initUI {
    self.distanceLabel = [[UILabel alloc]init];
    self.distanceLabel.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [self addSubview:self.distanceLabel];
    [self.distanceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(kSCREEN_WIDTH, 10*kHeightScale));
    }];
    
    self.lineLabel = [[UILabel alloc]init];
    self.lineLabel.backgroundColor = kUIColor(37, 134, 216, 1.0);
    [self addSubview:self.lineLabel];
    [self.lineLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.distanceLabel.mas_bottom).offset(14*kHeightScale);
        make.left.mas_equalTo(self.mas_left).offset(10*kWidthScale);
        make.size.mas_equalTo(CGSizeMake(2, 18*kHeightScale));
    }];
    
    self.positionLabel = [[UILabel alloc]init];
    self.positionLabel.font = [UIFont systemFontOfSize:15];
    self.positionLabel.textColor = kUIColor(51, 51, 51, 1.0);
    [self addSubview:self.positionLabel];
    [self.positionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.distanceLabel.mas_bottom).offset(14*kHeightScale);
        make.left.mas_equalTo(self.lineLabel.mas_right).offset(10*kWidthScale);
        make.right.mas_equalTo(-15);
        //make.size.mas_equalTo(CGSizeMake(150*kWidthScale, 16*kHeightScale));
    }];
}

@end
