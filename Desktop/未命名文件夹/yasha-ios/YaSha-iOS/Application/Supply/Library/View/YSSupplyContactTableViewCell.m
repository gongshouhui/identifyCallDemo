//
//  YSSupplyContactTableViewCell.m
//  YaSha-iOS
//
//  Created by YaSha_Tom on 2017/10/20.
//

#import "YSSupplyContactTableViewCell.h"

@interface YSSupplyContactTableViewCell ()

@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *isMainLbael;
@property (nonatomic, strong) UIImageView * headerImage;
@property (nonatomic, strong) QMUIButton *mobileButton;
@property (nonatomic, strong) QMUIButton *phoneButton;
@property (nonatomic, strong) QMUIButton *positionButton;

@end

@implementation YSSupplyContactTableViewCell


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self initUI];
    }
    return self;
}

- (void)initUI {
    self.headerImage = [[UIImageView alloc]init];
    self.headerImage.layer.masksToBounds = YES;
    self.headerImage.layer.cornerRadius = 18*kHeightScale;
    self.headerImage.image = [UIImage imageNamed:@"头像"];
    [self.contentView addSubview:self.headerImage];
    [self.headerImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.contentView.mas_top).offset(16);
        make.left.mas_equalTo(self.contentView.mas_left).offset(20);
        make.size.mas_equalTo(CGSizeMake(36*kWidthScale, 36*kHeightScale));
    }];
    
    self.nameLabel = [[UILabel alloc]init];
    self.nameLabel.text = @"老魏";
    self.nameLabel.textAlignment = NSTextAlignmentCenter;
    self.nameLabel.font = [UIFont systemFontOfSize:16];
    self.nameLabel.textColor = [UIColor blackColor];
    [self.contentView addSubview:self.nameLabel];
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.headerImage.mas_bottom).offset(12);
        make.left.mas_equalTo(self.contentView.mas_left).offset(5);
        make.size.mas_equalTo(CGSizeMake(66*kWidthScale, 15*kHeightScale));
    }];
    
    self.mobileButton = [[QMUIButton alloc]init];
    self.mobileButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [self.mobileButton setTitleColor:kUIColor(51, 51, 51, 1) forState:UIControlStateNormal];
    [self.contentView addSubview:self.mobileButton];
    [self.mobileButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.contentView.mas_top).offset(18);
        make.left.mas_equalTo(self.headerImage.mas_right).offset(30);
        make.size.mas_equalTo(CGSizeMake(180*kWidthScale, 15*kHeightScale));
    }];
    
    self.isMainLbael = [[UILabel alloc]init];
    self.isMainLbael.font = [UIFont systemFontOfSize:16];
    self.isMainLbael.textColor = [UIColor redColor];
    [self.contentView addSubview:self.isMainLbael];
    [self.isMainLbael mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.contentView.mas_top).offset(16);
        make.right.mas_equalTo(self.contentView.mas_right).offset(-15);
        make.size.mas_equalTo(CGSizeMake(115*kWidthScale, 15*kHeightScale));
    }];
    
    
    self.phoneButton = [[QMUIButton alloc]init];
    self.phoneButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [self.phoneButton setTitleColor:kUIColor(51, 51, 51, 1) forState:UIControlStateNormal];
    [self.contentView addSubview:self.phoneButton];
    [self.phoneButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.mobileButton.mas_bottom).offset(10);
        make.left.mas_equalTo(self.headerImage.mas_right).offset(30);
        make.size.mas_equalTo(CGSizeMake(180*kWidthScale, 15*kHeightScale));
    }];
    
    self.positionButton = [[QMUIButton alloc]init];
    self.positionButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [self.positionButton setTitleColor:kUIColor(51, 51, 51, 1) forState:UIControlStateNormal];
    [self.contentView addSubview:self.positionButton];
    [self.positionButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.phoneButton.mas_bottom).offset(10);
        make.left.mas_equalTo(self.headerImage.mas_right).offset(30);
        make.size.mas_equalTo(CGSizeMake(150*kWidthScale, 15*kHeightScale));
    }];
}

- (void)setSupplyContactCell:(YSSupplyPersonModel *)cellModel {
    self.nameLabel.text = cellModel.name;
    [self.mobileButton setImage:[UIImage imageNamed:@"手机"] forState:UIControlStateNormal];
    [self.mobileButton setTitle:cellModel.mobile forState:UIControlStateNormal];
    self.mobileButton.imagePosition = QMUIButtonImagePositionLeft;
    self.mobileButton.spacingBetweenImageAndTitle = 10;
    [self.phoneButton setImage:[UIImage imageNamed:@"座机"] forState:UIControlStateNormal];
    [self.phoneButton setTitle:([cellModel.phone isEqual:[NSNull null]] || [cellModel.phone isEqual:@""]) ? @"暂无": cellModel.phone forState:UIControlStateNormal];
    self.phoneButton.imagePosition = QMUIButtonImagePositionLeft;
    self.phoneButton.spacingBetweenImageAndTitle = 10;
    [self.positionButton setImage:[UIImage imageNamed:@"职位"] forState:UIControlStateNormal];
    [self.positionButton setTitle:([cellModel.duty isEqual:[NSNull null]] || [cellModel.duty isEqual:@""]) ? @"暂无": cellModel.duty forState:UIControlStateNormal];
    self.positionButton.imagePosition = QMUIButtonImagePositionLeft;
    self.positionButton.spacingBetweenImageAndTitle = 10;
    DLog(@"-------%@",cellModel.isMainStr);
    if ([cellModel.isMainStr isEqual:@"是"]) {
        self.isMainLbael.text = @"【主要联系人】";
    }
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
