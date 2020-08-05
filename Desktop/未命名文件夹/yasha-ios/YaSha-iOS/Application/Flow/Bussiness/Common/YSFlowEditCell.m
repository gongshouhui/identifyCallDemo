//
//  YSFlowEditCell.m
//  YaSha-iOS
//
//  Created by 罗罗诺亚索隆 on 2019/3/14.
//  Copyright © 2019 亚厦装饰股份有限公司. All rights reserved.
//

#import "YSFlowEditCell.h"

@implementation YSFlowEditCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self initUI];
    }
    return self;
}
- (void)initUI {
    self.titleLb = [[UILabel alloc]initWithFont:[UIFont systemFontOfSize:15] textColor:[UIColor colorWithHexString:@"#191F25"]];
    self.titleLb.font = [UIFont boldSystemFontOfSize:14];
    [self.contentView addSubview:self.titleLb];
    [self.titleLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(15);
        make.left.mas_equalTo(15);
        make.bottom.mas_equalTo(-15);
    }];
    self.editButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.editButton setTitle:@"立即修改" forState:UIControlStateNormal];
    self.editButton.titleLabel.font = [UIFont boldSystemFontOfSize:14];
    [self.editButton setTitleColor:[UIColor colorWithHexString:@"#2295FF"] forState:UIControlStateNormal];
    [self.editButton setImage:[UIImage imageNamed:@"icon-edit"] forState:UIControlStateNormal];
    [self.contentView addSubview:self.editButton];
    [self.editButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(0);
        make.right.mas_equalTo(-15);
    }];
    self.editButton.userInteractionEnabled = NO;
    UIView *lineView = [[UIView alloc]init];
    lineView.backgroundColor = [UIColor colorWithHexString:@"#E5E5E5"];
    [self.contentView addSubview:lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(_editButton.mas_left).mas_equalTo(-3);
        make.width.mas_equalTo(1);
        make.top.mas_equalTo(_editButton.mas_top).mas_equalTo(3);
        make.bottom.mas_equalTo(_editButton.mas_bottom).mas_equalTo(-3);
    }];
}
@end
