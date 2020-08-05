//
//  YSHRMDTrainingGTableViewCell.h
//  YaSha-iOS
//
//  Created by GZl on 2019/4/9.
//  Copyright © 2019 亚厦装饰股份有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <PNChart.h>
#import "YSHRMTTrainingModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface YSHRMDTrainingGTableViewCell : UITableViewCell

@property (nonatomic, strong) PNCircleChart *circleChart;
@property (nonatomic, strong) UILabel *currentLab;
@property (nonatomic, strong) UIView *backTopView;
@property (nonatomic, strong) UIView *backBottomView;
@property (nonatomic, strong) UIImageView *schematicImg;
@property (nonatomic, strong) CourseDevelopModel *courseDevelop;//课程开发
@property (nonatomic, strong) TrainingCourseModel *trainingCourse;//培训课程
@property (nonatomic, strong) CompleteModel *complete;//人均完成


@end


@interface CellShowSubView : UIView

@property (nonatomic, strong) UILabel *numberLab;
@property (nonatomic, strong) UILabel *nameLab;


@end

NS_ASSUME_NONNULL_END
