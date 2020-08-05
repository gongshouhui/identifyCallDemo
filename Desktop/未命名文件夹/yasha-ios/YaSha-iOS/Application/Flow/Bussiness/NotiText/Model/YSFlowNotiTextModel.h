//
//  YSFlowNotiTextModel.h
//  YaSha-iOS
//
//  Created by 龚守辉 on 2018/3/1.
//  Copyright © 2018年 亚厦装饰股份有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YSFlowFormModel.h"
@class YSFlowNotiTextListModel;
@interface YSFlowNotiTextModel : NSObject
@property (nonatomic, strong) YSFlowFormHeaderModel *baseInfo;
@property (nonatomic, strong) YSFlowNotiTextListModel *info;
@end
@interface YSFlowNotiTextListModel : NSObject
@property (nonatomic, strong) NSString *content;
@property (nonatomic,strong)  NSString *writingTime;
@property (nonatomic, strong) NSString *typeIdArrayRemark;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *keyword;
@property (nonatomic, strong) NSString *ownerName;
@property (nonatomic, strong) NSString *rangeList;
@property (nonatomic, strong) NSArray *fileList;
@property (nonatomic, strong) NSString *categoryName;
@end
