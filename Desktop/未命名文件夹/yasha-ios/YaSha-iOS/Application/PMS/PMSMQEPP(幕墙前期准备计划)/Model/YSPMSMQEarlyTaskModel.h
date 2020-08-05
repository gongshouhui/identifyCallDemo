//
//  YSPMSMQEarlyTaskModel.h
//  YaSha-iOS
//
//  Created by 罗罗诺亚索隆 on 2018/11/2.
//  Copyright © 2018 亚厦装饰股份有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface YSPMSMQEarlyTaskModel : NSObject
/**任务名字*/
@property (nonatomic,strong) NSString *name;//
/**任务进度*/
@property (nonatomic,strong) NSString *graphicProgress;//
/**任务阶段*/
@property (nonatomic,strong) NSString *parentName;//
/**负责人*/
@property (nonatomic,strong) NSString *mainPersonName;
/**计划开始*/
@property (nonatomic,strong) NSString *planStartDate;
/**计划结束*/
@property (nonatomic,strong) NSString *planEndDate;
/**超期天数*/
@property (nonatomic,strong) NSString *outDayNumber;
/**施工任务备注*/
@property (nonatomic,strong) NSString *remark;
/***/
@property (nonatomic,strong) NSArray *planPrepareStageList;
/**任务状态*/
@property (nonatomic,assign) NSInteger taskStatus;

@end
@interface YSPMSMQEarlyChildTaskModel : NSObject
/** dd */
@property (nonatomic,strong) NSString *title;//
/**更新时间*/
@property (nonatomic,strong) NSString *updateTime;
/**进度*/
@property (nonatomic,strong) NSString *graphicProgress;
/**阶段*/
@property (nonatomic,strong) NSString *taskStatus;
/**图片*/
@property (nonatomic,strong) NSArray *files;
/**操作备注*/
@property (nonatomic,strong) NSString *finishRemark;
/**是否影响总工期*/
@property (nonatomic,assign) BOOL isLimit;
/**是否影响总工期备注*/
@property (nonatomic,strong) NSString *isLimitRemark;

@end
@interface YSPMSImageModel : NSObject
/** 图片 */
@property (nonatomic,strong) NSString *filePath;//


@end


NS_ASSUME_NONNULL_END
