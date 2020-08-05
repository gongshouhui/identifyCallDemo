//
//  YSPMSUnitTableViewCell.m
//  YaSha-iOS
//
//  Created by YaSha_Tom on 2017/8/30.
//
//

#import "YSPMSUnitTableViewCell.h"
#import "YSPMSUnitInfoModel.h"

@interface YSPMSUnitTableViewCell()

@property(nonatomic,strong) UILabel *oneTitleLabel;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *phoneLabel;

@end

@implementation YSPMSUnitTableViewCell


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self initUI];
    }
    return self;
}

- (void)initUI {
    self.oneTitleLabel = [[UILabel alloc]init];
    self.oneTitleLabel.font = [UIFont systemFontOfSize:14];
    self.oneTitleLabel.textColor = kUIColor(51, 51, 51, 1.0);
    [self.contentView addSubview:self.oneTitleLabel];
    [self.oneTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.contentView.mas_top).offset(22);
        make.left.mas_equalTo(self.contentView.mas_left).offset(10);
        make.size.mas_equalTo(CGSizeMake(110*kWidthScale, 15*kHeightScale));
    }];
    
    self.twoTitleLabel = [[UILabel alloc]init];
    self.twoTitleLabel.font = [UIFont systemFontOfSize:14];
    [self.contentView addSubview:self.twoTitleLabel];
    [self.twoTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.contentView.mas_top).offset(19);
        make.bottom.mas_equalTo(self.contentView.mas_bottom).offset(-70*kHeightScale);
        make.left.mas_equalTo(self.oneTitleLabel.mas_right).offset(10);
        make.right.mas_equalTo(self.contentView.mas_right).offset(-15);
        make.width.mas_equalTo(240*kWidthScale);
    }];
    
    self.nameLabel = [[UILabel alloc]init];
    self.nameLabel.font = [UIFont systemFontOfSize:15];
    [self.contentView addSubview:self.nameLabel];
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.twoTitleLabel.mas_bottom).offset(9);
        make.left.mas_equalTo(self.oneTitleLabel.mas_right).offset(10);
        make.size.mas_equalTo(CGSizeMake(240*kWidthScale, 15*kHeightScale));
    }];
    
    self.phoneLabel = [[UILabel alloc]init];
    self.phoneLabel.font = [UIFont systemFontOfSize:15];
    self.phoneLabel.textColor = [UIColor blueColor];
    [self.contentView addSubview:self.phoneLabel];
    [self.phoneLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.nameLabel.mas_bottom).offset(9);
        make.left.mas_equalTo(self.oneTitleLabel.mas_right).offset(10);
        make.size.mas_equalTo(CGSizeMake(240*kWidthScale, 15*kHeightScale));
    }];
}

- (void)setUnitInfoCellData:(YSPMSUnitInfoModel *)model andUinitInfoArr:(NSArray *)arr andIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        self.oneTitleLabel.text = model.typeStr;
    }
    self.twoTitleLabel.text = model.name;
    if(arr.count > 0){
        self.nameLabel.text = arr[indexPath.row][@"name"];
        self.phoneLabel.text = arr[indexPath.row][@"mobile"];
    }
    if (arr.count <= 0) {
        [self.twoTitleLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.contentView.mas_top).offset(19);
            make.bottom.mas_equalTo(self.contentView.mas_bottom).offset(-18);
            make.left.mas_equalTo(self.oneTitleLabel.mas_right).offset(10);
            make.right.mas_equalTo(self.contentView.mas_right).offset(-15);
            make.width.mas_equalTo(240*kWidthScale);
        }];
    }
    
}

@end
