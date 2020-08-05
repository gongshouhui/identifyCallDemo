//
//  YSPMSOrdinaryCell.h
//  YaSha-iOS
//
//  Created by YaSha_Tom on 2017/9/9.
//
//

#import <UIKit/UIKit.h>

@interface YSPMSOrdinaryCell : UICollectionViewCell
@property(nonatomic,strong)UILabel *titleLabel;

- (void)setFilterIndexPath:(NSIndexPath *)indexPath andFilter:(BOOL)isFilter andTitleAry:(NSArray *)titleAry;
@end
