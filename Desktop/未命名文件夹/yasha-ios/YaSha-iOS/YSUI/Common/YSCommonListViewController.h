//
//  YSCommonListViewController.h
//  YaSha-iOS
//
//  Created by 方鹏俊 on 2017/12/7.
//

#import "YSCommonTableViewController.h"

@interface YSCommonListViewController : YSCommonTableViewController

@property(nonatomic, strong) NSArray *detailTextDataSource;
@property(nonatomic, strong) QMUIOrderedDictionary *dataSourceWithDetailText;

// 搜索关键词
@property (nonatomic, strong) NSString *keyWord;
// 页码
@property (nonatomic, assign) NSInteger pageNumber;
@property (nonatomic, strong) UITextField *searchField;
@property (nonatomic, strong) UISearchBar *searchBar;
// 数据源
//@property (nonatomic, strong) NSMutableArray *dataSourceArray;

/** 显示搜索框 */
- (void)ys_shouldShowSearchBar;
- (void)ys_shouldShowSearchBaraAndScreening;
- (void)monitorFiltButton;

- (void)hideMJRefresh;



/** 兼容空白页 */
- (void)ys_reloadData;
//** 空白页 */
- (void)ys_reloadDataWithImageName:(NSString *)imageName text:(NSString *)text;
/** 提示网络错误 */
- (void)ys_showNetworkError;

@end
