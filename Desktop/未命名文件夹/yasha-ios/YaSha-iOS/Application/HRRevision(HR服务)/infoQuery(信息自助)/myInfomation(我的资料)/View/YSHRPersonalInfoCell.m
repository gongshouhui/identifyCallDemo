//
//  YSPersonalInfoCell.m
//  YaSha-iOS
//
//  Created by 蘑菇加 on 2017/12/8.
//  Copyright © 2017年 亚厦装饰股份有限公司. All rights reserved.
//

#import "YSHRPersonalInfoCell.h"
@interface YSHRPersonalInfoCell()

@property (nonatomic,strong)UIView *backGroundView;
@end
@implementation YSHRPersonalInfoCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self initUI];
    }
    return self;
}

- (void)initUI{
    
//    self.backgroundColor = kUIColor(229, 229, 229, 1);
    
//    self.backGroundView = [[UIView alloc]init];
//    self.backGroundView.backgroundColor = [UIColor whiteColor];
//    [self.contentView addSubview:self.backGroundView];
//    [self.backGroundView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.mas_equalTo(10);
//        make.right.mas_equalTo(-10);
//        make.top.bottom.mas_equalTo(0);
//    }];
    
    self.titleLb = [[UILabel alloc]init];
    self.titleLb.numberOfLines = 0;
    self.titleLb.font = [UIFont systemFontOfSize:14];
    self.titleLb.textColor = kUIColor(25, 31, 37, 1);
    [self.contentView addSubview:self.titleLb];
    [self.titleLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(17);
        //make.bottom.mas_equalTo(-17);
        make.width.mas_equalTo(80*kWidthScale);
        make.left.mas_equalTo(16);
        
    }];
    
    self.detailLb = [[UILabel alloc]init];
    self.detailLb.font = [UIFont systemFontOfSize:14];
    self.detailLb.textColor = kUIColor(153, 153, 153, 1);
    self.detailLb.numberOfLines = 0;
    self.detailLb.textAlignment = NSTextAlignmentRight;
    [self.contentView addSubview:self.detailLb];
    
    [self.detailLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(17);
        make.bottom.mas_equalTo(-17);
        make.left.mas_equalTo(_titleLb.mas_right).mas_equalTo(30*kWidthScale);
        make.right.mas_equalTo(-16);
    }];
    
    
}

- (void)layoutSubviews {
    [super layoutSubviews];
}


- (void)setDic:(NSDictionary *)dic{
    _dic = dic;
    NSString *key = [dic allKeys].firstObject;
    NSString *value = [dic allValues].firstObject;
    if ([key isEqualToString:@"身高"]) {
        self.titleLb.text = key;
        if (value.length > 0) {
            NSString *textStr = [NSString stringWithFormat:@"%@ CM",value];
            NSMutableAttributedString *attriStr = [[NSMutableAttributedString alloc]initWithString:textStr];
            [attriStr addAttributes:@{NSForegroundColorAttributeName:kUIColor(152, 163, 178, 1),NSFontAttributeName:[UIFont systemFontOfSize:12]} range:[textStr rangeOfString:@"CM"]];
            self.detailLb.attributedText = attriStr;
        }else{
            self.detailLb.text = value;
        }
        
    }else if([key isEqualToString:@"体重"]){
        self.titleLb.text = key;
        if (value.length > 0) {
            NSString *textStr = [NSString stringWithFormat:@"%@ KG",value];
            NSMutableAttributedString *attriStr = [[NSMutableAttributedString alloc]initWithString:textStr];
            [attriStr addAttributes:@{NSForegroundColorAttributeName:kUIColor(152, 163, 178, 1),NSFontAttributeName:[UIFont systemFontOfSize:12]} range:[textStr rangeOfString:@"KG"]];
            self.detailLb.attributedText = attriStr;
        }else{
            self.detailLb.text = value;
        }
        
    }else{
        self.titleLb.text = key;
        self.detailLb.text = value;
    }
    
    if (self.detailLb.text.length == 0) {
        self.detailLb.text = @"    ";
    }
   
    
    
}
- (void)setOtherByIndexPath:(NSIndexPath *)indexPath withArray:(NSArray *)array{
    
    [self layoutIfNeeded];
    if (indexPath.row == 0) {
        UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, 0, kSCREEN_WIDTH - 30, 40*kHeightScale) byRoundingCorners:UIRectCornerTopLeft|UIRectCornerTopRight cornerRadii:CGSizeMake(10, 10)];
        CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
        maskLayer.frame = CGRectMake(0, 0, kSCREEN_WIDTH - 30, 40*kHeightScale);
        maskLayer.path = maskPath.CGPath;
        self.backGroundView.layer.mask = maskLayer;
        
    }
    if (indexPath.row == array.count - 1) {
        
        
        UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, 0, kSCREEN_WIDTH - 30, 40*kHeightScale) byRoundingCorners:UIRectCornerBottomLeft|UIRectCornerBottomRight cornerRadii:CGSizeMake(10, 10)];
        
        CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
        maskLayer.frame = CGRectMake(0, 0, kSCREEN_WIDTH - 30, 40*kHeightScale);
        maskLayer.path = maskPath.CGPath;
        self.backGroundView.layer.mask = maskLayer;
        
        if (!(indexPath.section == 0)) {
            self.titleLb.font = [UIFont systemFontOfSize:16];
            
            self.detailLb.font =  [UIFont fontWithName:@"PingFangTC-Medium" size:16];
        }
    }
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
