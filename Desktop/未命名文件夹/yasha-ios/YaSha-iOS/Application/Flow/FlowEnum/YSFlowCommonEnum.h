//
//  YSFlowCommonEnum.h
//  YaSha-iOS
//
//  Created by 龚守辉 on 2018/6/6.
//  Copyright © 2018年 亚厦装饰股份有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YSFlowCommonEnum : NSObject
typedef enum : NSUInteger {
    YSFlowTypeTodo,
    YSFlowTypeFinished,
    YSFlowTypeSent,
    YSFlowTypeNone,
} YSFlowType;//待办、已办、已发

typedef enum : NSUInteger {
    FlowHandleTypeTrans,    // 转阅
    FlowHandleTypeApproval,    // 审批
    FlowHandleTypeReject,    // 驳回
    FlowHandleTypeAdd,    // 加签
    FlowHandleTypeChange,    // 转办
    FlowHandleTypeSave,    // 暂存
    FlowHandleTypeRevoke,    // 撤回
    FlowHandleTypeTurnRead,    // 转阅已读，跳转到详情页时点击，程序自己执行,不需用户点击
    FlowHandleTypeReview,     //评审
    YSFlowHandleTypeSynergy,   //协同
} YSFlowHandleType;//流程 处理方式

typedef NS_ENUM(NSInteger, FlowHandleStatusType) {
    FlowHandleStatusSPZ = 1, //审批中
    FlowHandleStatusBH, //驳回
    FlowHandleStatusCH, //撤回
    FlowHandleStatusJQ, //加签
    FlowHandleStatusZC, //暂存
    FlowHandleStatusZB, //转办
    FlowHandleStatusBJ, //办结
    FlowHandleStatusZZ, //终止
    //FlowHandleStatusPS, //评审
    //FlowHandleStatusNo,//无处理
};//流程处理过程状态值
typedef NS_ENUM(NSInteger, BussinessFlowCellType) {
    BussinessFlowCellNormal = 0, //普通显示
    BussinessFlowCellHead, //head的样式
    BussinessFlowCellTurn, //跳转链接
    BussinessFlowCellExtend, //展开cell
    BussinessFlowCellText, //纯文本cell签
    BussinessFlowCellHeadWhite, //cell为head的样式背景为白色
    BussinessFlowCellEdit,//编辑类型
    BussinessFlowCellBG,//d有特殊背景的cell
    BussinessFlowCellEmpty,//空白cell
    
    
};//业务表单cell的值
//cell特殊 0为 1处理cell为   2跳转链接  3  4显示纯文本cell  5处理cell为head的样式背景为白色
@end
