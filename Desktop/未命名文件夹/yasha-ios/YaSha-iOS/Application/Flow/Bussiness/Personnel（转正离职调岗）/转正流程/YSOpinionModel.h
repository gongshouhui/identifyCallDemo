//
//  YSOpinionModel.h
//  YaSha-iOS
//
//  Created by 罗罗诺亚索隆 on 2020/1/7.
//  Copyright © 2020 亚厦装饰股份有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface YSOpinionModel : NSObject
@property (nonatomic,strong) NSString *title;
@property (nonatomic,strong) NSString *score;
@property (nonatomic,strong) NSString *opinion;
@property (nonatomic,strong) NSString *rowName;
@end

NS_ASSUME_NONNULL_END
