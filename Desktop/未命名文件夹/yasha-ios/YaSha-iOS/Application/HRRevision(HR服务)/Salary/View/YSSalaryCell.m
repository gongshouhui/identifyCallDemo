//
//  YSSalaryCell.m
//  YaSha-iOS
//
//  Created by 蘑菇加 on 2017/11/24.
//

#import "YSSalaryCell.h"
@interface YSSalaryCell()
@property (nonatomic,strong)UILabel *titleLb;
@property (nonatomic,strong)UILabel *detailLb;
@property (nonatomic,strong)UIView *backGroundView;
@end
@implementation YSSalaryCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self initUI];
    }
    return self;
}

- (void)initUI{

    self.backgroundColor = kUIColor(229, 229, 229, 1);
    
    self.backGroundView = [[UIView alloc]init];
    self.backGroundView.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:self.backGroundView];
    [self.backGroundView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.right.mas_equalTo(-15);
        make.top.bottom.mas_equalTo(0);
    }];
    
    self.titleLb = [[UILabel alloc]init];
    self.titleLb.font = [UIFont systemFontOfSize:14];
    self.titleLb.textColor = kUIColor(153, 153, 153, 1);
    [self.backGroundView addSubview:self.titleLb];
    [self.titleLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(0);
        make.left.mas_equalTo(18);
        
    }];
    
    self.detailLb = [[UILabel alloc]init];
    self.detailLb.font = [UIFont systemFontOfSize:14];
    self.detailLb.textColor = kUIColor(51, 51, 51, 1);
    [self.backGroundView addSubview:self.detailLb];
    
    [self.detailLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(0);
        make.left.mas_equalTo(450/2*kWidthScale);
    }];
    
    
}

- (void)layoutSubviews {
    [super layoutSubviews];
}


- (void)setDic:(NSDictionary *)dic{
    _dic = dic;
    self.titleLb.text = [dic allKeys].firstObject;
    self.detailLb.text = [dic allValues].firstObject;
    
    
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
