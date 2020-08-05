//
//  YSExpenseTransportController.h
//  YaSha-iOS
//
//  Created by 龚守辉 on 2018/1/15.
//  Copyright © 2018年 亚厦装饰股份有限公司. All rights reserved.
//

#import "YSCommonListViewController.h"

typedef NS_ENUM(NSInteger,TranType) {
    TranTypeTravel = 0,//交通费用
    TranTypeSubSidy,//补助
    TranTypeHouse,//住宿
    TranTypeBusisses,//业务明细
    TranTypePerson,//个人明细
    TranTypePublic//对公冲账明细
};
/**交通费用详情，住宿费用，费用明细*/
@interface YSExpenseTransportController : YSCommonListViewController

@property (nonatomic,strong) NSString *expenseID;
@property (nonatomic,assign) TranType trantype;
@end

