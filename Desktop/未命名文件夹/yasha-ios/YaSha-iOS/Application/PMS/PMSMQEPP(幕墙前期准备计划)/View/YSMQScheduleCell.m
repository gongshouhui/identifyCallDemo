//
//  YSMQScheduleCell.m
//  YaSha-iOS
//
//  Created by 罗罗诺亚索隆 on 2018/11/1.
//  Copyright © 2018 亚厦装饰股份有限公司. All rights reserved.
//

#import "YSMQScheduleCell.h"

@implementation YSMQScheduleCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self layoutIfNeeded];
    self.progressView.layer.masksToBounds = YES;
    self.progressView.layer.cornerRadius = self.progressView.qmui_height*0.5;
    // Initialization code
}
- (void)setCellData:(YSPMSMQEarlyTaskModel *)model {
    self.titlelb.text = model.name;
    if (!model.graphicProgress.length) {
        self.percentLb.text = @"0%";
    }else{
          self.percentLb.text = [NSString stringWithFormat:@"%@%s",model.graphicProgress,"%"];
    }
  
    self.progressView.progress = [model.graphicProgress floatValue]/100;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
