//
//  YSFlowSupplyTableViewCell.m
//  YaSha-iOS
//
//  Created by YaSha_Tom on 2017/11/18.
//

#import "YSFlowSupplyTableViewCell.h"

@interface YSFlowSupplyTableViewCell ()

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *companyLabel;
@property (nonatomic, strong) UIImageView *companyImageView;
@property (nonatomic, strong) UILabel *stateLabel;

@end

@implementation YSFlowSupplyTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self initUI];
    }
    return self;
}

- (void)initUI {
    _titleLabel = [[UILabel alloc]init];
    _titleLabel.text = @"中国某某某某某某某某某项目";
    _titleLabel.numberOfLines = 0;
    _titleLabel.textAlignment = NSTextAlignmentLeft;
    _titleLabel.font = [UIFont systemFontOfSize:16];
//    _titleLabel.adjustsFontSizeToFitWidth = YES;
    [self.contentView addSubview:_titleLabel];
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.mas_equalTo(self.contentView.mas_left).offset(16);
//        make.top.mas_equalTo(self.contentView.mas_top).offset(8);
//        make.size.mas_equalTo(CGSizeMake(280*kWidthScale, 30*kHeightScale));
        make.left.mas_equalTo(self.contentView.mas_left).offset(30);
        make.top.mas_equalTo(self.contentView.mas_top).offset(8);
        make.right.mas_equalTo(self.contentView.mas_right).offset(-80*kHeightScale);
        make.height.mas_greaterThanOrEqualTo(0);
       
    }];
    
    _stateLabel = [[UILabel alloc]init];
    _stateLabel.text = @"【有效】";
    _stateLabel.textColor = kUIColor(42, 138, 219, 1.0);
    _stateLabel.font = [UIFont systemFontOfSize:14];
    [self.contentView addSubview:_stateLabel];
    [_stateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_titleLabel.mas_right).offset(10);
        make.top.mas_equalTo(self.contentView.mas_top).offset(8);
        make.size.mas_equalTo(CGSizeMake(80*kWidthScale, 20*kHeightScale));
    }];
    
    _companyImageView = [[UIImageView alloc]init];
    _companyImageView.image = [UIImage imageNamed:@"公司"];
    _titleLabel.font = [UIFont systemFontOfSize:16];
    [self.contentView addSubview:_companyImageView];
    [_companyImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.contentView.mas_left).offset(15);
        make.top.mas_equalTo(_titleLabel.mas_bottom).offset(8);
        make.size.mas_equalTo(CGSizeMake(14*kWidthScale, 14*kHeightScale));
    }];
    
    _companyLabel = [[UILabel alloc]init];
    _companyLabel.text = @"中国某某某某某公司-2017";
    _companyLabel.numberOfLines = 0;
    _companyLabel.font = [UIFont systemFontOfSize:16];
    _companyLabel.adjustsFontSizeToFitWidth = YES;
    [self.contentView addSubview:_companyLabel];
    [_companyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_companyImageView.mas_right).offset(6);
        make.top.mas_equalTo(_titleLabel.mas_bottom).offset(3);
        make.right.mas_equalTo(self.contentView.mas_right).offset(-10);
        make.bottom.mas_equalTo(self.contentView.mas_bottom).offset(-10);
    }];
    
}

- (void)setFlowSupplyData:(NSArray *)array andIndexPath:(NSIndexPath *)indexPath {
    _titleLabel.text = array[2];
    _stateLabel.text = [NSString stringWithFormat:@"【%@】",array[1]] ;
    _companyLabel.text = [NSString stringWithFormat:@"%@ - %@",array[0],[YSUtility timestampSwitchTime:array[3] andFormatter:@"yyyy"]];
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
