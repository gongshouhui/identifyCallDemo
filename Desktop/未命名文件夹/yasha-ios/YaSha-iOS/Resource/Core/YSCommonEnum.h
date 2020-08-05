//
//  YSCommonEnum.h
//  YaSha-iOS
//
//  Created by 罗罗诺亚索隆 on 2018/8/15.
//  Copyright © 2018年 亚厦装饰股份有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface YSCommonEnum : NSObject

typedef NS_ENUM(NSInteger,BidFlowType) {
    bidFlowTypeWillInvite = 1,//1:拟邀标
    bidFlowTypeBid //2:招标议价/合同盖章
    
};
typedef NS_ENUM(NSInteger,WorkbenchItemType) {
    WorkbenchItemNeedToDo = 1,//待办
    WorkbenchItemCalendar = 2,//日程
    WorkbenchItemNewsBulletin = 3,//新闻公告
    WorkbenchItemHR = 4,//HR频道
    WorkbenchItemAssets = 5,//固定资产
    WorkbenchItemRepair = 6,//自助保报账
    WorkbenchItemPMSZS = 7,//装饰项目管理
    WorkbenchItemPMSMQ = 8,//幕墙项目管理
    WorkbenchItemSupply = 9,//供应链
    WorkbenchItemEMS = 10,//EMS
    WorkbenchItemRecharge = 11,//一卡通充值
    WorkbenchItemVedioMetting = 12,//视频会议
    WorkbenchItemsService = 13,//智能客服
    WorkbenchItemCRM = 14,//报备营销
	WorkbenchItemQY = 15,// 七鱼客服
	
    WorkbenchItemAdd //添加
    
};

typedef NS_ENUM(NSInteger,BannerType) {
    BannerTypeWorkbenchItem = 1,//工作台
    BannerTypeHRItem = 2,//HR
    BannerTypePerformanceItem = 3,//HR-绩效管理
    BannerTypeAssetsItem = 4,//固定资产
    BannerTypePMSZSItem = 5,//装饰项目管理
    BannerTypePMSMQItem = 6,//幕墙项目管理
    BannerTypeSupplyItem = 7,//供应链
    BannerTypeEMSItem = 8,//EMS
};

@end


NS_ASSUME_NONNULL_END
