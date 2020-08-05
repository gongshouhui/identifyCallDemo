//
//  SideSlipServiceTableViewCell.m
//  ZYSideSlipFilter
//
//  Created by zhiyi on 16/10/14.
//  Copyright © 2016年 zhiyi. All rights reserved.
//

#import "SideSlipServiceTableViewCell.h"
#import "ZYSideSlipFilterRegionModel.h"
#import "CommonItemModel.h"
#import "FilterCommonCollectionViewCell.h"
#import <UIView+Utils.h>
#import "FilterAddressController.h"
#import "AddressModel.h"
#import "ZYSideSlipFilterController.h"
#import <YBPopupMenu.h>

#define FILTER_LEADING ((ZYSideSlipFilterController *)self.delegate).sideSlipLeading
#define CELL_WIDTH kSCREEN_WIDTH - FILTER_LEADING

#define LINE_SPACE_COLLECTION_ITEM 8
#define GAP_COLLECTION_ITEM 8
#define NUM_OF_ITEM_ONCE_ROW 3.f
#define ITEM_WIDTH ((CELL_WIDTH - (NUM_OF_ITEM_ONCE_ROW+1)*GAP_COLLECTION_ITEM)/NUM_OF_ITEM_ONCE_ROW)
#define ITEM_WIDTH_HEIGHT_RATIO 4.f
#define ITEM_HEIGHT ceil(ITEM_WIDTH/ITEM_WIDTH_HEIGHT_RATIO)

@interface SideSlipServiceTableViewCell () <UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, FilterAddressControllerDelegate, YBPopupMenuDelegate>
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIButton *addressButton;
@property (weak, nonatomic) IBOutlet UICollectionView *mainCollectionView;
@property (strong, nonatomic) ZYSideSlipFilterRegionModel *regionModel;
@property (strong, nonatomic) NSArray *dataList;
@property (assign, nonatomic) CommonTableViewCellSelectionType selectionType;
@property (strong, nonatomic) NSMutableArray *selectedItemList;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *collectionViewHeightConstraint;
@property (strong, nonatomic) AddressModel *addressModel;
@property (strong, nonatomic) NSArray *addressList;
@property (nonatomic, strong) NSMutableArray *yearArray;

@end

@implementation SideSlipServiceTableViewCell
+ (NSString *)cellReuseIdentifier {
    return @"SideSlipServiceTableViewCell";
}

+ (instancetype)createCellWithIndexPath:(NSIndexPath *)indexPath {
    SideSlipServiceTableViewCell *cell = [[NSBundle mainBundle] loadNibNamed:@"SideSlipServiceTableViewCell" owner:nil options:nil][0];
    [cell configureCell];
    return cell;
}

- (void)configureCell {
    _addressButton.enabled = NO;
    
    _yearArray = [NSMutableArray array];
    _mainCollectionView.delegate = self;
    _mainCollectionView.dataSource = self;
    _mainCollectionView.contentInset = UIEdgeInsetsMake(0, GAP_COLLECTION_ITEM, 0, GAP_COLLECTION_ITEM);
    [_mainCollectionView registerClass:[FilterCommonCollectionViewCell class] forCellWithReuseIdentifier:[FilterCommonCollectionViewCell cellReuseIdentifier]];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)updateCellWithModel:(ZYSideSlipFilterRegionModel *__autoreleasing *)model
                  indexPath:(NSIndexPath *)indexPath {
    self.regionModel = *model;
    //title
    [_titleLabel setText:_regionModel.regionTitle];
    //content
    self.dataList = _regionModel.itemList;
    //address
    self.addressList = _regionModel.customDict[ADDRESS_LIST];
    self.addressModel = _addressList.firstObject;
    [_addressButton setTitle:_addressModel.addressString forState:UIControlStateNormal];
    //update selectedAddress
    NSMutableDictionary *customDict = [NSMutableDictionary dictionaryWithDictionary:_regionModel.customDict];
    [customDict setValue:_addressModel forKey:SELECTED_ADDRESS];
    _regionModel.customDict = [customDict copy];
    
    //UI
    [self fitCollectonViewHeight];
    [_mainCollectionView reloadData];
}

//根据数据源个数决定collectionView高度
- (void)fitCollectonViewHeight {
    CGFloat displayNumOfRow;
    displayNumOfRow = ceil(_dataList.count/NUM_OF_ITEM_ONCE_ROW);
    CGFloat collectionViewHeight = displayNumOfRow*ITEM_HEIGHT + (displayNumOfRow - 1)*LINE_SPACE_COLLECTION_ITEM;
    _collectionViewHeightConstraint.constant = collectionViewHeight;
    [_mainCollectionView updateHeight:collectionViewHeight];
}

- (BOOL)tap2SelectItem:(NSIndexPath *)indexPath {
    FilterCommonCollectionViewCell *cell = [_mainCollectionView dequeueReusableCellWithReuseIdentifier:[FilterCommonCollectionViewCell cellReuseIdentifier] forIndexPath:indexPath];
    switch (_selectionType) {
        case BrandTableViewCellSelectionTypeSingle:
        {
            NSArray *itemArray = _regionModel.itemList;
            CommonItemModel *model = [itemArray objectAtIndex:indexPath.row];
            model.itemName = [NSString stringWithFormat:@"%ld", [[NSDate date] year]];
            if (!model.selected) {
                for (CommonItemModel *item in itemArray) {
                    item.selected = NO;
                }
                [self.selectedItemList removeAllObjects];
                [self.selectedItemList addObject:model];
            } else {
                [self.selectedItemList removeObject:model];
            }
//            model.selected = !model.selected;
            NSDate *date = [NSDate date];
            _yearArray = [NSMutableArray array];
            for (int i = 2015; i <= [date year]; i ++) {
                [_yearArray addObject:[NSString stringWithFormat:@"%zd", i]];
            }
            [YBPopupMenu showAtPoint:CGPointMake(112*kWidthScale, 204) titles:_yearArray icons:nil menuWidth:95*kWidthScale otherSettings:^(YBPopupMenu *popupMenu) {
                popupMenu.dismissOnSelected = YES;
                popupMenu.isShowShadow = YES;
                popupMenu.delegate = self;
                popupMenu.offset = 10;
                popupMenu.fontSize = 12;
                popupMenu.itemHeight = 30;
                popupMenu.type = YBPopupMenuTypeDefault;
                popupMenu.arrowWidth = 0;
                popupMenu.backColor = [UIColor whiteColor];
                popupMenu.arrowDirection = YBPopupMenuArrowDirectionBottom;
            }];
            
            return model.selected;
        }
            break;
        case BrandTableViewCellSelectionTypeMultiple:
        {
            NSArray *itemArray = _regionModel.itemList;
            CommonItemModel *model = [itemArray objectAtIndex:indexPath.row];
            model.selected = !model.selected;
            if (model.selected) {
                [self.selectedItemList addObject:model];
            } else {
                [self.selectedItemList removeObject:model];
            }
            FilterAddressController *addressController = [[FilterAddressController alloc] initWithDataList:_addressList selectedAddressId:_addressModel.addressId];
            addressController.title = _regionModel.regionTitle;
            addressController.delegate = self;
            
            if ([self.delegate respondsToSelector:@selector(sideSlipTableViewCellNeedsPushViewController:animated:)]) {
                [self.delegate sideSlipTableViewCellNeedsPushViewController:addressController animated:YES];
            }
            [self updateSelectedItemListWithItem:model];
            
            return model.selected;
        }
            break;
        case BrandTableViewCellSelectionTypeAddress:
        {
            return nil;
            break;
        }
        default:
            break;
    }
    _regionModel.selectedItemList = _selectedItemList;
}

- (void)ybPopupMenuDidSelectedAtIndex:(NSInteger)index ybPopupMenu:(YBPopupMenu *)ybPopupMenu {
    NSArray *itemArray = _regionModel.itemList;
    CommonItemModel *model = [itemArray objectAtIndex:0];
    model.itemName = _yearArray[index];
    model.selected = YES;
    _regionModel.selectedItemList = @[model];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    [_mainCollectionView reloadItemsAtIndexPaths:@[indexPath]];
    [_addressButton setTitle:_yearArray[index] forState:UIControlStateNormal];
    
    [ybPopupMenu dismiss];
}

- (void)updateSelectedItemListWithItem:(CommonItemModel *)model {
    [self.selectedItemList addObject:model];
//    if (model.selected) {
//        [self.selectedItemList addObject:model];
//    } else {
//        [self.selectedItemList removeObject:model];
//    }
    //update Data
    _regionModel.selectedItemList = _selectedItemList;
}

- (IBAction)clickAddressButton:(id)sender {
    FilterAddressController *addressController = [[FilterAddressController alloc] initWithDataList:_addressList selectedAddressId:_addressModel.addressId];
    addressController.delegate = self;
    if ([self.delegate respondsToSelector:@selector(sideSlipTableViewCellNeedsPushViewController:animated:)]) {
        [self.delegate sideSlipTableViewCellNeedsPushViewController:addressController animated:YES];
    }
}

- (NSArray *)generateAddressDataList {
    return @[[self createAddressModelWithAddress:@"广州市天河区" addressId:@"0000"],
             [self createAddressModelWithAddress:@"广州市天河区" addressId:@"0001"],
             [self createAddressModelWithAddress:@"广州市天河区" addressId:@"0002"],
             [self createAddressModelWithAddress:@"广州市天河区" addressId:@"0003"],
             [self createAddressModelWithAddress:@"广州市天河区" addressId:@"0004"],
             [self createAddressModelWithAddress:@"广州市天河区" addressId:@"0005"]];
}

- (AddressModel *)createAddressModelWithAddress:(NSString *)address addressId:(NSString *)addressId {
    AddressModel *model = [[AddressModel alloc] init];
    model.addressString = address;
    model.addressId = addressId;
    return model;
}

#pragma mark - DataSource Delegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _dataList.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    FilterCommonCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:[FilterCommonCollectionViewCell cellReuseIdentifier] forIndexPath:indexPath];
    CommonItemModel *model = [_dataList objectAtIndex:indexPath.row];
    [cell updateCellWithModel:model];
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(ITEM_WIDTH, ITEM_HEIGHT);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return LINE_SPACE_COLLECTION_ITEM;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 0.5*GAP_COLLECTION_ITEM;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [collectionView deselectItemAtIndexPath:indexPath animated:NO];
    FilterCommonCollectionViewCell *cell = (FilterCommonCollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
    [cell tap2SelectItem:[self tap2SelectItem:indexPath]];
}

- (void)addressControllerDidSelectedAddress:(AddressModel *)addressModel {
    _addressModel = addressModel;
    [_addressButton setTitle:addressModel.addressString forState:UIControlStateNormal];
    NSMutableDictionary *mutDict = [NSMutableDictionary dictionaryWithDictionary:_regionModel.customDict];
    [mutDict setValue:addressModel forKey:SELECTED_ADDRESS];
    _regionModel.customDict = [mutDict copy];
}
@end
