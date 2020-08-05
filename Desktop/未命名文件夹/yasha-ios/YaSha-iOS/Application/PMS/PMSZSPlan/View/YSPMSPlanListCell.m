//
//  YSPMSPlanListCell.m
//  YaSha-iOS
//
//  Created by YaSha_Tom on 2017/9/26.
//

#import "YSPMSPlanListCell.h"
#import "YSPMSPlanListModel.h"

@interface YSPMSPlanListCell ()

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *percentageLabel;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, strong) UILabel *stateLabel;
@property (nonatomic, strong) UILabel *delayTimeLabel;

@end

@implementation YSPMSPlanListCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self initUI];
    }
    return self;
}
- (void)initUI {
    self.titleLabel = [[UILabel alloc]init];
    self.titleLabel.font = [UIFont systemFontOfSize:16];
    self.titleLabel.textColor = kUIColor(51, 51, 51, 1);
//    self.titleLabel.text = @"万丰高科精品园年产30万套汽车冲压...";
    [self.contentView addSubview:self.titleLabel];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.contentView.mas_top).offset(16);
        make.left.mas_equalTo(self.contentView.mas_left).offset(14);
        make.size.mas_equalTo(CGSizeMake(270*kWidthScale, 16*kHeightScale));
    }];
    
    self.percentageLabel = [[UILabel alloc]init];
    self.percentageLabel.font = [UIFont systemFontOfSize:16];
    self.percentageLabel.textColor = kUIColor(42, 139, 220, 1);
//    self.percentageLabel.text = @"80%";
    self.percentageLabel.textAlignment = NSTextAlignmentRight;
    [self.contentView addSubview:self.percentageLabel];
    [self.percentageLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.contentView.mas_top).offset(19);
    make.left.mas_equalTo(self.titleLabel.mas_right).offset(20*kWidthScale);
        make.size.mas_equalTo(CGSizeMake(55*kWidthScale, 13*kHeightScale));
    }];
    
    self.nameLabel = [[UILabel alloc]init];
    self.nameLabel.font = [UIFont systemFontOfSize:12];
    self.nameLabel.textColor = kUIColor(153, 153, 153, 1);
//    self.nameLabel.text = @"自营.费克峰";
    [self.contentView addSubview:self.nameLabel];
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.titleLabel.mas_bottom).offset(14);
    make.left.mas_equalTo(self.contentView.mas_left).offset(15*kWidthScale);
        make.size.mas_equalTo(CGSizeMake(194*kWidthScale, 15*kHeightScale));
    }];
    
    
    self.timeLabel = [[UILabel alloc]init];
    self.timeLabel.font = [UIFont systemFontOfSize:12];
    self.timeLabel.textColor = kUIColor(153, 153, 153, 1);
//    self.timeLabel.text = @"2016.10.01-2017.10.30";
    [self.contentView addSubview:self.timeLabel];
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.titleLabel.mas_bottom).offset(16);
    make.left.mas_equalTo(self.nameLabel.mas_right).offset(30*kWidthScale);
        make.size.mas_equalTo(CGSizeMake(130*kWidthScale, 10*kHeightScale));
    }];
    
    
    self.stateLabel = [[UILabel alloc]init];
    self.stateLabel.font = [UIFont systemFontOfSize:13];
    self.stateLabel.textColor = [UIColor redColor];
//    self.stateLabel.text = @"输入中";
    [self.contentView addSubview:self.stateLabel];
    [self.stateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.nameLabel.mas_bottom).offset(10);
    make.left.mas_equalTo(self.contentView.mas_left).offset(16*kWidthScale);
        make.size.mas_equalTo(CGSizeMake(70*kWidthScale, 15*kHeightScale));
    }];
    
    
    self.delayTimeLabel = [[UILabel alloc]init];
    self.delayTimeLabel.font = [UIFont systemFontOfSize:13];
    self.delayTimeLabel.textColor = [UIColor redColor];
    //    self.stateLabel.text = @"输入中";
    self.delayTimeLabel.textAlignment = NSTextAlignmentRight;
    [self.contentView addSubview:self.delayTimeLabel];
    [self.delayTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.nameLabel.mas_bottom).offset(10);
        make.right.mas_equalTo(self.contentView.mas_right).offset(-16*kWidthScale);
        make.size.mas_equalTo(CGSizeMake(120*kWidthScale, 15*kHeightScale));
    }];
    
}

- (void)setPMSPlanListDataCell:(YSPMSPlanListModel *)model {
    self.titleLabel.text = model.proName;
    DLog(@"=========%@",model.graphicProgress);
    if ([model.graphicProgress floatValue] == 0) {
        self.percentageLabel.text = @"0%";
    }else{
        self.percentageLabel.text = [NSString stringWithFormat:@"%.2f%@",[model.graphicProgress floatValue], @"%"];
    }
    self.nameLabel.text = [NSString stringWithFormat:@"%@.%@.%@",model.proNatureStr,model.proManagerName,model.deptsInfo];
    self.timeLabel.text = [NSString stringWithFormat:@"%@-%@",[YSUtility timestampSwitchTime:model.planStartDate andFormatter:@"yyyy.MM.dd"],[YSUtility timestampSwitchTime:model.planEndDate andFormatter:@"yyyy.MM.dd"]];
    self.stateLabel.text = model.auditStatusStr;
//    self.delayTimeLabel.text = model.outDayNumber == nil ? @"" :[NSString stringWithFormat:@"已延期%@天",model.outDayNumber];
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
