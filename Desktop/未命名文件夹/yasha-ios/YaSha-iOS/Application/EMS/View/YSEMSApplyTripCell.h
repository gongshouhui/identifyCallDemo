//
//  YSEMSApplyTripCell.h
//  YaSha-iOS
//
//  Created by 方鹏俊 on 2017/11/8.
//

#import "YSCommonTableViewCell.h"
#import "YSEMSApplyTripModel.h"

@interface YSEMSApplyTripCell : YSCommonTableViewCell

@property (nonatomic, strong) YSEMSApplyTripModel *cellModel;

- (void)setCellModel:(YSEMSApplyTripModel *)cellModel payload:(NSDictionary *)payload indexPath:(NSIndexPath *)indexPath;

@end
