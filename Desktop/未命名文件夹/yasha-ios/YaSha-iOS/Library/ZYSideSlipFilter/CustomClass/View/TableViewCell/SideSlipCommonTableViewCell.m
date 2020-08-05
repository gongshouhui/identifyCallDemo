//
//  SideSlipCommonTableViewCell.m
//  ZYSideSlipFilter
//
//  Created by zhiyi on 16/10/14.
//  Copyright © 2016年 zhiyi. All rights reserved.
//

#import "SideSlipCommonTableViewCell.h"
#import "FilterCommonCollectionViewCell.h"
#import <UIView+Utils.h>
#import "CommonItemModel.h"
#import <UIColor+hexColor.h>
#import <ZYSideSlipFilterConfig.h>
#import <ZYSideSlipFilterController.h>
#import <YBPopupMenu.h>

#define FILTER_LEADING ((ZYSideSlipFilterController *)self.delegate).sideSlipLeading
#define CELL_WIDTH kSCREEN_WIDTH - FILTER_LEADING

#define LINE_SPACE_COLLECTION_ITEM 8
#define GAP_COLLECTION_ITEM 8
#define NUM_OF_ITEM_ONCE_ROW 3.f
#define ITEM_WIDTH ((CELL_WIDTH - (NUM_OF_ITEM_ONCE_ROW+1)*GAP_COLLECTION_ITEM)/NUM_OF_ITEM_ONCE_ROW)
#define ITEM_WIDTH_HEIGHT_RATIO 4.f
#define ITEM_HEIGHT ceil(ITEM_WIDTH/ITEM_WIDTH_HEIGHT_RATIO)

const int BRIEF_ROW = 2;

@interface SideSlipCommonTableViewCell () <UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, YBPopupMenuDelegate>
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *controlIcon;
@property (weak, nonatomic) IBOutlet UILabel *controlLabel;
@property (weak, nonatomic) IBOutlet UICollectionView *mainCollectionView;
@property (strong, nonatomic) NSArray *dataList;
@property (strong, nonatomic) NSIndexPath *indexPath;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *collectionViewHeightConstraint;
@property (strong, nonatomic) ZYSideSlipFilterRegionModel *regionModel;
@property (assign, nonatomic) CommonTableViewCellSelectionType selectionType;
@property (strong, nonatomic) NSMutableArray *selectedItemList;
@property (copy, nonatomic) NSString *selectedItemString;

@property (nonatomic, strong) NSMutableArray *provinceArray;
@property (nonatomic, strong) NSMutableArray *provinceCodeArray;
@property (nonatomic, strong) NSMutableArray *cityArray;
@property (nonatomic, strong) NSMutableArray *cityCodeArray;
@property (nonatomic, strong) NSMutableArray *areaArray;
@property (nonatomic, strong) NSMutableArray *areaCodeArray;

@property (nonatomic, strong) NSString *provinceCode;
@property (nonatomic, strong) NSString *cityCode;
@property (nonatomic, strong) NSString *areaCode;

@property (nonatomic, assign) NSInteger addressSelectedIndex;

@end

@implementation SideSlipCommonTableViewCell
+ (NSString *)cellReuseIdentifier {
    return @"SideSlipCommonTableViewCell";
}

+ (instancetype)createCellWithIndexPath:(NSIndexPath *)indexPath {
    SideSlipCommonTableViewCell *cell = [[NSBundle mainBundle] loadNibNamed:@"SideSlipCommonTableViewCell" owner:nil options:nil][0];
    cell.indexPath = indexPath;
    [cell configureCell :indexPath ];
    return cell;
}

- (void)configureCell:(NSIndexPath *)index {
    _provinceCode = @"";
    _cityCode = @"";
    _areaCode = @"";
    
    _provinceArray = [NSMutableArray array];
    _provinceCodeArray = [NSMutableArray array];
    _cityArray = [NSMutableArray array];
    _cityCodeArray = [NSMutableArray array];
    _areaArray = [NSMutableArray array];
    _areaCodeArray = [NSMutableArray array];
    
    _mainCollectionView.delegate = self;
    _mainCollectionView.dataSource = self;
    _mainCollectionView.tag = index.row;
    _mainCollectionView.contentInset = UIEdgeInsetsMake(0, GAP_COLLECTION_ITEM, 0, GAP_COLLECTION_ITEM);
    [_mainCollectionView registerClass:[FilterCommonCollectionViewCell class] forCellWithReuseIdentifier:[FilterCommonCollectionViewCell cellReuseIdentifier]];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(resetPMSPayload) name:@"resetPMSPayload" object:nil];
}

- (void)resetPMSPayload {
    _provinceCode = @"";
    _cityCode = @"";
    _areaCode = @"";
}

- (void)updateCellWithModel:(ZYSideSlipFilterRegionModel **)model
                  indexPath:(NSIndexPath *)indexPath {
    self.indexPath = indexPath;
    self.regionModel = *model;
    //title
    [self.titleLabel setText:_regionModel.regionTitle];
    //content
    self.dataList = _regionModel.itemList;
    //icon
    if (_regionModel.isShowAll) {
        [_controlIcon setImage:[UIImage imageNamed:@"icon_up"]];
    } else {
        [_controlIcon setImage:[UIImage imageNamed:@"icon_down"]];
    }
    //controlLabel
    self.selectedItemList = [NSMutableArray arrayWithArray:_regionModel.selectedItemList];
    [self generateControlLabelText];
    //selectionType
    NSNumber *selectionType = _regionModel.customDict[REGION_SELECTION_TYPE];
    if (selectionType) {
        self.selectionType = [selectionType unsignedIntegerValue];
    }
    //UI
    [_mainCollectionView reloadData];
    [self fitCollectonViewHeight];
}

//根据数据源个数决定collectionView高度
- (void)fitCollectonViewHeight {
    CGFloat displayNumOfRow;
//    if (_regionModel.isShowAll) {
//        displayNumOfRow = ceil(_dataList.count/NUM_OF_ITEM_ONCE_ROW);
//    } else {
//        displayNumOfRow = BRIEF_ROW;
//    }
    displayNumOfRow = ceil(_dataList.count/NUM_OF_ITEM_ONCE_ROW);
    CGFloat collectionViewHeight = displayNumOfRow*ITEM_HEIGHT + (displayNumOfRow - 1)*LINE_SPACE_COLLECTION_ITEM;
    _collectionViewHeightConstraint.constant = collectionViewHeight;
    [_mainCollectionView updateHeight:collectionViewHeight];
}

- (void)tap2SelectItem:(NSIndexPath *)indexPath andClickRow:(NSInteger) row {
    switch (_selectionType) {
        case BrandTableViewCellSelectionTypeSingle:
        {
            NSArray *itemArray = _regionModel.itemList;
            CommonItemModel *model = [itemArray objectAtIndex:indexPath.row];
            if (!model.selected) {
                for (CommonItemModel *item in itemArray) {
                    item.selected = NO;
                }
                [self.selectedItemList removeAllObjects];
                [self.selectedItemList addObject:model];
            } else {
                [self.selectedItemList removeObject:model];
            }
            model.selected = !model.selected;
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
        }
            break;
        case BrandTableViewCellSelectionTypeAddress:
        {
            _addressSelectedIndex = indexPath.row;
            switch (indexPath.row) {
                case 0:
                {
                    [self doNetworking:indexPath.row andClickRow:row];
                    
                }
                    break;
                case 1:
                {
                    if ([_provinceCode isEqual:@""]) {
                        [QMUITips showInfo:@"请先选择省" inView:self.window hideAfterDelay:1];
                    } else {
                        [self doNetworking:indexPath.row andClickRow:row];
                    }
                }
                    break;
                case 2:
                {
                    if ([_provinceCode isEqual:@""]) {
                        [QMUITips showInfo:@"请先选择省" inView:self.window hideAfterDelay:1];
                    } else if ([_provinceCode isEqual:@""] && [_cityCode isEqual:@""]) {
                        [QMUITips showInfo:@"请先选择省市" inView:self.window hideAfterDelay:1];
                    } else if ([_cityCode isEqual:@""]) {
                        [QMUITips showInfo:@"请先选择市" inView:self.window hideAfterDelay:1];
                    } else {
                        [self doNetworking:indexPath.row andClickRow:row];
                    }
                }
                    break;
            }
            break;
        }
        default:
            break;
    }
    _regionModel.selectedItemList = _selectedItemList;
    [self generateControlLabelText];
}

- (void)doNetworking:(NSInteger)index andClickRow:(NSInteger)integer {
    _addressSelectedIndex = index;
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        NSString *urlString = [NSString stringWithFormat:@"%@%@", YSDomain, getArea];
        NSDictionary *payload;
        switch (index) {
            case 0:
                payload = nil;
                break;
            case 1:
                payload = @{@"pcode": _provinceCode};
                break;
            case 2:
                payload = @{@"pcode": _cityCode};
                break;
        }
        CGFloat w = 0;
        if (integer == 1) {
            w = 213;
        }else if (integer == 2) {
            w = 285;
        }else{
            w = 485;
        }
        [YSNetManager ys_request_GETWithUrlString:urlString isNeedCache:NO parameters:payload successBlock:^(id response) {
            DLog(@"获取地址:%@", response);
            switch (index) {
                case 0:
                {
                    [_provinceArray removeAllObjects];
                    [_provinceCodeArray removeAllObjects];
                    for (NSDictionary *dic in response[@"data"]) {
                        [_provinceArray addObject:dic[@"name"]];
                        [_provinceCodeArray addObject:dic[@"code"]];
                    }
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [YBPopupMenu showAtPoint:CGPointMake(108*kWidthScale, w*kHeightScale) titles:[_provinceArray copy] icons:nil menuWidth:85*kWidthScale otherSettings:^(YBPopupMenu *popupMenu) {
                            popupMenu.dismissOnSelected = YES;
                            popupMenu.isShowShadow = YES;
                            popupMenu.delegate = self;
                            popupMenu.offset = 10;
                            popupMenu.fontSize = 12;
                            popupMenu.itemHeight = 30;
                            popupMenu.type = YBPopupMenuTypeDefault;
                            popupMenu.arrowWidth = 0;
                            popupMenu.maxVisibleCount = 4;
                            popupMenu.arrowDirection = YBPopupMenuArrowDirectionBottom;
                            popupMenu.backColor = [UIColor whiteColor];
//                            popupMenu.rectCorner = UIRectCornerBottomLeft | UIRectCornerBottomRight;
                        }];
                    });
                }
                    break;
                case 1:
                {
                    [_cityArray removeAllObjects];
                    [_cityCodeArray removeAllObjects];
                    for (NSDictionary *dic in response[@"data"]) {
                        [_cityArray addObject:dic[@"name"]];
                        [_cityCodeArray addObject:dic[@"code"]];
                    }
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [YBPopupMenu showAtPoint:CGPointMake(215*kWidthScale, w*kHeightScale) titles:[_cityArray copy] icons:nil menuWidth:85*kWidthScale otherSettings:^(YBPopupMenu *popupMenu) {
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
//                            popupMenu.rectCorner = UIRectCornerBottomLeft | UIRectCornerBottomRight;
                        }];
                    });
                }
                    break;
                case 2:
                {
                    [_areaArray removeAllObjects];
                    [_areaCodeArray removeAllObjects];
                    for (NSDictionary *dic in response[@"data"]) {
                        [_areaArray addObject:dic[@"name"]];
                        [_areaCodeArray addObject:dic[@"code"]];
                    }
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [YBPopupMenu showAtPoint:CGPointMake(343*kWidthScale, w*kHeightScale) titles:[_areaArray copy] icons:nil menuWidth:85*kWidthScale otherSettings:^(YBPopupMenu *popupMenu) {
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
//                            popupMenu.rectCorner = UIRectCornerBottomLeft | UIRectCornerBottomRight;
                        }];
                    });
                }
                    break;
            }
        } failureBlock:^(NSError *error) {
            DLog(@"error:%@", error);
        } progress:nil];
    });
}

- (void)ybPopupMenuDidSelectedAtIndex:(NSInteger)index ybPopupMenu:(YBPopupMenu *)ybPopupMenu {
    switch (_addressSelectedIndex) {
        case 0:
        {
            _provinceCode = _provinceCodeArray[index];
            
            NSArray *itemArray = _regionModel.itemList;
            CommonItemModel *model = [itemArray objectAtIndex:_addressSelectedIndex];
            model.itemId = _provinceCodeArray[index];
            model.itemName = _provinceArray[index];
            model.selected = !model.selected;
            model.addressType = _addressSelectedIndex+1;
            model.selected = YES;
            [self.selectedItemList addObject:model];
            [self updateItems:_addressSelectedIndex];
        }
            break;
        case 1:
        {
            _cityCode = _cityCodeArray[index];
            
            NSArray *itemArray = _regionModel.itemList;
            CommonItemModel *model = [itemArray objectAtIndex:_addressSelectedIndex];
            model.itemId = _cityCodeArray[index];
            model.itemName = _cityArray[index];
            model.selected = !model.selected;
            model.addressType = _addressSelectedIndex+1;
            model.selected = YES;
            [self.selectedItemList addObject:model];
            [self updateItems:_addressSelectedIndex];
        }
            break;
        case 2:
        {
            _areaCode = _areaCodeArray[index];
            
            NSArray *itemArray = _regionModel.itemList;
            CommonItemModel *model = [itemArray objectAtIndex:_addressSelectedIndex];
            model.itemId = _areaCodeArray[index];
            model.itemName = _areaArray[index];
            model.selected = !model.selected;
            model.addressType = _addressSelectedIndex+1;
            model.selected = YES;
            [self.selectedItemList addObject:model];
        }
            break;
    }
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:_addressSelectedIndex inSection:0];
    [_mainCollectionView reloadItemsAtIndexPaths:@[indexPath]];
    [ybPopupMenu dismiss];
}

- (void)updateItems:(NSInteger)index {
    switch (index) {
        case 0:
        {
            _addressSelectedIndex = index;
            
            [_cityArray removeAllObjects];
            [_cityCodeArray removeAllObjects];
            [_areaArray removeAllObjects];
            [_areaCodeArray removeAllObjects];
            
            NSArray *itemArray = _regionModel.itemList;
            CommonItemModel *cityModel = [itemArray objectAtIndex:1];
            cityModel.itemId = @"";
            _cityCode = @"";
            cityModel.itemName = @"市";
//            cityModel.selected = !cityModel.selected;
            cityModel.addressType = 2;
            cityModel.selected = NO;
            [self.selectedItemList addObject:cityModel];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                NSIndexPath *indexPath = [NSIndexPath indexPathForRow:1 inSection:0];
                [_mainCollectionView reloadItemsAtIndexPaths:@[indexPath]];
            });
            
            
            CommonItemModel *areaModel = [itemArray objectAtIndex:2];
            areaModel.itemId = @"";
            _areaCode = @"";
            areaModel.itemName = @"区";
//            areaModel.selected = !areaModel.selected;
            areaModel.addressType = 3;
            areaModel.selected = NO;
            [self.selectedItemList addObject:areaModel];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                NSIndexPath *indexPath = [NSIndexPath indexPathForRow:2 inSection:0];
                [_mainCollectionView reloadItemsAtIndexPaths:@[indexPath]];
            });

        }
            break;
        case 1:
        {
            
            _addressSelectedIndex = index;
            
            [_areaArray removeAllObjects];
            [_areaCodeArray removeAllObjects];
            
            NSArray *itemArray = _regionModel.itemList;
            CommonItemModel *areaModel = [itemArray objectAtIndex:2];
            areaModel.itemId = @"";
            _areaCode = @"";
            areaModel.itemName = @"区";
            areaModel.addressType = 3;
            areaModel.selected = NO;
            [self.selectedItemList addObject:areaModel];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                NSIndexPath *indexPath = [NSIndexPath indexPathForRow:2 inSection:0];
                [_mainCollectionView reloadItemsAtIndexPaths:@[indexPath]];
            });
            

        }
            break;
        default:
            break;
    }
}

- (NSString *)packageSelectedNameString {
    NSMutableArray *mutArray = [NSMutableArray array];
    for (CommonItemModel *model in _selectedItemList) {
        [mutArray addObject:model.itemName];
    }
    return [mutArray componentsJoinedByString:@","];
}

- (void)generateControlLabelText {
    if (_selectionType != BrandTableViewCellSelectionTypeAddress) {
        self.selectedItemString = [self packageSelectedNameString];
        UIColor *textColor;
        NSString *labelContent;
        if (_selectedItemString.length > 0) {
            labelContent = _selectedItemString;
            textColor = [UIColor hexColor:FILTER_RED_STRING];
        } else {
            labelContent = @"";
            textColor = [UIColor hexColor:@"999999"];
        }
        [_controlLabel setText:labelContent];
        [_controlLabel setTextColor:textColor];
    }
    
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
    return CGSizeMake(ITEM_WIDTH-10, ITEM_HEIGHT);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return LINE_SPACE_COLLECTION_ITEM;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 0.5*GAP_COLLECTION_ITEM;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [collectionView deselectItemAtIndexPath:indexPath animated:NO];
    [self tap2SelectItem:indexPath andClickRow:collectionView.tag];
    [_mainCollectionView reloadData];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}

- (NSMutableArray *)selectedItemList {
    if (!_selectedItemList) {
        _selectedItemList = [NSMutableArray array];
    }
    return _selectedItemList;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
