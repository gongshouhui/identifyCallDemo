//
//  YSPMSPlanDetailsViewCell.h
//  YaSha-iOS
//
//  Created by YaSha_Tom on 2017/9/27.
//

#import <UIKit/UIKit.h>
#import "YSPMSPlanListModel.h"

@interface AFIndexedCollectionView : UICollectionView

@property (nonatomic, strong) NSIndexPath *indexPath;

@end

static NSString *CollectionViewCellIdentifier = @"CollectionViewCellIdentifier";

@interface YSPMSPlanDetailsViewCell : UITableViewCell

@property (nonatomic, strong) AFIndexedCollectionView *collectionView;
@property (nonatomic, strong) UILabel *contentLabel;

- (void)setCollectionViewDataSourceDelegate:(id<UICollectionViewDataSource, UICollectionViewDelegate>)dataSourceDelegate indexPath:(NSIndexPath *)indexPath;

- (void) setPlanDetailsDataCell:(YSPMSPlanListModel *)model ;
@end
