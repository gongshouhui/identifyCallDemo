//
//  YSFlowTenderNewTableViewCell.m
//  YaSha-iOS
//
//  Created by YaSha_Tom on 2018/4/25.
//  Copyright © 2018年 亚厦装饰股份有限公司. All rights reserved.
//



#import "YSFlowTenderNewTableViewCell.h"

@interface YSFlowTenderNewTableViewCell ()
@property (nonatomic, strong) UILabel *levelLabel;
@property (nonatomic, strong) UILabel *companyLabel;
@property (nonatomic, strong) UIImageView *companyImageView;
@property (nonatomic, strong) UIImageView *dropDownImageView;
@property (nonatomic, strong) UILabel *unitLabel;
@end


@implementation YSFlowTenderNewTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self initUI];
    }
    return self;
}

- (void)initUI {
    
    _companyImageView = [[UIImageView alloc]init];
    _companyImageView.image = [UIImage imageNamed:@"公司"];
    [self addSubview:_companyImageView];
    [_companyImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.mas_top).offset(17);
        make.left.mas_equalTo(self.mas_left).offset(14);
        make.size.mas_equalTo(CGSizeMake(13*kWidthScale, 13*kHeightScale));
    }];
    
    _companyLabel = [[UILabel alloc]init];
    _companyLabel.text = @"杭州丽居木业有限公司";
    _companyLabel.numberOfLines = 0;
    _companyLabel.font = [UIFont systemFontOfSize:14];
    [self addSubview:_companyLabel];
    [_companyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.mas_top).offset(17);
        make.left.mas_equalTo(_companyImageView.mas_right).offset(6);
        make.right.mas_equalTo(self.contentView.mas_right).offset(-15);
        make.height.greaterThanOrEqualTo(0);
    }];
    
    _levelLabel = [[UILabel alloc]init];
    _levelLabel.text = @"A级 CNY";
    _levelLabel.font = [UIFont systemFontOfSize:11];
    _levelLabel.textColor = [UIColor grayColor];
    [self addSubview:_levelLabel];
    [_levelLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_companyLabel.mas_bottom).offset(8);
        make.left.mas_equalTo(_companyImageView.mas_right).offset(6);
        make.size.mas_equalTo(CGSizeMake(140*kWidthScale, 11*kHeightScale));
    }];
    
    _unitLabel = [[UILabel alloc]init];
    _unitLabel.text = @"抗衰老的法律塑料袋发牢骚了对方";
    _unitLabel.font = [UIFont systemFontOfSize:11];
    _unitLabel.textColor = [UIColor grayColor];
    [self addSubview:_unitLabel];
    [_unitLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_companyLabel.mas_bottom).offset(8);
        make.left.mas_equalTo(self.levelLabel.mas_right).offset(15);
        make.right.mas_equalTo(self.contentView.mas_right).offset(-15);
        make.height.mas_equalTo(11);
    }];
   
}

- (void) setTenderNewData:(NSDictionary *)dict {
    _companyLabel.text = dict[@"franName"];
    NSString *str = nil;
    if ([dict[@"currency"] isEqual:@"registerCNY"]) {
        str = @"人民币";
    }else if ([dict[@"currency"] isEqual:@"registerUSD"]){
        str = @"美元";
    }
    else if ([dict[@"currency"] isEqual:@"Mark"]){
        str = @"马克";
        
    }else if ([dict[@"currency"] isEqual:@"123"]){
        str = @"港币";
    }else {
        str = @"其他币种";
    }
    _levelLabel.text = [NSString stringWithFormat:@"%@%@       %@",dict[@"admitLevel"],(dict[@"admitLevel"] == nil || [dict[@"admitLevel"] isEqual:@""]|| [dict[@"admitLevel"] isEqual:[NSNull null]])?@"":@"级",str];
    _unitLabel.text = [NSString stringWithFormat:@"推荐单位:%@",dict[@"recommendBy"]];
    
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
