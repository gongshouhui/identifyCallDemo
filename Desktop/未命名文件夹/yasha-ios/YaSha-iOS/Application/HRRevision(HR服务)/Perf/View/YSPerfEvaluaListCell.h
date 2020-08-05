//
//  YSPerfEvaluaListCell.h
//  YaSha-iOS
//
//  Created by 方鹏俊 on 2017/10/19.
//

#import <UIKit/UIKit.h>
#import "YSPerfEvaluaListModel.h"

@interface YSPerfEvaluaListCell : UITableViewCell

@property (nonatomic, strong) YSPerfEvaluaListModel *cellModel;

- (void)setCellModel:(YSPerfEvaluaListModel *)cellModel  andIndexPath:(NSInteger)index;
@end
