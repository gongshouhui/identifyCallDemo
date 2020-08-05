//
//  YSPMSPlanStartsViewCell.h
//  YaSha-iOS
//
//  Created by YaSha_Tom on 2017/9/27.
//

#import <SWTableViewCell/SWTableViewCell.h>
@class YSPMSPlanListModel;

@interface YSPMSPlanStartsViewCell : SWTableViewCell

- (void)setPlanStartsCellData:(YSPMSPlanListModel *)model ;
- (void)setEarlyPreparePlanCellData:(YSPMSPlanListModel *)model;
@end
