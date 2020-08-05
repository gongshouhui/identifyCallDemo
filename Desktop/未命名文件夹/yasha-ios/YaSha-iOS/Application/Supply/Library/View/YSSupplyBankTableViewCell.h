//
//  YSSupplyBankTableViewCell.h
//  YaSha-iOS
//
//  Created by YaSha_Tom on 2017/10/20.
//

#import <UIKit/UIKit.h>
#import "YSSupplyBankModel.h"
#import "YSSupplySupplierModel.h"

@interface YSSupplyBankTableViewCell : UITableViewCell

@property (nonatomic, strong) UILabel *contentLabel;
- (void)setSupplyBankCellData:(NSIndexPath *)indexPath andCellModel:(YSSupplyBankModel *)model;
- (void)setSupplySupplierCellData:(NSIndexPath *)indexPath andCellModel:(YSSupplySupplierModel *)model;

@end
