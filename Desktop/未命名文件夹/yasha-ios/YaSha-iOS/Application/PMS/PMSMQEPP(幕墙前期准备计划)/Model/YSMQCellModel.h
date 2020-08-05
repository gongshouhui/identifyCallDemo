//
//  YSMQCellModel.h
//  YaSha-iOS
//
//  Created by 罗罗诺亚索隆 on 2018/10/26.
//  Copyright © 2018 亚厦装饰股份有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface YSMQCellModel : NSObject
@property (nonatomic,strong) NSString *className;
@property (nonatomic,strong) NSString *title;
@property (nonatomic,strong) NSString *content;
@property (nonatomic,assign) BOOL necessary;
@property (nonatomic,strong) NSMutableArray *imageArray;
@end

NS_ASSUME_NONNULL_END
