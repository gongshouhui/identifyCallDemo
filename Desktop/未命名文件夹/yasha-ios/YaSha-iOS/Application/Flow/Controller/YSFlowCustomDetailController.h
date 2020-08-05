//
//  YSFlowDetailsViewController.h
//  YaSha-iOS
//
//  Created by YaSha_Tom on 2018/7/30.
//  Copyright © 2018年 亚厦装饰股份有限公司. All rights reserved.
//


#import "YSCommonFlowNewViewController.h"

//typedef enum : NSUInteger {
//    FlowPostscriptList,    //附言
//    FlowExaminationList,   //审批
//    FlowTransferList,      //转阅
//} YSFlowAttachType;

@interface YSFlowCustomDetailController : YSCommonFlowNewViewController
@property (nonatomic,strong) NSString *attendanceJumpStr;
@end
