//
//  YSFormJumpCell.m
//  YaSha-iOS
//
//  Created by 方鹏俊 on 2017/11/21.
//

#import "YSFormJumpCell.h"

@implementation YSFormJumpCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        [self initUI];
    }
    return self;
}

- (void)initUI {
    [self addTitleLabel];
    [self addDetailLabel];
}

- (void)setCellModel:(YSFormRowModel *)cellModel {
    [super setCellModel:cellModel];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    if (self.selected == selected) return;
    [super setSelected:selected animated:animated];
    if (selected) {
        if (!self.cellModel.disable) {
            if (self.cellModel.jumpClass) {
                UIViewController *vc = [[NSClassFromString(self.cellModel.jumpClass) alloc] init];
                [[YSUtility getCurrentViewController].navigationController pushViewController:vc animated:YES];
            }else{
                 [[YSUtility getCurrentViewController].navigationController pushViewController:self.cellModel.jumpViewController animated:YES];
            }
           
        }
        self.selected = NO;
    }
}

@end
