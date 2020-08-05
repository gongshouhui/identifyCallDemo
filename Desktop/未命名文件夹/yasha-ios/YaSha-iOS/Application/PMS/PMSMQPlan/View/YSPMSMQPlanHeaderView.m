//
//  YSPMSMQPlanHeaderView.m
//  YaSha-iOS
//
//  Created by YaSha_Tom on 2018/3/27.
//  Copyright © 2018年 亚厦装饰股份有限公司. All rights reserved.
//

#import "YSPMSMQPlanHeaderView.h"
#import <PNChart.h>

@interface YSPMSMQPlanHeaderView ()

@property (nonatomic, strong) UILabel *bigTitleLabel;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *line1Label;
@property (nonatomic, strong) UILabel *line2Label;
@property (nonatomic, strong) PNCircleChart *circleChart;
@property (nonatomic, strong) UILabel *infoLabel;
@property (nonatomic, strong) UILabel *bigNoteLabel;
@property (nonatomic, strong) UILabel *noteLabel;

@end

@implementation YSPMSMQPlanHeaderView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self initUI];
    }
    return self;
}

- (void)initUI {
    
    self.bigTitleLabel = [[UILabel alloc]init];
    self.bigTitleLabel.text = @"龙骨系统安装";
    self.bigTitleLabel.font = [UIFont systemFontOfSize:20];
    [self addSubview:self.bigTitleLabel];
    [self.bigTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.mas_top).offset(20);
        make.centerX.mas_equalTo(self.mas_centerX);
        make.size.mas_equalTo(CGSizeMake(kSCREEN_WIDTH-40*kWidthScale, 24*kHeightScale));
    }];
    
    self.titleLabel = [[UILabel alloc]init];
    self.titleLabel.text = @"一层、会议室、多功能室、墙柱面、卫生间厨房餐厅";
    self.titleLabel.font = [UIFont systemFontOfSize:13];
    self.titleLabel.numberOfLines = 0;
    self.titleLabel.textColor = kUIColor(126, 126, 126, 1);
    self.titleLabel.adjustsFontSizeToFitWidth = YES;
    [self addSubview:self.titleLabel];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.bigTitleLabel.mas_bottom).offset(10);
        make.centerX.mas_equalTo(self.mas_centerX);
        make.size.mas_equalTo(CGSizeMake(kSCREEN_WIDTH-40*kHeightScale, 40*kHeightScale));
    }];
    
    self.line1Label = [[UILabel alloc]init];
    self.line1Label.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [self addSubview:self.line1Label];
    [self.line1Label mas_makeConstraints:^(MASConstraintMaker *make) {
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
    
    self.line2Label = [[UILabel alloc]init];
    self.line2Label.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [self addSubview:self.line2Label];
    [self.line2Label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.circleChart.mas_bottom).offset(30);
        make.size.mas_equalTo(CGSizeMake(kSCREEN_WIDTH, 1));
    }];
    
    self.bigNoteLabel = [[UILabel alloc]init];
    self.bigNoteLabel.text = @"施工任务备注";
    self.bigNoteLabel.textColor = [UIColor blackColor];
    self.bigNoteLabel.font = [UIFont systemFontOfSize:16];
    [self addSubview:self.bigNoteLabel];
    [self.bigNoteLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.line2Label.mas_bottom).offset(10);
        make.centerX.mas_equalTo(self.mas_centerX);
        make.size.mas_equalTo(CGSizeMake(kSCREEN_WIDTH-40*kWidthScale, 20));
    }];
    
    self.noteLabel = [[UILabel alloc]init];
    self.noteLabel.font = [UIFont systemFontOfSize:13];
    self.noteLabel.textColor = kGrayColor(126);
    self.noteLabel.numberOfLines = 0;
//    self.noteLabel.text = @"打开门水电费看看收到福克斯快乐时空的方式发送了开始调克利夫兰酸辣粉律师代理费了萨菲罗斯律师代理费老师傅了六十多分类酸辣粉";
    [self addSubview:self.noteLabel];
    [self.noteLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.bigNoteLabel.mas_bottom).offset(8);
        make.left.mas_equalTo(self.mas_left).offset(20);
        make.right.mas_equalTo(self.mas_right).offset(-20);
        make.bottom.mas_equalTo(self.mas_bottom).offset(-10);
    }];
}


- (void) setData:(NSDictionary *)dic {
    DLog(@"======%@------%@---------%@",dic[@"taskDefineName"],dic[@"pileName"],dic[@"areaName"]);
    if (dic != nil) {
        self.bigTitleLabel.text = dic[@"taskDefineName"];
        self.noteLabel.text = dic[@"taskNotes"];
        self.titleLabel.text = [NSString stringWithFormat:@"%@%@%@%@%@%@\n%@",dic[@"consName"],[dic[@"consName"] isEqual:@""] ? @"":@",",dic[@"pileName"],[dic[@"pileName"] isEqual:@""] ? @"":@",",dic[@"areaName"],[dic[@"areaName"] isEqual:@""] ? @"":@",",dic[@"taskDefineRemarks"]];
        DLog(@"======%@",dic[@"progressRatio"]);
        [self.circleChart updateChartByCurrent:[dic[@"progressRatio"] isEqual:[NSNull null] ]? @0 : @([dic[@"progressRatio"] intValue])];
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
