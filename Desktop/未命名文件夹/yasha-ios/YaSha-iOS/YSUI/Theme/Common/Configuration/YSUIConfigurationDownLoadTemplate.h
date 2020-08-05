//
//  YSUIConfigurationDownLoadTemplate.h
//  YaSha-iOS
//
//  Created by 罗罗诺亚索隆 on 2018/11/20.
//  Copyright © 2018 亚厦装饰股份有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YSThemeProtocol.h"
#import "YSThemeConfigModel.h"
#import "YSUIConfigurationTemplate.h"
NS_ASSUME_NONNULL_BEGIN
//网络下载的zip包，包中包含配置文件和资源文件  
@interface YSUIConfigurationDownLoadTemplate : NSObject<YSThemeProtocol>
/**下载到沙盒中的json数据*/
@property (nonatomic,strong) YSThemeConfigModel *configModel;
@property (nonatomic,strong) YSUIConfigurationTemplate *defaultTemple;
- (UIImage *)getImageWithName:(NSString *)name;
@end

NS_ASSUME_NONNULL_END
