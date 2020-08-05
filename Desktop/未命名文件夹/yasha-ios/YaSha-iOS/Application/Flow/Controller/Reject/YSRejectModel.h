//
//  YSRejectModel.h
//  YaSha-iOS
//
//  Created by 罗罗诺亚索隆 on 2018/8/27.
//  Copyright © 2018年 亚厦装饰股份有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YSRejectNodeModel.h"
typedef NS_ENUM(NSInteger, YSRejectType) {
    RejectTypeSource = 1, //驳回到提交者
   
    RejectTypeLastNode,//驳回到上一个节点
    RejectTypeSelectedNode,//驳回到指定节点
    
};
@interface YSRejectModel : NSObject
@property (nonatomic,strong) NSString *title;
@property (nonatomic,strong) NSString *name;
@property (nonatomic,assign) YSRejectType rejectType;
@property (nonatomic,strong) YSRejectNodeModel *nodeModel;
@property (nonatomic,assign) BOOL isSelected;
@end
