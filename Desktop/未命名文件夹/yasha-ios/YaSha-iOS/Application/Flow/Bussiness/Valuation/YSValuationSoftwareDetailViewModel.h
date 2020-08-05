//
//  YSValuationSoftwareDetailViewModel.h
//  YaSha-iOS
//
//  Created by 罗罗诺亚索隆 on 2019/4/26.
//  Copyright © 2019 亚厦装饰股份有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YSFlowValuationModel.h"
#import "YSFlowFormModel.h"
#import "YSFlowValuationViewModel.h"
NS_ASSUME_NONNULL_BEGIN
typedef void(^ChangeSoftWareBlock)(NSArray *paraArray);
@interface YSValuationSoftwareDetailViewModel : NSObject
@property (nonatomic,strong) NSMutableArray *viewDataArr;
@property (nonatomic,strong) NSString *handType;
@property (nonatomic,assign) CGFloat purchMoney;
@property (nonatomic,strong) NSString *lockNumber;
@property (nonatomic,strong) ChangeSoftWareBlock changeBlock;
@property (nonatomic,assign) ValuationEditType editType;
-(id)initWithValuationValuationFormID:(NSString *)valuationFormID EditType:(ValuationEditType)editType applyInfo:(NSMutableArray *)applyInfo valuationFlowType:(ValuationFlowType)valuationFlowType;
- (void)turnOtherViewControllerWith:(UIViewController *)viewController andIndexPath:(NSIndexPath *)indexPath;
- (void)turnBack;
@end

NS_ASSUME_NONNULL_END
