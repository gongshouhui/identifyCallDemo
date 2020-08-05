//
//  YSPMSPlanAddPhotoTableViewCell.m
//  YaSha-iOS
//
//  Created by YaSha_Tom on 2017/10/17.
//

#import "YSPMSPlanAddPhotoTableViewCell.h"

@interface YSPMSPlanAddPhotoTableViewCell ()

//@property (nonatomic, strong) UILabel *titleLabel;
//@property (nonatomic, strong) UITextField *inputTextFiled;

@end

@implementation YSPMSPlanAddPhotoTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle: style reuseIdentifier:reuseIdentifier]) {
        self.titleLabel = [[UILabel alloc]init];
        self.titleLabel.text = @"名称";
        self.titleLabel.font = [UIFont systemFontOfSize:16];
        [self.contentView addSubview:self.titleLabel];
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(self.contentView.mas_centerY);
            make.left.mas_equalTo(self.contentView.mas_left).offset(15);
            make.size.mas_equalTo(CGSizeMake(200*kWidthScale, 20*kHeightScale));
        }];
        
        self.inputTextFiled = [[UITextField alloc]init];
        self.inputTextFiled.textAlignment = NSTextAlignmentRight;
        [self.contentView addSubview:self.inputTextFiled];
        [self.inputTextFiled mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(self.contentView.mas_centerY);
            make.left.mas_equalTo(self.titleLabel.mas_right).offset(15*kWidthScale);
            make.size.mas_equalTo(CGSizeMake(135*kWidthScale, 25*kHeightScale));
            
        }];
    }
    return self;
}

- (void)setAddPhotoCellData:(NSString *)cumulativeCount andProportion:(NSString *)proportion andIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 2 ) {
        self.inputTextFiled.userInteractionEnabled = NO;
        self.inputTextFiled.text = cumulativeCount == nil ? @" " : cumulativeCount;
    }
    if (indexPath.row == 3) {
        self.inputTextFiled.userInteractionEnabled = NO;
        self.inputTextFiled.text = proportion == nil ? @" " : proportion;
    }
}
- (void)setMQAddPhotoCellData:(NSArray *)dataArray andIndexPath:(NSIndexPath *)indexPath {
   
    if (indexPath.row > 1 && dataArray.count > 2)  {
        self.inputTextFiled.text = dataArray[indexPath.row-2];
        if ([dataArray[2] floatValue] < 0 ) {
            self.inputTextFiled.textColor = [UIColor redColor];
        }else{
            self.inputTextFiled.textColor = [UIColor blackColor];
        }
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
