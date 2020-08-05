//
//  YSMQImageSelectCellCell.h
//  YaSha-iOS
//
//  Created by 罗罗诺亚索隆 on 2018/10/26.
//  Copyright © 2018 亚厦装饰股份有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
typedef void(^ImageSelectCellBlock)(NSMutableArray *imageArray);
@interface YSMQImageSelectCellCell : UITableViewCell
@property (nonatomic,strong) NSMutableArray *dataArray;
@property (nonatomic,copy) ImageSelectCellBlock selectedImageBlock;
@end

NS_ASSUME_NONNULL_END
