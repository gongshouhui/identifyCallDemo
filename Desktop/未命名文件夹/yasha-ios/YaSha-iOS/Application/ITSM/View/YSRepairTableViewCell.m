//
//  YSRepairTableViewCell.m
//  YaSha-iOS
//
//  Created by mHome on 2017/7/12.
//
//

#import "YSRepairTableViewCell.h"

@implementation YSRepairTableViewCell

-(instancetype) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self initUI];
    }
    return self;
}

- (void)initUI {
    _textFiled = [[UITextField alloc] init];
    _textFiled.textAlignment = NSTextAlignmentRight;
    _textFiled.textColor = kUIColor(153, 153, 153, 1.0);
    _textFiled.font = [UIFont systemFontOfSize:15];
    [self.contentView addSubview:_textFiled];
    [_textFiled mas_makeConstraints:^(MASConstraintMaker *make) {
       make.centerY.mas_equalTo(self.contentView.mas_centerY);
       make.right.mas_equalTo(self.contentView.mas_right).offset(-18);
       make.height.mas_equalTo(44*kHeightScale);
       make.width.mas_equalTo(200*kWidthScale);
    }];
}

@end
