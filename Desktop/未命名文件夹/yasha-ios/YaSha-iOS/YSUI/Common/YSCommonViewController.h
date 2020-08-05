//
//  YSCommonViewController.h
//  YaSha-iOS
//
//  Created by 方鹏俊 on 2017/10/10.
//

#import <QMUIKit/QMUIKit.h>
#import "YSThemeProtocol.h"

@interface YSCommonViewController : QMUICommonViewController <YSChangingThemeDelegate>

// 搜索关键词
@property (nonatomic, strong) NSString *keyWord;
// 页码
@property (nonatomic, assign) NSInteger pageNumber;

// 数据源
@property (nonatomic, strong) NSArray *dataSource;
@property (nonatomic, strong) NSMutableArray *dataSourceArray;

- (void)doNetworking;
/**空白页显示*/
- (void)ys_emptyView;

//记录将需要在退出ViewController取消的请求
- (void)addSessionDataTask:(NSURLSessionDataTask *)task;

//移除已经请求成功的请求
- (void)removeSessionDataTask:(NSURLSessionDataTask *)task;

//取消所有的请求
- (void)cancelAllSessionDataTask;
@end
