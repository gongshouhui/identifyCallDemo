//
//  YSExpenseInfoCell.h
//  YaSha-iOS
//
//  Created by 龚守辉 on 2018/3/12.
//  Copyright © 2018年 亚厦装饰股份有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YSCostInfoModel.h"
@interface YSExpenseInfoCell : UITableViewCell
@property (nonatomic,strong) YSCostInfoModelDetail *infoModel;
@end

@interface YSDetailItemView : UIView
@property (nonatomic,strong)UILabel *titleLb;
@property (nonatomic,strong)UILabel *detailLb;
@end
