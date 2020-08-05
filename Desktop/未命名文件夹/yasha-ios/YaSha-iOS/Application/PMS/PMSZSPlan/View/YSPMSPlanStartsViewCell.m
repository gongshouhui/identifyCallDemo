//
//  YSPMSPlanStartsViewCell.m
//  YaSha-iOS
//
//  Created by YaSha_Tom on 2017/9/27.
//

#import "YSPMSPlanStartsViewCell.h"
#import "YSPMSPlanListModel.h"
@interface YSPMSPlanStartsViewCell ()

@property (nonatomic, strong) UILabel *titlelabel;
@property (nonatomic, strong) UILabel *percentageLabel;
@property (nonatomic, strong) UILabel *blockNumLb;
@property (nonatomic,strong) UILabel *floorNumLb;
@property (nonatomic,strong) UILabel *roomLb;

/**
 责任人
 */
@property (nonatomic,strong)UILabel *dutyLb;

@property (nonatomic,strong)UILabel *timeLb;

@property (nonatomic, strong) QMUIButton *timeButton;
@property (nonatomic, strong) UILabel *stateLabel;
@property (nonatomic, strong) UILabel *delayTimeLabel;

@end

@implementation YSPMSPlanStartsViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle: style reuseIdentifier:reuseIdentifier]) {
        
        [self initUI];
    }
    return self;
}

- (void)initUI {
    UIView *sepView = [[UIView alloc]init];
    sepView.backgroundColor = kUIColor(245, 245, 245, 1);
    [self.contentView addSubview:sepView];
    [sepView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.mas_offset(0);
        make.height.mas_equalTo(10);
    }];
    //标题
    self.titlelabel = [[UILabel alloc]init];
    self.titlelabel.font = [UIFont systemFontOfSize:16];
    self.titlelabel.textColor = kUIColor(51, 51, 51, 1);
    [self.contentView addSubview:self.titlelabel];
    [self.titlelabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(sepView.mas_bottom).offset(14);
        make.left.mas_equalTo(14);
        // make.size.mas_equalTo(CGSizeMake(259*kWidthScale, 16*kHeightScale));
    }];
    
    //百分比
    self.percentageLabel = [[UILabel alloc]init];
    self.percentageLabel.backgroundColor = kUIColor(229, 241, 251, 1);
    self.percentageLabel.layer.cornerRadius = 20*kHeightScale*0.5;
    self.percentageLabel.layer.masksToBounds = YES;
    self.percentageLabel.font = [UIFont systemFontOfSize:16];
    self.percentageLabel.textColor = kUIColor(42, 139, 220, 1);
    self.percentageLabel.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:self.percentageLabel];
    [self.percentageLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(sepView.mas_bottom).offset(14);
        make.right.mas_equalTo(-15);
        //make.size.mas_equalTo(CGSizeMake(44*kWidthScale, 20*kHeightScale));
    }];
    //分割线
    UIView *sepLineView = [[UIView alloc]init];
    sepLineView.backgroundColor = kUIColor(234, 234, 234, 1);
    [self.contentView addSubview:sepLineView];
    [sepLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.titlelabel.mas_bottom).mas_equalTo(14);
        make.left.right.mas_equalTo(0);
        make.height.mas_equalTo(1);
    }];
    
    
    //楼号
    self.blockNumLb = [[UILabel alloc]init];
    self.blockNumLb.font = [UIFont systemFontOfSize:12];
    self.blockNumLb.textColor = kUIColor(51, 51, 51, 1);
    [self.contentView addSubview:self.blockNumLb];
    [self.blockNumLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(sepLineView.mas_bottom).offset(15);
        make.left.mas_equalTo(15);
        make.width.greaterThanOrEqualTo(@30);
        
        //make.size.mas_equalTo(CGSizeMake(100*kWidthScale, 15*kHeightScale));
    }];
    
    //楼层
    self.floorNumLb = [[UILabel alloc]init];
    self.floorNumLb.font = [UIFont systemFontOfSize:12];
    self.floorNumLb.textColor = kUIColor(51, 51, 51, 1);
    [self.contentView addSubview:self.floorNumLb];
    [self.floorNumLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.blockNumLb.mas_centerY);
        make.left.mas_equalTo(self.blockNumLb.mas_right);
        make.width.greaterThanOrEqualTo(@30);
        
    }];
    
    //房间
    self.roomLb = [[UILabel alloc]init];
    //[self.roomLb setContentHuggingPriority:(UILayoutPriorityDefaultHigh) forAxis:(UILayoutConstraintAxisHorizontal)];
    self.roomLb.font = [UIFont systemFontOfSize:12];
    self.roomLb.textColor = kUIColor(51, 51, 51, 1);
    [self.contentView addSubview:self.roomLb];
    [self.roomLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.blockNumLb.mas_centerY);
        //make.left.mas_equalTo(self.floorNumLb.mas_right);
        //make.right.mas_equalTo(-15);
        make.left.mas_equalTo(self.floorNumLb.mas_right);
        make.width.greaterThanOrEqualTo(@30);
        
        
        
    }];
    
    //责任人:(153灰)
    self.dutyLb = [[UILabel alloc]init];
    self.dutyLb.font = [UIFont systemFontOfSize:12];
    self.dutyLb.textColor = kUIColor(51, 51, 51, 1);
    [self.contentView addSubview:self.dutyLb];
    [self.dutyLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.top.mas_equalTo(self.blockNumLb.mas_bottom).mas_equalTo(10);
        
    }];
    //计划开工
    
    self.timeLb = [[UILabel alloc]init];
    self.timeLb.font = [UIFont systemFontOfSize:12];
    self.timeLb.textColor = kUIColor(51, 51, 51, 1);
    [self.contentView addSubview:self.timeLb];
    [self.timeLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.top.mas_equalTo(self.dutyLb.mas_bottom).mas_equalTo(10);
    }];
    
    self.stateLabel = [[UILabel alloc]init];
    self.stateLabel.font = [UIFont systemFontOfSize:12];
    self.stateLabel.textColor = [UIColor redColor];
    //    self.stateLabel.text = @"未开工";
    [self.contentView addSubview:self.stateLabel];
    [self.stateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.timeLb.mas_bottom).offset(8);
        make.left.mas_equalTo(15);
    }];
    
    self.delayTimeLabel = [[UILabel alloc]init];
    self.delayTimeLabel.font = [UIFont systemFontOfSize:12];
    self.delayTimeLabel.textColor = [UIColor redColor];
    //    self.delayTimeLabel.text = @"开工延期13天";
    self.delayTimeLabel.textAlignment = NSTextAlignmentRight;
    [self.contentView addSubview:self.delayTimeLabel];
    [self.delayTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.stateLabel.mas_centerY);
        make.right.mas_equalTo(-15);
    }];
    
    
    
}

- (void)setPlanStartsCellData:(YSPMSPlanListModel *)model  {
    
    if (model.taskDefineRemarks.length <= 0) {
        self.titlelabel.text = [NSString stringWithFormat:@"%@",model.taskDefineName];
    }else{
        self.titlelabel.text = [NSString stringWithFormat:@"%@(%@)",model.taskDefineName,model.taskDefineRemarks];
    }
    
    self.percentageLabel.text = [NSString stringWithFormat:@" %@%@%@",model.progressRatio == nil  ? @"0" : model.progressRatio ,@"%",@"    "];
    //if (model.consName.length > 0) {
    self.blockNumLb.text = model.consName.length > 0?[NSString stringWithFormat:@"%@",model.consName]:nil;
    //}
    //if (model.pileName.length > 0) {
    self.floorNumLb.text = model.pileName.length > 0?[NSString stringWithFormat:@" + %@",model.pileName]:nil;
    //}
    // if (model.areaName.length > 0) {
    self.roomLb.text = model.areaName.length > 0?[NSString stringWithFormat:@" + %@",model.areaName]:nil;
    //   }
    CGFloat width1 = [self.blockNumLb.text sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]}].width;
    CGFloat width2 = [self.floorNumLb.text sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]}].width;
    CGFloat width3 = [self.roomLb.text sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]}].width;
    if ((width1 + width2 + width3) > kSCREEN_WIDTH - 30 -15) {
        if (width1 > (kSCREEN_WIDTH - 30)/3) {
            [self.blockNumLb mas_updateConstraints:^(MASConstraintMaker *make) {
                make.width.mas_equalTo((kSCREEN_WIDTH - 30)/3);
            }];
        }
        if (width2 > (kSCREEN_WIDTH - 30)/3) {
            [self.floorNumLb mas_updateConstraints:^(MASConstraintMaker *make) {
                make.width.mas_equalTo((kSCREEN_WIDTH - 30)/3);
            }];
        }
        if (width3 > (kSCREEN_WIDTH - 30)/3) {
            [self.roomLb mas_updateConstraints:^(MASConstraintMaker *make) {
                make.width.mas_equalTo((kSCREEN_WIDTH - 30)/3);
            }];
        }
    }else{
        [self.blockNumLb mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(width1 + 5);
        }];
        [self.floorNumLb mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(width2 + 5);
        }];
        [self.roomLb mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(width3 + 5);
        }];
        
    }
    
    //负责人
    if (!model.personLiableName.length) {
        model.personLiableName = @" ";
    }
    NSString *dutyStr = [NSString stringWithFormat:@"负责人： %@",model.personLiableName];
    NSMutableAttributedString *dutyAtti = [[NSMutableAttributedString alloc]initWithString:dutyStr];
    [dutyAtti addAttributes:@{NSForegroundColorAttributeName:kUIColor(153, 153, 153, 1)} range:[dutyStr rangeOfString:model.personLiableName]];
    self.dutyLb.attributedText = dutyAtti;
    
    
    if ([model.taskStatus isEqual:@"10"]) {
        self.stateLabel.text = @"未开工";
        NSString *title = @"计划开工：";
        NSString *time = [YSUtility timestampSwitchTime:model.planStartDate andFormatter:@"yyyy-MM-dd"];
        NSString *allStr = [NSString stringWithFormat:@"%@ %@",title,time];
        NSMutableAttributedString *attiStr = [[NSMutableAttributedString alloc]initWithString:allStr];
        [attiStr addAttributes:@{NSForegroundColorAttributeName:kUIColor(153, 153, 153, 1)} range:[allStr rangeOfString:time]];
        self.timeLb.attributedText = attiStr;
        DLog(@"======%@",model.outDayNumber);
        if([model.outDayNumber intValue] < 0) {
            self.delayTimeLabel.text = [NSString stringWithFormat:@"开工延期%d天",abs([model.outDayNumber intValue])];
        }else{
            self.delayTimeLabel.text = [NSString stringWithFormat:@"开工剩余%@天",model.outDayNumber == nil ? @0:@(abs([model.outDayNumber intValue]))
                                        ];
        }
    }else if ([model.taskStatus isEqual:@"20"]) {
        self.stateLabel.text = @"进行中";
        NSString *title = @"计划完工：";
        NSString *time = [YSUtility timestampSwitchTime:model.planEndDate andFormatter:@"yyyy-MM-dd"];
        NSString *allStr = [NSString stringWithFormat:@"%@ %@",title,time];
        NSMutableAttributedString *attiStr = [[NSMutableAttributedString alloc]initWithString:allStr];
        [attiStr addAttributes:@{NSForegroundColorAttributeName:kUIColor(153, 153, 153, 1)} range:[allStr rangeOfString:time]];
        self.timeLb.attributedText = attiStr;
        
        if([model.outDayNumber intValue] < 0) {
            self.delayTimeLabel.text = [NSString stringWithFormat:@"完工延期%d天",abs([model.outDayNumber intValue])];
        }else{
            self.delayTimeLabel.text = [NSString stringWithFormat:@"完工剩余%@天",model.outDayNumber == nil ? @0:@(abs([model.outDayNumber intValue]))
                                        ];
        }
    }else{
        self.stateLabel.text = @"已完工";
        
        NSString *title = @"完工时间：";
        NSString *time = [YSUtility timestampSwitchTime:model.actualEndDate andFormatter:@"yyyy-MM-dd"];
        NSString *allStr = [NSString stringWithFormat:@"%@ %@",title,time];
        NSMutableAttributedString *attiStr = [[NSMutableAttributedString alloc]initWithString:allStr];
        [attiStr addAttributes:@{NSForegroundColorAttributeName:kUIColor(153, 153, 153, 1)} range:[allStr rangeOfString:time]];
        self.timeLb.attributedText = attiStr;
        self.delayTimeLabel.text = @"";//已完工的隐藏延期天数
    }
}
- (void)setEarlyPreparePlanCellData:(YSPMSPlanListModel *)model {
    
    self.titlelabel.text = model.name;
    self.percentageLabel.text = [NSString stringWithFormat:@" %@%@%@",model.graphicProgress == nil  ? @"0" : model.graphicProgress ,@"%",@"    "];
    //任务阶段
    if (!model.parentName.length) {
        model.parentName = @" ";
    }
    NSString *progressStr = [NSString stringWithFormat:@"任务阶段： %@",model.parentName];
    //    NSMutableAttributedString *progressAtti = [[NSMutableAttributedString alloc]initWithString:progressStr];
    //    [progressAtti addAttributes:@{NSForegroundColorAttributeName:kUIColor(153, 153, 153, 1)} range:[progressStr rangeOfString:model.parentName]];
    self.blockNumLb.text = progressStr;
    //负责人
    if (!model.mainPersonName.length) {
        model.mainPersonName = @" ";
    }
    NSString *dutyStr = [NSString stringWithFormat:@"负责人： %@",model.mainPersonName];
    //    NSMutableAttributedString *dutyAtti = [[NSMutableAttributedString alloc]initWithString:dutyStr];
    //    [dutyAtti addAttributes:@{NSForegroundColorAttributeName:kUIColor(153, 153, 153, 1)} range:[dutyStr rangeOfString:model.mainPersonName]];
    self.dutyLb.text = dutyStr;
    //时间
    NSString *title = @"计划时间：";
    NSString *starttTime = [YSUtility timestampSwitchTime:model.planStartDate andFormatter:@"yyyy-MM-dd"];
    NSString *endtime = [YSUtility timestampSwitchTime:model.planEndDate andFormatter:@"yyyy-MM-dd"];
    NSString *startAndEndTime = [NSString stringWithFormat:@"%@-%@",starttTime,endtime];
    NSString *allStr = [NSString stringWithFormat:@"%@ %@",title,startAndEndTime];
    //    NSMutableAttributedString *attiStr = [[NSMutableAttributedString alloc]initWithString:allStr];
    //    [attiStr addAttributes:@{NSForegroundColorAttributeName:kUIColor(153, 153, 153, 1)} range:[allStr rangeOfString:startAndEndTime]];
    self.timeLb.text = allStr;
    
    if ([model.taskStatus isEqual:@"10"]) {
        self.stateLabel.text = @"未开工";
        if([model.outDayNumber intValue] < 0) {
            self.delayTimeLabel.text = [NSString stringWithFormat:@"开工延期%d天",abs([model.outDayNumber intValue])];
        }else{
            self.delayTimeLabel.text = [NSString stringWithFormat:@"开工剩余%@天",model.outDayNumber == nil ? @0:@(abs([model.outDayNumber intValue]))
                                        ];
        }
    }else if ([model.taskStatus isEqual:@"20"]) {
        self.stateLabel.text = @"进行中";
        if([model.outDayNumber intValue] < 0) {
            self.delayTimeLabel.text = [NSString stringWithFormat:@"完工延期%d天",abs([model.outDayNumber intValue])];
        }else{
            self.delayTimeLabel.text = [NSString stringWithFormat:@"完工剩余%@天",model.outDayNumber == nil ? @0:@(abs([model.outDayNumber intValue]))
                                        ];
        }
    }else{
        self.stateLabel.text = @"已完工";
        self.delayTimeLabel.text = @"";//已完工的隐藏延期天数
    }
}
- (void)layoutSubviews
{
    [super layoutSubviews];
    
    
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
