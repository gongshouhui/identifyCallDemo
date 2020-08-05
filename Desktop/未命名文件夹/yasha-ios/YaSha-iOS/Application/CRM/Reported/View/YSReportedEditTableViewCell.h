//
//  YSReportedEditTableViewCell.h
//  YaSha-iOS
//
//  Created by GZl on 2019/5/14.
//  Copyright © 2019 亚厦装饰股份有限公司. All rights reserved.
//

#import "SWTableViewCell.h"
#import "YSReporetModel.h"


NS_ASSUME_NONNULL_BEGIN

@interface YSReportedEditTableViewCell : SWTableViewCell
- (void)setReporedData:(YSReporetModel *)cellModel;

@end

NS_ASSUME_NONNULL_END
