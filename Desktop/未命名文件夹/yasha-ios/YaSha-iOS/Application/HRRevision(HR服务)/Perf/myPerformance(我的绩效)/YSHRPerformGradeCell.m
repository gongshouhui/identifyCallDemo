//
//  YSHRPerformGradeCell.m
//  YaSha-iOS
//
//  Created by 罗罗诺亚索隆 on 2019/1/9.
//  Copyright © 2019 亚厦装饰股份有限公司. All rights reserved.
//

#import "YSHRPerformGradeCell.h"
@interface YSHRPerformGradeCell()
@property (nonatomic,strong) UIImageView *leftImageView;
@property (nonatomic,strong) UILabel *yearLb;
@property (nonatomic,strong) UILabel *detailLb;
@property (nonatomic,strong) UIImageView *borderIV;
@end
@implementation YSHRPerformGradeCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self initUI];
    }
    return self;
}
- (void)initUI {
    
    self.leftImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"进度"]];
    [self addSubview:self.leftImageView];
    [self.leftImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.top.mas_equalTo(20);
        make.width.mas_equalTo(15);
        make.bottom.mas_equalTo(0);
    }];
    
    self.yearLb = [[UILabel alloc]initWithFont:[UIFont fontWithName:@"PingFangSC-Medium" size:Multiply(20)] textColor:[UIColor blackColor]];
    self.yearLb.text = @"2018";
    [self addSubview:self.yearLb];
    [self.yearLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.leftImageView.mas_top).offset(-9);
        make.left.mas_equalTo(self.leftImageView.mas_right).mas_equalTo(15);
        make.height.mas_equalTo(28);
    }];
    
    
    
    self.borderIV = [[UIImageView alloc]init];
    [self addSubview:self.borderIV];
    [self.borderIV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.yearLb.mas_left);
        make.top.mas_equalTo(self.yearLb.mas_bottom).mas_equalTo(5);
        make.right.mas_equalTo(-15);
        make.bottom.mas_equalTo(-20);
    }];
    // 加载图片
    UIImage *image = [UIImage imageNamed:@"内容框"];
    // 设置端盖的值
    CGFloat top = image.size.height * 0.5;
    CGFloat left = image.size.width * 0.5;
    CGFloat bottom = image.size.height * 0.5;
    CGFloat right = image.size.width * 0.5;
    
    // 设置端盖的值
    UIEdgeInsets edgeInsets = UIEdgeInsetsMake(top, left, bottom, right);
    // 设置拉伸的模式
    UIImageResizingMode mode = UIImageResizingModeStretch;
    
    // 拉伸图片
    UIImage *newImage = [image resizableImageWithCapInsets:edgeInsets resizingMode:mode];
    
    // 设置按钮的背景图片
    self.borderIV.image = newImage;
    
    
    
    self.detailLb = [[UILabel alloc]initWithFont:[UIFont systemFontOfSize:15] textColor:[UIColor blackColor]];
    self.detailLb.numberOfLines = 0;
    self.detailLb.textAlignment = NSTextAlignmentLeft;
    self.detailLb.text = @"2018\n2019";
    [self.borderIV addSubview:self.detailLb];
    [self.detailLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(20);
        make.left.mas_equalTo(20*kWidthScale);
        make.right.mas_equalTo(-15);
        make.bottom.mas_equalTo(-15);
    }];
    
  
}
- (void)setCellDataWithModel:(YSHRPerformModel *)model indexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        self.leftImageView.image = [UIImage imageNamed:@"进度"];
    }else{
        self.leftImageView.image = [UIImage imageNamed:@"进度（灰）"];
        
    }
    if (indexPath.row == 0) {
        self.yearLb.textColor = [UIColor colorWithHexString:@"#1890FF"];
        self.detailLb.textColor = [UIColor colorWithHexString:@"#191F25" alpha:0.8];
    }else{
        self.yearLb.textColor = [UIColor colorWithHexString:@"#1890FF" alpha:0.8];
        self.detailLb.textColor = [UIColor colorWithHexString:@"#000000" alpha:0.6];
    }
    
    self.yearLb.text= model.year;
    NSString *detail = [NSString stringWithFormat:@"您的年度绩效评定结果等级为 %@ \n您的半年度绩效评定结果等级为 %@ ",model.yearPer,model.halfYearPer];
    NSMutableAttributedString *attiStr = [[NSMutableAttributedString alloc]initWithString:detail];
    if (indexPath.row == 0) {
        [attiStr addAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:18],NSForegroundColorAttributeName:[UIColor colorWithHexString:@"#191F25" alpha:0.8]} range:[detail rangeOfString:model.halfYearPer]];
        [attiStr addAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:18],NSForegroundColorAttributeName:[UIColor colorWithHexString:@"#191F25" alpha:0.8]} range:[detail rangeOfString:model.yearPer]];
    }else{
        [attiStr addAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14],NSForegroundColorAttributeName:[UIColor colorWithHexString:@"#000000" alpha:0.6]} range:[detail rangeOfString:model.halfYearPer]];
        [attiStr addAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14],NSForegroundColorAttributeName:[UIColor colorWithHexString:@"#000000" alpha:0.6]} range:[detail rangeOfString:model.yearPer]];
    }
   
    self.detailLb.attributedText = attiStr;
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
