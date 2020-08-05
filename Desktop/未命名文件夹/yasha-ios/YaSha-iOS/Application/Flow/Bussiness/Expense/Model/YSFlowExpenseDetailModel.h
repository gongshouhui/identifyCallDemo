//
//  YSFlowExpenseDetailModel.h
//  YaSha-iOS
//
//  Created by 龚守辉 on 2018/1/18.
//  Copyright © 2018年 亚厦装饰股份有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YSFlowExpenseDetailModel : NSObject
/**报销费用类型*/
@property (nonatomic,strong) NSString *emsType;
@property (nonatomic,strong) NSArray *info;
/**data重组数据缓存*/
@property (nonatomic,strong) NSArray *redata;
@end

@interface YSFlowExpenseCostDetailModel : NSObject
/**费用详情ID*/
@property (nonatomic,strong) NSString *id;
/**费用时间，入住时间*/
@property (nonatomic,strong) NSString *startTime;
/**退房时间*/
@property (nonatomic,strong) NSString *endTime;
/**费用地点,出发地*/
@property (nonatomic,strong) NSString *startAreaStr;
/**同住人员*/
@property (nonatomic,strong) NSString *dPersonNameStr;
/**消费人数*/
@property (nonatomic,assign) NSInteger expenseNum;
/**金额*/
@property (nonatomic,assign) CGFloat money;
/**发票号码*/
@property (nonatomic,strong) NSString *invoiceNum;
/**发票号码*/
@property (nonatomic,strong) NSString *plateNum;
/**费用归属*/
@property (nonatomic,strong) NSString *proTypeStr;
/**费用归属信息*/
@property (nonatomic,strong) NSString *proName;
/**张数*/
@property (nonatomic,assign) NSInteger sheet;
/**附件*/
@property (nonatomic,strong) NSArray *mobileFiles;
/**备注*/
@property (nonatomic,strong) NSString *remark;
/**购买方式*/
@property (nonatomic,strong) NSString *buyModeStr;
/**座位等级*/
@property (nonatomic,strong) NSString *seatGradeStr;
/**目的地*/
@property (nonatomic,strong) NSString *endAreaStr;
/**警告*/
@property (nonatomic,strong) NSString *warningMsg;
/**同住人员列表*/
@property (nonatomic,strong) NSArray *dPersonList;     
/**出差天数*/
@property (nonatomic,assign) NSInteger businessDay;


@end
