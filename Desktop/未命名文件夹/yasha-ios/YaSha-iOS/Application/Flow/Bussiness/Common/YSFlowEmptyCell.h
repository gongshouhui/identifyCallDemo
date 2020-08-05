//
//  YSFlowEmptyCell.h
//  YaSha-iOS
//
//  Created by 罗罗诺亚索隆 on 2019/3/15.
//  Copyright © 2019 亚厦装饰股份有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface YSFlowEmptyCell : UITableViewCell
@property (nonatomic,assign) CGFloat height;
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier background:(UIColor *)color;
@end

NS_ASSUME_NONNULL_END
