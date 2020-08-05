//
//  YSFlowFormHeaderView.m
//  YaSha-iOS
//
//  Created by 方鹏俊 on 2017/10/27.
//

#import "YSFlowFormHeaderView.h"
#import "YSContactDetailViewController.h"

@interface YSFlowFormHeaderView ()

@property (nonatomic, strong) UIView *headerView;
@property (nonatomic, strong) UILabel *deptNameLabel;
@property (nonatomic, strong) QMUIButton *BPNameButton;

@property (nonatomic, strong) UILabel *flowNameLabel;
@property (nonatomic, strong) UIImageView *startUserNameImageView;
@property (nonatomic, strong) QMUIButton *startUserNameButton;
@property (nonatomic, strong) UIImageView *ownDeptNameImageView;
@property (nonatomic, strong) UILabel *ownDeptNameLabel;
@property (nonatomic, strong) UIImageView *startTimeImageView;
@property (nonatomic, strong) UILabel *startTimeLabel;



@end

@implementation YSFlowFormHeaderView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        //self.frame = CGRectMake(0, 0, kSCREEN_WIDTH, 53+108*kHeightScale);
        self.backgroundColor = [UIColor whiteColor];
        [self initUI];
    }
    return self;
}

- (void)initUI {
    [self mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(kSCREEN_WIDTH);
    }];
    _headerView = [[UIView alloc] init];
    _headerView.backgroundColor = [UIColor colorWithHexString:@"FFF9E5"];
    [self addSubview:_headerView];
    [_headerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.mas_equalTo(self);
        //make.height.mas_equalTo(30*kHeightScale);
    }];
    
    _deptNameLabel = [[UILabel alloc] init];
    _deptNameLabel.numberOfLines = 0;
    _deptNameLabel.font = [UIFont systemFontOfSize:14];
    _deptNameLabel.textColor = [UIColor colorWithHexString:@"F08250"];
    [_deptNameLabel setContentCompressionResistancePriority:UILayoutPriorityDefaultLow forAxis:UILayoutConstraintAxisHorizontal];
    [_headerView addSubview:_deptNameLabel];
    [_deptNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(10);
        make.bottom.mas_equalTo(-10);
        make.left.mas_equalTo(_headerView.mas_left).offset(15);
    }];
    
    _BPNameButton = [[QMUIButton alloc] init];
    _BPNameButton.titleLabel.font = UIFontMake(14);
    [_BPNameButton setTitleColor:[UIColor colorWithHexString:@"F08250"] forState:UIControlStateNormal];
    [_BPNameButton setContentCompressionResistancePriority:UILayoutPriorityDefaultHigh forAxis:UILayoutConstraintAxisHorizontal];
    [_headerView addSubview:_BPNameButton];
    [_BPNameButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_deptNameLabel.mas_top);
        make.left.mas_equalTo(_deptNameLabel.mas_right).offset(15);
        make.right.mas_equalTo(_headerView.mas_right).offset(-15);
    }];
    
    _flowNameLabel = [[UILabel alloc] init];
//    _flowNameLabel.numberOfLines = 0;
    _flowNameLabel.font = [UIFont boldSystemFontOfSize:17];
    _flowNameLabel.textColor = [UIColor colorWithHexString:@"333333"];
    [self addSubview:_flowNameLabel];
    [_flowNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_headerView.mas_bottom).offset(15);
        make.left.mas_equalTo(self.mas_left).offset(15);
        make.right.mas_equalTo(self.mas_right).offset(-15);
        make.height.mas_equalTo(17*kHeightScale);
    }];

    _startUserNameImageView = [[UIImageView alloc] init];
    _startUserNameImageView.image = [UIImage imageNamed:@"流程详情-头像icon"];
    [self addSubview:_startUserNameImageView];
    [_startUserNameImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_flowNameLabel.mas_bottom).offset(20);
        make.left.mas_equalTo(_flowNameLabel.mas_left);
        make.size.mas_equalTo(CGSizeMake(12*kWidthScale, 12*kWidthScale));
    }];
    
    _startUserNameButton = [[QMUIButton alloc] init];
    [_startUserNameButton setTitleColor:[UIColor colorWithHexString:@"333333"] forState:UIControlStateNormal];
    _startUserNameButton.titleLabel.font = UIFontMake(12);
    [self addSubview:_startUserNameButton];
    [_startUserNameButton setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
    [_startUserNameButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(_startUserNameImageView.mas_centerY);
        make.left.mas_equalTo(_startUserNameImageView.mas_right).offset(5);
        make.height.mas_equalTo(13*kHeightScale);
        make.width.mas_greaterThanOrEqualTo(36);
        make.width.mas_lessThanOrEqualTo(90);
        
    }];
    
    //时间
    _startTimeLabel = [[UILabel alloc] init];
    _startTimeLabel.textColor = kGrayColor(51);
    _startTimeLabel.font = [UIFont systemFontOfSize:12];
    [self addSubview:_startTimeLabel];
    [_startTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(_startUserNameImageView.mas_centerY);
        make.right.mas_equalTo(self.mas_right).offset(-15);
        make.height.mas_equalTo(13*kHeightScale);
        //make.width.mas_equalTo(100*kWidthScale);
    }];
    
    _startTimeImageView = [[UIImageView alloc] init];
    _startTimeImageView.image = [UIImage imageNamed:@"流程详情-时间icon"];
    [self addSubview:_startTimeImageView];
    [_startTimeImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(_startUserNameImageView.mas_centerY);
        make.right.mas_equalTo(_startTimeLabel.mas_left).offset(-5);
        make.size.mas_equalTo(CGSizeMake(12*kWidthScale, 12*kWidthScale));
    }];
    
    
//所属部门
    [self layoutIfNeeded];//这个时候获取的宽是没有赋值获取的
    _ownDeptNameLabel = [[UILabel alloc] init];
    _ownDeptNameLabel.textColor = kGrayColor(51);
    _ownDeptNameLabel.font = [UIFont systemFontOfSize:12];
    _ownDeptNameLabel.textAlignment = NSTextAlignmentCenter;
    _ownDeptNameLabel.numberOfLines = 0;
    [self addSubview:_ownDeptNameLabel];
    [_ownDeptNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_startUserNameButton.mas_top);
        make.centerX.mas_equalTo((-12*kWidthScale - 5)/2);
        make.width.mas_lessThanOrEqualTo(kSCREEN_WIDTH - _startUserNameButton.qmui_width - _startTimeLabel.qmui_width - 12*kWidthScale*2 - 2*15 - 2*30);
        //make.left.mas_equalTo(self.startUserNameButton.mas_right).mas_equalTo(30);
        //make.right.mas_equalTo(self.startTimeLabel.mas_left).mas_equalTo(-30);
    }];
    
    _ownDeptNameImageView = [[UIImageView alloc] init];
    _ownDeptNameImageView.image = [UIImage imageNamed:@"流程详情-部门icon"];
    [self addSubview:_ownDeptNameImageView];
    [_ownDeptNameImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(_startUserNameImageView.mas_centerY);
        make.right.mas_equalTo(_ownDeptNameLabel.mas_left).offset(-5);
        make.size.mas_equalTo(CGSizeMake(12*kWidthScale, 12*kWidthScale));
    }];
    
   
    _lineLabel = [[UILabel alloc] init];
    _lineLabel.backgroundColor = [UIColor colorWithRed:0.95 green:0.95 blue:0.95 alpha:1.00];
    [self addSubview:_lineLabel];
    [_lineLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_ownDeptNameLabel.mas_bottom).offset(20);
        make.left.mas_equalTo(_startUserNameImageView.mas_left);
        make.right.mas_equalTo(self.mas_right).offset(-15);
        make.height.mas_equalTo(1);
    }];
    
    _actionButton = [[UIButton alloc] init];
    [_actionButton setTitle:@"关联文档&关联流程、提交者附言" forState:UIControlStateNormal];
    [_actionButton setTitleEdgeInsets:UIEdgeInsetsMake(0, 10, 0, 0)];
    [_actionButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_actionButton setImage:[UIImage imageNamed:@"arrow"] forState:UIControlStateNormal];
    [_actionButton setImageEdgeInsets:UIEdgeInsetsMake(0, kSCREEN_WIDTH-20, 0, 0)];
    _actionButton.titleLabel.font = [UIFont systemFontOfSize:14];
    _actionButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [self addSubview:_actionButton];
    [_actionButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_lineLabel.mas_bottom);
        make.left.right.mas_equalTo(self);
        make.height.mas_equalTo(50*kHeightScale);
        make.bottom.mas_equalTo(0);
    }];
    YSWeak;
    [[_BPNameButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        NSLog(@"======%@------%@",weakSelf.headerModel.processDockingNo,weakSelf.headerModel.processDockingName);
        [YSUtility pushToContactDetailViewControllerWithuserId:weakSelf.headerModel.processDockingNo];
    }];
    [[_startUserNameButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        [YSUtility pushToContactDetailViewControllerWithuserId:weakSelf.headerModel.sponsorNo];
    }];
}
- (void)hiddenActionButton {
    self.lineLabel.hidden = YES;
    [_lineLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_ownDeptNameLabel.mas_bottom).offset(20);
        make.left.mas_equalTo(_startUserNameImageView.mas_left);
        make.right.mas_equalTo(self.mas_right).offset(-15);
        make.height.mas_equalTo(1);
        make.bottom.mas_equalTo(0);
    }];
    
    [self.actionButton removeFromSuperview];
    
   
}

- (void)setHeaderModel:(YSFlowFormHeaderModel *)headerModel {
    _headerModel = headerModel;
    
    _deptNameLabel.text = [NSString stringWithFormat:@"流程归属部门：%@", headerModel.ownDeptName];
    [_BPNameButton setTitle:[NSString stringWithFormat:@"流程BP：%@", headerModel.processDockingName] forState:UIControlStateNormal];
    _flowNameLabel.text = headerModel.title;
   //
    [_startUserNameButton setTitle:headerModel.sponsor forState:UIControlStateNormal];
    //
    _ownDeptNameLabel.text = headerModel.launchDepartment;
    _startTimeLabel.text = [YSUtility formatTimestamp:headerModel.launchTime Length:16];
    //赋值后更新约束，主要是更新_ownDeptNameLabel的宽
    [self layoutIfNeeded];
    [_ownDeptNameLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.mas_lessThanOrEqualTo(kSCREEN_WIDTH - _startUserNameButton.qmui_width - _startTimeLabel.qmui_width - 12*kWidthScale*3 - 2*15 - 2*15 -5);
    }];
}

@end
