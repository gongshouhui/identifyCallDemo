//
//  YSFlowLaunchFormHeaderView.m
//  YaSha-iOS
//
//  Created by 方鹏俊 on 2017/12/26.
//  Copyright © 2017年 亚厦装饰股份有限公司. All rights reserved.
//

#import "YSFlowLaunchFormHeaderView.h"

@interface YSFlowLaunchFormHeaderView ()

@property (nonatomic, strong) UILabel *deptNameLabel;
@property (nonatomic, strong) UILabel *BPNameLabel;

@end

@implementation YSFlowLaunchFormHeaderView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self initUI];
    }
    return self;
}

- (void)initUI {
    self.frame = CGRectMake(0, 0, kSCREEN_WIDTH, 30*kHeightScale);
    self.backgroundColor = [UIColor colorWithHexString:@"FFF9E5"];
    
    _deptNameLabel = [[UILabel alloc] init];
    _deptNameLabel.font = [UIFont systemFontOfSize:14];
    _deptNameLabel.textColor = [UIColor colorWithHexString:@"F08250"];
    [self addSubview:_deptNameLabel];
    [_deptNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.mas_centerY);
        make.left.mas_equalTo(self.mas_left).offset(15);
        make.height.mas_equalTo(15*kHeightScale);
        make.width.mas_greaterThanOrEqualTo(0);
    }];
    
    _BPNameLabel = [[UILabel alloc] init];
    _BPNameLabel.font = [UIFont systemFontOfSize:14];
    _BPNameLabel.textAlignment = NSTextAlignmentRight;
    _BPNameLabel.textColor = [UIColor colorWithHexString:@"F08250"];
    [self addSubview:_BPNameLabel];
    [_BPNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.mas_centerY);
        make.right.mas_equalTo(self.mas_right).offset(-15);
        make.height.mas_equalTo(15*kHeightScale);
        make.width.mas_greaterThanOrEqualTo(0);
    }];
}

- (void)setHeaderModel:(YSFlowLaunchFormListModel *)headerModel {
    _headerModel = headerModel;
    _deptNameLabel.text = [NSString stringWithFormat:@"流程归属部门：%@", _headerModel.extendProcdef.ownDeptName];
    _BPNameLabel.text = [NSString stringWithFormat:@"流程BP：%@", _headerModel.extendProcdef.processDockingName];
}

@end
