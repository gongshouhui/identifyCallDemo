//
//  YSHRMSSubAllTableViewCell.h
//  YaSha-iOS
//
//  Created by GZl on 2019/4/9.
//  Copyright © 2019 亚厦装饰股份有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YSSummaryModel.h"
#import "YSTeamCompilePostModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface YSHRMSSubAllTableViewCell : UITableViewCell
@property (nonatomic, strong) UIImageView *headerImg;
@property (nonatomic, strong) UILabel *nameLab;
@property (nonatomic, strong) UILabel *typeLab;
@property (nonatomic, strong) UILabel *timeLab;
@property (nonatomic, strong) UILabel *hoursLab;
@property (nonatomic, strong) YSSummaryModel *lateModel;//迟到早退
@property (nonatomic, strong) YSSummaryModel *leaveModel;//请假
//因公外出
@property (nonatomic, strong) YSSummaryModel *outWarkModel;

//旷工
@property (nonatomic, strong) YSSummaryModel *absenteeisModel;
// 加班
@property (nonatomic, strong) YSSummaryModel *workModel;

@property (nonatomic, strong) YSSummaryModel *otherModel;//其他类型

@property (nonatomic, strong) YSTeamCompilePostModel *perforModel;//部门绩效



@end

NS_ASSUME_NONNULL_END
