//
//  YSPersonalInfoCell.h
//  YaSha-iOS
//
//  Created by 蘑菇加 on 2017/12/8.
//  Copyright © 2017年 亚厦装饰股份有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YSHRPersonalInfoCell : UITableViewCell
@property (nonatomic,strong)UILabel *titleLb;
@property (nonatomic,strong)UILabel *detailLb;
@property (nonatomic, strong) NSDictionary *dic;

- (void)setOtherByIndexPath:(NSIndexPath *)indexPath withArray:(NSArray *)array;

@end
