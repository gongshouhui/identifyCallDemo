//
//  YSApplicationModel.h
//  YaSha-iOS
//
//  Created by 方鹏俊 on 16/11/28.
//  Copyright © 2016年 方鹏俊. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface YSApplicationModel : NSObject

@property (nonatomic, strong) NSString *id;
@property (nonatomic, assign) WorkbenchItemType workBenchType;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) id imageName;
@property (nonatomic, strong) NSString *className;
@property (nonatomic, strong) NSString *modelName;    // 后台定义模块名
@property (nonatomic, assign) NSInteger unreadCount;
@end
