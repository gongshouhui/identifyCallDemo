//
//  YSSearch.h
//  YaSha-iOS
//
//  Created by mHome on 2016/12/4.
//
//

#import <Foundation/Foundation.h>

@interface YSSearch : NSObject

@property (copy, nonatomic) NSString *name;
@property (strong, nonatomic) UIImage *icon;
@property (strong,nonatomic) NSString *tel;


// 搜索联系人的方法 (拼音/拼音首字母缩写/汉字)
+ (NSArray  *)searchText:(NSString *)searchText inDataArray:(NSArray *)dataArray;
@end
