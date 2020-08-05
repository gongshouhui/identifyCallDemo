//
//  YSFormDetailCell.m
//  YaSha-iOS
//
//  Created by 方鹏俊 on 2017/11/20.
//

#import "YSFormDetailCell.h"

@implementation YSFormDetailCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self initUI];
    }
    return self;
}

- (void)initUI {
    [self addTitleLabel];
    [self addDetailLabel];
}

@end
