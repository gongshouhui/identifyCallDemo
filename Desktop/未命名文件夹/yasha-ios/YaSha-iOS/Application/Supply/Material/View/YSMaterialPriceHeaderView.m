//
//  YSMaterialPriceHeaderView.m
//  YaSha-iOS
//
//  Created by 蘑菇加 on 2017/12/5.
//

#import "YSMaterialPriceHeaderView.h"
@interface YSMaterialPriceHeaderView()
@property (nonatomic,strong) UILabel *positionLabel;
@end
@implementation YSMaterialPriceHeaderView

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithReuseIdentifier:reuseIdentifier]) {
        [self initUI];
    }
    return self;
}
- (void)initUI
{
    self.backgroundColor = [UIColor whiteColor];
    self.contentView.backgroundColor = [UIColor whiteColor];
    UILabel *distanceLabel = [[UILabel alloc]init];
    distanceLabel.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [self.contentView addSubview:distanceLabel];
    [distanceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.mas_equalTo(0);
        make.height.mas_equalTo(10*kHeightScale);
    }];
    
    UILabel *lineLabel = [[UILabel alloc]init];
    lineLabel.backgroundColor = kUIColor(37, 134, 216, 1.0);
    [self.contentView addSubview:lineLabel];
    [lineLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(distanceLabel.mas_bottom).offset(14*kHeightScale);
        make.left.mas_equalTo(self.mas_left).offset(10*kWidthScale);
        make.size.mas_equalTo(CGSizeMake(2, 18*kHeightScale));
    }];
    
    self.positionLabel = [[UILabel alloc]init];
    self.positionLabel.font = [UIFont systemFontOfSize:15];
    self.positionLabel.textColor = kUIColor(51, 51, 51, 1.0);
    self.positionLabel.text = @"杭州";
    [self.contentView addSubview:self.positionLabel];
    [self.positionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(distanceLabel.mas_bottom).offset(14*kHeightScale);
        make.left.mas_equalTo(lineLabel.mas_right).offset(10*kWidthScale);
        make.size.mas_equalTo(CGSizeMake(250*kWidthScale, 16*kHeightScale));
    }];
    UITapGestureRecognizer *gestture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(materialPriceHeaderViewDidClickWith)];
    [self addGestureRecognizer:gestture];

}
- (void)materialPriceHeaderViewDidClickWith{
    //self.model.open = !self.model.isOpen;
    //model 记录展开和关闭
    if (self.delegate && [self.delegate respondsToSelector:@selector(materialPriceHeaderViewDidClickWith:)]) {
         [self.delegate materialPriceHeaderViewDidClickWith:self];
    }
}

- (void)setAdderssShow:(NSDictionary *)addressStr {
    self.positionLabel.text = [NSString stringWithFormat:@"%@  %@",addressStr[@"province"],addressStr[@"city"]];
}
@end
