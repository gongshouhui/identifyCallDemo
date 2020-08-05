//
//  YSMultiDepartEditViewModel.h
//  YaSha-iOS
//
//  Created by 罗罗诺亚索隆 on 2019/3/18.
//  Copyright © 2019 亚厦装饰股份有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface YSMultiDepartEditViewModel : NSObject
@property (nonatomic,strong) NSString *bussinessKey;
@property (nonatomic,strong) NSMutableArray *departArray;
@property (nonatomic,strong) NSMutableArray *viewDataArr;
- (void)turnOtherViewControllerWith:(UIViewController *)viewController andIndexPath:(NSIndexPath *)indexPath;
@end

NS_ASSUME_NONNULL_END
