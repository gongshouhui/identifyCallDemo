//
//  YSSalaryRemarkCell.m
//  YaSha-iOS
//
//  Created by 蘑菇加 on 2017/11/25.
//

#import "YSSalaryRemarkCell.h"
@interface YSSalaryRemarkCell()

@end
@implementation YSSalaryRemarkCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self initUI];
        
    }
    return self;
}
- (void)initUI{
    self.backgroundColor = kUIColor(229, 229, 229, 1);
    UIView *bgView = [[UIView alloc]init];
    bgView.layer.masksToBounds = YES;
    bgView.layer.cornerRadius = 10;
    bgView.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:bgView];
    [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.right.mas_equalTo(-15);
        make.top.bottom.mas_equalTo(0);
    }];
    self.remarkLb = [[UILabel alloc]init];
    self.remarkLb.numberOfLines = 0;
    self.remarkLb.textColor = kUIColor(51, 51, 51, 1);
    self.remarkLb.font = [UIFont systemFontOfSize:14];
    [bgView addSubview:self.remarkLb];
    [self.remarkLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(18);
        make.top.mas_equalTo(15);
        make.right.mas_equalTo(-15);
        make.bottom.mas_equalTo(-15);
    }];
    

}
- (void)setDic:(NSDictionary *)dic{
    _dic = dic;
    self.remarkLb.text = dic[@"remark"];
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
