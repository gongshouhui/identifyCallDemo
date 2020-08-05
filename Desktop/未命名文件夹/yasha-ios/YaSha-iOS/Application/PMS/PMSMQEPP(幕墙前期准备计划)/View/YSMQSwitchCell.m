//
//  YSMQSwitchCell.m
//  YaSha-iOS
//
//  Created by 罗罗诺亚索隆 on 2018/10/26.
//  Copyright © 2018 亚厦装饰股份有限公司. All rights reserved.
//

#import "YSMQSwitchCell.h"
@interface YSMQSwitchCell()


@end
@implementation YSMQSwitchCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.switchBtn.on = NO;
    YSWeak;
    [[self.switchBtn rac_signalForControlEvents:UIControlEventValueChanged] subscribeNext:^(id x) {
        weakSelf.switchBlock(weakSelf.switchBtn.isOn);
    }];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
