//
//  YSContactSelectOrgsBottomView.m
//  YaSha-iOS
//
//  Created by 方鹏俊 on 2018/1/12.
//  Copyright © 2018年 亚厦装饰股份有限公司. All rights reserved.
//

#import "YSContactSelectOrgsBottomView.h"
#import "YSContactModel.h"

@interface YSContactSelectOrgsBottomView ()

@property (nonatomic, strong) QMUIButton *selectedAllButton;
@property (nonatomic, strong) UILabel *selectedAllLabel;
@property (nonatomic, strong) QMUIButton *confirmButton;
@property (nonatomic, strong) UILabel *messageLabel;

@end

@implementation YSContactSelectOrgsBottomView

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
    [[_selectedAllButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        _selectedAllButton.selected = !_selectedAllButton.selected;
        [_selectedAllButton setImage:UIImageMake(_selectedAllButton.isSelected ? @"选择项目-选中" : @"选择项目-未选") forState:UIControlStateNormal];
        [_sendSelectAllSubject sendNext:_selectedAllButton];
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
        [_sendConfirmSubject sendNext:_confirmButton];
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

- (void)updateSelectCountWithpNum:(NSString *)pNum {
    RLMResults *subResults = [YSContactModel objectsWhere:[NSString stringWithFormat:@"pNum = '%@' AND isOrg = YES", pNum]];
    for (YSContactModel *model in subResults) {
        if (!model.isSelected) {
            [_selectedAllButton setSelected:NO];
            break;
        } else {
            [_selectedAllButton setSelected:YES];
        }
    }
    RLMResults *orgResults = [YSContactModel objectsWhere:[NSString stringWithFormat:@"num = '%@' AND isOrg = YES", pNum]];
    if (orgResults.count != 0) {
        YSContactModel *orgContactModel = orgResults[0];
        RLMRealm *realm = [RLMRealm defaultRealm];
        [realm beginWriteTransaction];
        orgContactModel.isSelected = _selectedAllButton.isSelected;
        [realm commitWriteTransaction];
    }
    RLMResults *results = [YSContactModel objectsWhere:[NSString stringWithFormat:@"isSelected = YES AND isOrg = YES"]];
    _messageLabel.text = [NSString stringWithFormat:@"共选择%ld个部门", results.count];
    dispatch_async(dispatch_get_main_queue(), ^{
        [_selectedAllButton setImage:UIImageMake(_selectedAllButton.isSelected ? @"选择项目-选中" : @"选择项目-未选") forState:UIControlStateNormal];
    });
}

@end
