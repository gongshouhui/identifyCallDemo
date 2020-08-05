//
//  YSInfoFirstCell.m
//  YaSha-iOS
//
//  Created by 蘑菇加 on 2017/12/11.
//  Copyright © 2017年 亚厦装饰股份有限公司. All rights reserved.
//

#import "YSHRInfoFirstCell.h"

@implementation YSHRInfoFirstCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self initUI];
    }
    return self;
}
- (void)initUI{
    self.backgroundColor = kUIColor(229, 229, 229, 1);
    self.contentLb = [[UILabel alloc]init];
    self.contentLb.numberOfLines = 0;
    self.contentLb.font = [UIFont systemFontOfSize:16];
    self.contentLb.textColor = kGrayColor(51);
    [self.contentView addSubview:_contentLb];
    [self.contentLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(30);
        make.right.mas_equalTo(-30);
        make.top.mas_equalTo(17);
        make.bottom.mas_equalTo(-17);
    }];
    
}

- (void)setLangDic:(NSDictionary *)langDic
{
    _langDic = langDic;
    NSString *language = [langDic allValues].firstObject;
    NSString *skill = [NSString stringWithFormat:@"(%@)",[langDic allValues].lastObject];
    NSString *textStr = [NSString stringWithFormat:@"%@%@",language,skill];
    NSMutableAttributedString *atti = [[NSMutableAttributedString alloc]initWithString:textStr];
    [atti addAttributes:@{NSForegroundColorAttributeName:kUIColor(130, 140, 153, 1),NSFontAttributeName:[UIFont systemFontOfSize:14]} range:[textStr rangeOfString:skill]];
    self.contentLb.attributedText = atti;
    
    
    
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
