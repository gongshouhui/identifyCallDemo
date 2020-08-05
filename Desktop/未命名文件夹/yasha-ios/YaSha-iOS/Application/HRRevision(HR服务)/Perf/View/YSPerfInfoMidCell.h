//
//  YSPerfInfoMidCell.h
//  YaSha-iOS
//
//  Created by 方鹏俊 on 2017/10/18.
//

#import <UIKit/UIKit.h>
#import "YSPerfInfoModel.h"

@interface YSPerfInfoMidCell : UITableViewCell

@property (nonatomic, strong) YSPerfInfoModel *cellModel;
@property (nonatomic, assign) NSInteger index;

- (void)setCellModel:(YSPerfInfoModel *)cellModel indexPath:(NSIndexPath *)indexPath;
- (void)setPlanCellModel:(YSPerfInfoModel *)cellModel indexPath:(NSIndexPath *)indexPath;

@end
