//
//  YSPMSPlanStartsCell.m
//  YaSha-iOS
//
//  Created by YaSha_Tom on 2017/9/26.
//

#import "YSPMSPlanStartsCell.h"

@interface YSPMSPlanStartsCell ()

@property (nonatomic, strong) UILabel *titlelabel;
@property (nonatomic, strong) UILabel *percentageLabel;
@property (nonatomic, strong) UILabel *addresslabel;
@property (nonatomic, strong) QMUIButton *timeButton;
@property (nonatomic, strong) UILabel *stateLabel;
@property (nonatomic, strong) UILabel *delayTimeLabel;

@end

@implementation YSPMSPlanStartsCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle: style reuseIdentifier:reuseIdentifier]) {
        
        [self initUI];
    }
    return self;
}

- (void)initUI {
    self.titlelabel = [[UILabel alloc]init];
    self.titlelabel.font = [UIFont systemFontOfSize:16];
    self.titlelabel.textColor = kUIColor(51, 51, 51, 1);
    self.titlelabel.text = @"蒸汽加气混凝土砌块填充砌体工程";
    [self.contentView addSubview:self.titlelabel];
    [self.titlelabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.contentView.mas_top).offset(16);
        make.left.mas_equalTo(self.contentView.mas_left).offset(14);
        make.size.mas_equalTo(CGSizeMake(259*kWidthScale, 16*kHeightScale));
    }];
    
    self.percentageLabel = [[UILabel alloc]init];
    self.percentageLabel.font = [UIFont systemFontOfSize:16];
    self.percentageLabel.textColor = kUIColor(42, 139, 220, 1);
    self.percentageLabel.textAlignment = NSTextAlignmentRight;
    self.percentageLabel.text = @"100%";
    [self.contentView addSubview:self.percentageLabel];
    [self.percentageLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.contentView.mas_top).offset(19);
       make.right.mas_equalTo(self.contentView.mas_right).offset(-15);
        make.size.mas_equalTo(CGSizeMake(44*kWidthScale, 13*kHeightScale));
    }];
    
    self.addresslabel = [[UILabel alloc]init];
    self.addresslabel.font = [UIFont systemFontOfSize:12];
    self.addresslabel.textColor = kUIColor(153, 153, 153, 1);
    self.addresslabel.text = @"1号楼";
    [self.contentView addSubview:self.addresslabel];
    [self.addresslabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.titlelabel.mas_bottom).offset(15);
        make.left.mas_equalTo(self.contentView.mas_left).offset(15);
        make.size.mas_equalTo(CGSizeMake(100*kWidthScale, 15*kHeightScale));
    }];
    
    self.timeButton = [[QMUIButton alloc]init];
    self.timeButton.titleLabel.font = [UIFont systemFontOfSize:12];
    [self.timeButton setTitleColor:kUIColor(153, 153, 153, 1) forState:UIControlStateNormal];
    [self.timeButton setImage:[UIImage imageNamed:@"电话"] forState:UIControlStateNormal];
    [self.timeButton setTitle:@"2017.10.30" forState:UIControlStateNormal];
    //设置button文字的位置
    self.timeButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
//    //调整与边距的距离
//    self.timeButton.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 10);
    self.timeButton.imagePosition = QMUIButtonImagePositionLeft;
    self.timeButton.spacingBetweenImageAndTitle = 8;
    [self.contentView addSubview:self.timeButton];
    [self.timeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.percentageLabel.mas_bottom).offset(15);
        make.right.mas_equalTo(self.contentView.mas_right).offset(-15);
            make.size.mas_equalTo(CGSizeMake(100*kWidthScale, 15*kHeightScale));
    }];
    
    self.stateLabel = [[UILabel alloc]init];
    self.stateLabel.font = [UIFont systemFontOfSize:12];
    self.stateLabel.textColor = [UIColor redColor];
    self.stateLabel.text = @"未开工";
    [self.contentView addSubview:self.stateLabel];
    [self.stateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.addresslabel.mas_bottom).offset(8);
        make.left.mas_equalTo(self.contentView.mas_left).offset(15);
        make.size.mas_equalTo(CGSizeMake(100*kWidthScale, 15*kHeightScale));
    }];
    
    self.delayTimeLabel = [[UILabel alloc]init];
    self.delayTimeLabel.font = [UIFont systemFontOfSize:12];
    self.delayTimeLabel.textColor = [UIColor redColor];
    self.delayTimeLabel.text = @"开工延期13天";
    self.delayTimeLabel.textAlignment = NSTextAlignmentRight;
    [self.contentView addSubview:self.delayTimeLabel];
    [self.delayTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.timeButton.mas_bottom).offset(8);
        make.right.mas_equalTo(self.contentView.mas_right).offset(-15);
        make.size.mas_equalTo(CGSizeMake(100*kWidthScale, 15*kHeightScale));
    }];
    
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
