//
//  YSAssetsMineCell.h
//  YaSha-iOS
//
//  Created by 方鹏俊 on 2017/9/13.
//
//

#import <UIKit/UIKit.h>
#import "YSAssetsMineModel.h"

@interface YSAssetsMineCell : UITableViewCell

@property (nonatomic, strong) YSAssetsMineModel *cellModel;
@property (nonatomic, strong) UILabel *statusLabel;

@end
