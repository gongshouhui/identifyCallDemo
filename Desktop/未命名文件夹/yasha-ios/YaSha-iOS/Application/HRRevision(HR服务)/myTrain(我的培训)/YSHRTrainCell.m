//
//  YSHRTrainCell.m
//  YaSha-iOS
//
//  Created by 罗罗诺亚索隆 on 2019/1/15.
//  Copyright © 2019 亚厦装饰股份有限公司. All rights reserved.
//

#import "YSHRTrainCell.h"
@interface YSHRTrainCell()
@property (weak, nonatomic) IBOutlet UILabel *timeLb;
@property (weak, nonatomic) IBOutlet UILabel *addressLb;
@property (weak, nonatomic) IBOutlet UILabel *resultLb;
@property (weak, nonatomic) IBOutlet UILabel *scoreLb;

@end
@implementation YSHRTrainCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (void)setDetailModel:(YSHRTrainDetailModel *)detailModel{
    _detailModel = detailModel;
    self.timeLb.text = [NSString stringWithFormat:@"时长：%@时",_detailModel.classHour];
    self.addressLb.text = [NSString stringWithFormat:@"授课地点：%@",_detailModel.lecturePlace];
    self.resultLb.text = [NSString stringWithFormat:@"考核结果：%@",_detailModel.checkResults];
    self.scoreLb.text = [NSString stringWithFormat:@"成绩：%@分",_detailModel.couresScores];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
