//
//  NSMutableArray+YSExtension.m
//  YaSha-iOS
//
//  Created by YaSha_Tom on 2017/8/23.
//
//

#import "NSMutableArray+YSExtension.h"
#import "NSObject+YSSwizzleMethod.h"
#import <objc/runtime.h>
#import "YSApplicationModel.h"

@implementation NSMutableArray (YSExtension)

+ (void)load {
    [super load];
    //替换系统添加数据方法
    Method orginalMethod = class_getInstanceMethod(NSClassFromString(@"__NSArrayM"), @selector(addObject:));
    Method newMethod = class_getInstanceMethod(NSClassFromString(@"__NSArrayM"), @selector(newAddobject:));
    method_exchangeImplementations(orginalMethod, newMethod);

    //只在正式环境处理错误，防止应用崩溃
//#ifdef DEBUG
//#else
    //无论怎样 都要保证方法只交换一次
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        //交换NSMutableArray中的方法
        [objc_getClass("__NSArrayM") SystemSelector:@selector(objectAtIndex:) swizzledSelector:@selector(jz_objectAtIndex:) error:nil];
        [objc_getClass("__NSArrayM") SystemSelector:@selector(objectAtIndexedSubscript:) swizzledSelector:@selector(jz_objectAtIndexedSubscript:) error:nil];
    });
//#endif

}

- (id)jz_objectAtIndex:(NSUInteger)index{
    if (index < self.count) {
        return [self jz_objectAtIndex:index];
    }else{
        
		
        return nil;
    }
}
- (id)jz_objectAtIndexedSubscript:(NSUInteger)index{
    if (index < self.count) {
        
        return [self jz_objectAtIndexedSubscript:index];
    }else{
        
        return nil;
    }
}

- (void)newAddobject:(id)obj {
    if (obj != nil) {
        [self newAddobject:obj];
    }else{
        [self newAddobject:@""];
    }
}

- (void)removeApplicationWithIds:(NSArray *)ids {
    YSApplicationModel *removeModel;
    for (NSString *id in ids) {
        // 此处不能用forin，因为forin遍历时规定不能修改数组元素
        for (int i = 0; i < [self count]; i++) {
            YSApplicationModel *model = self[i];
            if ([model.id isEqual:id]) {
                removeModel = model;
                break;
            }
        }
    }
    [self removeObject:removeModel];
}

@end
