//
//  YSFlowSupplyRecheckScoreModel.h
//  YaSha-iOS
//
//  Created by 龚守辉 on 2017/12/28.
//  Copyright © 2017年 亚厦装饰股份有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YSFlowSupplyRecheckScoreModel : NSObject
/**考评人*/
@property (nonatomic,strong) NSString *name;
/**考评评分*/
@property (nonatomic,assign) CGFloat score;
/**个人评分数据*/
@property (nonatomic,strong) NSArray *admitScoreList;
/**个人评分数据重组数据*/
@property (nonatomic,strong) NSArray *reScoreList;
@end

@interface YSFlowSupplyRecheckScoreListModel : NSObject
/**模板名称*/
@property (nonatomic,strong) NSString *templateName;
/**模板id*/
@property (nonatomic,strong) NSString *mobileId;
@property(nonatomic, assign) CGFloat weight;//权重
/**考评时间*/
@property (nonatomic,strong) NSString *sdateStr;
/**综合评估*/
@property (nonatomic,strong) NSString *content;
/**评分*/
@property (nonatomic,assign) CGFloat score;

@end
