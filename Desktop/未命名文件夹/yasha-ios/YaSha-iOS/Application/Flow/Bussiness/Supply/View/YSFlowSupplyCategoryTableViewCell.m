//
//  YSFlowSupplyCategoryTableViewCell.m
//  YaSha-iOS
//
//  Created by YaSha_Tom on 2017/11/18.
//

#import "YSFlowSupplyCategoryTableViewCell.h"

@interface YSFlowSupplyCategoryTableViewCell ()

@property (nonatomic, strong) UILabel *titleLabel;



@end

@implementation YSFlowSupplyCategoryTableViewCell


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self initUI];
    }
    return self;
}

- (void)initUI {
    
    _titleLabel = [[UILabel alloc]init];
    _titleLabel.numberOfLines = 0;
    _titleLabel.text = @"装饰 非标准品 粘合剂类";
    _titleLabel.textColor = kUIColor(51, 51, 51, 1.0);
    
    _titleLabel.adjustsFontSizeToFitWidth = YES;
    [self.contentView addSubview:_titleLabel];
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.contentView.mas_left).offset(15);
        make.top.mas_equalTo(self.contentView.mas_top).offset(8);
        make.size.mas_equalTo(CGSizeMake(kSCREEN_WIDTH-30, 30*kHeightScale));
    }];
    
    _cententLabel = [[UILabel alloc]init];
    _cententLabel.numberOfLines = 0;
    _cententLabel.font = [UIFont systemFontOfSize:15];
    _cententLabel.text = @"801胶水,502胶水,901胶水,108胶水,AB胶,泡沫玻璃专用粘结剂,云石胶,密封胶,sika灌浆料,界面处理剂,封口胶";
    _cententLabel.textColor = kUIColor(153, 153, 153, 1.0);
    _cententLabel.adjustsFontSizeToFitWidth = YES;
    [self.contentView addSubview:_cententLabel];
    [_cententLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.contentView.mas_left).offset(15);
        make.top.mas_equalTo(_titleLabel.mas_bottom).offset(5);
        make.right.mas_equalTo(self.contentView.mas_right).offset(-15);
        make.bottom.mas_equalTo(self.contentView.mas_bottom).offset(-5);
    }];
    
}

- (void)setFlowSupplyCategoryData:(NSArray *)array andIndexPath:(NSIndexPath *)indexPath {
    
    _titleLabel.text = [NSString stringWithFormat:@"%@   %@  %@",array[0],array[1],array[2]];
    _titleLabel.font = [UIFont fontWithName:@"PingFang-SC-Bold" size:16.f];
    _cententLabel.text = array[3];
    
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
