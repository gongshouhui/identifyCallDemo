//
//  YSContactSelectPeopleBottomView.m
//  YaSha-iOS
//
//  Created by 方鹏俊 on 2018/1/9.
//  Copyright © 2018年 亚厦装饰股份有限公司. All rights reserved.
//

#import "YSContactSelectPeopleBottomView.h"
#import "YSContactModel.h"

@interface YSContactSelectPeopleBottomView ()


@property (nonatomic, strong) UILabel *selectedAllLabel;
@property (nonatomic, strong) QMUIButton *confirmButton;
@property (nonatomic, strong) UILabel *messageLabel;

@end

@implementation YSContactSelectPeopleBottomView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = UIColorWhite;
        self.frame = CGRectMake(0, kSCREEN_HEIGHT-50*kHeightScale-kBottomHeight, kSCREEN_WIDTH, 50*kHeightScale+kBottomHeight);
        [self initUI];
    }
    return self;
}

- (void)initUI {
    _sendSelectAllSubject = [RACSubject subject];
    _sendConfirmSubject = [RACSubject subject];
    
    _selectedAllButton = [[QMUIButton alloc] init];
    [_selectedAllButton setImage:UIImageMake(@"选择项目-未选") forState:UIControlStateNormal];
    YSWeak;
    [[_selectedAllButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        weakSelf.selectedAllButton.selected = !weakSelf.selectedAllButton.selected;
        [weakSelf.selectedAllButton setImage:UIImageMake(weakSelf.selectedAllButton.isSelected ? @"选择项目-选中" : @"选择项目-未选") forState:UIControlStateNormal];
        [weakSelf.sendSelectAllSubject sendNext:weakSelf.selectedAllButton];
    }];
    [self addSubview:self.selectedAllButton];
    [_selectedAllButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.mas_top).offset(10*kHeightScale);
        make.left.mas_equalTo(self.mas_left).offset(15);
        make.size.mas_equalTo(CGSizeMake(30*kWidthScale, 30*kWidthScale));
    }];
    
    _selectedAllLabel = [[UILabel alloc] init];
    _selectedAllLabel.text = @"全选";
    _selectedAllLabel.font = UIFontMake(15);
    [self addSubview:self.selectedAllLabel];
    [_selectedAllLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(_selectedAllButton.mas_centerY);
        make.left.mas_equalTo(_selectedAllButton.mas_right).offset(10);
        make.size.mas_equalTo(CGSizeMake(50*kHeightScale, 16*kHeightScale));
    }];
    
    _confirmButton = [[QMUIButton alloc] init];
    _confirmButton.backgroundColor = kThemeColor;
    [_confirmButton setTitle:@"确定" forState:UIControlStateNormal];
    [_confirmButton setTitleColor:UIColorWhite forState:UIControlStateNormal];
    _confirmButton.titleLabel.font = [UIFont systemFontOfSize:15];
    [[_confirmButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        [weakSelf.sendConfirmSubject sendNext:weakSelf.confirmButton];
    }];
    [self addSubview:self.confirmButton];
    [_confirmButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(_selectedAllButton.mas_centerY);
        make.right.mas_equalTo(self.mas_right).offset(-15);
        make.size.mas_equalTo(CGSizeMake(100*kWidthScale, 30*kWidthScale));
    }];
    
    _messageLabel = [[UILabel alloc] init];
    _messageLabel.text = @"共选择0人";
    _messageLabel.font = [UIFont systemFontOfSize:15];
    [self addSubview:self.messageLabel];
    [_messageLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(_selectedAllButton.mas_centerY);
        make.right.mas_equalTo(_confirmButton.mas_left).offset(-10);
        make.height.mas_equalTo(15*kHeightScale);
        make.width.mas_greaterThanOrEqualTo(0);
    }];
}

- (void)updateSelectCountWithpDatasourceArray:(NSArray *)datasourceArray andIsRootView:(Boolean) isRootView {
    if (isRootView) {//根目录
        for (YSContactModel *model in datasourceArray[0]) {
            if ([model isKindOfClass:[YSContactModel class]] &&model.isSelected) {
                [_selectedAllButton setSelected:YES];
            }else{
                [_selectedAllButton setSelected:NO];
            }
        }
    }else{//子目录
        for (YSContactModel *model in datasourceArray[0]) {
            if (!model.isSelected) {
                [_selectedAllButton setSelected:NO];
                break;
            }else{
                [_selectedAllButton setSelected:YES];
            }
        }
    }
    RLMResults *results = [YSContactModel objectsWhere:[NSString stringWithFormat:@"isSelected = YES AND isOrg = NO"]];
    _messageLabel.text = [NSString stringWithFormat:@"共选择%ld个人", results.count];
    dispatch_async(dispatch_get_main_queue(), ^{
        [_selectedAllButton setImage:UIImageMake(_selectedAllButton.isSelected ? @"选择项目-选中" : @"选择项目-未选") forState:UIControlStateNormal];
    });
}

@end
