//
//  YSPMSInputCell.m
//  YaSha-iOS
//
//  Created by YaSha_Tom on 2017/9/9.
//
//

#import "YSPMSInputCell.h"

@implementation YSPMSInputCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor groupTableViewBackgroundColor];
        self.textfile = [[UITextField alloc]init];
        self.textfile.placeholder = @"请输入所属部门...";
        self.textfile.layer.masksToBounds = YES;
        self.textfile.layer.cornerRadius = 5;
        self.textfile.font = [UIFont systemFontOfSize:12];
        [self.contentView addSubview:self.textfile];
        [self.textfile mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(self.contentView.mas_centerX);
            make.centerY.mas_equalTo(self.contentView.mas_centerY);
            make.size.mas_equalTo(CGSizeMake(self.frame.size.width -30*kWidthScale, 30*kHeightScale));
        }];
    }
    return self;
}

@end
