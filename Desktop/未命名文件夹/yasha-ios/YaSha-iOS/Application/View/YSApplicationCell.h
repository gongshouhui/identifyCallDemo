//
//  YSApplicationCell.h
//  YaSha-iOS
//
//  Created by 方鹏俊 on 16/11/23.
//  Copyright © 2016年 方鹏俊. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YSApplicationModel.h"
#import "YSHRSelpItem.h"
@interface YSApplicationCell : UICollectionViewCell

@property (nonatomic, strong) YSApplicationModel *cellModel;
@property (nonatomic,strong) YSHRSelpItem *selfHelpItem;

//HR服务修改icon图
@property (nonatomic, strong) YSApplicationModel *hrIconModel;

// 修改icon图
@property (nonatomic, strong) YSApplicationModel *iconModel;

// 我的团队icon图
@property (nonatomic, strong) YSApplicationModel *managerModel;

@end
