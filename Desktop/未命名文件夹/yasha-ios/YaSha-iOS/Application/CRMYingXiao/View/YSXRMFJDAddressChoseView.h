//
//  YSXRMFJDAddressChoseView.h
//  YaSha-iOS
//
//  Created by GZl on 2019/5/27.
//  Copyright © 2019 亚厦装饰股份有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@protocol YSXRMFJDAddressChoseViewDelegate <NSObject>

- (void)selectIndex:(NSInteger)index selectDataArrayIndexID:(NSInteger)chose_index;

- (void)getSelectAddressInfor:(NSArray *)addressInfor;
@end

@interface YSXRMFJDAddressChoseView : UIView<UIScrollViewDelegate,UITableViewDelegate,UITableViewDataSource>
@property(nonatomic, strong) UIScrollView *areaScrollView;
@property(nonatomic, strong) UIView *areaWhiteBaseView;
@property (nonatomic, strong) UIView *btnWhiteBaseView;

@property(nonatomic, strong) NSMutableArray *provinceArray;
@property(nonatomic, strong) NSMutableArray *cityArray;
@property(nonatomic, strong) NSMutableArray *regionsArray;
@property(nonatomic, strong) id <YSXRMFJDAddressChoseViewDelegate> address_delegate;

- (void)showAreaView;
- (void)hidenAreaView;



@end

NS_ASSUME_NONNULL_END
