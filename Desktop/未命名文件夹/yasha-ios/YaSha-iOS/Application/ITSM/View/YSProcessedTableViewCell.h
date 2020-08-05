//
//  YSProcessedTableViewCell.h
//  YaSha-iOS
//
//  Created by mHome on 2017/7/5.
//
//

#import <UIKit/UIKit.h>
#import "YSITSMUntreatedModel.h"

@interface YSProcessedTableViewCell : UITableViewCell

@property (nonatomic, strong) UIButton *lastButton;
@property (nonatomic, strong) UIButton *complaintsButton;
@property (nonatomic, strong) YSITSMUntreatedModel *cellModel;

@end
