//
//  YSCRMYXAddTableViewCell.m
//  YaSha-iOS
//
//  Created by GZl on 2019/5/21.
//  Copyright © 2019 亚厦装饰股份有限公司. All rights reserved.
//

#import "YSCRMYXAddTableViewCell.h"
@interface YSCRMYXAddTableViewCell ()
@property (nonatomic, strong) UILabel *holderLab;


@end


@implementation YSCRMYXAddTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if ([super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self loadSubViews];
    }
    return self;
}

- (void)loadSubViews {
    // 只用于 项目推进/问题与支持 暂时用labe 多的话就去掉textField 改成textView
    _hiddenLab = [[UILabel alloc] init];
    _hiddenLab.textColor = [UIColor colorWithHexString:@"#41485D"];
    _hiddenLab.numberOfLines = 0;
    _hiddenLab.hidden = YES;
    _hiddenLab.textAlignment = NSTextAlignmentRight;
    _hiddenLab.font = [UIFont fontWithName:@"PingFangSC-Regular" size:Multiply(14)];
    [self.contentView addSubview:_hiddenLab];
    [_hiddenLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-40*kWidthScale);
        make.left.mas_equalTo(125*kWidthScale);
        make.top.mas_equalTo(15*kHeightScale);
        make.bottom.mas_equalTo(-14*kHeightScale);
    }];
    
    // 左侧文字
    _leftLab = [[UILabel alloc] init];
    _leftLab.textColor = [UIColor colorWithHexString:@"#111A34"];
    _leftLab.font = [UIFont fontWithName:@"PingFangSC-Regular" size:Multiply(16)];
    _leftLab.numberOfLines = 2;
    [self.contentView addSubview:_leftLab];
    [_leftLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15*kWidthScale);
        make.width.mas_equalTo(131*kWidthScale);
        make.top.mas_equalTo(14*kHeightScale);
        make.bottom.mas_equalTo(-14*kHeightScale);
    }];
    // 右侧视图btn
    _accessoryBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    [self.contentView addSubview:_accessoryBtn];
    [_accessoryBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(19*kHeightScale);
        make.size.mas_equalTo(CGSizeMake(6*kWidthScale, 12*kHeightScale)); make.right.mas_equalTo(self.contentView.mas_right).offset(-15*kWidthScale);
        
    }];
    _accessorySwitch = [[UISwitch alloc] init];
    [self.contentView addSubview:_accessorySwitch];
    [_accessorySwitch mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(40*kWidthScale, 24*kHeightScale));
        make.right.mas_equalTo(-15*kWidthScale);
        make.top.mas_equalTo(13*kHeightScale);
    }];
    // 右侧输入框
    _rightTF = [[UITextField alloc] init];
    _rightTF.textColor = [UIColor colorWithHexString:@"#41485D"];
    _rightTF.clearButtonMode = UITextFieldViewModeWhileEditing;
    _rightTF.textAlignment = NSTextAlignmentRight;
    _rightTF.font = [UIFont fontWithName:@"PingFangSC-Regular" size:Multiply(14)];
    [self.contentView addSubview:_rightTF];
    [_rightTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-15*kWidthScale);
        make.left.mas_equalTo(_leftLab.mas_right).offset(8*kWidthScale);
        make.top.mas_equalTo(15*kHeightScale);
    }];
    @weakify(self);
    [[_rightTF rac_textSignal] subscribeNext:^(NSString * _Nullable x) {
        @strongify(self);
        self.hiddenLab.text = x;
//        if ([self.addModel.nameStr containsString:@"预付款比例"] || [self.editModel.nameStr containsString:@"预付款比例"]) {
//                    }
        if ([self.delegate respondsToSelector:@selector(textField:inputTextFieldChangeModel:)]) {
            [self.delegate textField:self.rightTF inputTextFieldChangeModel:self.passModel];
        }
    }];
    
    
}

- (void)setAddModel:(YSCRMYXBaseModel *)addModel {
    _addModel = addModel;
    _passModel = addModel;
    _accessorySwitch.hidden = YES;
    _rightTF.text = addModel.textTF;
    if (addModel.currentyStr && ![YSUtility judgeIsEmpty:addModel.textTF]) {
        _rightTF.text = [NSString stringWithFormat:@"%@%@", addModel.currentyStr, addModel.textTF];
    }
    _rightTF.placeholder = addModel.holderStr;
    _rightTF.enabled = !addModel.isTFEnabled;
    if (addModel.isMustWrite) {
        self.contentView.backgroundColor = [UIColor colorWithHexString:@"#FFFFF5"];
        NSMutableAttributedString *contentStr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@*", addModel.nameStr]];
        //找出特定字符在整个字符串中的位置
        NSRange redRange = NSMakeRange([[contentStr string] rangeOfString:@"*"].location, [[contentStr string] rangeOfString:@"*"].length);
        //修改特定字符的颜色
        [contentStr addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:redRange];
        //修改特定字符的字体大小
        [contentStr addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:16] range:redRange];
        _leftLab.attributedText = contentStr;
    }else {
        self.contentView.backgroundColor = [UIColor colorWithHexString:@"#FFFFFF"];
        _leftLab.text = addModel.nameStr;
    }
    CGFloat rightMasonry = -15*kHeightScale;//输入框约束
    switch (addModel.accessoryView) {
        case AccessoryViewTypeNone:
            {
                _accessoryBtn.hidden = YES;
                rightMasonry = -15*kWidthScale;
                [_rightTF mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.right.mas_equalTo(-15*kWidthScale);
                }];
            }
            break;
        case AccessoryViewTypeDisclosureIndicator:
        {
            _accessoryBtn.hidden = NO;
            [_accessoryBtn setImage:[UIImage imageNamed:@"arrow_right"] forState:(UIControlStateNormal)];
            [_accessoryBtn mas_updateConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(19*kHeightScale);
                make.size.mas_equalTo(CGSizeMake(6*kWidthScale, 12*kHeightScale));
            }];
            rightMasonry = -29*kWidthScale;
            [_rightTF mas_updateConstraints:^(MASConstraintMaker *make) {
                make.right.mas_equalTo(-29*kWidthScale);
            }];
            
        }
            break;
        case AccessoryViewTypeDetailDisclosureButton:
        {
            _accessoryBtn.hidden = NO;
            [_accessoryBtn setImage:[UIImage imageNamed:@"CRMYXPeopleImg"] forState:(UIControlStateNormal)];
            [_accessoryBtn mas_updateConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(15*kHeightScale);
                make.size.mas_equalTo(CGSizeMake(22*kWidthScale, 22*kHeightScale));
            }];
            rightMasonry = -45*kWidthScale;
            [_rightTF mas_updateConstraints:^(MASConstraintMaker *make) {
                make.right.mas_equalTo(-45*kWidthScale);
            }];
        }
            break;
            case AccessoryViewTypeDetailSwitchOFF:
        {
            _accessoryBtn.hidden = YES;
            _accessorySwitch.hidden = NO;
            [_accessorySwitch setOn:NO];
            [_accessoryBtn mas_updateConstraints:^(MASConstraintMaker *make) {
                make.size.mas_equalTo(CGSizeMake(22*kWidthScale, 22*kHeightScale));
            }];
            rightMasonry = -45*kWidthScale;
            [_rightTF mas_updateConstraints:^(MASConstraintMaker *make) {
                make.right.mas_equalTo(-45*kWidthScale);
            }];
        }
            break;
        case AccessoryViewTypeDetailSwitchON:
        {
            _accessoryBtn.hidden = YES;
            _accessorySwitch.hidden = NO;
            [_accessorySwitch setOn:YES];
            rightMasonry = -45*kWidthScale;
            [_rightTF mas_updateConstraints:^(MASConstraintMaker *make) {
                make.right.mas_equalTo(-45*kWidthScale);
            }];
        }
            break;
            case AccessoryViewTypeMoney:
        {
            _accessoryBtn.hidden = YES;
            _accessorySwitch.hidden = YES;
            rightMasonry = -15*kWidthScale;
            [_rightTF mas_updateConstraints:^(MASConstraintMaker *make) {
                make.right.mas_equalTo(-15*kWidthScale);
            }];

        }
            break;
            
        default:
            break;
    }
    
    if (![YSUtility judgeIsEmpty:addModel.textTF] && ([addModel.nameStr isEqualToString:@"项目名称"] || [addModel.nameStr isEqualToString:@"项目推进情况"] || [addModel.nameStr isEqualToString:@"问题与支持"] || [addModel.nameStr isEqualToString:@"工作所在地"] || [addModel.nameStr isEqualToString:@"丧事所在地"])) {
        self.hiddenLab.hidden = NO;
        self.hiddenLab.text = addModel.textTF;
        self.rightTF.textColor = [UIColor clearColor];
        [_leftLab mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(15*kWidthScale);
            make.width.mas_equalTo(131*kWidthScale);
            make.top.mas_equalTo(14*kHeightScale);
            
        }];
        [_rightTF mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(-15*kHeightScale);
        }];
    }else {
        self.hiddenLab.text = @"";
        self.hiddenLab.hidden = YES;
        self.rightTF.textColor = [UIColor colorWithHexString:@"#41485D"];
        [_leftLab mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(15*kWidthScale);
            make.width.mas_equalTo(131*kWidthScale);
            make.top.mas_equalTo(14*kHeightScale);
            make.bottom.mas_equalTo(-14*kHeightScale);
        }];
        [_rightTF mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(rightMasonry);
            make.left.mas_equalTo(_leftLab.mas_right).offset(8*kWidthScale);
            make.top.mas_equalTo(15*kHeightScale);
        }];
    }
}

- (void)setEditModel:(YSCRMYXBaseModel *)editModel {
    _editModel = editModel;
    _passModel = editModel;
    _accessorySwitch.hidden = YES;
    _rightTF.text = editModel.textTF;
    if (editModel.currentyStr && ![YSUtility judgeIsEmpty:editModel.textTF]) {
        _rightTF.text = [NSString stringWithFormat:@"%@%@", editModel.currentyStr, editModel.textTF];
    }
    _rightTF.placeholder = editModel.holderStr;
    _rightTF.enabled = !editModel.isTFEnabled;
    if (editModel.isMustWrite) {
        self.contentView.backgroundColor = [UIColor colorWithHexString:@"#FFFFF5"];
        NSMutableAttributedString *contentStr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@*", editModel.nameStr]];
        //找出特定字符在整个字符串中的位置
        NSRange redRange = NSMakeRange([[contentStr string] rangeOfString:@"*"].location, [[contentStr string] rangeOfString:@"*"].length);
        //修改特定字符的颜色
        [contentStr addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:redRange];
        //修改特定字符的字体大小
        [contentStr addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:16] range:redRange];
        _leftLab.attributedText = contentStr;
    }else {
        self.contentView.backgroundColor = [UIColor colorWithHexString:@"#FFFFFF"];
        _leftLab.text = editModel.nameStr;
    }
    _rightTF.hidden = NO;
    CGFloat rightMasonry = -15*kHeightScale;//输入框约束
    switch (editModel.accessoryView) {
        case AccessoryViewTypeNone:
        {
            _accessoryBtn.hidden = YES;
            rightMasonry = -15*kWidthScale;
            [_rightTF mas_updateConstraints:^(MASConstraintMaker *make) {
                make.right.mas_equalTo(-15*kWidthScale);
            }];
        }
            break;
        case AccessoryViewTypeDisclosureIndicator:
        {
            _accessoryBtn.hidden = NO;
            [_accessoryBtn setImage:[UIImage imageNamed:@"arrow_right"] forState:(UIControlStateNormal)];
            [_accessoryBtn mas_updateConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(19*kHeightScale);
                make.size.mas_equalTo(CGSizeMake(6*kWidthScale, 12*kHeightScale));
            }];
            rightMasonry = -29*kWidthScale;
            [_rightTF mas_updateConstraints:^(MASConstraintMaker *make) {
                make.right.mas_equalTo(-29*kWidthScale);
            }];
            
        }
            break;
        case AccessoryViewTypeDetailDisclosureButton:
        {
            _accessoryBtn.hidden = NO;
            [_accessoryBtn setImage:[UIImage imageNamed:@"CRMYXPeopleImg"] forState:(UIControlStateNormal)];
            [_accessoryBtn mas_updateConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(15*kHeightScale);
                make.size.mas_equalTo(CGSizeMake(22*kWidthScale, 22*kHeightScale));
            }];
            rightMasonry = -45*kWidthScale;
            [_rightTF mas_updateConstraints:^(MASConstraintMaker *make) {
                make.right.mas_equalTo(-45*kWidthScale);
            }];
        }
            break;
        case AccessoryViewTypeDetailSwitchOFF:
        {
            _rightTF.hidden = YES;
            _accessoryBtn.hidden = YES;
            _accessorySwitch.hidden = NO;
            [_accessorySwitch setOn:NO];
            [_accessoryBtn mas_updateConstraints:^(MASConstraintMaker *make) {
                make.size.mas_equalTo(CGSizeMake(22*kWidthScale, 22*kHeightScale));
            }];
            rightMasonry = -45*kWidthScale;
            [_rightTF mas_updateConstraints:^(MASConstraintMaker *make) {
                make.right.mas_equalTo(-45*kWidthScale);
            }];
        }
            break;
        case AccessoryViewTypeDetailSwitchON:
        {
            _rightTF.hidden = YES;
            _accessoryBtn.hidden = YES;
            _accessorySwitch.hidden = NO;
            [_accessorySwitch setOn:YES];
            rightMasonry = -45*kWidthScale;
            [_rightTF mas_updateConstraints:^(MASConstraintMaker *make) {
                make.right.mas_equalTo(-45*kWidthScale);
            }];
        }
            break;
        case AccessoryViewTypeMoney:
        {
            _accessoryBtn.hidden = YES;
            _accessorySwitch.hidden = YES;
            rightMasonry = -15*kWidthScale;
            [_rightTF mas_updateConstraints:^(MASConstraintMaker *make) {
                make.right.mas_equalTo(-15*kWidthScale);
            }];
            
        }
            break;
        default:
            break;
    }
    
    if (![YSUtility judgeIsEmpty:editModel.textTF] && ([editModel.nameStr isEqualToString:@"项目名称"] || [editModel.nameStr isEqualToString:@"项目推进情况"] || [editModel.nameStr isEqualToString:@"问题与支持"] || [editModel.nameStr isEqualToString:@"备注"] || [editModel.nameStr isEqualToString:@"质量要求"] || [editModel.nameStr isEqualToString:@"其他配合"])) {//自适应
        self.hiddenLab.hidden = NO;
        self.hiddenLab.text = editModel.textTF;
        self.rightTF.textColor = [UIColor clearColor];
        [_leftLab mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(15*kWidthScale);
            make.width.mas_equalTo(131*kWidthScale);
            make.top.mas_equalTo(14*kHeightScale);
            
        }];
        [_rightTF mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(-15*kHeightScale);
        }];
    }else {
        self.hiddenLab.text = @"";
        self.hiddenLab.hidden = YES;
        self.rightTF.textColor = [UIColor colorWithHexString:@"#41485D"];
        [_leftLab mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(15*kWidthScale);
            make.width.mas_equalTo(131*kWidthScale);
            make.top.mas_equalTo(14*kHeightScale);
            make.bottom.mas_equalTo(-14*kHeightScale);
        }];
        [_rightTF mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(rightMasonry);
            make.left.mas_equalTo(_leftLab.mas_right).offset(8*kWidthScale);
            make.top.mas_equalTo(15*kHeightScale);
        }];
    }
}

// 异常申诉
- (void)setComplaintFlowModel:(YSCRMYXBaseModel *)complaintFlowModel {
    _complaintFlowModel = complaintFlowModel;
    _passModel = complaintFlowModel;
    _accessorySwitch.hidden = YES;
    _rightTF.text = complaintFlowModel.textTF;
    if (complaintFlowModel.currentyStr && ![YSUtility judgeIsEmpty:complaintFlowModel.textTF]) {
        _rightTF.text = [NSString stringWithFormat:@"%@%@", complaintFlowModel.currentyStr, complaintFlowModel.textTF];
    }
    _rightTF.placeholder = complaintFlowModel.holderStr;
    _rightTF.enabled = !complaintFlowModel.isTFEnabled;
    if (complaintFlowModel.isMustWrite) {
        self.contentView.backgroundColor = [UIColor colorWithHexString:@"#FFFFF5"];
        NSMutableAttributedString *contentStr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@*", complaintFlowModel.nameStr]];
        //找出特定字符在整个字符串中的位置
        NSRange redRange = NSMakeRange([[contentStr string] rangeOfString:@"*"].location, [[contentStr string] rangeOfString:@"*"].length);
        //修改特定字符的颜色
        [contentStr addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:redRange];
        //修改特定字符的字体大小
        [contentStr addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:16] range:redRange];
        _leftLab.attributedText = contentStr;
    }else {
        self.contentView.backgroundColor = [UIColor colorWithHexString:@"#FFFFFF"];
        _leftLab.text = complaintFlowModel.nameStr;
    }
    CGFloat rightMasonry = -15*kHeightScale;//输入框约束
    switch (complaintFlowModel.accessoryView) {
        case AccessoryViewTypeNone:
            {
                _accessoryBtn.hidden = YES;
                rightMasonry = -15*kWidthScale;
                [_rightTF mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.right.mas_equalTo(-15*kWidthScale);
                }];
            }
            break;
        case AccessoryViewTypeDisclosureIndicator:
        {
            _accessoryBtn.hidden = NO;
            [_accessoryBtn setImage:[UIImage imageNamed:@"arrow_right"] forState:(UIControlStateNormal)];
            [_accessoryBtn mas_updateConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(19*kHeightScale);
                make.size.mas_equalTo(CGSizeMake(6*kWidthScale, 12*kHeightScale));
            }];
            rightMasonry = -29*kWidthScale;
            [_rightTF mas_updateConstraints:^(MASConstraintMaker *make) {
                make.right.mas_equalTo(-29*kWidthScale);
            }];
            
        }
            break;
        case AccessoryViewTypeDetailDisclosureButton:
        {
            _accessoryBtn.hidden = NO;
            [_accessoryBtn setImage:[UIImage imageNamed:@"CRMYXPeopleImg"] forState:(UIControlStateNormal)];
            [_accessoryBtn mas_updateConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(15*kHeightScale);
                make.size.mas_equalTo(CGSizeMake(22*kWidthScale, 22*kHeightScale));
            }];
            rightMasonry = -45*kWidthScale;
            [_rightTF mas_updateConstraints:^(MASConstraintMaker *make) {
                make.right.mas_equalTo(-45*kWidthScale);
            }];
        }
            break;
            case AccessoryViewTypeDetailSwitchOFF:
        {
            _accessoryBtn.hidden = YES;
            _accessorySwitch.hidden = NO;
            [_accessorySwitch setOn:NO];
            [_accessoryBtn mas_updateConstraints:^(MASConstraintMaker *make) {
                make.size.mas_equalTo(CGSizeMake(22*kWidthScale, 22*kHeightScale));
            }];
            rightMasonry = -45*kWidthScale;
            [_rightTF mas_updateConstraints:^(MASConstraintMaker *make) {
                make.right.mas_equalTo(-45*kWidthScale);
            }];
        }
            break;
        case AccessoryViewTypeDetailSwitchON:
        {
            _accessoryBtn.hidden = YES;
            _accessorySwitch.hidden = NO;
            [_accessorySwitch setOn:YES];
            rightMasonry = -45*kWidthScale;
            [_rightTF mas_updateConstraints:^(MASConstraintMaker *make) {
                make.right.mas_equalTo(-45*kWidthScale);
            }];
        }
            break;
            case AccessoryViewTypeMoney:
        {
            _accessoryBtn.hidden = YES;
            _accessorySwitch.hidden = YES;
            rightMasonry = -15*kWidthScale;
            [_rightTF mas_updateConstraints:^(MASConstraintMaker *make) {
                make.right.mas_equalTo(-15*kWidthScale);
            }];

        }
            break;
            
        default:
            break;
    }
    
    if (![YSUtility judgeIsEmpty:complaintFlowModel.textTF] && ([complaintFlowModel.nameStr isEqualToString:@"打卡时间"] || [complaintFlowModel.nameStr isEqualToString:@"项目名称"])) {
        self.hiddenLab.hidden = NO;
        self.hiddenLab.textColor = [UIColor colorWithHexString:@"#0000FF"];
        self.hiddenLab.text = complaintFlowModel.textTF;
        self.rightTF.textColor = [UIColor clearColor];
        
        [_hiddenLab mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(-21*kWidthScale);
            make.left.mas_equalTo(98*kWidthScale);
            make.top.mas_equalTo(15*kHeightScale);
            make.bottom.mas_equalTo(-14*kHeightScale);
        }];
        [_leftLab mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(15*kWidthScale);
            make.width.mas_equalTo(131*kWidthScale);
            make.top.mas_equalTo(14*kHeightScale);
            
        }];
        [_rightTF mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(-15*kHeightScale);
        }];
    }else {
        self.hiddenLab.text = @"";
        self.hiddenLab.hidden = YES;
        self.rightTF.textColor = [UIColor colorWithHexString:@"#0000FF"];
        [_leftLab mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(15*kWidthScale);
            make.width.mas_equalTo(131*kWidthScale);
            make.top.mas_equalTo(14*kHeightScale);
            make.bottom.mas_equalTo(-14*kHeightScale);
        }];
        [_rightTF mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(rightMasonry);
            make.left.mas_equalTo(_leftLab.mas_right).offset(8*kWidthScale);
            make.top.mas_equalTo(15*kHeightScale);
        }];
    }
}

// 复工证明申请
- (void)setWorkProveModel:(YSCRMYXBaseModel *)workProveModel {
    _rightTF.textColor = [UIColor colorWithHexString:@"#FF0000FF"];
    _rightTF.font = [UIFont fontWithName:@"PingFangSC-Regular" size:Multiply(15)];
    self.contentView.backgroundColor = [UIColor colorWithHexString:@"#FFFFFF"];
    _workProveModel = workProveModel;
    _passModel = workProveModel;
    _accessorySwitch.hidden = YES;
    _rightTF.text = workProveModel.textTF;
    _rightTF.placeholder = workProveModel.holderStr;
    _rightTF.enabled = !workProveModel.isTFEnabled;
    if (workProveModel.isMustWrite) {
        NSMutableAttributedString *contentStr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@*", workProveModel.nameStr]];
        //找出特定字符在整个字符串中的位置
        NSRange redRange = NSMakeRange([[contentStr string] rangeOfString:@"*"].location, [[contentStr string] rangeOfString:@"*"].length);
        //修改特定字符的颜色
        [contentStr addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:redRange];
        //修改特定字符的字体大小
        [contentStr addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:14] range:redRange];
        _leftLab.attributedText = contentStr;
    }else {
        _leftLab.text = workProveModel.nameStr;
    }
    CGFloat rightMasonry = -15*kHeightScale;//输入框约束
    switch (workProveModel.accessoryView) {
        case AccessoryViewTypeNone:
        {
            _accessoryBtn.hidden = YES;
            rightMasonry = -15*kWidthScale;
            [_rightTF mas_updateConstraints:^(MASConstraintMaker *make) {
                make.right.mas_equalTo(-15*kWidthScale);
            }];
        }
            break;
        case AccessoryViewTypeDisclosureIndicator:
        {
            _accessoryBtn.hidden = NO;
            [_accessoryBtn setImage:[UIImage imageNamed:@"arrow_right"] forState:(UIControlStateNormal)];
            [_accessoryBtn mas_updateConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(19*kHeightScale);
                make.size.mas_equalTo(CGSizeMake(6*kWidthScale, 12*kHeightScale));
            }];
            rightMasonry = -29*kWidthScale;
            [_rightTF mas_updateConstraints:^(MASConstraintMaker *make) {
                make.right.mas_equalTo(-29*kWidthScale);
            }];
            
        }
            break;
        default:
            break;
    }
    
}

- (void)setModifyModel:(YSCRMYXBaseModel *)modifyModel {
    _rightTF.textColor = [UIColor colorWithHexString:@"#FF0000FF"];
    _rightTF.font = [UIFont fontWithName:@"PingFangSC-Regular" size:Multiply(15)];
    self.contentView.backgroundColor = [UIColor colorWithHexString:@"#FFFFFF"];
    _workProveModel = modifyModel;
    _passModel = modifyModel;
    _accessorySwitch.hidden = YES;
    _rightTF.text = modifyModel.textTF;
    _rightTF.placeholder = modifyModel.holderStr;
    _rightTF.enabled = !modifyModel.isTFEnabled;
    if (modifyModel.isMustWrite) {
        NSMutableAttributedString *contentStr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@*", modifyModel.nameStr]];
        //找出特定字符在整个字符串中的位置
        NSRange redRange = NSMakeRange([[contentStr string] rangeOfString:@"*"].location, [[contentStr string] rangeOfString:@"*"].length);
        //修改特定字符的颜色
        [contentStr addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:redRange];
        //修改特定字符的字体大小
        [contentStr addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:14] range:redRange];
        _leftLab.attributedText = contentStr;
    }else {
        _leftLab.text = modifyModel.nameStr;
    }
    CGFloat rightMasonry = -15*kHeightScale;//输入框约束
    switch (modifyModel.accessoryView) {
        case AccessoryViewTypeNone:
        {
            _accessoryBtn.hidden = YES;
            rightMasonry = -15*kWidthScale;
            [_rightTF mas_updateConstraints:^(MASConstraintMaker *make) {
                make.right.mas_equalTo(-15*kWidthScale);
            }];
        }
            break;
        case AccessoryViewTypeDisclosureIndicator:
        {
            _accessoryBtn.hidden = NO;
            [_accessoryBtn setImage:[UIImage imageNamed:@"arrow_right"] forState:(UIControlStateNormal)];
            [_accessoryBtn mas_updateConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(19*kHeightScale);
                make.size.mas_equalTo(CGSizeMake(6*kWidthScale, 12*kHeightScale));
            }];
            rightMasonry = -29*kWidthScale;
            [_rightTF mas_updateConstraints:^(MASConstraintMaker *make) {
                make.right.mas_equalTo(-29*kWidthScale);
            }];
            
        }
            break;
        default:
            break;
    }
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
