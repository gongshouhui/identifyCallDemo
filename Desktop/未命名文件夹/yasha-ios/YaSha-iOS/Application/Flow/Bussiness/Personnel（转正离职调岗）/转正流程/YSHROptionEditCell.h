//
//  YSHROptionEditCell.h
//  YaSha-iOS
//
//  Created by 罗罗诺亚索隆 on 2020/1/6.
//  Copyright © 2020 亚厦装饰股份有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YSOpinionModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface YSHROptionEditCell : UITableViewCell
@property (nonatomic,strong) UITextField *scoreTF;
@property (nonatomic,strong) QMUITextView *contentTV;
@property (nonatomic,strong) YSOpinionModel *opinionModel;
@property (nonatomic,strong) void(^opinionBlock)(NSString *score,NSString *opinion);
@end

NS_ASSUME_NONNULL_END
