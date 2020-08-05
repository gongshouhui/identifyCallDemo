//
//  YSPMSInfoDetailHeaderCell.h
//  YaSha-iOS
//
//  Created by 方鹏俊 on 2017/8/30.
//
//

#import <UIKit/UIKit.h>


@interface YSPMSInfoDetailHeaderCell : UITableViewCell

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *contentLabel;
@property (nonatomic, strong) UIView *lineView;
@property (nonatomic,strong) NSDictionary *dic;

- (void)setInfoDetailCellData:(NSString *)priceStr  andLetters:(NSArray *)handelLettersArr andPayments:(NSArray *)handelPaymentsArr andIndexPath:(NSIndexPath *)indexPath;

@end
