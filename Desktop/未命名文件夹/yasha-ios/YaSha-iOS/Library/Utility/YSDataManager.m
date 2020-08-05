//
//  YSDataManager.m
//  YaSha-iOS
//
//  Created by mHome on 2016/12/10.
//
//

#import "YSDataManager.h"
#import "YSUtility.h"
#import "YSExternalModel.h"
#import "YSInformationModel.h"
#import "YSInternalModel.h"
#import "YSInternalPeopleModel.h"
#import "YSPersonalInformationModel.h"

#import "YSInternalDetails.h"
#import "YSAttendanceModel.h"

// 新闻公告
#import "YSNewsListModel.h"
#import "YSNewsAttachmentModel.h"

// 资产
#import "YSAssetsResultModel.h"
#import "YSAssetsListModel.h"
#import "YSAssetsDetailListModel.h"
#import "YSAssetsMineModel.h"

#import "YSITSMUntreatedModel.h"

#import "YSApplicationModel.h"
#import "YSACLModel.h"

#import "YSCalendarEventModel.h"
#import "YSCalendarGrantPeopleModel.h"

// 绩效
#import "YSPerfListModel.h"
#import "YSPerfInfoModel.h"
#import "YSPerfEvaluaListModel.h"
#import "YSPerfEvaluaRecordModel.h"

#import "YSPMSInfoListModel.h"

#import "YSGroupListModel.h"
#import "YSPMSUnitInfoModel.h"
#import "YSPMSPeopleInfoModel.h"
#import "YSPMSHistoryInfoModel.h"
#import "YSPMSAddressModel.h"
#import "YSPMSFinanceInfoModel.h"


// 流程
#import "YSFlowListModel.h"
#import "YSFlowRecordListModel.h"
#import "YSFlowAttachListModel.h"
#import "YSFlowFormModel.h"
#import "YSFlowLaunchListModel.h"

//供应商
#import "YSSupplyListModel.h"
#import "YSSupplyPersonModel.h"
#import "YSSupplyBankModel.h"
#import "YSSupplySupplierModel.h"

// EMS
#import "YSEMSMyTripListModel.h"
#import "YSEMSProListModel.h"

// 公用查询
#import "YSAreaPickerView.h"

// 通讯录
#import "YSContactModel.h"
#import "YSDepartmentModel.h"
#import "YSIdentPhoneModel.h"


//考勤
#import "YSSummaryModel.h"
#import "YSReporetModel.h"
#import "YSHRMTSummaryModel.h"
#import "YSHRMTDeptTreeModel.h"

// 培训 我的团队 团队详情
#import "YSTeamCompilePostModel.h"
#import "YSHRMTTrainingModel.h"
#import "CallDirectoryHandler.h"
@implementation YSDataManager

static YSDataManager *_datamanager = nil;

+ (YSDataManager *)sharedDataManager {
    if (!_datamanager) {
        _datamanager = [[YSDataManager alloc] init];
    }
    return _datamanager;
}

#pragma mark - 应用及权限

+ (NSArray *)getApplicationsData:(id)response {
    NSMutableArray *mutableArray = [NSMutableArray array];
    for (NSDictionary *dic in response) {
        YSApplicationModel *model = [YSApplicationModel yy_modelWithJSON:dic];
        [mutableArray addObject:model];
    }
    return [mutableArray copy];
}

+ (void)saveUserACLDB:(id)response {
    NSMutableArray *mutableArray = [NSMutableArray array];
    NSDictionary *dic = response[@"data"];
    for (NSString *key in dic.allKeys) {
        for (NSDictionary *subDic in [dic valueForKey:key]) {
            YSACLModel *model = [YSACLModel yy_modelWithJSON:subDic];
            model.companyId = key;
            [mutableArray addObject:model];
        }
    }
    RLMRealm *realm = [RLMRealm defaultRealm];
    [realm beginWriteTransaction];
    [realm addObjects:[mutableArray copy]];
    [realm commitWriteTransaction];
}

+ (void)saveACLDB:(id)response {
    NSMutableArray *mutableArray = [NSMutableArray array];
    for (NSDictionary *dic in response[@"data"]) {
        YSACLModel *model = [YSACLModel yy_modelWithJSON:dic];
        [mutableArray addObject:model];
    };
    RLMRealm *realm = [RLMRealm defaultRealm];
    [realm beginWriteTransaction];
    [realm addObjects:[mutableArray copy]];
    [realm commitWriteTransaction];
}

+ (void)savePMSACLDB:(id)response {
    NSMutableArray *mutableArray = [NSMutableArray array];
    NSDictionary *dic = response[@"data"];
    for (NSString *key in dic.allKeys) {
        for (NSDictionary *subDic in [dic valueForKey:key]) {
            YSACLModel *model = [YSACLModel yy_modelWithJSON:subDic];
            model.companyId = key;
            [mutableArray addObject:model];
        }
    }
    RLMRealm *realm = [RLMRealm defaultRealm];
    [realm beginWriteTransaction];
    [realm addObjects:[mutableArray copy]];
    [realm commitWriteTransaction];
}

+ (void)deleteACLDB {
    DLog(@"权限数据库目录:%@", [RLMRealm defaultRealm].configuration.fileURL);
    RLMRealm *realm = [RLMRealm defaultRealm];
    //权限清空
    RLMResults *aclResults = [YSACLModel allObjects];
    //通讯录清空
    RLMResults *contactResults = [YSContactModel allObjects];
    RLMResults *orgResults = [YSDepartmentModel allObjects];
    RLMResults *identPhoneResults = [YSIdentPhoneModel allObjects];
    [realm beginWriteTransaction];
    [realm deleteObjects:aclResults];
    [realm deleteObjects:contactResults];
    [realm deleteObjects:orgResults];
    [realm deleteObjects:identPhoneResults];
    [realm commitWriteTransaction];
}

#pragma mark - 公用查询

+ (NSArray *)getAreaData:(id)response {
    NSMutableArray *mutableArray = [NSMutableArray array];
    for (NSDictionary *dic in response[@"data"]) {
        YSProvinceModel *model = [YSProvinceModel yy_modelWithJSON:dic];
        [mutableArray addObject:model];
    }
    return [mutableArray copy];
}

+ (void)getApplicationsWithBadgeWithDatasource:(NSMutableArray *)datasource andResponse:(id)response {
   
    for (int i = 0; i < datasource.count; i++) {
        YSApplicationModel *model = datasource[i];
        for (NSDictionary *dic in response[@"data"][@"info"]) {
            NSString *modelName = dic[@"modelName"];
            if ([modelName isEqualToString:model.modelName]) {
                model.unreadCount = [dic[@"unreadCount"] integerValue];
            }
        }
    }
}

#pragma mark - IM

+ (NSArray *)getGroupListData:(id)response {
    NSMutableArray *mutableArray = [NSMutableArray array];
    for (NSDictionary *dic in response[@"data"]) {
        YSGroupListModel *model = [YSGroupListModel yy_modelWithJSON:dic];
        [mutableArray addObject:model];
    }
    return [mutableArray copy];
}

#pragma mark - 通讯录

+ (NSArray *)getExternalData:(id)response {
    NSArray *userProjectArray = response[@"data"];
    NSMutableArray *mutableArray = [NSMutableArray array];
    for (NSDictionary *dic in userProjectArray) {
        YSExternalModel *model = [YSExternalModel yy_modelWithJSON:dic];
        [mutableArray addObject:model];
    }
    return [mutableArray copy];
}

+ (NSArray *)getExternalDetailsData:(id)response {
    NSMutableArray *mutableArray = [NSMutableArray array];
    NSDictionary *detailsDic = response[@"data"];
    YSInformationModel *model = [YSInformationModel yy_modelWithJSON:detailsDic];
    [mutableArray addObject:model];
    return [mutableArray copy];
}

+ (NSArray *)getInternallData:(id)response {
    NSArray *userProjectArray = response[@"data"];
    NSMutableArray *mutableArray = [NSMutableArray array];
    for (NSDictionary *dic in userProjectArray) {
        YSInternalModel *model = [YSInternalModel yy_modelWithJSON:dic];
        [mutableArray addObject:model];
    }
    return [mutableArray copy];
}

+ (NSArray *)getPeopleData:(id)response {
    NSMutableArray *mutableArray = [NSMutableArray array];
    NSDictionary *detailsDic = response[@"data"];
    YSPersonalInformationModel *model = [YSPersonalInformationModel yy_modelWithJSON:detailsDic];
    [mutableArray addObject:model];
    return [mutableArray copy];
}

+ (NSArray *)getInternPeopleMemberData:(id)response {
    NSDictionary *userProjectArray = response[@"data"];
    NSMutableArray *mutableArray = [NSMutableArray array];
    YSInternalPeopleModel *model = [YSInternalPeopleModel yy_modelWithJSON:userProjectArray];
    [mutableArray addObject:model];
    return [mutableArray copy];
}

+ (NSArray *)getInternallMemberData:(id)response {
    NSArray *userProjectArray = response[@"data"];
    NSMutableArray *mutableArray = [NSMutableArray array];
    for (NSDictionary *dic in userProjectArray) {
        YSInternalPeopleModel *model = [YSInternalPeopleModel yy_modelWithJSON:dic];
        [mutableArray addObject:model];
    }
    return [mutableArray copy];
}

+ (NSArray *)getInternallistData:(id)response {
    NSArray *userProjectArray = response[@"data"];
    NSMutableArray *mutableArray = [NSMutableArray array];
    for (NSDictionary *dic in userProjectArray) {
        YSInternalModel *model = [YSInternalModel yy_modelWithJSON:dic];
        [mutableArray addObject:model];
    }
    return [mutableArray copy];
}

+ (NSArray *)getInternalDetailsData:(id)response {
    NSMutableArray *mutableArray = [NSMutableArray array];
    NSDictionary *detailsDic = response[@"data"];
    YSInternalDetails *model = [YSInternalDetails yy_modelWithJSON:detailsDic];
    [mutableArray addObject:model];
    return [mutableArray copy];
}

+ (NSArray *)getChoosegetExternalData:(id)response {
    NSArray *userProjectArray = response[@"data"];
    NSMutableArray *mutableArray = [NSMutableArray array];
    for (NSDictionary *dic in userProjectArray) {
        YSExternalModel *model = [YSExternalModel yy_modelWithJSON:dic];
        if (model.isCommon == nil || [model.isCommon isEqual:@"0"]) {
            [mutableArray addObject:model];
        }
    }
    return [mutableArray copy];
}


#pragma mark - 通讯录（新）

+ (void)saveContactDB:(id)response isAll:(BOOL)isall {
    RLMRealm *realm = [RLMRealm defaultRealm];
    [realm beginWriteTransaction];
    /** 逻辑：为空时全量，否则为增量处理 */
    if (isall) {
        //NSLog(@"---------%@",[NSThread currentThread]);
        NSMutableArray *orgMutableArray = [NSMutableArray array];
        for (NSDictionary *orgDic in response[@"data"][@"org"]) {
            YSDepartmentModel *orgModel = [YSDepartmentModel yy_modelWithJSON:orgDic];
            [orgMutableArray addObject:orgModel];
        };
        NSMutableArray *personMutableArray = [NSMutableArray array];
        for (NSDictionary *personDic in response[@"data"][@"person"]) {
            YSContactModel *personModel = [YSContactModel yy_modelWithJSON:personDic];
            personModel.isOrg = NO;
            [personMutableArray addObject:personModel];
        };
        [realm addObjects:[orgMutableArray copy]];
        [realm addObjects:[personMutableArray copy]];
    } else {
        DLog(@"处理增量数据");
        for (NSDictionary *orgDic in response[@"data"][@"org"]) {
            YSDepartmentModel *orgModel = [YSDepartmentModel yy_modelWithJSON:orgDic];
            [realm addOrUpdateObject:orgModel];
        };
        for (NSDictionary *personDic in response[@"data"][@"person"]) {
            YSContactModel *personModel = [YSContactModel yy_modelWithJSON:personDic];
            personModel.isOrg = NO;
            [realm addOrUpdateObject:personModel];
        };
    }
    [realm commitWriteTransaction];
	[self updateContactIDentPhone];//顺便更新号码识别库
	
}

+ (void)clearContact {
    RLMRealm *realm = [RLMRealm defaultRealm];
    [realm beginWriteTransaction];
    [realm deleteObjects:[YSContactModel allObjects]];
    [realm deleteObjects:[YSDepartmentModel allObjects]];
    [realm deleteObjects:[YSIdentPhoneModel allObjects]];
    [realm commitWriteTransaction];
}

#pragma mark - 新流程中心

+ (NSArray *)getFlowListData:(id)response {
    NSMutableArray *mutableArray = [NSMutableArray array];
    if (![response[@"data"] isEqual:[NSNull null]]) {
        for (NSDictionary *dic in response[@"data"]) {
            YSFlowListModel *model = [YSFlowListModel yy_modelWithJSON:dic];
            [mutableArray addObject:model];
        }
    }
    return [mutableArray copy];
}

+ (NSArray *)getFlowRecordListData:(id)response {
    NSMutableArray *mutableArray = [NSMutableArray array];
    for (NSDictionary *dic in response[@"data"]) {
        YSFlowRecordListModel *model = [YSFlowRecordListModel yy_modelWithJSON:dic];
        [mutableArray addObject:model];
        /** 流程终止后，后续的数据不予显示 */
        if ([model.type isEqual:@"LCZZ"]) {
            break;
        }
    }
    return [mutableArray copy];
}

+ (NSMutableArray *)getFlowRecordListNewData:(NSArray *)response {
    NSMutableArray *mutableArray = [NSMutableArray array];
    for (int i = 0 ; i < response.count; i ++) {
        YSFlowRecordListModel *model = [YSFlowRecordListModel yy_modelWithJSON:response[i]];
        [mutableArray addObject:model];
        /** 流程终止后，后续的数据不予显示 */
        if ([model.type isEqual:@"LCZZ"]) {
            break;
        }
    }
    return mutableArray;
}

+ (NSArray *)getFlowAttachPSListData:(id)response {
    NSMutableArray *mutableArray = [NSMutableArray array];
    for (NSDictionary *dic in response[@"data"]) {
        YSFlowAttachPSListModel *model = [YSFlowAttachPSListModel yy_modelWithJSON:dic];
        [mutableArray addObject:model];
    }
    return [mutableArray copy];
}

+ (NSMutableArray *)getFlowAttachPSListNewData:(NSArray *)response {
    NSMutableArray *mutableArray = [NSMutableArray array];
    for (int i = 0 ; i < response.count; i ++) {
        YSFlowRecordListModel *model = [YSFlowRecordListModel yy_modelWithJSON:response[i]];
        [mutableArray addObject:model];
    }
    return mutableArray;
}

+ (NSArray *)getFlowAttachFileListData:(id)response {
    NSMutableArray *mutableArray = [NSMutableArray array];
    NSLog(@"------%@",response);
    for (NSDictionary *dic in response[@"data"]) {
        YSNewsAttachmentModel *model = [YSNewsAttachmentModel yy_modelWithJSON:dic];
        [mutableArray addObject:model];
    }
    return [mutableArray copy] ;
}
+ (NSArray *)getFlowAttachFileListAndPSListData:(id)response {
    NSMutableArray *mutableArray = [NSMutableArray array];
    for (NSDictionary *dic in response) {
            YSNewsAttachmentModel *model = [YSNewsAttachmentModel yy_modelWithJSON:dic];
            [mutableArray addObject:model];
        }
    return [mutableArray copy] ;
}

+ (NSArray *)getFlowFormDocumentationListData:(NSArray *)response {
    NSMutableArray *mutableArray = [NSMutableArray array];
    for (int i = 0 ; i < response.count; i ++) {
        YSNewsAttachmentModel *model = [YSNewsAttachmentModel yy_modelWithJSON:response[i]];
        [mutableArray addObject:model];
    }
    return [mutableArray copy] ;
}

+ (NSArray *)getFlowFormAttachFileListData:(id)response {
    NSMutableArray *mutableArray = [NSMutableArray array];
    YSFlowFormModel *flowFormModel = [YSFlowFormModel yy_modelWithJSON:response[@"data"]];
    for (YSFlowFormListModel *flowFormListModel in flowFormModel.dataInfo) {
        if ([flowFormListModel.fieldType isEqual:@"upload"]) {
            NSData *jsonData = [flowFormListModel.value dataUsingEncoding:NSUTF8StringEncoding];
            NSError *error = nil;
            NSDictionary *fileDic = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:&error];
            for (NSDictionary *dic in fileDic) {
                YSNewsAttachmentModel *model = [YSNewsAttachmentModel yy_modelWithJSON:dic];
                [mutableArray addObject:model];
            }
        }
    }
    return [mutableArray copy];
}

+ (NSArray *)getFlowLaunchListData:(id)response {
    NSMutableArray *mutableArray = [NSMutableArray array];
    for (NSDictionary *dic in response[@"data"]) {
        YSFlowLaunchListModel *flowLaunchListModel = [YSFlowLaunchListModel yy_modelWithJSON:dic];
        [mutableArray addObject:flowLaunchListModel];
    }
    return [mutableArray copy];
}

#pragma mark - 新流程中心（发起）

+ (NSArray *)getFlowLaunchOptionsData:(id)response {
    NSMutableArray *mutableArray = [NSMutableArray array];
    for (NSDictionary *dic in response) {
        NSDictionary *optionsDic = @{dic[@"ename"]: dic[@"cname"]};
        [mutableArray addObject:optionsDic];
    }
    return [mutableArray copy];
}

#pragma mark - 公文

+ (NSArray *)getNewsBannerListData:(id)response {
    NSMutableArray *mutableArray = [NSMutableArray array];
    for (NSDictionary *dic in response[@"data"]) {
        YSNewsListModel *model = [YSNewsListModel yy_modelWithJSON:dic];
        [mutableArray addObject:[NSString stringWithFormat:@"%@%@", YSImageDomain, model.thumbImg]];
    }
    return [mutableArray copy];
}

+ (NSArray *)getNewsListData:(id)response {
    NSMutableArray *mutableArray = [NSMutableArray array];
    for (NSDictionary *dic in response[@"data"]) {
        YSNewsListModel *model = [YSNewsListModel yy_modelWithJSON:dic];
        [mutableArray addObject:model];
    }
    return [mutableArray copy];
}

+ (NSArray *)getNewsAttachmentListData:(id)response {
    NSMutableArray *mutableArray = [NSMutableArray array];
    for (NSDictionary *dic in response[@"data"]) {
        YSNewsAttachmentModel *model = [YSNewsAttachmentModel yy_modelWithJSON:dic];
        [mutableArray addObject:model];
    }
    return [mutableArray copy];
}

#pragma mark - 资产

+ (NSArray *)getAssetsListData:(id)response {
    NSMutableArray *mutableArray = [NSMutableArray array];
    for (NSDictionary *dic in response[@"data"]) {
        YSAssetsListModel *model = [YSAssetsListModel yy_modelWithJSON:dic];
        [mutableArray addObject:model];
    }
    return [mutableArray copy];
}

+ (NSArray *)getAssetsDetailListData:(id)response {
    NSMutableArray *mutableArray = [NSMutableArray array];
    for (NSDictionary *dic in response[@"data"]) {
        YSAssetsDetailListModel *model = [YSAssetsDetailListModel yy_modelWithJSON:dic];
        [mutableArray addObject:model];
    }
    return [mutableArray copy];
}

+ (NSArray *)getAssetsResultListData:(id)response {
    NSMutableArray *mutableArray = [NSMutableArray array];
    for (NSDictionary *dic in response[@"data"]) {
        YSAssetsResultModel *model = [YSAssetsResultModel yy_modelWithJSON:dic];
        [mutableArray addObject:model];
    }
    return [mutableArray copy];
}

+ (NSArray *)getMyAssetsListData:(id)response {
    NSMutableArray *mutableArray = [NSMutableArray array];
    for (NSDictionary *dic in response[@"data"]) {
        YSAssetsMineModel *model = [YSAssetsMineModel yy_modelWithJSON:dic];
        [mutableArray addObject:model];
    }
    return [mutableArray copy];
}

#pragma mark - 考勤

+ (NSArray *)getAttendanceData:(id)response {
    NSMutableArray *mutableArray = [NSMutableArray array];
    NSMutableArray *arr = [NSMutableArray arrayWithCapacity:100];
    for (NSDictionary *dic in response[@"data"]){
        [arr addObject:dic];
    }
    NSArray *sortDescriptors = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"sdate" ascending:NO]];
    [arr sortUsingDescriptors:sortDescriptors];
    for (NSDictionary *dic in arr ) {
        YSAttendanceModel *model = [YSAttendanceModel yy_modelWithJSON:dic];
        if ([model.type isEqual:@"30"] || [model.type isEqual:@"20"]) {
            [mutableArray addObject:model];
        }
    }
    return [mutableArray copy];
}

+ (NSArray *)getAllAttendanceData:(id)response {
    NSMutableArray *mutableArray = [NSMutableArray array];

    NSMutableArray *arr = [NSMutableArray array];
    for (NSDictionary *dic in response[@"data"]){
        [arr addObject:dic];
    }
    NSArray *sortDescriptors = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"sdate" ascending:NO]];
    [arr sortUsingDescriptors:sortDescriptors];
    for (NSDictionary *dic in arr) {
        YSAttendanceModel *model = [YSAttendanceModel yy_modelWithJSON:dic];
        [mutableArray addObject:model];

    }
    return [mutableArray copy];
}

+ (NSArray *)getAttendanceDetailData:(id)response {
    NSMutableArray *mutableArray = [NSMutableArray array];
    for (NSDictionary *dic in response[@"data"]) {
        YSSummaryModel *model = [YSSummaryModel yy_modelWithJSON:dic];
        [mutableArray addObject:model];
    }
    return [mutableArray copy];
}

+ (NSArray *)getTeamAllAttendanceData:(id)response {
    NSMutableArray *mutableArray = [NSMutableArray array];
    for (NSDictionary *dic in response[@"rows"]) {
        YSHRMTSummaryModel *model = [YSHRMTSummaryModel yy_modelWithJSON:dic];
        [mutableArray addObject:model];
    }
    return [mutableArray copy];
}

+ (NSArray *)getTeamAllDeptTreeData:(id)response {
    NSMutableArray *mutableArray = [NSMutableArray array];
    for (NSDictionary *dic in response[@"data"]) {
        YSHRMTDeptTreeModel *model = [YSHRMTDeptTreeModel yy_modelWithJSON:dic];
        [mutableArray addObject:model];
    }
    return [mutableArray copy];
}
#pragma marrk - HR管理者培训
/** 获取我的团队 团队编制详情 */
+ (NSArray*)getTeamMyAllAuthorizedData:(id)response {
    
    NSMutableArray *mutableArray = [NSMutableArray array];
    for (NSDictionary *dic in response[@"data"]) {
        YSTeamCompilePostModel *model = [YSTeamCompilePostModel yy_modelWithJSON:dic];
        [mutableArray addObject:model];
    }
    return [mutableArray copy];
}

#pragma mark--团队 部门培训
+ (NSArray*)getTeamMyAllTrainingData:(id)response {
    
    NSMutableArray *mutableArray = [NSMutableArray array];
    for (NSDictionary *dic in response[@"data"]) {
         TrainingDetailModel *model = [TrainingDetailModel yy_modelWithJSON:dic];
        [mutableArray addObject:model];
    }
    return [mutableArray copy];
}

#pragma makr - ITSM

+ (NSArray *)getAlllistData:(id)response{
    NSMutableArray *mutableArray = [NSMutableArray array];

    if (![response[@"data"] isEqual:[NSNull null]]) {
        for (NSDictionary *dic in response[@"data"]) {

            YSITSMUntreatedModel *model = [YSITSMUntreatedModel yy_modelWithJSON:dic];
            [mutableArray addObject:model];
        }
    }
    return [mutableArray copy];
}

#pragma mark - 日程

+ (NSArray *)getCalendarEventData:(id)response {
    NSMutableArray *mutableArray = [NSMutableArray array];
    for (NSDictionary *dic in response[@"data"]) {
        YSCalendarEventModel *model = [YSCalendarEventModel yy_modelWithJSON:dic];
        // 针对跨日后台返回第二天00:00:00
        if ([model.end containsString:@"00:00:00"]) {
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            dateFormatter.timeZone = [NSTimeZone systemTimeZone];
            dateFormatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
            NSDate *endDate = [NSDate dateWithString:model.end formatString:@"yyyy-MM-dd HH:mm:ss"];
            NSDate *newEndDate = [endDate dateBySubtractingSeconds:1];
            model.end = [dateFormatter stringFromDate:newEndDate];
        }
        [mutableArray addObject:model];
    }
    return [mutableArray copy];
}

+ (NSArray *)getCalendarEventDate:(id)response {
    NSMutableArray *mutableArray = [NSMutableArray array];
    for (NSDictionary *dic in response[@"data"]) {
        YSCalendarEventModel *model = [YSCalendarEventModel yy_modelWithJSON:dic];
        [mutableArray addObject:[model.start substringToIndex:10]];
    }
    return [mutableArray copy];
}

+ (NSArray *)getCalendarGrantPeopleData:(id)response {
    NSMutableArray *mutableArray = [NSMutableArray array];
    for (NSDictionary *dic in response[@"data"]) {
        YSCalendarGrantPeopleModel *model = [YSCalendarGrantPeopleModel yy_modelWithJSON:dic];
        [mutableArray addObject:model];
    }
    return [mutableArray copy];
}

#pragma mark - 绩效

+ (NSArray *)getPerfListData:(id)response {
    NSMutableArray *mutableArray = [NSMutableArray array];
    if (![response[@"data"] isEqual:[NSNull null]]) {
        for (NSDictionary *dic in response[@"data"]) {
            YSPerfListModel *model = [YSPerfListModel yy_modelWithJSON:dic];
            [mutableArray addObject:model];
        }
    }
    return [mutableArray copy];
}

+ (NSArray *)getPerfInfoListData:(id)response {
    NSMutableArray *mutableArray = [NSMutableArray array];
    if (![response[@"data"] isEqual:[NSNull null]]) {
        for (NSDictionary *dic in response[@"data"][0][@"examContent"]) {
            YSPerfInfoModel *model = [YSPerfInfoModel yy_modelWithJSON:dic];
            [mutableArray addObject:model];
        }
    }
    return [mutableArray copy];
}

+ (NSArray *)getPerfEvalueRecordListData:(id)response {
    NSMutableArray *mutableArray = [NSMutableArray array];
    if (![response[@"data"] isEqual:[NSNull null]]) {
        for (NSDictionary *dic in response[@"data"]) {
            YSPerfEvaluaRecordModel *model = [YSPerfEvaluaRecordModel yy_modelWithJSON:dic];
            [mutableArray addObject:model];
        }
    }
    return [mutableArray copy];
}

+ (NSArray *)getPerfEvaluaListData:(id)response {
    NSMutableArray *mutableArray = [NSMutableArray array];
    if (![response[@"data"] isEqual:[NSNull null]]) {
        for (NSDictionary *dic in response[@"data"]) {
            YSPerfEvaluaListModel *model = [YSPerfEvaluaListModel yy_modelWithJSON:dic];
            [mutableArray addObject:model];
        }
    }
    return [mutableArray copy];
}

#pragma mark - 项目管理PMS

+ (NSArray *)getPMSInfoListData:(id)response {
    NSMutableArray *mutableArray = [NSMutableArray array];
    if (![response[@"data"] isEqual:[NSNull null]]) {
        for (NSDictionary *dic in response[@"data"]) {
            YSPMSInfoListModel *model = [YSPMSInfoListModel yy_modelWithJSON:dic];
            [mutableArray addObject:model];
        }
    }
    return [mutableArray copy];
}

+ (NSArray *)getPMSUnitInfoData:(id)response {
    NSMutableArray *mutableArray = [NSMutableArray array];
    if (![response[@"data"] isEqual:[NSNull null]]) {
        for (NSDictionary  *dic in response[@"data"]) {
            YSPMSUnitInfoModel *model = [YSPMSUnitInfoModel yy_modelWithJSON:dic];
            [mutableArray addObject:model];
        }
    }
    return [mutableArray copy];
}

+ (NSArray *)getPMSPeopleInfoData:(id)response {
    NSMutableArray *mutableArray = [NSMutableArray array];
    if (![response[@"data"] isEqual:[NSNull null]]) {
        for (NSDictionary  *dic in response[@"data"]) {
            YSPMSPeopleInfoModel *model = [YSPMSPeopleInfoModel yy_modelWithJSON:dic];
            [mutableArray addObject:model];
        }
    }
    return [mutableArray copy];
}

+ (NSArray *)getPMSHistoryInfoData:(NSArray *)response {
    NSMutableArray *mutableArray = [NSMutableArray array];
    for (NSDictionary  *dic in response) {
        YSPMSHistoryInfoModel *model = [YSPMSHistoryInfoModel yy_modelWithJSON:dic];
        [mutableArray addObject:model];
    }
   
    return [mutableArray copy];
}

+ (NSArray *)getAddressData:(id)response {
    NSMutableArray *mutableArray = [NSMutableArray array];
    if (![response[@"data"] isEqual:[NSNull null]]) {
        for (NSDictionary  *dic in response[@"data"]) {
            YSPMSAddressModel *model = [YSPMSAddressModel yy_modelWithJSON:dic];
            [mutableArray addObject:model];
        }
    }
    return [mutableArray copy];
}

+ (NSArray *)getPMSFinanceData:(id)response {
    NSMutableArray *mutableArray = [NSMutableArray array];
    YSPMSFinanceInfoModel *model = [YSPMSFinanceInfoModel yy_modelWithJSON:response[@"data"]];
    [mutableArray addObject:model];
    return [mutableArray copy];
}


#pragma mark - 供应链

+ (NSArray *)getSupplyListData:(id)response {
    NSMutableArray *mutableArray = [NSMutableArray array];
    if (![response[@"data"] isEqual:[NSNull null]]) {
        for (NSDictionary *dic in response[@"data"]) {
            YSSupplyListModel *model = [YSSupplyListModel yy_modelWithJSON:dic];
            [mutableArray addObject:model];
        }
    }
    return [mutableArray copy];
}

+ (NSArray *)getSupplyDetailsData:(id)response {
    NSMutableArray *mutableArray = [NSMutableArray array];
    YSSupplyListModel *model = [YSSupplyListModel yy_modelWithJSON:response[@"data"]];
    [mutableArray addObject:model];
    return [mutableArray copy];
}

+ (NSArray *)getSupplyPersonListData:(id)response {
    NSMutableArray *mutableArray = [NSMutableArray array];
    if (![response[@"data"] isEqual:[NSNull null]]) {
        for (NSDictionary *dic in response[@"data"]) {
            YSSupplyPersonModel *model = [YSSupplyPersonModel yy_modelWithJSON:dic];
            [mutableArray addObject:model];
        }
    }
    return [mutableArray copy];
}

+ (NSArray *)getSupplyBankData:(id)response {
    NSMutableArray *mutableArray = [NSMutableArray array];
    if (![response[@"data"] isEqual:[NSNull null]]) {
        for (NSDictionary  *dic in response[@"data"]) {
            YSSupplyBankModel *model = [YSSupplyBankModel yy_modelWithJSON:dic];
            [mutableArray addObject:model];
        }
    }
    return [mutableArray copy];
}

+ (NSArray *)getSupplySupplierData:(id)response {
    NSMutableArray *mutableArray = [NSMutableArray array];
    if (![response[@"data"] isEqual:[NSNull null]]) {
        for (NSDictionary  *dic in response[@"data"]) {
            YSSupplySupplierModel *model = [YSSupplySupplierModel yy_modelWithJSON:dic];
            [mutableArray addObject:model];
        }
    }
    return [mutableArray copy];
}



#pragma mark - EMS

+ (NSArray *)getEMSMyTripListData:(id)response {
    NSMutableArray *mutableArray = [NSMutableArray array];
    if (![response[@"data"] isEqual:[NSNull null]]) {
        for (NSDictionary *dic in response[@"data"]) {
            YSEMSMyTripListModel *model = [YSEMSMyTripListModel yy_modelWithJSON:dic];
            [mutableArray addObject:model];
        }
    }
    return [mutableArray copy];
}

+ (NSArray *)getEMSProListData:(id)response {
    NSMutableArray *mutableArray = [NSMutableArray array];
    if (![response[@"data"] isEqual:[NSNull null]]) {
        for (NSDictionary *dic in response[@"data"]) {
            YSEMSProListModel *model = [YSEMSProListModel yy_modelWithJSON:dic];
            [mutableArray addObject:model];
        }
    }
    return [mutableArray copy];
}

+ (NSArray *)getMessageListData:(id)response {
    NSMutableArray *mutableArray = [NSMutableArray array];
    if (![response[@"data"] isEqual:[NSNull null]]) {
        for (NSDictionary *dic in response[@"data"]) {
            YSFlowListModel *model = [YSFlowListModel yy_modelWithJSON:dic];
            [mutableArray addObject:model];
        }
    }
    return [mutableArray copy];
}

+ (NSArray *)getReporedlistData:(id)response {
    NSMutableArray *mutableArray = [NSMutableArray array];
    for (NSDictionary *dic in response[@"data"]) {
        YSReporetModel *model = [YSReporetModel yy_modelWithJSON:dic];
        [mutableArray addObject:model];
    }
    return [mutableArray copy];
}
+ (NSArray *)getTrackinglistData:(id)response {
    NSMutableArray *mutableArray = [NSMutableArray array];
    for (NSDictionary *dic in response[@"data"]) {
        YSReporetModel *model = [YSReporetModel yy_modelWithJSON:dic[@"proReportInfo"]];
        [mutableArray addObject:model];
    }
    return [mutableArray copy];
}
+ (NSArray *)getReporedInfoData:(id)response {
    NSMutableArray *mutableArray = [NSMutableArray array];
    YSReporetModel *model = [YSReporetModel yy_modelWithJSON:response[@"data"]];
    [mutableArray addObject:model];
    return [mutableArray copy];
}



+(void)updateContactIDentPhone {
	[YSUtility checkCallDirectoryEnabledStatus:^(NSInteger enable) {
		if (enable == CXCallDirectoryEnabledStatusEnabled) {
			RLMResults *deleteResults = [YSIdentPhoneModel allObjects];
			if (deleteResults.count != 0) {
				RLMRealm *realm = [RLMRealm defaultRealm];
				[realm transactionWithBlock:^{
					[realm deleteObjects:deleteResults];
				}];
				DLog(@"数据库地址:%@", realm.configuration.fileURL);
			}
			CFAbsoluteTime startTime =CFAbsoluteTimeGetCurrent();
			RLMRealm *realm = [RLMRealm defaultRealm];
			[realm beginWriteTransaction];
			DLog(@"数据库地址:%@", realm.configuration.fileURL);
			//postStatus
			RLMResults *results = [[YSContactModel objectsWhere:@"isOrg = NO and postStatus = '1'"] sortedResultsUsingKeyPath:@"sortNo" ascending:YES];
			DLog(@"========%@==========%zd",results,results.count);
			//            [realm commitWriteTransaction];
			for (YSContactModel *model in results) {
				if (model.mobile.length == 11) {
					RLMResults *results = [YSIdentPhoneModel objectsWhere:[NSString stringWithFormat:@"phone == %zd", [[NSString stringWithFormat:@"%@%@",@"86",[model.mobile substringToIndex:11]] integerValue]]];
					if (results.count == 0) {
						YSIdentPhoneModel *identPhoneModel = [[YSIdentPhoneModel alloc]init];
						identPhoneModel.name = [NSString stringWithFormat:@"%@-%@",model.deptName,model.name];
						DLog(@"==========%@",model.mobile);
						identPhoneModel.phone = [[NSString stringWithFormat:@"%@%@",@"86",[model.mobile substringToIndex:11]] integerValue];
						[realm addObject:identPhoneModel];
					}
				}
				if (model.shortPhone.length == 6) {
					DLog(@"----------%@",model.shortPhone);
					DLog(@"----22222222------%@",model.name);
					RLMResults *results = [YSIdentPhoneModel objectsWhere:[NSString stringWithFormat:@"phone == %zd",[[model.shortPhone substringToIndex:6] integerValue]]];
					if (results.count == 0) {
						YSIdentPhoneModel *identPhoneModel = [[YSIdentPhoneModel alloc]init];
						identPhoneModel.name = [NSString stringWithFormat:@"%@-%@",model.deptName,model.name];
						identPhoneModel.phone = [[NSString stringWithFormat:@"%@",[model.shortPhone substringToIndex:6]] integerValue];
						if (![model.shortPhone isEqual:@"000000"]) {
							[realm addObject:identPhoneModel];
						}
					}
				}
				if (model.shortWorkPhone.length == 6) {
					RLMResults *results = [YSIdentPhoneModel objectsWhere:[NSString stringWithFormat:@"phone == %zd", [[NSString stringWithFormat:@"%@",[model.shortWorkPhone substringToIndex:6]]integerValue]]];
					if (results.count == 0) {
						YSIdentPhoneModel *identPhoneModel = [[YSIdentPhoneModel alloc]init];
						identPhoneModel.name = [NSString stringWithFormat:@"%@-%@",model.deptName,model.name];
						identPhoneModel.phone = [[NSString stringWithFormat:@"%@",[model.shortWorkPhone substringToIndex:6]] integerValue];
						[realm addObject:identPhoneModel];
					}
				}
				if (model.phone.length == 13) {
					RLMResults *results = [YSIdentPhoneModel objectsWhere:[NSString stringWithFormat:@"phone == %zd", [[NSString stringWithFormat:@"%@%@",@"86",[[model.phone substringFromIndex:1] stringByReplacingOccurrencesOfString:@"-" withString:@""]] integerValue]]];
					if (results.count == 0) {
						YSIdentPhoneModel *identPhoneModel = [[YSIdentPhoneModel alloc]init];
						identPhoneModel.name = [NSString stringWithFormat:@"%@-%@",model.deptName,model.name];
						identPhoneModel.phone = [[NSString stringWithFormat:@"%@%@",@"86",[[model.phone substringFromIndex:1] stringByReplacingOccurrencesOfString:@"-" withString:@""]] integerValue];
						[realm addObject:identPhoneModel];
					}
				}
			}
			[realm commitWriteTransaction];
			CFAbsoluteTime linkTime = (CFAbsoluteTimeGetCurrent() - startTime);
			
			NSLog(@"Linked in %f ms", linkTime *1000.0);
			
			DLog(@"数据库地址:%@", realm.configuration.fileURL);
			CXCallDirectoryManager *manager = [CXCallDirectoryManager sharedInstance];
			[manager reloadExtensionWithIdentifier:@"com.yasha.ys.YaSha-Call" completionHandler:^(NSError * _Nullable error) {
				dispatch_async(dispatch_get_main_queue(), ^{
					
					//						if (error) {
					//							DLog(@"弹屏数据更新失败:%@", error);
					//							[QMUITips showError:@"号码库更新失败" inView:self.view hideAfterDelay:1.5];
					//						} else {
					//							DLog(@"弹屏数据更新成功");
					//							[QMUITips showSucceed:@"号码库更新成功" inView:self.view hideAfterDelay:1.5];
					//						}
				});
			}];
		}
	}];
	
}

@end


