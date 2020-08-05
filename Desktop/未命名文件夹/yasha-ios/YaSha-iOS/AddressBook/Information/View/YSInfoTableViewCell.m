//
//  YSInfoTableViewCell.m
//  YaSha-iOS
//
//  Created by mHome on 2017/3/10.
//
//

#import "YSInfoTableViewCell.h"

@implementation YSInfoTableViewCell
-(instancetype) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.titleLabel = [[UILabel alloc]init];
        self.titleLabel.adjustsFontSizeToFitWidth = YES;
        [self.contentView addSubview:self.titleLabel];
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(self.contentView.mas_centerY);
            make.left.mas_equalTo(self.contentView.mas_left).offset(10);
            make.size.mas_equalTo(CGSizeMake(80*kWidthScale, 20*kHeightScale));
        }];
        
        self.conterLabel = [[UILabel alloc]init];
        self.conterLabel.textAlignment = NSTextAlignmentRight;
        [self.contentView addSubview:self.conterLabel];
        [self.conterLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(self.contentView.mas_centerY);
            make.left.mas_equalTo(self.titleLabel.mas_right).offset(5);
            make.size.mas_equalTo(CGSizeMake(264*kWidthScale, 20*kHeightScale));
        }];
    }
    return self;
}

-(void)setInfoTableViewCellData:(YSInternalPeopleModel *)cellModel andAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.row) {
        case 0:
            _conterLabel.text = cellModel.no;
            break;
        case 1:
            _conterLabel.text = cellModel.deptName;
            break;
        case 2:
            _conterLabel.text = cellModel.position;
            break;
        case 3:
            _conterLabel.text = cellModel.selfMobile;
            _conterLabel.textColor = [UIColor blueColor];
            break;
        case 4:
            _conterLabel.text = cellModel.companyMobile;
            _conterLabel.textColor = [UIColor blueColor];
            break;
        case 5:
            _conterLabel.text = cellModel.shortPhone;
            _conterLabel.textColor = [UIColor blueColor];
            break;
        case 6:
            _conterLabel.text = cellModel.phone;
            _conterLabel.textColor = [UIColor blueColor];
            break;
        case 7:
            _conterLabel.text = cellModel.workAddress;
            break;
        case 8:
            _conterLabel.text = cellModel.companyEmail;
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
