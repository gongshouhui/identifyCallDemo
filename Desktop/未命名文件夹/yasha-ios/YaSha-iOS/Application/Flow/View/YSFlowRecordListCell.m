//
//  YSFlowRecordListCell.m
//  YaSha-iOS
//
//  Created by 方鹏俊 on 2017/10/30.
//

#import "YSFlowRecordListCell.h"
#import "YSContactDetailViewController.h"

@interface YSFlowRecordListCell ()


@property (nonatomic, strong) UILabel *userNameLabel;
@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, strong) UILabel *messageLabel;
@property (nonatomic,strong) UIView *lineView;

@end

@implementation YSFlowRecordListCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self initUI];
    }
    return self;
}

- (void)initUI {
    _avatarButton = [[QMUIButton alloc] init];
    [_avatarButton setImage:UIImageMake(@"头像") forState:UIControlStateNormal];
    _avatarButton.layer.masksToBounds = YES;
    _avatarButton.layer.cornerRadius = 16*kHeightScale;
    [self.contentView addSubview:_avatarButton];
    [_avatarButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.contentView.mas_top).offset(12);
        make.left.mas_equalTo(self.contentView.mas_left).offset(16);
        make.size.mas_equalTo(CGSizeMake(32*kWidthScale, 32*kHeightScale));
    }];
    YSWeak;
    [[_avatarButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        YSStrong;
        if(strongSelf.cellModel.userId){
            [YSUtility pushToContactDetailViewControllerWithuserId:strongSelf.cellModel.userId];
        }else{
            [YSUtility pushToContactDetailViewControllerWithuserId:strongSelf.cellModel.creator];
        }
    }];
    
    
    //打电话ico-call
    _callButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_callButton setTitle:@"立即联系" forState:UIControlStateNormal];
    _callButton.titleLabel.font = [UIFont systemFontOfSize:12];
    [_callButton setImageEdgeInsets:UIEdgeInsetsMake(0, -10, 0, 0)];
    _callButton.contentEdgeInsets = UIEdgeInsetsMake(10, 10, 10, 10);
    [_callButton setTitleColor:[UIColor colorWithHexString:@"#FF2295FF"] forState:UIControlStateNormal];
    [_callButton setImage:[UIImage imageNamed:@"ico-call"] forState:UIControlStateNormal];
    [self.contentView addSubview:_callButton];
    [_callButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(_avatarButton.mas_centerY);
        make.right.mas_equalTo(-15);
    }];
	[[_callButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
		YSStrong;
		if (strongSelf.delegate) {
			[strongSelf.delegate recordListCellCallButtonDidClick:strongSelf.cellModel.userId];
		}
	}];
   
    UIView *lineView = [UIView new];
    _lineView = lineView;
    lineView.backgroundColor = [UIColor colorWithHexString:@"#FFE5E5E5"];
    [self.contentView addSubview:lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(1);
        make.height.mas_equalTo(15);
        make.centerY.mas_equalTo(_callButton.mas_centerY);
        make.right.mas_equalTo(_callButton.mas_left).mas_equalTo(-8);
    }];
    
    _userNameLabel = [[UILabel alloc] init];
    _userNameLabel.text = @"刘春雷";
    _userNameLabel.font = [UIFont boldSystemFontOfSize:16];
    _userNameLabel.textColor = [UIColor colorWithHexString:@"333333"];
    [self.contentView addSubview:_userNameLabel];
    [_userNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(15);
        make.left.mas_equalTo(_avatarButton.mas_right).offset(15);
    }];
    
    _typeNameLabel = [YSTagButton buttonWithType:UIButtonTypeCustom];
    _typeNameLabel.titleLabel.font = [UIFont systemFontOfSize:12];
    [self.contentView addSubview:_typeNameLabel];
    [_typeNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(20);
        make.left.mas_equalTo(_userNameLabel.mas_right).offset(8);
    }];
    
    _timeLabel = [[UILabel alloc] init];
    _timeLabel.text = @"2018-08-01";
    _timeLabel.textAlignment = NSTextAlignmentLeft;
    _timeLabel.textColor = [UIColor colorWithHexString:@"B2B2B2"];
    _timeLabel.font = [UIFont systemFontOfSize:12];
    [self.contentView addSubview:_timeLabel];
    [_timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_userNameLabel.mas_bottom).mas_equalTo(5);
        make.left.mas_equalTo(_userNameLabel.mas_left);
        make.height.mas_equalTo(14);
    }];
    
    
    _messageLabel = [[UILabel alloc] init];
    _messageLabel.text = @"测试数据测试数据测试数据测试数据测试数据";
    _messageLabel.numberOfLines = 0;
    _messageLabel.textColor = [UIColor colorWithHexString:approvalDetailColor];
    _messageLabel.font = [UIFont systemFontOfSize:14];
    [self.contentView addSubview:_messageLabel];
    [_messageLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_timeLabel.mas_bottom).offset(12);
        make.left.mas_equalTo(_avatarButton.mas_right).offset(15);
        make.right.mas_equalTo(-15);
        make.bottom.mas_equalTo(self.contentView.mas_bottom).offset(-15);
    }];
}

- (void)setRecordListCellModel:(YSFlowRecordListModel *)cellModel andIndexPath:(NSIndexPath *)indexPath {
    _cellModel = cellModel;
    if (!cellModel.type) {
        RLMResults *results = [[YSContactModel objectsWhere:[NSString stringWithFormat:@"(userId CONTAINS '%@') AND isOrg = NO AND delFlag = '1' AND postStatus = '1' AND status = '1' AND isPublic != '0'", cellModel.creator]] sortedResultsUsingKeyPath:@"userId" ascending:YES];
        
        YSContactModel *model;
        if (results.count > 0) {
            model = results[0];
        }
        NSString *urlString = [NSString stringWithFormat:@"%@%@", YSImageDomain, [YSUtility getAvatarUrlString:model.headImg]];
        [_avatarButton sd_setImageWithURL:[NSURL URLWithString:urlString] forState:UIControlStateNormal placeholderImage:UIImageMake(@"头像")];
        _userNameLabel.text = model.name;
        _messageLabel.text = _cellModel.massage;
        
    }else{
        NSString *urlString = [NSString stringWithFormat:@"%@%@", YSImageDomain, [YSUtility getAvatarUrlString:cellModel.userUrl]];
        [_avatarButton sd_setImageWithURL:[NSURL URLWithString:urlString] forState:UIControlStateNormal placeholderImage:UIImageMake(@"头像")];
        _userNameLabel.text = _cellModel.userName;
        _messageLabel.text = [_cellModel.message stringByReplacingOccurrencesOfString:@"</br>" withString:@"\n"];
        
    }
    [_typeNameLabel setTitle:_cellModel.typeName forState:UIControlStateNormal];
     _timeLabel.text = [YSUtility timestampSwitchTime:(_cellModel.time?_cellModel.time:_cellModel.createTime) andFormatter:@"yyyy-MM-dd HH:mm"];
    //驳回，撤销状态为橙色，其余均是蓝色
    //_cellModel.type:AGREE("审批"), DISAGREE("驳回"), REVOCATION("撤回"), TEMPORARY("暂存"), SYSAGREE("系统执行"), FLOWCREATE("提交"), REEDITFROM("重新提交"), FLOWEND("审批结束"), END("流程终止"), LETPERSON("知会"), TURNREAD("转阅"), HAVEREAD("已阅"), TURNTASK("转办"), ADDSIGN("加签");
    //状态修改后  *SP("审批"),BH("驳回"),CH("撤回"),ZC("暂存"),XTZX("系统执行"),TJ("提交"),CXTJ("重新提交"),SPJS("审批结束"),LCZZ("流程终止"),ZH("知会"),ZY("转阅"),YY("已阅"),ZB("转办"),SPBJQ("审批并加签"),SQ("授权"),XT("协同"),PS("评审");
    if ([_cellModel.type isEqualToString:@"BH"] || [_cellModel.type isEqualToString:@"CH"]) {
        _typeNameLabel.titleColor = [UIColor colorWithHexString:@"F08250"];
        _typeNameLabel.borderColor = [UIColor colorWithHexString:@"F08250"];
    }else{
        _typeNameLabel.titleColor = [UIColor colorWithHexString:@"256EA8"];
        _typeNameLabel.borderColor = [UIColor colorWithHexString:@"256EA8"];
    }
    // 流程审批结束、终止单独处理
    if ([_cellModel.type isEqual:@"SPJS"]) {
        _callButton.hidden = YES;
        _lineView.hidden = YES;
        _typeNameLabel.hidden = YES;
        [_avatarButton setImage:UIImageMake(@"处理记录-流程完结") forState:UIControlStateNormal];
        _timeLabel.text = @"";
        _userNameLabel.text = @"流程已审批完结！";
        _messageLabel.text = @"";
    } else if ([_cellModel.type isEqual:@"LCZZ"]) {
        _callButton.hidden = YES;
        _lineView.hidden = YES;
        _typeNameLabel.hidden = YES;
        [_avatarButton setImage:UIImageMake(@"处理记录-流程终止") forState:UIControlStateNormal];
        _timeLabel.text = @"";
        _userNameLabel.text = @"流程已终止！";
        _messageLabel.text = @"";
    }else{
        if (!_cellModel.typeName.length){
           _typeNameLabel.hidden = YES;
        }else {
           _typeNameLabel.hidden = NO;
        }
        _callButton.hidden = NO;
        _lineView.hidden = NO;
    }
    
    //布局调整
    if (_timeLabel.text.length) {
        [_userNameLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(15);
            make.left.mas_equalTo(_avatarButton.mas_right).offset(15);
            make.height.mas_equalTo(16);
        }];
    }else{
        [_userNameLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(_avatarButton.mas_centerY);
            make.left.mas_equalTo(_avatarButton.mas_right).offset(15);
            make.height.mas_equalTo(16);
        }];
    }
    if (!_cellModel.userName.length) {
        [_typeNameLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(15);
            make.left.mas_equalTo(_userNameLabel.mas_left);
        }];
        _callButton.hidden = YES;//名字为空时，一般是系统执行，打电话按钮隐藏
        _lineView.hidden = YES;
    }else{

        [_typeNameLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(_userNameLabel.mas_centerY);
            make.left.mas_equalTo(_userNameLabel.mas_right).offset(8);
        }];
    }
    
    if (_messageLabel.text.length) {
        [_messageLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(_timeLabel.mas_bottom).mas_equalTo(12);
        }];
    }else{
        [_messageLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(_timeLabel.mas_bottom).mas_equalTo(-2);
        }];
    }
}

@end
