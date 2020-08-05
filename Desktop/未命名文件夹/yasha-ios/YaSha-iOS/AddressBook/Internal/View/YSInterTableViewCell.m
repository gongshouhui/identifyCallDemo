//
//  YSInterTableViewCell.m
//  YaSha-iOS
//
//  Created by YaSha_Tom on 2017/8/3.
//
//

#import "YSInterTableViewCell.h"

@implementation YSInterTableViewCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self initUI];
    }
    return self;
}

- (void)initUI{
    self.titleImage= [[UIImageView alloc]init];
    self.titleImage.layer.cornerRadius = 15*kWidthScale ;
    self.titleImage.clipsToBounds = YES;
    [self addSubview:self.titleImage];
    [self.titleImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.contentView.mas_top).offset(9);
        make.left.mas_equalTo(self.contentView.mas_right).offset(17);
        make.size.mas_equalTo(CGSizeMake(30*kWidthScale, 30*kHeightScale));
    }];
    
    self.nameLabel = [[UILabel alloc]init];
    self.nameLabel.textColor = kUIColor(51, 51, 51, 1);
    self.nameLabel.font = [UIFont systemFontOfSize:15];
    [self addSubview:self.nameLabel];
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.contentView.mas_top).offset(16);
        make.left.mas_equalTo(self.contentView.mas_right).offset(67*kWidthScale);
        make.size.mas_equalTo(CGSizeMake(200*kWidthScale, 15*kHeightScale));
    }];
    
    
    self.jobsName = [[UILabel alloc]init];
    self.jobsName.textAlignment = NSTextAlignmentRight;
    self.jobsName.font = [UIFont systemFontOfSize:13];
    self.jobsName.textColor = [UIColor lightGrayColor];
    [self addSubview:self.jobsName];
    [self.jobsName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.contentView.mas_top).offset(14);
        make.left.mas_equalTo(self.contentView.mas_left).offset(150*kWidthScale);
        make.size.mas_equalTo(CGSizeMake(200*kWidthScale, 20*kHeightScale));
    }];
}


- (void)setAdderssBookCell:(YSInternalModel *)cellModel  {
        if (cellModel.headImg.length > 0) {
            DLog(@"------33333------%@",[NSString stringWithFormat:@"%@%@",cellModel.headImg, @"_S.jpg"]);
            [_titleImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",cellModel.headImg, @"_S.jpg"]] placeholderImage:[UIImage imageNamed:@"头像"]];
            
        }else{
//            _titleImage.image = [UIImage imageNamed:@"头像"];
        }
        _nameLabel.text = cellModel.name;
        _jobsName.text = cellModel.position;
 
   
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
