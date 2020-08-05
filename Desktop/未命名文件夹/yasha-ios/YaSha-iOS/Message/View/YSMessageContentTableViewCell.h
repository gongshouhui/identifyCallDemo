//
//  YSMessageContentTableViewCell.h
//  YaSha-iOS
//
//  Created by YaSha_Tom on 2018/8/6.
//  Copyright © 2018年 亚厦装饰股份有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YSFlowListModel.h"

@interface YSMessageContentTableViewCell : UITableViewCell

- (void)setMessageContent:(YSFlowListModel *)model andIndexPath:(NSIndexPath *)inde;
@end
