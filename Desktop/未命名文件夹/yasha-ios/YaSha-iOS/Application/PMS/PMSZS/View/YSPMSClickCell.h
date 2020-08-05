//
//  YSPMSClickCell.h
//  YaSha-iOS
//
//  Created by YaSha_Tom on 2017/9/9.
//
//

#import <UIKit/UIKit.h>

@interface YSPMSClickCell : UICollectionViewCell

@property (nonatomic,strong)UIButton *chooseBtn;

@property(nonatomic,strong)UILabel *textLabel;

-(void)setFilterIndexPath:(NSIndexPath *)indexPath andFilter:(BOOL)isFilter andTitleAry:(NSArray *)titleAry;

@end
