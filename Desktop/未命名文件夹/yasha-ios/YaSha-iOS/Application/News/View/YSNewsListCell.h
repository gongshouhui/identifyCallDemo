//
//  YSNewsListCell.h
//  YaSha-iOS
//
//  Created by 方鹏俊 on 2017/9/29.
//

#import <UIKit/UIKit.h>
#import "YSNewsListModel.h"

@interface YSNewsListCell : UITableViewCell

@property (nonatomic, strong) YSNewsListModel *cellModel;
/** 公关类隐藏图片 */
- (void)hideThumbImageView;

@end
