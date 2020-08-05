//
//  YSMaterialPriceHeaderView.h
//  YaSha-iOS
//
//  Created by 蘑菇加 on 2017/12/5.
//

#import <UIKit/UIKit.h>
@class YSMaterialPriceHeaderView;
@protocol YSMaterialPriceHeaderViewDelegate <NSObject>
- (void)materialPriceHeaderViewDidClickWith:(YSMaterialPriceHeaderView *)view;

@end
@interface YSMaterialPriceHeaderView : UITableViewHeaderFooterView

@property (nonatomic,weak) id <YSMaterialPriceHeaderViewDelegate> delegate;

- (void)setAdderssShow:(NSDictionary *)addressStr;

@end
