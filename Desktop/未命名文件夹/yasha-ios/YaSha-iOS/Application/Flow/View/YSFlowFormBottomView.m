//
//  YSFlowFormBottomView.m
//  YaSha-iOS
//
//  Created by 方鹏俊 on 2017/10/27.
//

#import "YSFlowFormBottomView.h"

@interface YSFlowFormBottomView ()


@end

@implementation YSFlowFormBottomView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        [self initUI];
    }
    return self;
}

- (void)initUI {
    _sendActionSubject = [RACSubject subject];
    
    _handleButton = [[UIButton alloc] init];
    _handleButton.tag = 0;
    [_handleButton setTitle:@"处理" forState:UIControlStateNormal];
    _handleButton.titleLabel.font = [UIFont systemFontOfSize:15];
    _handleButton.backgroundColor = kThemeColor;
    YSWeak;
    [[_handleButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        [weakSelf.sendActionSubject sendNext:weakSelf.handleButton];
    }];
    [self addSubview:_handleButton];
    [_handleButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.bottom.mas_equalTo(self);
        make.width.mas_equalTo(kSCREEN_WIDTH*0.68);
    }];
    
    _transButton = [[UIButton alloc] init];
    _transButton.tag = 1;
    _transButton.layer.borderWidth = 0.5;
    _transButton.layer.borderColor = [UIColor lightGrayColor].CGColor;
    [_transButton setTitle:@"转阅" forState:UIControlStateNormal];
    [_transButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    _transButton.titleLabel.font = [UIFont systemFontOfSize:15];
    [[_transButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        [weakSelf.sendActionSubject sendNext:weakSelf.transButton];
    }];
    [self addSubview:_transButton];
    [_transButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.right.bottom.mas_equalTo(self);
        make.left.mas_equalTo(_handleButton.mas_right);
    }];
}

- (void)setCellModel:(YSFlowListModel *)cellModel withFlowType:(YSFlowType)flowType {
    _cellModel = cellModel;
    if (cellModel.noticeType) {
        [_handleButton mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.left.bottom.mas_equalTo(self);
            make.width.mas_equalTo(0);
        }];
    }
    if (flowType == YSFlowTypeFinished) {
        [_handleButton mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.left.bottom.mas_equalTo(self);
            make.width.mas_equalTo(0);
        }];
    } else if (flowType == YSFlowTypeSent) {
        if (_cellModel.flowStatus == FlowHandleStatusBJ || _cellModel.flowStatus == FlowHandleStatusZZ || _cellModel.flowStatus == FlowHandleStatusCH || _cellModel.flowStatus == FlowHandleStatusBH) {
            [_handleButton mas_updateConstraints:^(MASConstraintMaker *make) {
                make.top.left.bottom.mas_equalTo(self);
                make.width.mas_equalTo(0);
            }];
        } else {
            
            [_handleButton setTitle:@"撤回" forState:UIControlStateNormal];
            _handleButton.tag = 2;
        }
    } else if (flowType == YSFlowTypeTodo) {
      
        /** 待办列表中被驳回(驳回到提交人)、撤回,办结，终止，知会节点的流程只能转阅 */
        if ((_cellModel.flowStatus == FlowHandleStatusBH && [_cellModel.taskName isEqualToString:@"提交人"])  || _cellModel.flowStatus == FlowHandleStatusCH || _cellModel.flowStatus == FlowHandleStatusBJ || _cellModel.flowStatus == FlowHandleStatusZZ || [_cellModel.taskType isEqualToString:FlowTaskZH]) {
            [_handleButton mas_updateConstraints:^(MASConstraintMaker *make) {
                make.top.left.bottom.mas_equalTo(self);
                make.width.mas_equalTo(0);
            }];
        }
    }else{
        self.hidden = YES;
    }
    
}

@end
