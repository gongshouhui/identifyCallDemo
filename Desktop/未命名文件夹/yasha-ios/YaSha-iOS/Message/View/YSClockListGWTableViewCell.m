//
//  YSClockListGWTableViewCell.m
//  YaSha-iOS
//
//  Created by GZl on 2019/12/21.
//  Copyright © 2019 亚厦装饰股份有限公司. All rights reserved.
//

#import "YSClockListGWTableViewCell.h"

@interface YSClockListGWTableViewCell ()
@property (nonatomic, strong) UILabel *timeTitleLab;
@property (nonatomic, strong) UIImageView *headerImg;
@property (nonatomic, strong) UIImageView *markImg;
@property (nonatomic, strong) UILabel *titleLab;
@property (nonatomic, strong) UILabel *contentLab;


@end

@implementation YSClockListGWTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if ([super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.backgroundColor = [UIColor colorWithHexString:@"#FFFCFCFC"];
        [self loadSubViews];
    }
    return self;
}

- (void)loadSubViews {
    
    _timeTitleLab = [UILabel new];
    _timeTitleLab.text = @"12月21日 09:00";
    _timeTitleLab.textColor = [UIColor colorWithHexString:@"#FF111A34"];
    _timeTitleLab.font = [UIFont fontWithName:@"PingFangSC-Regular" size:Multiply(14)];
    [self.contentView addSubview:_timeTitleLab];
    [_timeTitleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(0);
        make.top.mas_equalTo(30*kHeightScale);
    }];
    
    _headerImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"clockListIcon"]];
    [self.contentView addSubview:_headerImg];
    [_headerImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(16*kWidthScale);
        make.top.mas_equalTo(62*kHeightScale);
        make.size.mas_equalTo(CGSizeMake(50*kWidthScale, 50*kWidthScale));
    }];
    
    UIView *backContentView = [[UIView alloc] init];
    backContentView.backgroundColor = [UIColor colorWithHexString:@"#FFFFFFFF"];
    backContentView.layer.cornerRadius = 4;
    backContentView.layer.borderWidth = 1;
    backContentView.layer.borderColor = [UIColor colorWithHexString:@"#66C5CAD5"].CGColor;
    [self.contentView addSubview:backContentView];
    [backContentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_headerImg.mas_top);
        make.left.mas_equalTo(_headerImg.mas_right).offset(10*kWidthScale);
        make.size.mas_equalTo(CGSizeMake(277*kWidthScale, 136*kHeightScale));
    }];
    
    _markImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"markClockImg"]];
    [backContentView addSubview:_markImg];
    [_markImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(16*kWidthScale);
        make.top.mas_equalTo(23*kHeightScale);
        make.size.mas_equalTo(CGSizeMake(14*kWidthScale, 16*kHeightScale));
    }];
    
    _titleLab = [[UILabel alloc] init];
    _titleLab.textColor = [UIColor colorWithHexString:@"#FF111A34"];
    _titleLab.text = @"打卡周报(12月8日-14日)";
    _titleLab.font = [UIFont fontWithName:@"PingFangSC-Medium" size:Multiply(16)];
    [backContentView addSubview:_titleLab];
    [_titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_markImg.mas_right).offset(10*kWidthScale);
        make.centerY.mas_equalTo(_markImg.mas_centerY);
    }];
    
    _contentLab = [[UILabel alloc] init];
    _contentLab.textColor = [UIColor colorWithHexString:@"#FF666F83"];
    _contentLab.text = @"上周异常考勤共2次";
    _contentLab.font = [UIFont fontWithName:@"PingFangSC-Regular" size:Multiply(14)];
    [backContentView addSubview:_contentLab];
    [_contentLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_markImg.mas_left);
        make.top.mas_equalTo(_markImg.mas_bottom).offset(13*kHeightScale);
    }];
    
    _detailBtn = [[QMUIButton alloc] init];
    [_detailBtn setTitleColor:[UIColor colorWithHexString:@"#FF007AFF"] forState:(UIControlStateNormal)];
    [_detailBtn setTitle:@"查看详情" forState:(UIControlStateNormal)];
    _detailBtn.layer.cornerRadius = 20;
    _detailBtn.layer.borderColor = [UIColor colorWithHexString:@"#66C5CAD5"].CGColor;
    _detailBtn.layer.borderWidth = 1;
    _detailBtn.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:Multiply(16)];
    [backContentView addSubview:_detailBtn];
    [_detailBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_markImg.mas_left);
        make.top.mas_equalTo(_contentLab.mas_bottom).offset(10*kHeightScale);
        make.size.mas_equalTo(CGSizeMake(246*kWidthScale, 40*kHeightScale));
    }];
}

- (void)setModel:(YSMessageClockListModel *)model {
    _model = model;
    self.timeTitleLab.text = [YSUtility timestampSwitchTime:model.sendTime andFormatter:@"yyyy年MM月dd HH:mm"];
    NSString *title = @"打卡周报";
    NSString *detailTile = @"周报详情";
    if (![YSUtility judgeIsEmpty:model.content] && [model.content containsString:@" "]) {
        NSArray *titleArray = [model.content componentsSeparatedByString:@" "];
        title = titleArray[0];
        detailTile = titleArray[1];
    }
    self.titleLab.text = title;
    self.contentLab.text = detailTile;
    //系统的当前时间
    NSString *nowDate = [NSString stringWithFormat:@"%ld", (long)([[NSDate date] timeIntervalSince1970]*1000)];
    
    if ([[YSUtility timestampSwitchTime:model.createTime andFormatter:@"yyyy"] isEqualToString:[YSUtility timestampSwitchTime:nowDate andFormatter:@"yyyy"]]) {
        //同年
        if ([[YSUtility timestampSwitchTime:model.createTime andFormatter:@"yyyy年MM月dd"] isEqualToString:[YSUtility timestampSwitchTime:nowDate andFormatter:@"yyyy年MM月dd"]]) {
            // 同天
            self.timeTitleLab.text = [YSUtility timestampSwitchTime:model.createTime andFormatter:@"HH:mm"];
            
        }else {
            //不同天
            self.timeTitleLab.text = [YSUtility timestampSwitchTime:model.createTime andFormatter:@"MM月dd HH:mm"];
        }
    }else {
        //不同年
        self.timeTitleLab.text = [YSUtility timestampSwitchTime:model.createTime andFormatter:@"yyyy年MM月dd HH:mm"];

    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
