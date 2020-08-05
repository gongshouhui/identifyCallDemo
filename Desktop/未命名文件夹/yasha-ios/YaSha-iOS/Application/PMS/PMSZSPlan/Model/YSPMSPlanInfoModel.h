//
//  YSPMSPlanInfoModel.h
//  YaSha-iOS
//
//  Created by YaSha_Tom on 2017/9/30.
//

#import <Foundation/Foundation.h>

@interface YSPMSPlanInfoModel : NSObject

@property (nonatomic, strong) NSString *graphicProgress;//形象进度
@property (nonatomic, strong) NSString *planStartDate;//计划开始时间
@property (nonatomic, strong) NSString *planEndDate;//计划结束时间
@property (nonatomic, strong) NSString *compileDate;//编制日期
@property (nonatomic, strong) NSString *actualStartDate; // 实际开工时间
@property (nonatomic, strong) NSString *proManagerName; //项目经理
@property (nonatomic, strong) NSString *proNatureStr;// 项目性质
@property (nonatomic, strong) NSString *deptsInfo;//管理部门
//@property (nonatomic, strong) NSString *graphicProgress;//实际形象进度
@property (nonatomic, assign) int outDayNumber;//天数
@property (nonatomic, assign) int normalCount;//正常
@property (nonatomic, assign) int extensionCountFiveti;//延期<=5天
@property (nonatomic, assign) int extensionCountLessFifteenti;//延期5-15天
@property (nonatomic, assign) int extensionCountmoreFifteenti;//延期>=15天
@property (nonatomic, assign) int pointNormalCount;//正常
@property (nonatomic, assign) int pointExtensionCountFiveti;//延期<=5天
@property (nonatomic, assign) int pointExtensionCountLessFifteenti;//延期5-15天
@property (nonatomic, assign) int pointExtensionCountmoreFifteenti;//延期>=15天
@property (nonatomic, assign) int startExtensionTask;//开工延期任务
@property (nonatomic, assign) int processingTask;//进行中任务
@property (nonatomic, assign) int completionExtension;//完工延期任务
@property (nonatomic, assign) int notStartedTask;//未开工任务
@property (nonatomic, assign) int threeTrackTask;//3日内需跟踪任务
@property (nonatomic, assign) int completedTask;//已完工任务
@property (nonatomic, assign) int controlPointTask;//控制点任务
@property (nonatomic, assign) int extensionCompletedTask;//延期控制点任务
@property (nonatomic, strong) NSString  *fiveDay;
@property (nonatomic, assign) NSString *tenDay;

@property (nonatomic, strong) NSString *planDuration;
@property (nonatomic, assign) int commencementOfDelayNormal;//开工延期正常
@property (nonatomic, assign) int commencementOfDelayToFifteen;//开工延期0~15
@property (nonatomic, assign) int commencementOfDelayToThirty;//开工延期15~30
@property (nonatomic, assign) int commencementOfDelayMoreThirty;//开工延期30~
@property (nonatomic, assign) int completionDelayNormal;//完工延期正常
@property (nonatomic, assign) int completionDelayToFifteen;//完工延期0~15
@property (nonatomic, assign) int completionDelayToThirty;//开完延期15~30
@property (nonatomic, assign) int completionDelayMoreThirty;//完工延期30~


@end
