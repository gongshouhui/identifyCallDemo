//
//  YSFlowDetailsHeaderView.m
//  YaSha-iOS
//
//  Created by YaSha_Tom on 2018/7/30.
//  Copyright © 2018年 亚厦装饰股份有限公司. All rights reserved.
//

#import "YSFlowDetailsHeaderView.h"
#import "UIView+Extension.h"

@interface YSFlowDetailsHeaderView()
@property (nonatomic,strong) UILabel *titleLabel;
@property (nonatomic,strong) UIButton *departmentTextButton;
@property (nonatomic,strong) UIButton *peopelNameButton;
@property (nonatomic,strong) UILabel *infoLabel;
@end

@implementation YSFlowDetailsHeaderView

- (instancetype)initWithFrame:(CGRect)frame {
    if(self = [super initWithFrame:frame]){
        self.frame = CGRectMake(0, 0, kSCREEN_WIDTH, 160*kHeightScale);
        self.backgroundColor = kUIColor(46, 106, 253, 1);
        [self setGradientBackgroundWithColors:@[kUIColor(84, 106, 253, 1),kUIColor(46, 193, 255, 1)] locations:nil startPoint:CGPointMake(0, 0) endPoint:CGPointMake(1, 0)];
        [self initUI];
    }
    return self;
}

- (void)initUI {
    self.titleLabel = [[UILabel alloc]init];
    self.titleLabel.textColor = [UIColor whiteColor];
    self.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:17];
    self.titleLabel.numberOfLines = 0;
    [self addSubview:self.titleLabel];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.mas_top).offset(10*kHeightScale);
        make.left.mas_equalTo(self.mas_left).offset(16);
        make.right.mas_equalTo(self.mas_right).offset(-16);
        make.height.mas_equalTo(24*kHeightScale);
    }];

    self.departmentTextButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.departmentTextButton.layer.masksToBounds = YES;
    self.departmentTextButton.layer.cornerRadius = 2;
    self.departmentTextButton.backgroundColor = [UIColor colorWithRed:98.0/255.0 green:180.0/255.0 blue:254.0/255.0 alpha:0.26];
    self.departmentTextButton.titleLabel.textColor = [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:0.65];
    self.departmentTextButton.titleLabel.font = [UIFont systemFontOfSize:14];
     [self.departmentTextButton setTitleEdgeInsets:UIEdgeInsetsMake(6, -3, 6, 4)];
    [self addSubview:self.departmentTextButton];
    [self.departmentTextButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.titleLabel.mas_bottom).offset(8*kHeightScale);
        make.left.mas_equalTo(self.mas_left).offset(16);
        make.height.mas_equalTo(20*kHeightScale);
        make.width.mas_equalTo(25*kWidthScale);
    }];
    
    self.peopelNameButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.peopelNameButton.layer.masksToBounds = YES;
    self.peopelNameButton.layer.cornerRadius = 2;
//    [self.peopelNameButton setTitle:@"流程BP：王洪洲" forState:UIControlStateNormal];
    self.peopelNameButton.backgroundColor = [UIColor colorWithRed:98.0/255.0 green:180.0/255.0 blue:254.0/255.0 alpha:0.26];
    self.peopelNameButton.titleLabel.textColor = [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:0.65];
    self.peopelNameButton.titleLabel.font = [UIFont systemFontOfSize:14];
    [self.peopelNameButton setTitleEdgeInsets:UIEdgeInsetsMake(6, -3, 6, 4)];
    [self addSubview:self.peopelNameButton];
    [self.peopelNameButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.titleLabel.mas_bottom).offset(8*kHeightScale);
        make.left.mas_equalTo(self.departmentTextButton.mas_right).offset(8);
        make.width.mas_equalTo(90*kWidthScale);
        make.height.mas_equalTo(20*kHeightScale);
    }];
    

    self.infoLabel = [[UILabel alloc]init];
    self.infoLabel.textColor = [UIColor whiteColor];
    self.infoLabel.font = [UIFont systemFontOfSize:14];
//    self.infoLabel.text = @"周莘羽 / 产品规划部 / 2018-11-11";
    [self addSubview:self.infoLabel];
    [self.infoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.departmentTextButton.mas_bottom).offset(14*kHeightScale);
        make.left.mas_equalTo(self.mas_left).offset(16);
        make.height.mas_equalTo(20*kHeightScale);
    }];
    
//    UIView *lineBottom = [[UIView alloc]init];
//    lineBottom.backgroundColor = [UIColor colorWithRed:25.0/255.0 green:31.0/255.0 blue:37.0/255.0 alpha:0.12];
//    [self addSubview:lineBottom];
//    [lineBottom mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.mas_equalTo(self.infoLabel.mas_bottom).offset(16);
//        make.size.mas_equalTo(CGSizeMake(kSCREEN_WIDTH, 1));
//    }];
    
    
    
    self.flowButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.flowButton setTitle:@"关联流程(0)" forState:UIControlStateNormal];
    self.flowButton.backgroundColor = kUIColor(14, 101, 175, 0.25);
    self.flowButton.titleLabel.font = [UIFont systemFontOfSize:15];
    [self.flowButton setTitleEdgeInsets:UIEdgeInsetsMake(2, 0, 0, -7)];
    [self.flowButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.flowButton.tag = 10;
    [self.flowButton setImage:[UIImage imageNamed:@"ico16-关联流程"] forState:UIControlStateNormal];
    //上 左 下 右
    [self.flowButton setImageEdgeInsets:UIEdgeInsetsMake(8, -10, 4, -7)];
    [self addSubview:self.flowButton];
    [self.flowButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.infoLabel.mas_bottom).offset(17*kHeightScale);
        make.left.mas_equalTo(self.mas_left).offset(0);
        make.size.mas_equalTo(CGSizeMake(kSCREEN_WIDTH/3, 48*kHeightScale));
    }];
    
    UIView *line = [[UIView alloc]init];
    line.backgroundColor = kUIColor(189, 215, 254, 1.0);
    [self addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.flowButton.mas_centerY);
        make.left.mas_equalTo(self.flowButton.mas_right).offset(-1);
        make.size.mas_equalTo(CGSizeMake(1, 20*kHeightScale));
    }];
    
    self.documentButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.documentButton setTitle:@"关联文档(0)" forState:UIControlStateNormal];
    self.documentButton.backgroundColor = kUIColor(14, 101, 175, 0.25);
    self.documentButton.titleLabel.font = [UIFont systemFontOfSize:15];
    [self.documentButton setTitleEdgeInsets:UIEdgeInsetsMake(2, 0, 0, -7)];
    self.documentButton.tag = 20;
    [self.documentButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.documentButton setImage:[UIImage imageNamed:@"ico16-关联文档"] forState:UIControlStateNormal];
    //上 左 下 右
    [self.documentButton setImageEdgeInsets:UIEdgeInsetsMake(8, -10, 4, -7)];
    [self addSubview:self.documentButton];
    [self.documentButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.infoLabel.mas_bottom).offset(17*kHeightScale);
        make.left.mas_equalTo(self.flowButton.mas_right).offset(0);
        make.size.mas_equalTo(CGSizeMake(kSCREEN_WIDTH/3, 48*kHeightScale));
    }];
    
    UIView *line1 = [[UIView alloc]init];
    line1.backgroundColor = kUIColor(189, 215, 254, 1.0);
    [self addSubview:line1];
    [line1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.documentButton.mas_centerY);
        make.left.mas_equalTo(self.documentButton.mas_right).offset(-1);
        make.size.mas_equalTo(CGSizeMake(1, 20*kWidthScale));
    }];
    
    self.chartButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.chartButton setTitle:@"流程视图" forState:UIControlStateNormal];
    self.chartButton.backgroundColor = kUIColor(14, 101, 175, 0.25);
    self.chartButton.titleLabel.font = [UIFont systemFontOfSize:15];
    [self.chartButton setTitleEdgeInsets:UIEdgeInsetsMake(2, 0, 0, -7)];
    [self.chartButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.chartButton.tag = 30;
    [self.chartButton setImage:[UIImage imageNamed:@"ico16-流程视图"] forState:UIControlStateNormal];
    //上 左 下 右
    [self.chartButton setImageEdgeInsets:UIEdgeInsetsMake(8, -10, 4, -7)];
    [self addSubview:self.chartButton];
    [self.chartButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.infoLabel.mas_bottom).offset(17*kHeightScale);
        make.left.mas_equalTo(self.documentButton.mas_right).offset(0);
        make.size.mas_equalTo(CGSizeMake(kSCREEN_WIDTH/3, 48*kHeightScale));
    }];
}
- (void)setHeaderModel:(YSFlowFormHeaderModel *)headerModel {
//    NSString *str = @"开始的看法乐山大佛了临水临电分类数打瞌睡付款了第三轮";
    NSDictionary *attributesTitle = @{NSFontAttributeName:[UIFont systemFontOfSize:17]};
    CGFloat lengthTitle = [headerModel.title boundingRectWithSize:CGSizeMake(343*kWidthScale, 48*kHeightScale) options:NSStringDrawingUsesLineFragmentOrigin attributes:attributesTitle context:nil].size.height;
    DLog(@"========%f",lengthTitle);
    if (lengthTitle > 24) {
        self.frame = CGRectMake(0, 0, kSCREEN_WIDTH, 184*kHeightScale);
        [self.titleLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(48*kHeightScale);
        }];
    }else{
        self.frame = CGRectMake(0, 0, kSCREEN_WIDTH, 160*kHeightScale);
        [self.titleLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(24*kHeightScale);
        }];
    }
    self.titleLabel.text = headerModel.title;
    DLog(@"=========%@",headerModel.ownDeptName);
    NSDictionary *attributes = @{NSFontAttributeName:[UIFont systemFontOfSize:14]};
    CGFloat length = [[NSString stringWithFormat:@"流程归属部门：%@", headerModel.ownDeptName] boundingRectWithSize:CGSizeMake(235*kWidthScale, 24*kHeightScale) options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil].size.width;
    [self.departmentTextButton setTitle:[NSString stringWithFormat:@"流程归属部门：%@", headerModel.ownDeptName] forState:UIControlStateNormal];
    [self.departmentTextButton mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.titleLabel.mas_bottom).offset(8*kHeightScale);
        make.left.mas_equalTo(self.mas_left).offset(16);
        make.height.mas_equalTo(20*kHeightScale);
        make.width.mas_equalTo(length+10);
    }];
    CGFloat lengthTwo = [[NSString stringWithFormat:@"流程BP：%@", headerModel.processDockingName] boundingRectWithSize:CGSizeMake(235*kWidthScale, 24*kHeightScale) options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil].size.width;
     [self.peopelNameButton setTitle:[NSString stringWithFormat:@"流程BP：%@",headerModel.processDockingName]forState:UIControlStateNormal];
    [self.peopelNameButton mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.titleLabel.mas_bottom).offset(8*kHeightScale);
        make.left.mas_equalTo(self.departmentTextButton.mas_right).offset(8);
        make.height.mas_equalTo(20*kHeightScale);
        make.width.mas_equalTo(lengthTwo+10);
    }];
    self.infoLabel.text = [NSString stringWithFormat:@"%@ / %@ / %@",headerModel.sponsor,headerModel.launchDepartment,[YSUtility timestampSwitchTime:headerModel.launchTime andFormatter:@"yyyy-MM-dd"]];
}
@end
