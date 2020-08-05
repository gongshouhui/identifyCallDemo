//
//  YSFlowListCell.m
//  YaSha-iOS
//
//  Created by 方鹏俊 on 2017/10/25.
//

#import "YSFlowListCell.h"

@interface YSFlowListCell ()

@property (nonatomic, strong) UILabel *flowStatusLabel;
@property (nonatomic, strong) UILabel *fromNameLabel;
@property (nonatomic, strong) UIImageView *avatarImageView;
@property (nonatomic, strong) UILabel *startPersonNameLabel;
@property (nonatomic, strong) UILabel *approverNameLabel;
@property (nonatomic, strong) UIImageView *warningImageView;
@property (nonatomic,strong)  UIImageView *typeIV;

@end

@implementation YSFlowListCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self initUI];
    }
    return self;
}

- (void)initUI {
    _flowStatusLabel = [[UILabel alloc] init];
    _flowStatusLabel.textColor = [UIColor whiteColor];
    _flowStatusLabel.textAlignment = NSTextAlignmentCenter;
    _flowStatusLabel.font = [UIFont boldSystemFontOfSize:12];
    _flowStatusLabel.backgroundColor = [UIColor colorWithRed:0.46 green:0.82 blue:0.80 alpha:1.00];
    _flowStatusLabel.layer.masksToBounds = YES;
    _flowStatusLabel.layer.cornerRadius = 4*kWidthScale;
    [self.contentView addSubview:_flowStatusLabel];
    [_flowStatusLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        //        make.centerY.mas_equalTo(self.contentView.mas_centerY);
        make.top.mas_equalTo(self.contentView.mas_top).offset(10);
        make.left.mas_equalTo(self.contentView.mas_left).offset(15);
        make.size.mas_equalTo(CGSizeMake(50*kWidthScale, 50*kWidthScale));
    }];
    
    _fromNameLabel = [[UILabel alloc] init];
    _fromNameLabel.font = [UIFont systemFontOfSize:15];
    [self.contentView addSubview:_fromNameLabel];
    [_fromNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_flowStatusLabel.mas_top);
        make.left.mas_equalTo(_flowStatusLabel.mas_right).offset(12);
        make.right.mas_equalTo(self.contentView.mas_right).offset(-15);
        make.height.mas_equalTo(16*kHeightScale);
    }];
    
    _avatarImageView = [[UIImageView alloc] init];
    _avatarImageView.image = [UIImage imageNamed:@"流程列表-头像icon"];
    [self.contentView addSubview:_avatarImageView];
    [_avatarImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(_flowStatusLabel.mas_bottom);
        make.left.mas_equalTo(_fromNameLabel.mas_left);
        make.size.mas_equalTo(CGSizeMake(12*kWidthScale, 12*kWidthScale));
    }];
    
    _startPersonNameLabel = [[UILabel alloc] init];
    _startPersonNameLabel.textColor = [UIColor colorWithRed:0.60 green:0.60 blue:0.60 alpha:1.00];
    _startPersonNameLabel.font = [UIFont systemFontOfSize:12];
    [self.contentView addSubview:_startPersonNameLabel];
    [_startPersonNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(_avatarImageView.mas_centerY);
        make.left.mas_equalTo(_avatarImageView.mas_right).offset(6);
        make.height.mas_equalTo(13*kHeightScale);
        make.width.mas_greaterThanOrEqualTo(0);
    }];
    
    _approverNameLabel = [[UILabel alloc] init];
    _approverNameLabel.textColor = [UIColor colorWithRed:0.60 green:0.60 blue:0.60 alpha:1.00];
    _approverNameLabel.font = [UIFont systemFontOfSize:12];
    [self.contentView addSubview:_approverNameLabel];
    [_approverNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(_startPersonNameLabel.mas_centerY);
        make.left.mas_equalTo(self.contentView.mas_centerX);
        make.height.mas_equalTo(13*kHeightScale);
        make.right.mas_equalTo(self.contentView.mas_right).offset(-15);
    }];
}
- (void)setAssociatedFlowCell:(YSFlowListModel *)cellModel {
	
    _cellModel = cellModel;
    _fromNameLabel.text = cellModel.fromName;
	if (_cellModel.flowStatusName.length) {
		_flowStatusLabel.text = _cellModel.flowStatusName;
	}else{
	  _flowStatusLabel.text = @"流程";
	}
	
    _startPersonNameLabel.text = cellModel.startPersonName;
    _approverNameLabel.hidden = YES;
    if (_cellModel.processType != 1 && _cellModel.processType != 5) {
        YSFlowModel *flowModel = [YSUtility getFlowModelWithProcessDefinitionKey:_cellModel.processDefinitionKey];
        if (!flowModel.isMobile && !_cellModel.approverName) {
            _approverNameLabel.text = @"";
            _warningImageView = [[UIImageView alloc] init];
            _warningImageView.image = [UIImage imageNamed:@"电脑处理_icon"];
            [self.contentView addSubview:_warningImageView];
            [_warningImageView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.mas_equalTo(_approverNameLabel.mas_centerY);
                make.right.mas_equalTo(-15);
                make.size.mas_equalTo(CGSizeMake(24*kWidthScale, 24*kHeightScale));
            }];
        } else if (!flowModel.isMobile && _cellModel.approverName) {
            _warningImageView = [[UIImageView alloc] init];
            _warningImageView.image = [UIImage imageNamed:@"电脑处理_icon"];
            [self.contentView addSubview:_warningImageView];
            [_warningImageView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.mas_equalTo(_approverNameLabel.mas_centerY);
                make.right.mas_equalTo(-15);
                make.size.mas_equalTo(CGSizeMake(24*kWidthScale, 24*kHeightScale));
            }];
        }
    }
//    NSMutableAttributedString *approverNameString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"当前审批人: %@", cellModel.approverName]];
//    approverNameString.yy_font = [UIFont systemFontOfSize:12];
//    [approverNameString yy_setColor:kBlueColor range:NSMakeRange(7, cellModel.approverName.length)];
//    _approverNameLabel.attributedText = approverNameString;
}
- (void)setCellModel:(YSFlowListModel *)cellModel withFlowType:(YSFlowType)flowType {
    _cellModel = cellModel;
    if (_cellModel.flowStatus == FlowHandleStatusZC && flowType == YSFlowTypeTodo) {
        _fromNameLabel.text = [NSString stringWithFormat:@"【暂存】%@",_cellModel.fromName];
    }else{
      _fromNameLabel.text = _cellModel.fromName;
    }
    
    _startPersonNameLabel.text = _cellModel.startPersonName;
    
    NSMutableAttributedString *approverNameString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"当前审批人: %@", _cellModel.approverName]];
    approverNameString.yy_font = [UIFont systemFontOfSize:12];
    [approverNameString yy_setColor:kBlueColor range:NSMakeRange(7, _cellModel.approverName.length)];
    _approverNameLabel.attributedText = approverNameString;
    
    if (!_cellModel.approverName || _cellModel.flowStatus == FlowHandleStatusBJ || _cellModel.flowStatus == FlowHandleStatusZZ) {
        NSMutableAttributedString *nilString = [[NSMutableAttributedString alloc] initWithString:@""];
        _approverNameLabel.attributedText = nilString;
    };

    // 状态设置
    if (flowType == YSFlowTypeTodo) {
        _flowStatusLabel.text = [NSString stringWithFormat:@"%zd", _cellModel.stayHour > 0?_cellModel.stayHour:0];
        if (_cellModel.stayHour < 24) {
            _flowStatusLabel.backgroundColor = [UIColor colorWithRed:0.46 green:0.82 blue:0.79 alpha:1.00];
        } else if (_cellModel.stayHour > 24 && _cellModel.stayHour < 72) {
            _flowStatusLabel.backgroundColor =  [UIColor colorWithRed:0.98 green:0.79 blue:0.51 alpha:1.00];
        } else {
            _flowStatusLabel.text = @"99+";
            _flowStatusLabel.backgroundColor = [UIColor colorWithRed:0.97 green:0.52 blue:0.47 alpha:1.00];
        }
        
    } else {
        _flowStatusLabel.text = _cellModel.flowStatusName;
        // 办结和终止
        if (_cellModel.flowStatus == FlowHandleStatusBJ || _cellModel.flowStatus == FlowHandleStatusZZ) {
            _flowStatusLabel.backgroundColor = [UIColor colorWithRed:0.80 green:0.80 blue:0.80 alpha:1.00];
        } else {
            _flowStatusLabel.backgroundColor = [UIColor colorWithRed:0.46 green:0.82 blue:0.80 alpha:1.00];
        }
    }
    
    // 待办不显示当前待办人
    if (flowType == YSFlowTypeTodo) {
        _approverNameLabel.text = @"";
        if (_cellModel.processType != 1 && _cellModel.processType != 5) {
            YSFlowModel *flowModel = [YSUtility getFlowModelWithProcessDefinitionKey:_cellModel.processDefinitionKey];
            if (!flowModel.isMobile) {
                _warningImageView = [[UIImageView alloc] init];
                _warningImageView.image = [UIImage imageNamed:@"电脑处理_icon"];
                [self.contentView addSubview:_warningImageView];
                [_warningImageView mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.centerY.mas_equalTo(_approverNameLabel.mas_centerY);
                    make.right.mas_equalTo(-15);
                    make.size.mas_equalTo(CGSizeMake(24*kWidthScale, 24*kHeightScale));
                }];
            }
        }
    } else {
        if (_cellModel.processType != 1 && _cellModel.processType != 5) {
            YSFlowModel *flowModel = [YSUtility getFlowModelWithProcessDefinitionKey:_cellModel.processDefinitionKey];
            if (!flowModel.isMobile && !_cellModel.approverName) {
                _approverNameLabel.text = @"";
                _warningImageView = [[UIImageView alloc] init];
                _warningImageView.image = [UIImage imageNamed:@"电脑处理_icon"];
                [self.contentView addSubview:_warningImageView];
                [_warningImageView mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.centerY.mas_equalTo(_approverNameLabel.mas_centerY);
                    make.right.mas_equalTo(-15);
                    make.size.mas_equalTo(CGSizeMake(24*kWidthScale, 24*kHeightScale));
                }];
            } else if (!flowModel.isMobile && _cellModel.approverName) {
                _warningImageView = [[UIImageView alloc] init];
                _warningImageView.image = [UIImage imageNamed:@"电脑处理_icon"];
                [self.contentView addSubview:_warningImageView];
                [_warningImageView mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.centerY.mas_equalTo(_approverNameLabel.mas_centerY);
                    make.right.mas_equalTo(-15);
                    make.size.mas_equalTo(CGSizeMake(24*kWidthScale, 24*kHeightScale));
                }];
            }
        }
    }
    
    if (flowType == YSFlowTypeFinished) {
         _approverNameLabel.text = @"";
    }
}

@end

