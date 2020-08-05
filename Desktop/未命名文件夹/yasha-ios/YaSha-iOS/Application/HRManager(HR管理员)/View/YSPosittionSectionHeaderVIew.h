//
//  YSPosittionSectionHeaderVIew.h
//  YaSha-iOS
//
//  Created by GZl on 2019/3/28.
//  Copyright © 2019 亚厦装饰股份有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface YSPosittionSectionHeaderVIew : UITableViewHeaderFooterView

// type:0编制详情 1入职 2离职
- (void)updateConstraintsAndDataWithType:(NSInteger)type;
@end

NS_ASSUME_NONNULL_END
