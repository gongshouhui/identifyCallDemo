//
//  YSHRPerformGradeCell.h
//  YaSha-iOS
//
//  Created by 罗罗诺亚索隆 on 2019/1/9.
//  Copyright © 2019 亚厦装饰股份有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YSHRPerformModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface YSHRPerformGradeCell : UITableViewCell
-(void)setCellDataWithModel:(YSHRPerformModel *)model indexPath:(NSIndexPath *)indexPath;
@end

NS_ASSUME_NONNULL_END
