//
//  YSSupplyBankTableViewCell.m
//  YaSha-iOS
//
//  Created by YaSha_Tom on 2017/10/20.
//

#import "YSSupplyBankTableViewCell.h"

@interface YSSupplyBankTableViewCell ()

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *isMainLbael;



@end

@implementation YSSupplyBankTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self initUI];
    }
    return self;
}

- (void)initUI {
    self.titleLabel = [[UILabel alloc]init];
    self.titleLabel.font = [UIFont systemFontOfSize:15];
    self.titleLabel.textColor = kUIColor(153, 153, 153, 1);
    [self.contentView addSubview:self.titleLabel];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.contentView.mas_top).offset(8);
        make.left.mas_equalTo(self.contentView.mas_left).offset(16);
        make.size.mas_equalTo(CGSizeMake(120*kWidthScale, 24*kHeightScale));
    }];
    
    self.contentLabel = [[UILabel alloc]init];
    self.contentLabel.font = [UIFont systemFontOfSize:15];
    self.contentLabel.numberOfLines = 0;
    self.contentLabel.textColor = [UIColor blackColor];
    [self.contentView addSubview:self.contentLabel];
    [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.mas_equalTo(self.contentView.mas_top).offset(8);
    make.bottom.mas_equalTo(self.contentView.mas_bottom).offset(-8*kHeightScale);
        make.left.mas_equalTo(self.titleLabel.mas_right).offset(20*kWidthScale);
        make.right.mas_equalTo(self.contentView.mas_right).offset(-15*kHeightScale);
//        make.width.mas_equalTo(240*kWidthScale);
   
    }];
    self.isMainLbael = [[UILabel alloc]init];
    self.isMainLbael.font = [UIFont systemFontOfSize:16];
    self.isMainLbael.textColor = [UIColor redColor];
    [self.contentView addSubview:self.isMainLbael];
    [self.isMainLbael mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.contentView.mas_top).offset(16);
        make.right.mas_equalTo(self.contentView.mas_right).offset(-15);
        make.size.mas_equalTo(CGSizeMake(100*kWidthScale, 15*kHeightScale));
    }];
    
}

- (void)setSupplyBankCellData:(NSIndexPath *)indexPath andCellModel:(YSSupplyBankModel *)model{
    NSArray *arr = @[@"银行名称",@"银行编码",@"银行账户",@"银行账户名称"];
    self.titleLabel.text = arr[indexPath.row%4];
    switch (indexPath.row%4) {
        case 0:
            self.contentLabel.text = model.name;
//            if ([model.isMainStr isEqual:@"是"]) {
//                self.isMainLbael.text = @"【主要银行】";
//            }
            break;
        case 1:
            self.contentLabel.text = model.code;
            [self.isMainLbael removeFromSuperview];
            break;
        case 2:
            self.contentLabel.text = model.account;
            [self.isMainLbael removeFromSuperview];
            break;
        case 3:
            self.contentLabel.text = model.accountName;
            [self.isMainLbael removeFromSuperview];
            break;
    }
    
    
}

- (void)setSupplySupplierCellData:(NSIndexPath *)indexPath andCellModel:(YSSupplySupplierModel *)model {
    NSArray *arr = @[@"供应商名称",@"编码",@"关系说明"];
    self.titleLabel.text = arr[indexPath.row%3];
    switch (indexPath.row%3) {
        case 0:
            self.contentLabel.text = model.name;
            break;
        case 1:
            self.contentLabel.text = model.no;
            break;
        case 2:
            self.contentLabel.text = model.remark;
            break;
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
