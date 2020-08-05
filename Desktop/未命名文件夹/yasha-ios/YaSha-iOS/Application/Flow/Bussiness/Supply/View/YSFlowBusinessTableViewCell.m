//
//  YSFlowBusinessTableViewCell.m
//  YaSha-iOS
//
//  Created by YaSha_Tom on 2017/11/21.
//

#import "YSFlowBusinessTableViewCell.h"

@interface YSFlowBusinessTableViewCell ()

@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *yearLabel;
@property (nonatomic, strong) UILabel *numberLabel;

@end

@implementation YSFlowBusinessTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self initUI];
    }
    return self;
}

- (void)initUI {
    _nameLabel = [[UILabel alloc]init];
    _nameLabel.text = @"名称";
    _nameLabel.textColor = kUIColor(153, 153, 153, 1.0);
    _nameLabel.font = [UIFont systemFontOfSize:16];
    [self.contentView addSubview:_nameLabel];
    [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.contentView.mas_centerY);
        make.left.mas_equalTo(self.contentView.mas_left).offset(15);
        make.size.mas_equalTo(CGSizeMake(120*kWidthScale, 16*kHeightScale));
    }];
    
    
    _yearLabel = [[UILabel alloc]init];
    _yearLabel.text = @"年份";
    _yearLabel.textColor = kUIColor(153, 153, 153, 1.0);
    _yearLabel.font = [UIFont systemFontOfSize:16];
    [self.contentView addSubview:_yearLabel];
    [_yearLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.contentView.mas_centerY);
        make.left.mas_equalTo(_nameLabel.mas_right).offset(10);
        make.size.mas_equalTo(CGSizeMake(40*kWidthScale, 16*kHeightScale));
    }];
    
    _numberLabel = [[UILabel alloc]init];
    _numberLabel.text = @"值";
    _numberLabel.textColor = kUIColor(153, 153, 153, 1.0);
    _numberLabel.textAlignment = NSTextAlignmentCenter;
    _numberLabel.font = [UIFont systemFontOfSize:16];
    [self.contentView addSubview:_numberLabel];
    [_numberLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.contentView.mas_centerY);
        make.right.mas_equalTo(self.contentView.mas_right).offset(-15);
        make.size.mas_equalTo(CGSizeMake(120*kWidthScale, 16*kHeightScale));
    }];
}

- (void)setFlowBusinessData:(NSArray *)array andIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row > 0) {
        _nameLabel.text = array[0];
        _nameLabel.textColor = [UIColor blackColor];
        _yearLabel.text = [YSUtility timestampSwitchTime:array[1] andFormatter:@"yyyy"];
        _yearLabel.textColor = [UIColor blackColor];
        _numberLabel.text = array[2];
        _numberLabel.textColor = [UIColor blackColor];
    }
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
