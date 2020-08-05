//
//  YSMQTaskDetailCell.m
//  YaSha-iOS
//
//  Created by 罗罗诺亚索隆 on 2018/11/1.
//  Copyright © 2018 亚厦装饰股份有限公司. All rights reserved.
//

#import "YSMQTaskDetailCell.h"
@interface YSMQTaskDetailCell()
@property (weak, nonatomic) IBOutlet UILabel *remarkTitleLb;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *remarkBottomConstraint;
@property (weak, nonatomic) IBOutlet UILabel *statusTitleLb;

@end
@implementation YSMQTaskDetailCell

- (void)awakeFromNib {
    [super awakeFromNib];
    //xib加上至上而下的约束会报红，但不影响最后的显示
    // Initialization code
}
- (void)setCellDataWithModel:(YSPMSMQEarlyTaskModel *)model {
    self.renwujieduan.text = model.parentName.length?model.parentName:@"  ";
    self.fuzeren.text = model.mainPersonName.length?model.mainPersonName:@"  ";
    //计划日期
    NSString *starttTime = [YSUtility timestampSwitchTime:model.planStartDate andFormatter:@"yyyy-MM-dd"];
    NSString *endtime = [YSUtility timestampSwitchTime:model.planEndDate andFormatter:@"yyyy-MM-dd"];
    NSString *startAndEndTime = [NSString stringWithFormat:@"%@-%@",starttTime,endtime];
    self.jihuariqi.text = startAndEndTime;
    
    if (model.taskStatus == 10) {
        self.statusTitleLb.text = @"未开工：";
        if([model.outDayNumber intValue] < 0) {
            self.wangongyanqi.text = [NSString stringWithFormat:@"开工延期%d天",abs([model.outDayNumber intValue])];
        }else{
            self.wangongyanqi.text = [NSString stringWithFormat:@"开工剩余%@天",model.outDayNumber == nil ? @0:@(abs([model.outDayNumber intValue]))
                                      ];
        }
    }else if (model.taskStatus == 20) {
        self.statusTitleLb.text = @"进行中：";
        if([model.outDayNumber intValue] < 0) {
            self.wangongyanqi.text = [NSString stringWithFormat:@"完工延期%d天",abs([model.outDayNumber intValue])];
        }else{
            self.wangongyanqi.text = [NSString stringWithFormat:@"完工剩余%@天",model.outDayNumber == nil ? @0:@(abs([model.outDayNumber intValue]))
                                      ];
        }
    }else{
        self.statusTitleLb.text = @"已完工";
        
        self.wangongyanqi.text = @"  ";//已完工的隐藏延期天数
        
        
    }
    
    if (model.remark.length) {
        self.remarkTitleLb.hidden = NO;
        self.remark.hidden = NO;
        self.remark.text = model.remark;
        self.remarkBottomConstraint.constant = 15;
    }else {
        self.remarkTitleLb.hidden = YES;
        self.remark.hidden = YES;
        self.remarkBottomConstraint.constant = 0;
    }
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
