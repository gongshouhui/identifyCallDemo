//
//  YSHRManagerDetailHeaderView.h
//  YaSha-iOS
//
//  Created by GZl on 2019/3/26.
//  Copyright © 2019 亚厦装饰股份有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YSPersonalInformationModel.h"

typedef NS_ENUM(NSInteger, ItemSizeType) {
    ItemSizeTypeCompany,//部门
    ItemSizeTypePerson,//单行员工
    ItemSizeTypeMore,//多行员工
};

@protocol YSHRManagerDidItemDelegate <NSObject>
@required
- (void)didCollectionItemActionWith:(NSArray*)dataArray;

@end

NS_ASSUME_NONNULL_BEGIN

@interface YSHRManagerDetailHeaderView : UITableViewHeaderFooterView

@property (nonatomic, weak) id<YSHRManagerDidItemDelegate> delegate;

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier withType:(ItemSizeType)itemType;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSMutableArray *oldChoseArray;//以前选中的

// 刷新行
- (void)reloadCollectionViewWith:(NSArray*)deptArrat withChoseArray:(NSArray*)choseArray;

// 滚动到指定行
- (void)scrollToItemAtIndexPath:(NSIndexPath*)indexPath withChoseArray:(NSArray*)choseArray;
@end

NS_ASSUME_NONNULL_END
