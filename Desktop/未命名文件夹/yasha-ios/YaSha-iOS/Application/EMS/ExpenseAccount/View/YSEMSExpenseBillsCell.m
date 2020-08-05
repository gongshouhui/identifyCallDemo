//
//  YSEMSExpenseBillsCell.m
//  YaSha-iOS
//
//  Created by 罗罗诺亚索隆 on 2018/9/4.
//  Copyright © 2018年 亚厦装饰股份有限公司. All rights reserved.
//

#import "YSEMSExpenseBillsCell.h"
@interface YSEMSExpenseBillsCell()
@property (weak, nonatomic) IBOutlet UIView *didHandleView;
@property (weak, nonatomic) IBOutlet UIView *handlingView;
@property (weak, nonatomic) IBOutlet UIView *noSumitView;

@end
@implementation YSEMSExpenseBillsCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self layoutIfNeeded];
   
}
- (void)setModel:(YSEMSExpenseDetailModel *)model {
    _model = model;
    CGFloat allLength = kSCREEN_WIDTH - 100;
     NSInteger total = model.auditedCount + model.unauditedCount + model.unsubmittedCount;
    if (model.auditedCount == 0) {
        self.didHandleView.backgroundColor = [UIColor colorWithHexString:@"#F7F7F7"];
        self.didHandleWidth.constant = allLength;
    }else{
       self.didHandleWidth.constant = allLength * model.auditedCount/total;
    }
    if (model.unauditedCount == 0) {
        self.handlingView.backgroundColor = [UIColor colorWithHexString:@"#F7F7F7"];
        self.handlingWidth.constant = allLength;
    }else{
        self.handlingWidth.constant = allLength * model.unauditedCount/total;
    }
    if (model.unsubmittedCount == 0) {
        self.noSumitView.backgroundColor = [UIColor colorWithHexString:@"#F7F7F7"];
        self.noSumitWidth.constant = allLength;
    }else{
        self.noSumitWidth.constant = allLength * model.unsubmittedCount/total;
    }
   
    self.didHandleLb.text = [NSString stringWithFormat:@"%zd",model.auditedCount];
     self.handlingLb.text = [NSString stringWithFormat:@"%zd",model.unauditedCount];
     self.noSumitLb.text = [NSString stringWithFormat:@"%zd",model.unsubmittedCount];
    
    
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
