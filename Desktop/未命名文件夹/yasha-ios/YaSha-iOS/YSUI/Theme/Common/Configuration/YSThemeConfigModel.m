//
//  YSThemeConfigModel.m
//  YaSha-iOS
//
//  Created by 罗罗诺亚索隆 on 2018/11/26.
//  Copyright © 2018 亚厦装饰股份有限公司. All rights reserved.
//

#import "YSThemeConfigModel.h"

@implementation YSThemeConfigModel
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"guidePage" : [NSString
                         class]};
}
@end
@implementation YSThemeTabBarModel
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"items" : [YSThemeTabBarItemModel
                         class]};
}
@end
@implementation YSThemeTabBarItemModel

@end
@implementation YSThemeNavBarModel
@end
@implementation YSThemeWorkBenchModel
@end
