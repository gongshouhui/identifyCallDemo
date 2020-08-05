//
//  YSHRTrainSectionHeaderView.m
//  YaSha-iOS
//
//  Created by 罗罗诺亚索隆 on 2019/1/15.
//  Copyright © 2019 亚厦装饰股份有限公司. All rights reserved.
//

#import "YSHRTrainSectionHeaderView.h"
#import "YSTagButton.h"
@interface YSHRTrainSectionHeaderView()
@property (weak, nonatomic) IBOutlet UILabel *titleLb;
@property (weak, nonatomic) IBOutlet YSTagButton *tagButton;
@property (weak, nonatomic) IBOutlet UIButton *arrowButton;
@property (weak, nonatomic) IBOutlet UILabel *teacherLb;
@property (weak, nonatomic) IBOutlet UILabel *timeLb;
@property (weak, nonatomic) IBOutlet UILabel *classTypeLb;



@end
@implementation YSHRTrainSectionHeaderView
- (void)setDetailModel:(YSHRTrainDetailModel *)detailModel {
    _detailModel = detailModel;
    self.titleLb.text = _detailModel.courseName;
    [self.tagButton setTitle:_detailModel.courseStatus forState:UIControlStateNormal];
   
    self.teacherLb.text = [NSString stringWithFormat:@"讲师：%@",_detailModel.lecturerName];
    self.timeLb.text = [NSString stringWithFormat:@" 时间：%@",_detailModel.lectureTime];
   
    self.classTypeLb.text = [NSString stringWithFormat:@"授课类型：%@",_detailModel.courseAttributes];
}

@end
