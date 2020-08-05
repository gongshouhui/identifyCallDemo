//
//  YSPMSInfoDetailHeaderCell.m
//  YaSha-iOS
//
//  Created by 方鹏俊 on 2017/8/30.
//
//

#import "YSPMSInfoDetailHeaderCell.h"

@interface YSPMSInfoDetailHeaderCell ()

@end

@implementation YSPMSInfoDetailHeaderCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self initUI];
    }
    return self;
}

- (void)initUI {
    self.titleLabel = [[UILabel alloc]init];
    self.titleLabel.font = [UIFont systemFontOfSize:14];
    self.titleLabel.numberOfLines = 0;
    self.titleLabel.textColor = kUIColor(153, 153, 153, 1.0);
    [self.contentView addSubview:self.titleLabel];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.contentView.mas_top).offset(10);
        make.left.mas_equalTo(self.contentView.mas_left).offset(16);
        make.bottom.mas_equalTo(-10);
        make.width.mas_equalTo(110*kWidthScale);
    }];
    
    self.contentLabel = [[UILabel alloc]init];
    self.contentLabel.font = [UIFont systemFontOfSize:14];
    self.contentLabel.textAlignment = NSTextAlignmentRight;
    self.contentLabel.numberOfLines = 0;
    self.contentLabel.textColor = kUIColor(51, 51, 51, 1.0);
    [self.contentView addSubview:self.contentLabel];
    [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.mas_equalTo(self.contentView.mas_top).offset(10);
        make.bottom.mas_equalTo(self.contentView.mas_bottom).offset(-10);
        
        make.left.mas_equalTo(self.titleLabel.mas_right).offset(12);
        make.right.mas_equalTo(self.contentView.mas_right).offset(-15);
    }];
    
    self.lineView = [[UIView alloc]init];
    self.lineView.backgroundColor = kUIColor(220, 220, 223, 1.0);
   
    
}

- (void)setInfoDetailCellData:(NSString *)priceStr  andLetters:(NSArray *)handelLettersArr andPayments:(NSArray *)handelPaymentsArr andIndexPath:(NSIndexPath *)indexPath{
    NSArray *twoGroupArr = @[@"类型",@"备注"];
    NSArray *threeGroupArr = @[@"类型",@"比例",@"备注"];
    [self.titleLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.contentView.mas_centerY);
        make.left.mas_equalTo(self.contentView.mas_left).offset(22*kWidthScale);
        make.size.mas_equalTo(CGSizeMake(74*kWidthScale, 25*kHeightScale));
    }];
    self.contentLabel.textAlignment = NSTextAlignmentLeft;
    [self.contentLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.contentView.mas_centerY);
        make.left.mas_equalTo(self.titleLabel.mas_right).offset(17);
        make.size.mas_equalTo(CGSizeMake(180*kWidthScale, 25*kHeightScale));
    }];
    if (indexPath.section == 0) {
        if (priceStr.length>0 && priceStr != nil) {
            self.titleLabel.text = @"保证金金额";
            self.contentLabel.text =  [NSString stringWithFormat:@"¥ %@ 万元",priceStr];
        }else{
            self.contentLabel.text = @"暂无履约保证金数据";
        }
    }else if (indexPath.section == 1) {
        if (indexPath.row%2 == 1) {
            [self.contentView addSubview:self.lineView];
            [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(self.mas_bottom).offset(-1);
                make.size.mas_offset(CGSizeMake(kSCREEN_WIDTH, 1));
            }];
        }
        if ([handelLettersArr[0] isEqual:@"暂无保函信息数据"]) {
            self.contentLabel.text = handelLettersArr[indexPath.row];
            self.titleLabel.text = nil;
        }else{
            self.titleLabel.text = twoGroupArr[indexPath.row%2];
            self.contentLabel.text = handelLettersArr[indexPath.row];
        }
    }else {
        if (indexPath.row%3 == 2) {
            [self.contentView addSubview:self.lineView];
            [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(self.mas_bottom).offset(-1);
                make.size.mas_offset(CGSizeMake(kSCREEN_WIDTH, 1));
            }];
        }
        if ([handelPaymentsArr[0] isEqual:@"暂无付款信息数据"]) {
            self.contentLabel.text = handelPaymentsArr[indexPath.row];
            self.titleLabel.text = nil;
        }else{
            self.titleLabel.text = threeGroupArr[indexPath.row%3];
            self.contentLabel.text = handelPaymentsArr[indexPath.row];
        }
    }
 
}
- (void)setDic:(NSDictionary *)dic
{
    _dic = dic;

    NSMutableAttributedString *contentStr = [[NSMutableAttributedString alloc]initWithString:[dic allKeys].firstObject];
    //找出特定字符在整个字符串中的位置
    NSRange redRange = NSMakeRange([[contentStr string] rangeOfString:@"*"].location, [[contentStr string] rangeOfString:@"*"].length);
    //修改特定字符的颜色
    [contentStr addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:redRange];
    //修改特定字符的字体大小
    [contentStr addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:14] range:redRange];
    [self.titleLabel setAttributedText:contentStr];
//    self.titleLabel.text = [dic allKeys].firstObject;
    
    if ([[dic allValues].firstObject isKindOfClass:[NSString class]]) {
        self.contentLabel.text = [dic allValues].firstObject;
    }else{
        self.contentLabel.text = [NSString stringWithFormat:@"%@",[dic allValues].firstObject];
    }
//    if (self.contentLabel.text.length == 0) {
//        self.contentLabel.text = @"--";
//    }
    
}
@end
