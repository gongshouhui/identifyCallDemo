//
//  YSCommonTableViewController.h
//  YaSha-iOS
//
//  Created by 方鹏俊 on 2017/12/7.
//

#import <QMUIKit/QMUIKit.h>
#import "YSThemeProtocol.h"

@interface YSCommonTableViewController : QMUICommonTableViewController <YSChangingThemeDelegate>

@property (nonatomic, strong) NSArray *dataSource;

@property (nonatomic, strong) NSMutableArray *dataSourceArray;

- (void)doNetworking;

/** 兼容空白页 */
- (void)ys_reloadData;
/** 提示网络错误 */
- (void)ys_showNetworkError;

@end
