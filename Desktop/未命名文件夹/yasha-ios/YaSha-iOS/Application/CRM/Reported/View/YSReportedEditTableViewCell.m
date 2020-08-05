//
//  YSReportedEditTableViewCell.m
//  YaSha-iOS
//
//  Created by GZl on 2019/5/14.
//  Copyright © 2019 亚厦装饰股份有限公司. All rights reserved.
//

#import "YSReportedEditTableViewCell.h"

@interface YSReportedEditTableViewCell ()
@property (nonatomic,strong)UILabel *titleLabel;
@property (nonatomic,strong)UILabel *stateLabel;

@end

@implementation YSReportedEditTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self initUI];
    }
    return self;
}
- (void)initUI {
    self.titleLabel = [[UILabel alloc]init];
    self.titleLabel.font = [UIFont systemFontOfSize:16];
    [self addSubview:self.titleLabel];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.mas_top).offset(16);
        make.left.mas_equalTo(self.mas_left).offset(15);
        make.size.mas_equalTo(CGSizeMake(340*kWidthScale, 24*kHeightScale));
    }];
    
    self.stateLabel = [[UILabel alloc]init];
    self.stateLabel.font = [UIFont systemFontOfSize:12];
    [self addSubview:self.stateLabel];
    [self.stateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.titleLabel.mas_bottom).offset(8);
        make.left.mas_equalTo(self.mas_left).offset(15);
        make.size.mas_equalTo(CGSizeMake(340*kWidthScale, 20*kHeightScale));
    }];
}

- (void)setReporedData:(YSReporetModel *)cellModel {
    self.titleLabel.text = cellModel.projectName;
    NSString *str1 = [NSString stringWithFormat:@"%@-",cellModel.bizStatusStr];
    long len1 = [str1 length];
    NSString *str = [NSString stringWithFormat:@"%@%@",str1,cellModel.flowStatusStr];
    NSMutableAttributedString *str2 = [[NSMutableAttributedString alloc]initWithString:str];
    [str2 addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:0 green:122.0/255.0 blue:1 alpha:1] range:NSMakeRange(0,len1)];
    [str2 addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(len1,cellModel.flowStatusStr.length)];
    self.stateLabel.attributedText = str2;
}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
