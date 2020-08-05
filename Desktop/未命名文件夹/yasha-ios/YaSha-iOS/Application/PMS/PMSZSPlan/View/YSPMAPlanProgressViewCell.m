//
//  YSPMAPlanProgressViewCell.m
//  YaSha-iOS
//
//  Created by YaSha_Tom on 2017/10/10.
//

#import "YSPMAPlanProgressViewCell.h"
#import "YSPMSPlanProgressModel.h"

@interface YSPMAPlanProgressViewCell ()

@property (nonatomic, strong) NSString *progressValue;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *progressLabel;
@property (nonatomic, strong) UIView *progressBarViewBottom;
@property (nonatomic, strong) UIView *progressBarViewTop;
@property (nonatomic, strong) UIColor *progressColor;
@property (nonatomic, strong) UIColor *bottomColor;
@property (nonatomic, assign) CGFloat time;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *timeLabel;

@end

@implementation YSPMAPlanProgressViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self initUI];
    }
    return self;
}

- (void)initUI{
   
    self.progressBarViewBottom = [[UIView alloc]init];
    self.progressBarViewBottom.backgroundColor = [UIColor groupTableViewBackgroundColor];
    self.progressBarViewBottom.layer.cornerRadius = 3;
    self.progressBarViewBottom.layer.masksToBounds = YES;
    [self addSubview:self.progressBarViewBottom];
    [self.progressBarViewBottom mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.contentView.mas_centerY);
        make.left.mas_equalTo(self.progressLabel.mas_right).offset(15*kWidthScale);
        make.size.mas_equalTo(CGSizeMake(158*kWidthScale, 6*kHeightScale));
    }];
    
    self.progressBarViewTop = [[UIView alloc]init];
    self.progressBarViewTop.backgroundColor = kUIColor(42, 138, 219, 1);
    self.progressBarViewTop.layer.cornerRadius = 3;
    self.progressBarViewTop.layer.masksToBounds = YES;
    [self.progressBarViewBottom addSubview:self.progressBarViewTop];
    [self.progressBarViewTop mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.mas_equalTo(self.progressBarViewBottom);
        make.height.mas_equalTo(6);
    }];
    
    self.progressLabel = [[UILabel alloc]init];
    self.progressLabel.font = [UIFont systemFontOfSize:14];
    self.progressLabel.textColor = kUIColor(42, 138, 219, 1);
//    self.progressLabel.text = @"80%";
    [self addSubview:self.progressLabel];
    [self.progressLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.contentView.mas_centerY);
        make.left.mas_equalTo(self.progressBarViewBottom.mas_right).offset(20*kWidthScale);
        make.size.mas_equalTo(CGSizeMake(34*kWidthScale, 15*kHeightScale));
    }];
    
    self.nameLabel = [[UILabel alloc]init];
    self.nameLabel.font = [UIFont systemFontOfSize:14];
    self.nameLabel.textColor = kUIColor(126, 126, 126, 1.0);
//    self.nameLabel.text = @"张三";
    [self.contentView addSubview:self.nameLabel];
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.contentView.mas_centerY);
        make.left.mas_equalTo(self.progressLabel.mas_right).offset(5);
        make.size.mas_equalTo(CGSizeMake(60*kWidthScale, 14*kHeightScale));
    }];
    
    self.timeLabel = [[UILabel alloc]init];
    self.timeLabel.font = [UIFont systemFontOfSize:14];
    self.timeLabel.textColor = kUIColor(126, 126, 126, 1.0);
//    self.timeLabel.text = @"2017-08";
    [self.contentView addSubview:self.timeLabel];
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.contentView.mas_centerY);
        make.left.mas_equalTo(self.nameLabel.mas_right).offset(10);
        make.size.mas_equalTo(CGSizeMake(60*kWidthScale, 14*kHeightScale));
    }];
}

- (void)setPlanProgressCellData:(YSPMSPlanProgressModel *)model {
    self.progressLabel.text = [NSString stringWithFormat:@"%@%@",model.percent,@"%"];
    self.nameLabel.text = model.creator;
    DLog(@"======%@",model.planInfoProgreeDate);
    self.timeLabel.text = [YSUtility timestampSwitchTime:model.planInfoProgreeDate andFormatter:@"yyyy-MM"];
    [UIView animateWithDuration:_time animations:^{
        [self.progressBarViewTop mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.top.mas_equalTo(self.progressBarViewBottom);
            make.size.mas_equalTo(CGSizeMake(158*kWidthScale*[model.percent floatValue]/100, 6*kHeightScale));
        }];
    }];
    self.progressBarViewBottom.backgroundColor = [UIColor groupTableViewBackgroundColor];
    self.progressBarViewTop.backgroundColor = kUIColor(42, 138, 219, 1);
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
