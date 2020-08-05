//
//  YSCommonTableViewCell.m
//  YaSha-iOS
//
//  Created by 方鹏俊 on 2017/11/8.
//

#import "YSCommonTableViewCell.h"

@implementation YSCommonTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}

@end
