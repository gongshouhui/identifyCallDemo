//
//  YSRejectHandleHelper.h
//  YaSha-iOS
//
//  Created by 罗罗诺亚索隆 on 2018/8/27.
//  Copyright © 2018年 亚厦装饰股份有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YSRejectModel.h"
//YSRejectHandleHelper作为驳回处理C层，YSFlowHandleViewController作为一个处理场景（scene），包含了几种处理类型，只作为调节几种处理类型之间的关系的sceneVC
@interface YSRejectHandleHelper : NSObject <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) YSRejectModel *selectedModel;
- (instancetype)initWithTaskID:(NSString *)taskID;
@end
