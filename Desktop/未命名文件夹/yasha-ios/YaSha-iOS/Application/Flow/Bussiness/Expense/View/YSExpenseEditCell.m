//
//  YSExpenseEditCell.m
//  YaSha-iOS
//
//  Created by 龚守辉 on 2018/3/9.
//  Copyright © 2018年 亚厦装饰股份有限公司. All rights reserved.
//

#import "YSExpenseEditCell.h"
@interface YSExpenseEditCell()<UITextFieldDelegate>
@property (nonatomic,strong) UILabel *departmentLb;
@property (nonatomic,strong) UILabel *totalLb;
@property (nonatomic,strong) NSArray *titleArr;
@end
@implementation YSExpenseEditCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if ([super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self initUI];
       
    }
    return self;
}
- (void)initUI {
    self.departmentLb = [[UILabel alloc]init];
    _departmentLb.font = [UIFont systemFontOfSize:14];
    _departmentLb.numberOfLines = 0;
    _departmentLb.textColor = kGrayColor(51);
    [self.contentView addSubview:_departmentLb];
    [self.departmentLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(10);
        make.left.mas_equalTo(15);
    }];
    self.totalLb = [[UILabel alloc]init];
    _totalLb.font = [UIFont systemFontOfSize:14];
    _totalLb.textColor = kGrayColor(51);
    _totalLb.textAlignment = NSTextAlignmentLeft;
    [self.contentView addSubview:_totalLb];
    [self.totalLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(10);
        make.left.mas_equalTo(self.departmentLb.mas_right).offset(15);
        make.right.mas_equalTo(-15);
        make.height.mas_equalTo(21);
    }];
    UIView *lineView = [[UIView alloc] init];
    lineView.backgroundColor = kGrayColor(229);
    [self.contentView addSubview:lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.right.mas_equalTo(0);
        make.top.mas_equalTo(self.departmentLb.mas_bottom).offset(10);
        make.height.mas_equalTo(1);
    }];
    
    NSArray *titleArr = @[@"经营性费用",@"非经营性费用",@"固定补贴费用",@"公司承担费用"];
    self.titleArr = titleArr;
    YSExpenseTextFieldView *lastView = nil;
    for (int i = 0; i < titleArr.count; i++) {
        YSExpenseTextFieldView *view = [[YSExpenseTextFieldView alloc]init];
        view.textField.delegate = self;
        view.textField.tag = 500 + i;
        view.nameLb.text = titleArr[i];
        [self.contentView addSubview:view];
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            if (i == 0) {
                make.top.mas_equalTo(lineView.mas_bottom).offset(5);
            }else {
                make.top.mas_equalTo(lastView.mas_bottom).offset(5);
            }
            make.left.mas_equalTo(0);
            make.right.mas_equalTo(0);
            make.height.mas_equalTo(40);
            if (i == titleArr.count - 1) {
                make.bottom.mas_equalTo(-5);
            }
        }];
        
        lastView = view;
    }
}

- (void)setModel:(YSFlowExpenseShareDetailModel *)model {
    _model = model;
    CGSize departSize = [model.costOwnerDept boundingRectWithSize:CGSizeMake(MAXFLOAT, 21) options:NSStringDrawingUsesLineFragmentOrigin |NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]} context:nil].size;
    if (kSCREEN_WIDTH - 100 < departSize.width) {
        [self.departmentLb mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(10);
            make.left.mas_equalTo(15);
            make.right.mas_equalTo(-100 - 15);
        }];
        [self.totalLb mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(13);
        }];
    }else{
        [self.departmentLb mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(10);
            make.left.mas_equalTo(15);
        }];
        [self.totalLb mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(10);
        }];
    }
    self.departmentLb.text = model.costOwnerDept;
    self.totalLb.text = [NSString stringWithFormat:@"￥%.2f",model.money];
    
    
    
    //把四个具体金额的放入数组中便于处理，detailItem手动添加的不是后台返回的
//    if (_model.detailItem.count) {
        //设置具体的textfield的值
        for (int i = 0; i < self.titleArr.count; i++) {
            YSTextField *textFieldView = [self.contentView viewWithTag:(500 + i)] ;
            NSString *text = nil;
            switch (i) {
                case 0:
                    text = [NSString stringWithFormat:@"%.2f",model.operateCost];
                    break;
                case 1:
                    text = [NSString stringWithFormat:@"%.2f",model.noOperateCost];
                    break;
                case 2:
                    text = [NSString stringWithFormat:@"%.2f",model.fixedSubsidy];
                    break;
                case 3:
                    text = [NSString stringWithFormat:@"%.2f",model.compBear];
                    break;
                    
                default:
                    break;
            }
            textFieldView.text = text;
        }
}
#pragma mark - textfield代理方法
//- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
//
//    DLog(@"Change----%@",textField.text);
//    NSString *key = [NSString stringWithFormat:@"%ld",textField.tag - 500];
//    if ([self.delegate respondsToSelector:@selector(expenseEditCell:position:)]) {
//        [self.delegate expenseEditCell:self position:@{key:textField.text}];
//    }
//    return YES;
//}
//- (BOOL)textFieldShouldEndEditing:(UITextField *)textField {
//    DLog(@"Should----%@",textField.text);
//    return YES;
//}
- (void)textFieldDidEndEditing:(UITextField *)textField {
    //编辑后的数据记在model里
    NSInteger index = textField.tag - 500;
    switch (index) {
        case 0:
            _model.operateCost = [textField.text floatValue];
            break;
        case 1:
            _model.noOperateCost = [textField.text floatValue];
            break;
        case 2:
            _model.fixedSubsidy = [textField.text floatValue];
            break;
        case 3:
            _model.compBear = [textField.text floatValue];
            break;
            
        default:
            break;
    }
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self endEditing:YES];
    return YES;
}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
@implementation YSExpenseTextFieldView
//如果需要自适应高度，这里约束要自上而下
- (instancetype)initWithFrame:(CGRect)frame {
    if ([super initWithFrame:frame]) {
        [self initUI];
    }
    return self;
}
- (void)initUI {
    UILabel *nameLb = [[UILabel alloc] init];
    nameLb.text = @"经营性费用：";
    nameLb.font = [UIFont fontWithName:@"PingFang-SC-Medium" size:14];
    nameLb.textColor = kGrayColor(153);
    self.nameLb = nameLb;
    [self addSubview:self.nameLb];
    [self.nameLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(0);
        make.left.mas_equalTo(15);
        make.width.mas_equalTo(90);
    }];
    self.textField = [[YSTextField alloc]init];
    self.textField.borderStyle = UITextBorderStyleRoundedRect;
    self.textField.returnKeyType = UIReturnKeyDone;
    self.textField.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
    [self addSubview:self.textField];
    [self.textField setImageName:@"¥" frame:CGRectMake(10, 0, 10, 13) backgroundFrame:CGRectMake(0, 0, 20, 13) placeholder:@"请输入金额"];
    self.textField.leftViewMode = UITextFieldViewModeAlways;
    [self.textField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.nameLb.mas_right).offset(5);
        make.centerY.mas_equalTo(0);
        make.right.mas_equalTo(-15);
    }];
    
}
- (void)layoutSubviews {
    [super layoutSubviews];
    
    
}
@end
