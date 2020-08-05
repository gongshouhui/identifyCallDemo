//
//  YSPerfInfoTopCell.h
//  YaSha-iOS
//
//  Created by 方鹏俊 on 2017/10/18.
//

#import <UIKit/UIKit.h>
#import "YSPerfInfoModel.h"

@interface YSPerfInfoTopCell : UITableViewCell

@property (nonatomic, strong) YSPerfInfoModel *cellModel;
@property (nonatomic, assign) NSInteger index;

- (void)setCellModel:(YSPerfInfoModel *)cellModel ;

@end
