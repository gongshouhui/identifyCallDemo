//
//  YSFlowPMSContractInfoViewModel.m
//  YaSha-iOS
//
//  Created by 罗罗诺亚索隆 on 2019/3/21.
//  Copyright © 2019 亚厦装饰股份有限公司. All rights reserved.
//

#import "YSFlowPMSContractInfoViewModel.h"
#import "YSFLowMQContractInfoModel.h"
#import "YSFlowAttachmentViewController.h"
#import "YSFlowMQReplyController.h"
#import "YSFlowMQContractTipEditController.h"
@interface YSFlowPMSContractInfoViewModel()
@property (nonatomic,assign) MQFlowContractType flowContractType;
@property (nonatomic,strong) YSFLowMQContractInfoModel *contractModel;
@end
@implementation YSFlowPMSContractInfoViewModel
- (void)getFlowlistComplete:(fetchDataCompleteBlock)comleteBlock failue:(fetchDataFailueBlock)fetchFailueBlock {
    [YSNetManager ys_request_GETWithUrlString:[NSString stringWithFormat:@"%@%@/%@?taskId=%@",YSDomain,[self getContractUrl],self.flowModel.businessKey,self.flowModel.taskId] isNeedCache:NO parameters:nil successBlock:^(id response) {
        if ([response[@"code"] intValue] == 1) {
            self.flowFormModel = [YSFlowFormModel yy_modelWithJSON:response[@"data"]];
            self.contractModel = [YSFLowMQContractInfoModel yy_modelWithJSON:self.flowFormModel.info];
            [self setUpData];//重组数据
            //附件
            for (NSDictionary *dic in self.flowFormModel.info[@"mobileFiles"]) {
                YSNewsAttachmentModel *model = [YSNewsAttachmentModel yy_modelWithJSON:dic];
                [self.attachArray addObject:model];
            }
            if (self.attachArray.count > 0) {
                self.documentBtnTitle = [NSString stringWithFormat:@"关联文档(%lu)",(unsigned long)self.attachArray.count];
            }
            if (comleteBlock) {
                comleteBlock();
            }
        }else{
            if (fetchFailueBlock) {
                fetchFailueBlock(@"");//错误提示语由网络请求中心实现
            }
        }
    } failureBlock:^(NSError *error) {
        if (fetchFailueBlock) {
            fetchFailueBlock(@"");
        }
    } progress:nil];
}
- (void)setUpData {
    if ([self.flowModel.processDefinitionKey isEqualToString:@"pms_mq_contract_review"] || [self.flowModel.processDefinitionKey isEqualToString:@"pms_mq_supplement_contract_review"] || [self.flowModel.processDefinitionKey isEqualToString:@"pms_mq_supplement_contract_seal"] || [self.flowModel.processDefinitionKey isEqualToString:@"pms_mq_contract_seal"]) {//施工主合同及其协议(施工主合同分为评审和盖章，协议流程具体到评审和a盖章)
        [self setUpMainContractData];
        
    }
    
    if ([self.flowModel.processDefinitionKey containsString:@"construction"]) {//管理合同
        [self setUpConstructionContractData];
    }
    if ([self.flowModel.processDefinitionKey containsString:@"assessment"]) {//施工考核协议
        [self setUpAssessmentContractData];
    }
    if ([self.flowModel.processDefinitionKey containsString:@"record"]) {//备案合同
        [self setUpRecordContractData];
    }
    
    
}

/*
 主合同及其协议  评审和盖章流程
 pms_mq_contract_review
 pms_mq_contract_seal
 pms_mq_supplement_contract_review
 pms_mq_supplement_contract_seal
 管理合同及其协议  评审和盖章流程
 mqpms_construction_contract_review
 mqpms_construction_contract_seal
 mqpms_construction_contract_add_review
 mqpms_construction_contract_add_seal
 施工考核协议及其协议  评审和盖章流程
 mqpms_assessment_agreement_review
 mqpms_assessment_agreement_seal
 mqpms_assessment_agreement_add_review
 mqpms_assessment_agreement_add_seal
 备案合同及其协议  评审和盖章流程
 mqpms_record_contract_review
 mqpms_record_contract_seal
 mqpms_record_contract_add_review
 mqpms_record_contract_add_seal*/
- (NSString *)getContractUrl {
    if ([self.flowModel.processDefinitionKey hasPrefix:@"pms_mq"]) {
        self.flowContractType = MQFlowContractMain;
        return getMQContractInfo;
    }
    if ([self.flowModel.processDefinitionKey containsString:@"construction"]) {
        self.flowContractType = MQFlowContractConstruction;
        return getMQContractSupervisionInfo;
    }
    if ([self.flowModel.processDefinitionKey containsString:@"assessment"]) {
        self.flowContractType = MQFlowContractAssessment;
        return getMQContractCheckDealInfo;
    }
    if ([self.flowModel.processDefinitionKey containsString:@"record"]) {
        self.flowContractType = MQFlowContractRecord;
        return getMQContractFilingInfo;
    }
    return nil;
    
}

#pragma mark - 设置主合同数据
- (void)setUpMainContractData {
    [self.dataSourceArray addObject:@{@"title":@"基本信息",@"special":@(BussinessFlowCellHead)}];
    switch (self.contractModel.contractInfo.contractType) {
        case MQContractTypeMain:
            [self.dataSourceArray addObject:@{@"title":@"施工主合同编码" ,@"content":self.contractModel.contractInfo.masterContractCode}];
            [self.dataSourceArray addObject:@{@"title":@"主合同名称" ,@"content":self.contractModel.contractInfo.contractName}];
            break;
            
        default:
            [self.dataSourceArray addObject:@{@"title":@"补充协议编码" ,@"content":self.contractModel.contractInfo.sideLetterCode}];
            [self.dataSourceArray addObject:@{@"title":@"补充协议名称" ,@"content":self.contractModel.contractInfo.sideLetterName}];
            break;
    }
    [self.dataSourceArray addObject:@{@"title":@"合同金额(元)" ,@"content":[YSUtility thousandsFormat:self.contractModel.contractInfo.contPrice]}];
    NSString *contractDuration = nil;
    if (self.contractModel.contractInfo.contractDuration) {
        contractDuration = [NSString stringWithFormat:@"%ld",self.contractModel.contractInfo.contractDuration];
    }else{
        
    }
    [self.dataSourceArray addObject:@{@"title":@"合同工期(天)" ,@"content":contractDuration}];
    [self.dataSourceArray addObject:@{@"title":@"工程地址" ,@"content":self.contractModel.contractInfo.address}];
    [self.dataSourceArray addObject:@{@"title":@"签订单位" ,@"content":self.contractModel.contractInfo.signedUnit}];
    
    [self.dataSourceArray addObject:@{@"title":@"签订单位联系人" ,@"content":self.contractModel.contractInfo.signedContact}];
    [self.dataSourceArray addObject:@{@"title":@"签订单位联系方式" ,@"content":self.contractModel.contractInfo.signedUnitContact}];
    
    [self.dataSourceArray addObject:@{@"title":@"业务承接人" ,@"content":self.contractModel.contractManagement.undertakerName}];
    [self.dataSourceArray addObject:@{@"title":@"合同项目经理" ,@"content":self.contractModel.contractManagement.contractPm}];
    [self.dataSourceArray addObject:@{@"title":@"异常付款情况" ,@"content":self.contractModel.contractInfo.abnormalPayment}];
    [self.dataSourceArray addObject:@{@"title":@"预付款(%)" ,@"content":self.contractModel.contractInfo.advance}];
    [self.dataSourceArray addObject:@{@"title":@"履约担保保函(%)" ,@"content":self.contractModel.contractInfo.ensureBackletter}];
    
    [self.dataSourceArray addObject:@{@"title":@"履约担保保函(%)" ,@"content":self.contractModel.contractInfo.ensureCash}];
    [self.dataSourceArray addObject:@{@"title":@"盖章用印名称" ,@"content":self.contractModel.contractManagement.sealName}];
    
    [self.dataSourceArray addObject:@{@"title":@"付款条件完整表述" ,@"content":self.contractModel.contractInfo.paymentDescription}];
    [self.dataSourceArray addObject:@{@"title":@"质量要求" ,@"content":self.contractModel.contractInfo.qualityRequirements}];
    [self.dataSourceArray addObject:@{@"title":@"备注" ,@"content":self.contractModel.contractManagement.remark}];
    
    if ([self.flowModel.processDefinitionKey isEqualToString:@"pms_mq_contract_review"] || [self.flowModel.processDefinitionKey isEqualToString:@"pms_mq_supplement_contract_review"]) {//主合同评审和补充协议评审
        [self.dataSourceArray addObject:@{@"title":@"评审资料" ,@"special":@(BussinessFlowCellTurn),@"content":[NSString stringWithFormat:@"%ld",self.contractModel.contractManagement.crmdFileListForMobile.count],@"file":self.contractModel.contractManagement.crmdFileListForMobile}];
        
        switch (self.flowType) {
            case YSFlowTypeTodo:
                //评审有定稿h回复节点
                if (self.contractModel.isPersonelEdit) {
                    [self.dataSourceArray addObject:@{@"title":@"定稿回复",@"special":@(BussinessFlowCellHead)}];
					[self.dataSourceArray addObject:@{@"title":@"评审意见定稿回复",@"special":@(BussinessFlowCellTurn),@"content":[NSString stringWithFormat:@"%ld",self.contractModel.contractManagement.contentList.count],@"file":self.contractModel.contractManagement.contentList}];
                    [self.dataSourceArray addObject:@{@"title":@"总结与风险提示",@"special":@(BussinessFlowCellEdit)}];
                    if (self.contractModel.contractManagement.reviewRemark.length) {
                        [self.dataSourceArray addObject:@{@"content":self.contractModel.contractManagement.reviewRemark,@"special":@(BussinessFlowCellText)}];
                    }
                }else{//待办没有权限
                    
                }
                break;
                
            default://或已办、已发
                [self.dataSourceArray addObject:@{@"title":@"定稿回复",@"special":@(BussinessFlowCellHead)}];
                [self.dataSourceArray addObject:@{@"title":@"评审意见定稿回复",@"special":@(BussinessFlowCellTurn),@"content":[NSString stringWithFormat:@"%ld",self.contractModel.contractManagement.contentList.count],@"file":self.contractModel.contractManagement.contentList}];
                
                [self.dataSourceArray addObject:@{@"title":@"总结与风险提示"}];
                if (self.contractModel.contractManagement.reviewRemark.length) {
                    [self.dataSourceArray addObject:@{@"content":self.contractModel.contractManagement.reviewRemark,@"special":@(BussinessFlowCellText)}];
                }
                break;
        }
        
        
        
    }else{//盖章  盖章资料不同
        [self.dataSourceArray addObject:@{@"title":@"盖章资料" ,@"special":@(BussinessFlowCellTurn),@"content":[NSString stringWithFormat:@"%ld",self.contractModel.contractInfo.sealMaterialsForMobile.count],@"file":self.contractModel.contractInfo.sealMaterialsForMobile}];
    }
}
#pragma mark - 管理合同数据
/*设置管理合同数据 mqpms_construction_contract_review
 mqpms_construction_contract_seal
 mqpms_construction_contract_add_review
 mqpms_construction_contract_add_seal*/
- (void)setUpConstructionContractData {
    [self.dataSourceArray addObject:@{@"title":@"合同信息",@"special":@(BussinessFlowCellHead)}];
    [self.dataSourceArray addObject:@{@"title":@"项目名称" ,@"content":self.contractModel.contractSupervision.projectName}];
    [self.dataSourceArray addObject:@{@"title":@"执行经理" ,@"content":self.contractModel.contractSupervision.executiveManagerName}];
    [self.dataSourceArray addObject:@{@"title":@"项目性质" ,@"content":self.contractModel.contractSupervision.proNature}];
    [self.dataSourceArray addObject:@{@"title":@"主合同号" ,@"content":self.contractModel.contractSupervision.masterContractNo}];
    if ([self.flowModel.processDefinitionKey containsString:@"add"]) {//补充协议
        [self.dataSourceArray addObject:@{@"title":@"补充协议合同编码" ,@"content":self.contractModel.contractSupervision.sideLetterCode}];
        [self.dataSourceArray addObject:@{@"title":@"补充协议合同名称" ,@"content":self.contractModel.contractSupervision.sideLetterName}];
    }else{//管理合同
        [self.dataSourceArray addObject:@{@"title":@"合同编码" ,@"content":self.contractModel.contractSupervision.contractNo}];
        [self.dataSourceArray addObject:@{@"title":@"合同名称" ,@"content":self.contractModel.contractSupervision.contractName}];
    }
    [self.dataSourceArray addObject:@{@"title":@"合同类型" ,@"content":self.contractModel.contractSupervision.contractTypeStr}];
    [self.dataSourceArray addObject:@{@"title":@"签订单位" ,@"content":self.contractModel.contractSupervision.signedUnit}];
    [self.dataSourceArray addObject:@{@"title":@"签订状态" ,@"content":self.contractModel.contractSupervision.signedState}];
    if ([self.flowModel.processDefinitionKey containsString:@"add"]) {//补充协议
        [self.dataSourceArray addObject:@{@"title":@"补充协议合同金额(元)" ,@"content":[YSUtility thousandsFormat:self.contractModel.contractSupervision.contPrice]}];
        [self.dataSourceArray addObject:@{@"title":@"补充协议支付方式" ,@"content":self.contractModel.contractSupervision.payment}];
        [self.dataSourceArray addObject:@{@"title":@"补充协议合同重要信息" ,@"content":self.contractModel.contractSupervision.contractMatterInfo}];
        [self.dataSourceArray addObject:@{@"title":@"补充协议备注" ,@"content":self.contractModel.contractSupervision.remark}];
        
    }else{//管理合同
        [self.dataSourceArray addObject:@{@"title":@"合同金额(元)" ,@"content":[YSUtility thousandsFormat:self.contractModel.contractSupervision.contPrice]}];
        [self.dataSourceArray addObject:@{@"title":@"支付方式" ,@"content":self.contractModel.contractSupervision.payment}];
        [self.dataSourceArray addObject:@{@"title":@"合同重要信息" ,@"content":self.contractModel.contractSupervision.contractMatterInfo}];
        [self.dataSourceArray addObject:@{@"title":@"备注" ,@"content":self.contractModel.contractSupervision.remark}];
    }
    
    
    
    if ([self.flowModel.processDefinitionKey containsString:@"review"]) {//评审和补充协议评审
        [self.dataSourceArray addObject:@{@"title":@"评审资料" ,@"special":@(BussinessFlowCellTurn),@"content":[NSString stringWithFormat:@"%ld",self.contractModel.contractSupervision.filePszlListForMobile.count],@"file":self.contractModel.contractSupervision.filePszlListForMobile}];
        [self.dataSourceArray addObject:@{@"title":@"参考资料" ,@"special":@(BussinessFlowCellTurn),@"content":[NSString stringWithFormat:@"%ld",self.contractModel.contractSupervision.fileQtzlListForMobile.count],@"file":self.contractModel.contractSupervision.fileQtzlListForMobile}];
        
        
        switch (self.flowType) {
            case YSFlowTypeTodo:
                //评审有定稿h回复节点
                if (self.contractModel.isPersonelEdit) {
                    [self.dataSourceArray addObject:@{@"title":@"定稿回复",@"special":@(BussinessFlowCellHead)}];
                    [self.dataSourceArray addObject:@{@"title":@"评审意见定稿回复",@"special":@(BussinessFlowCellTurn),@"content":[NSString stringWithFormat:@"%ld",self.contractModel.reviewContentList.count],@"file":self.contractModel.reviewContentList}];
                    [self.dataSourceArray addObject:@{@"title":@"总结与风险提示",@"special":@(BussinessFlowCellEdit)}];
                    if (self.contractModel.contractSupervision.reviewRemark.length) {
                        [self.dataSourceArray addObject:@{@"content":self.contractModel.contractSupervision.reviewRemark,@"special":@(BussinessFlowCellText)}];
                    }
                }else{//待办没有权限
                    
                }
                break;
                
            default://或已办、已发
                [self.dataSourceArray addObject:@{@"title":@"定稿回复",@"special":@(BussinessFlowCellHead)}];
                [self.dataSourceArray addObject:@{@"title":@"评审意见定稿回复",@"special":@(BussinessFlowCellTurn),@"content":[NSString stringWithFormat:@"%ld",self.contractModel.reviewContentList.count],@"file":self.contractModel.reviewContentList}];
                
                [self.dataSourceArray addObject:@{@"title":@"总结与风险提示"}];
                if (self.contractModel.contractSupervision.reviewRemark.length) {
                    [self.dataSourceArray addObject:@{@"content":self.contractModel.contractSupervision.reviewRemark,@"special":@(BussinessFlowCellText)}];
                }
                break;
        }
        
        
        
    }else{//盖章  盖章资料不同
        [self.dataSourceArray addObject:@{@"title":@"盖章资料" ,@"special":@(BussinessFlowCellTurn),@"content":[NSString stringWithFormat:@"%ld",self.contractModel.contractSealMaterial.count],@"file":self.contractModel.contractSealMaterial}];
    }
}
#pragma mark - 设置施工考核协议 
- (void)setUpAssessmentContractData {
    [self.dataSourceArray addObject:@{@"title":@"合同信息",@"special":@(BussinessFlowCellHead)}];
    [self.dataSourceArray addObject:@{@"title":@"项目名称" ,@"content":self.contractModel.contractCheckDeal.projectName}];
    [self.dataSourceArray addObject:@{@"title":@"执行经理" ,@"content":self.contractModel.contractCheckDeal.executiveManagerName}];
    [self.dataSourceArray addObject:@{@"title":@"项目性质" ,@"content":self.contractModel.contractCheckDeal.proNature}];
    [self.dataSourceArray addObject:@{@"title":@"主合同号" ,@"content":self.contractModel.contractCheckDeal.masterContractNo}];
    if ([self.flowModel.processDefinitionKey containsString:@"add"]) {//补充协议
        [self.dataSourceArray addObject:@{@"title":@"补充协议合同编码" ,@"content":self.contractModel.contractCheckDeal.sideLetterCode}];
        [self.dataSourceArray addObject:@{@"title":@"补充协议合同名称" ,@"content":self.contractModel.contractCheckDeal.sideLetterName}];
    }else{//
        [self.dataSourceArray addObject:@{@"title":@"合同编码" ,@"content":self.contractModel.contractCheckDeal.contractNo}];
        [self.dataSourceArray addObject:@{@"title":@"合同名称" ,@"content":self.contractModel.contractCheckDeal.contractName}];
    }
    [self.dataSourceArray addObject:@{@"title":@"合同类型" ,@"content":self.contractModel.contractCheckDeal.contractTypeStr}];
    [self.dataSourceArray addObject:@{@"title":@"签订状态" ,@"content":self.contractModel.contractCheckDeal.signedState}];
    [self.dataSourceArray addObject:@{@"title":@"考核责任人" ,@"content":self.contractModel.contractCheckDeal.checkDutyPersonName}];
    [self.dataSourceArray addObject:@{@"title":@"考核责任人联络方式" ,@"content":self.contractModel.contractCheckDeal.checkDutyPersonContact}];
    //主合同金额(元)
    [self.dataSourceArray addObject:@{@"title":@"主合同金额(元)" ,@"content":[YSUtility thousandsFormat:self.contractModel.contractCheckDeal.masterContractPrice]}];
    [self.dataSourceArray addObject:@{@"title":@"净管理率(%)" ,@"content":[NSString stringWithFormat:@"%.0f",self.contractModel.contractCheckDeal.netManagementRate]}];
    [self.dataSourceArray addObject:@{@"title":@"合同金额(元)" ,@"content":[YSUtility thousandsFormat:self.contractModel.contractCheckDeal.contPrice]}];
    [self.dataSourceArray addObject:@{@"title":@"备注" ,@"content":self.contractModel.contractCheckDeal.remark}];
    
    if ([self.flowModel.processDefinitionKey containsString:@"review"]) {//评审和补充协议评审阶段
        [self.dataSourceArray addObject:@{@"title":@"评审资料" ,@"special":@(BussinessFlowCellTurn),@"content":[NSString stringWithFormat:@"%ld",self.contractModel.psFileListForMobile.count],@"file":self.contractModel.psFileListForMobile}];
        [self.dataSourceArray addObject:@{@"title":@"参考资料" ,@"special":@(BussinessFlowCellTurn),@"content":[NSString stringWithFormat:@"%ld",self.contractModel.qtzlFileListForMobile.count],@"file":self.contractModel.qtzlFileListForMobile}];
        
        
        switch (self.flowType) {
            case YSFlowTypeTodo:
                //评审有定稿h回复节点
                if (self.contractModel.isPersonelEdit) {
                    [self.dataSourceArray addObject:@{@"title":@"定稿回复",@"special":@(BussinessFlowCellHead)}];
                    [self.dataSourceArray addObject:@{@"title":@"评审意见定稿回复",@"special":@(BussinessFlowCellTurn),@"content":[NSString stringWithFormat:@"%ld",self.contractModel.reviewContentList.count],@"file":self.contractModel.reviewContentList}];
                    [self.dataSourceArray addObject:@{@"title":@"总结与风险提示",@"special":@(BussinessFlowCellEdit)}];
                    if (self.contractModel.contractCheckDeal.reviewRemark.length) {
                        [self.dataSourceArray addObject:@{@"content":self.contractModel.contractCheckDeal.reviewRemark,@"special":@(BussinessFlowCellText)}];
                    }
                }else{//待办没有权限
                    
                }
                break;
                
            default://或已办、已发
                [self.dataSourceArray addObject:@{@"title":@"定稿回复",@"special":@(BussinessFlowCellHead)}];
                [self.dataSourceArray addObject:@{@"title":@"评审意见定稿回复",@"special":@(BussinessFlowCellTurn),@"content":[NSString stringWithFormat:@"%ld",self.contractModel.reviewContentList.count],@"file":self.contractModel.reviewContentList}];
                
                [self.dataSourceArray addObject:@{@"title":@"总结与风险提示"}];
                if (self.contractModel.contractCheckDeal.reviewRemark.length) {
                    [self.dataSourceArray addObject:@{@"content":self.contractModel.contractCheckDeal.reviewRemark,@"special":@(BussinessFlowCellText)}];
                }
                break;
        }
        
        
        
    }else{//盖章  盖章资料不同
        [self.dataSourceArray addObject:@{@"title":@"盖章资料" ,@"special":@(BussinessFlowCellTurn),@"content":[NSString stringWithFormat:@"%ld",self.contractModel.contractSealMaterial.count],@"file":self.contractModel.contractSealMaterial}];
    }
      [self.dataSourceArray addObject:@{@"title":@"支付信息",@"special":@(BussinessFlowCellHead)}];
    for (YSFLowMQCheckPayInfo *model in self.contractModel.contractLoaningList) {
        [self.dataSourceArray addObject:@{@"title":@"税金承租" ,@"content":model.content}];
        [self.dataSourceArray addObject:@{@"title":@"执行经理履约保证金(元)" ,@"content":self.contractModel.contractCheckDeal.signedState}];
        [self.dataSourceArray addObject:@{@"title":@"是否预付款" ,@"content":self.contractModel.contractCheckDeal.checkDutyPersonName}];
        [self.dataSourceArray addObject:@{@"title":@"履约保证金或保函(元)" ,@"content":self.contractModel.contractCheckDeal.checkDutyPersonContact}];
        [self.dataSourceArray addObject:@{@"title":@"投标保证金(元)" ,@"content":self.contractModel.contractCheckDeal.checkDutyPersonName}];
        [self.dataSourceArray addObject:@{@"title":@"现金比例(%)" ,@"content":self.contractModel.contractCheckDeal.checkDutyPersonContact}];
        [self.dataSourceArray addObject:@{@"title":@"是否需要公司垫资或借款" ,@"content":self.contractModel.contractCheckDeal.checkDutyPersonContact}];
        [self.dataSourceArray addObject:@{@"title":@"垫资或借款说明" ,@"content":model.content}];
        [self.dataSourceArray addObject:@{@"title":@"垫资或借款提交日期" ,@"content":model.createTime}];
    }
   
}

#pragma mark - 备案合同协议
- (void)setUpRecordContractData {
    [self.dataSourceArray addObject:@{@"title":@"合同信息",@"special":@(BussinessFlowCellHead)}];
    if ([self.flowModel.processDefinitionKey containsString:@"add"]) {//补充协议
        [self.dataSourceArray addObject:@{@"title":@"补充协议合同编码" ,@"content":self.contractModel.contractFiling.sideLetterCode}];
        [self.dataSourceArray addObject:@{@"title":@"补充协议合同名称" ,@"content":self.contractModel.contractFiling.sideLetterName}];
    }else{//
        [self.dataSourceArray addObject:@{@"title":@"合同编码" ,@"content":self.contractModel.contractFiling.contractNo}];
        [self.dataSourceArray addObject:@{@"title":@"合同名称" ,@"content":self.contractModel.contractFiling.contractName}];
    }
   
    [self.dataSourceArray addObject:@{@"title":@"签订状态" ,@"content":self.contractModel.contractFiling.signedState}];
    if ([self.flowModel.processDefinitionKey containsString:@"add"]) {//补充协议
        [self.dataSourceArray addObject:@{@"title":@"补充协议建设方" ,@"content":self.contractModel.contractFiling.buildingSide}];
        [self.dataSourceArray addObject:@{@"title":@"补充协议签订单位" ,@"content":self.contractModel.contractFiling.signedUnit}];
        [self.dataSourceArray addObject:@{@"title":@"补充协议合同金额(元)" ,@"content":[YSUtility thousandsFormat:self.contractModel.contractFiling.contPrice]}];
    }else{//备案合同
        [self.dataSourceArray addObject:@{@"title":@"建设方" ,@"content":self.contractModel.contractFiling.buildingSide}];
        [self.dataSourceArray addObject:@{@"title":@"签订单位" ,@"content":self.contractModel.contractFiling.signedUnit}];
         [self.dataSourceArray addObject:@{@"title":@"合同金额(元)" ,@"content":[YSUtility thousandsFormat:self.contractModel.contractFiling.contPrice]}];
    }
    
    [self.dataSourceArray addObject:@{@"title":@"合同开工日期" ,@"content":self.contractModel.contractFiling.contractStartDate}];
    [self.dataSourceArray addObject:@{@"title":@"合同竣工日期" ,@"content":self.contractModel.contractFiling.contractEndDate}];
    [self.dataSourceArray addObject:@{@"title":@"合同工期" ,@"content":[NSString stringWithFormat:@"%ld",self.contractModel.contractCheckDeal.contractLimit]}];
    [self.dataSourceArray addObject:@{@"title":@"主合同结算方式" ,@"content":self.contractModel.contractCheckDeal.mainContractSettleManner}];
    if ([self.flowModel.processDefinitionKey containsString:@"add"]) {//补充协议
        [self.dataSourceArray addObject:@{@"title":@"备案合同补充协议结算方式" ,@"content":self.contractModel.contractFiling.filingContractSettleManner}];
        [self.dataSourceArray addObject:@{@"title":@"补充协议备注" ,@"content":self.contractModel.contractFiling.remark}];
    }else{//备案合同
        [self.dataSourceArray addObject:@{@"title":@"备案合同结算方式" ,@"content":self.contractModel.contractFiling.filingContractSettleManner}];
        [self.dataSourceArray addObject:@{@"title":@"备注" ,@"content":self.contractModel.contractFiling.remark}];
        [self.dataSourceArray addObject:@{@"title":@"合同金额(元)" ,@"content":[YSUtility thousandsFormat:self.contractModel.contractFiling.contPrice]}];
    }
    
    if ([self.flowModel.processDefinitionKey containsString:@"review"]) {//评审和补充协议评审阶段
        [self.dataSourceArray addObject:@{@"title":@"评审资料" ,@"special":@(BussinessFlowCellTurn),@"content":[NSString stringWithFormat:@"%ld",self.contractModel.psFileListForMobile.count],@"file":self.contractModel.psFileListForMobile}];
        [self.dataSourceArray addObject:@{@"title":@"参考资料" ,@"special":@(BussinessFlowCellTurn),@"content":[NSString stringWithFormat:@"%ld",self.contractModel.qtzlFileListForMobile.count],@"file":self.contractModel.qtzlFileListForMobile}];
        
        
        switch (self.flowType) {
            case YSFlowTypeTodo:
                //评审有定稿h回复节点
                if (self.contractModel.isPersonelEdit) {
                    [self.dataSourceArray addObject:@{@"title":@"定稿回复",@"special":@(BussinessFlowCellHead)}];
                    [self.dataSourceArray addObject:@{@"title":@"评审意见定稿回复",@"special":@(BussinessFlowCellTurn),@"content":[NSString stringWithFormat:@"%ld",self.contractModel.reviewContentList.count],@"file":self.contractModel.reviewContentList}];
                    [self.dataSourceArray addObject:@{@"title":@"总结与风险提示",@"special":@(BussinessFlowCellEdit)}];
                    if (self.contractModel.contractCheckDeal.reviewRemark.length) {
                        [self.dataSourceArray addObject:@{@"content":self.contractModel.contractCheckDeal.reviewRemark,@"special":@(BussinessFlowCellText)}];
                    }
                }else{//待办没有权限
                    
                }
                break;
                
            default://或已办、已发
                [self.dataSourceArray addObject:@{@"title":@"定稿回复",@"special":@(BussinessFlowCellHead)}];
                [self.dataSourceArray addObject:@{@"title":@"评审意见定稿回复",@"special":@(BussinessFlowCellTurn),@"content":[NSString stringWithFormat:@"%ld",self.contractModel.reviewContentList.count],@"file":self.contractModel.reviewContentList}];
                
                [self.dataSourceArray addObject:@{@"title":@"总结与风险提示"}];
                if (self.contractModel.contractCheckDeal.reviewRemark.length) {
                    [self.dataSourceArray addObject:@{@"content":self.contractModel.contractCheckDeal.reviewRemark,@"special":@(BussinessFlowCellText)}];
                }
                break;
        }
        
        
        
    }else{//盖章  盖章资料不同
        [self.dataSourceArray addObject:@{@"title":@"盖章资料" ,@"special":@(BussinessFlowCellTurn),@"content":[NSString stringWithFormat:@"%ld",self.contractModel.contractSealMaterial.count],@"file":self.contractModel.contractSealMaterial}];
    }
}

- (void)turnOtherViewControllerWith:(UIViewController *)viewController andIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *cellDic = self.dataSourceArray[indexPath.row];
    if ([cellDic[@"title"] isEqualToString:@"评审资料"] || [cellDic[@"title"] isEqualToString:@"盖章资料"] || [cellDic[@"title"] isEqualToString:@"参考资料"]) {//附件
        YSFlowAttachmentViewController *vc = [[YSFlowAttachmentViewController alloc]init];
        vc.naviTitle = cellDic[@"title"];
        vc.attachMentArray = cellDic[@"file"];
        if ([cellDic[@"file"] count]) {
            [viewController.navigationController pushViewController:vc animated:YES];
        }else{
            [QMUITips showInfo:[NSString stringWithFormat:@"暂无%@",cellDic[@"title"]] inView:viewController.view hideAfterDelay:1.5];
        }
        
    }
    if ([cellDic[@"title"] isEqualToString:@"评审意见定稿回复"]) {//附件
        NSArray *fileArray = cellDic[@"file"];
        if (fileArray.count) {
            YSFlowMQReplyController *vc = [[YSFlowMQReplyController alloc]init];
            vc.replyArray = fileArray;
            [viewController.navigationController pushViewController:vc animated:YES];
        }else{
            [QMUITips showInfo:[NSString stringWithFormat:@"暂无%@",cellDic[@"title"]] inView:viewController.view hideAfterDelay:1.5];
        }
        
    }
    if ([cellDic[@"special"] integerValue] == BussinessFlowCellEdit ) {//修改
        YSFlowMQContractTipEditController *vc = [[YSFlowMQContractTipEditController alloc]init];
        switch (self.flowContractType) {
            case MQFlowContractMain:
            {
                vc.content = self.contractModel.contractManagement.reviewRemark;
                vc.contractId = self.contractModel.contractManagement.contractId;
                vc.opt = @"123";
                vc.editBlock = ^(NSString * _Nonnull editContent) {
                    self.reviewRemark = editContent;
                    NSDictionary *dic = @{@"content":editContent,@"special":@(BussinessFlowCellText)};
                    if (self.contractModel.contractManagement.reviewRemark) {
                        
                        [self.dataSourceArray replaceObjectAtIndex:indexPath.row + 1 withObject:dic];
                    }else{
                        [self.dataSourceArray insertObject:dic atIndex:indexPath.row +1];
                    }
                    self.contractModel.contractManagement.reviewRemark = editContent;
                };
            }
                break;
                case MQFlowContractConstruction:
            {
                vc.content = self.contractModel.contractSupervision.reviewRemark;
                vc.contractId = self.contractModel.contractSupervision.contractId;
                vc.opt = @"1";
                vc.editBlock = ^(NSString * _Nonnull editContent) {
                    self.reviewRemark = editContent;
                    NSDictionary *dic = @{@"content":editContent,@"special":@(BussinessFlowCellText)};
                    if (self.contractModel.contractSupervision.reviewRemark) {
                        
                        [self.dataSourceArray replaceObjectAtIndex:indexPath.row + 1 withObject:dic];
                    }else{
                        [self.dataSourceArray insertObject:dic atIndex:indexPath.row +1];
                    }
                    self.contractModel.contractSupervision.reviewRemark = editContent;
                };
            }
                break;
            default:
                break;
        }
        
        [viewController.navigationController pushViewController:vc animated:YES];
    }
    
    
    
}
@end
