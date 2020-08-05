//
//  YSPMSPlanHeaderView.m
//  YaSha-iOS
//
//  Created by YaSha_Tom on 2017/9/28.
//

#import "YSPMSPlanHeaderView.h"
#import <PNChart.h>

@interface YSPMSPlanHeaderView ()

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *lineLabel;
@property (nonatomic, strong) PNCircleChart *circleChart;
@property (nonatomic, strong) UILabel *infoLabel;

@end

@implementation YSPMSPlanHeaderView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self initUI];
    }
    return self;
}

- (void)initUI {
    self.titleLabel = [[UILabel alloc]init];
    self.titleLabel.text = @"一层、会议室、多功能室、墙柱面、卫生间厨房餐厅";
    self.titleLabel.font = [UIFont systemFontOfSize:16];
    self.titleLabel.numberOfLines = 0;
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.titleLabel.textColor = kUIColor(126, 126, 126, 1);
    self.titleLabel.adjustsFontSizeToFitWidth = YES;
    [self addSubview:self.titleLabel];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.mas_top).offset(10);
        make.centerX.mas_equalTo(self.mas_centerX);
        make.size.mas_equalTo(CGSizeMake(kSCREEN_WIDTH-80*kHeightScale, 60*kHeightScale));
    }];
    
    self.lineLabel = [[UILabel alloc]init];
    self.lineLabel.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [self addSubview:self.lineLabel];
    [self.lineLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.titleLabel.mas_bottom);
        make.size.mas_equalTo(CGSizeMake(kSCREEN_WIDTH, 1));
    }];
    
    self.circleChart = [[PNCircleChart alloc] initWithFrame:CGRectMake(-100, 110.0, SCREEN_WIDTH, 100.0) total:@100 current:@0 clockwise:YES shadow:YES shadowColor:[UIColor groupTableViewBackgroundColor]];
    self.circleChart.backgroundColor = [UIColor whiteColor];
    [self.circleChart setStrokeColor:[UIColor redColor]];
    //        [self.circleChart setStrokeColorGradientStart:[UIColor redColor]];
    [self.circleChart strokeChart];
    [self addSubview:self.circleChart];
    
    
    for (int i = 0; i < 4; i ++ ) {
        self.infoLabel = [[UILabel alloc]init];
        self.infoLabel.text = @"计划开工时间：2017.08.15";
        self.infoLabel.font = [UIFont systemFontOfSize:13];
        self.infoLabel.tag = i + 5;
        self.infoLabel.textColor = kUIColor(126, 126, 126, 1);
        [self addSubview:self.infoLabel];
        [self.infoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.mas_top).offset((105 + 30*i) *kHeightScale);
            make.left.mas_equalTo(self.mas_left).offset(182*kWidthScale);
            make.size.mas_equalTo(CGSizeMake(159*kWidthScale, 20*kHeightScale));
        }];
    }
}


- (void) setData:(NSDictionary *)dic {
    DLog(@"======%@------%@---------%@",dic[@"taskDefineName"],dic[@"pileName"],dic[@"areaName"]);
    if (dic != nil) {
        self.titleLabel.text = [NSString stringWithFormat:@"%@%@%@%@%@%@%@\n%@",dic[@"consName"],[dic[@"consName"] isEqual:@""] ? @"":@",",dic[@"pileName"],[dic[@"pileName"] isEqual:@""] ? @"":@",",dic[@"areaName"],[dic[@"areaName"] isEqual:@""] ? @"":@",",dic[@"taskDefineName"],dic[@"taskDefineRemarks"]];
        DLog(@"======%@",dic[@"progressRatio"]);
        [self.circleChart updateChartByCurrent:[dic[@"completRatio"] isEqual:[NSNull null] ]? @0 : @([dic[@"completRatio"] intValue])];
        for(int i = 5 ; i < 9; i ++){
            UILabel *label = (UILabel *) [self viewWithTag:i];
            switch (label.tag) {
                case 5:
                    label.text = [NSString stringWithFormat:@"责任人：%@",dic[@"personLiableName"]];
                    break;
                case 6:
                    label.text = [NSString stringWithFormat:@"计划开工时间 : %@",[YSUtility timestampSwitchTime:dic[@"planStartDate"] andFormatter:@"yyyy.MM.dd"]];
                    break;
                case 7:
                    label.text = [NSString stringWithFormat:@"计划完工时间 : %@",[YSUtility timestampSwitchTime:dic[@"planEndDate"] andFormatter:@"yyyy.MM.dd"]];
                    break;
                case 8:
                    label.text = [NSString stringWithFormat:@"完工延期 : %d天",[dic[@"outDayNumber"] isEqual:[NSNull null]] ? 0 : abs([dic[@"outDayNumber"] intValue])];
                    break;
                    
                default:
                    break;
            }
           
        }
    }
}

@end
