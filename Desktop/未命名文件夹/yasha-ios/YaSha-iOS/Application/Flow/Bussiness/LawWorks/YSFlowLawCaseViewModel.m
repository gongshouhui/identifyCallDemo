//
//  YSFlowLawCaseViewModel.m
//  YaSha-iOS
//
//  Created by 罗罗诺亚索隆 on 2019/3/7.
//  Copyright © 2019 亚厦装饰股份有限公司. All rights reserved.
//

#import "YSFlowLawCaseViewModel.h"
#import "YSFlowLawDepartDetailViewController.h"
#import "YSLawDepartModel.h"
#import "YSFlowDepartEditController.h"
#import "YSFlowMultiDepartEditController.h"
#import "YSMultiDepartEditViewModel.h"
@interface YSFlowLawCaseViewModel()
@property (nonatomic,strong) YSLawDepartModel *owerDepart;
@end
@implementation YSFlowLawCaseViewModel
- (void)getFlowlistComplete:(fetchDataCompleteBlock)comleteBlock failue:(fetchDataFailueBlock)fetchFailueBlock {
    [YSNetManager ys_request_GETWithUrlString:[NSString stringWithFormat:@"%@%@/%@?taskId=%@",YSDomain,getLawsuitInfo,self.flowModel.businessKey,self.flowModel.taskId] isNeedCache:NO parameters:nil successBlock:^(id response) {
        if ([response[@"code"] integerValue] == 1) {
            self.flowFormModel = [YSFlowFormModel yy_modelWithJSON:response[@"data"]];
            
            [self setUpData:self.flowFormModel.info];
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
        
    } progress:nil];
}
- (void)turnOtherViewControllerWith:(UIViewController *)viewController andIndexPath:(NSIndexPath *)indexPath{
    NSDictionary *dic = self.dataSourceArray[indexPath.row];
    if ([dic[@"special"] integerValue] == BussinessFlowCellTurn) {
        if (self.caseModel.lawsuitEdit && self.flowType == YSFlowTypeTodo) {//法务部人员可编辑全部部门
            YSMultiDepartEditViewModel *multiVM = [[YSMultiDepartEditViewModel alloc]init];
            multiVM.departArray = self.caseModel.lawsuitDeptList;
        multiVM.bussinessKey = self.flowModel.businessKey;
            
            YSFlowMultiDepartEditController *vc = [[YSFlowMultiDepartEditController alloc]initWithViewModel:multiVM];
             [viewController.navigationController pushViewController:vc animated:YES];
            
            
        }else{//普通查看详情
            YSFlowLawDepartDetailViewController *vc = [[YSFlowLawDepartDetailViewController alloc]init];
            vc.departArr = [self.caseModel.lawsuitDeptList copy];
            [viewController.navigationController pushViewController:vc animated:YES];
        }
       
    }
    
    if ([dic[@"special"] integerValue] == BussinessFlowCellEdit) {
        YSFlowDepartEditController *vc = [[YSFlowDepartEditController alloc]init];
        vc.bussinessKey = self.flowModel.businessKey;
        vc.departModel = self.owerDepart;
        [viewController.navigationController pushViewController:vc animated:YES];
        
    }
    
}
- (void)setUpData:(NSDictionary *)dic {
    NSMutableArray *infoArray = [NSMutableArray array];
    self.caseModel = [YSLawCaseModel yy_modelWithJSON:dic];
    [infoArray addObject:@{@"title":@"基本信息",@"special":@(BussinessFlowCellHead)}];
   [infoArray addObject:@{@"title":@"原告（申请人)",@"content":self.caseModel.prosecutionPerson}];
    [infoArray addObject:@{@"title":@"被告（申请人）" ,@"content":self.caseModel.defense}];
    [infoArray addObject:@{@"title":@"第三人" ,@"content":self.caseModel.thirdPerson}];
    [infoArray addObject:@{@"title":@"审级" ,@"content":self.caseModel.trialStr}];
    [infoArray addObject:@{@"title":@"诉讼类型" ,@"content":self.caseModel.litigationTypeStr}];
    [infoArray addObject:@{@"title":@"案号" ,@"content":self.caseModel.causeNo}];
    [infoArray addObject:@{@"title":@"受理法院/仲裁" ,@"content":self.caseModel.court}];
    [infoArray addObject:@{@"title":@"案由" ,@"content":self.caseModel.causeOfAction }];
    [infoArray addObject:@{@"title":@"开庭时间" ,@"content":[YSUtility timestampSwitchTime:self.caseModel.courtDate andFormatter:@"yyyy-MM-dd"]}];
    [infoArray addObject:@{@"title":@"所属公司",@"content":self.caseModel.buessyTypeStr}];
    [infoArray addObject:@{@"title":@"案件性质" ,@"content":self.caseModel.natureCaseStr}];
    NSString *projecttType;
    if ([self.caseModel.buessyType isEqualToString:@"194"]) {//装饰项目类型
        projecttType = self.caseModel.decorateTypeStr;
    }else if ([self.caseModel.buessyType isEqualToString:@"196"]){//机电项目类型
        projecttType = self.caseModel.electricalTypeStr;
        
    }else if ([self.caseModel.buessyType isEqualToString:@"195"]){//幕墙项目类型
        projecttType = self.caseModel.curtainTypeStr;
    }else{
       
    }
    [infoArray addObject:@{@"title":[NSString stringWithFormat:@"%@项目类型",self.caseModel.buessyTypeStr],@"content":projecttType}];
    
    [infoArray addObject:@{@"title":@"其他类说明" ,@"content":self.caseModel.explainOther}];
    [infoArray addObject:@{@"title":@"案件承办人员" ,@"content":self.caseModel.lawsuitPerson}];
    [infoArray addObject:@{@"title":@"联系方式" ,@"content":self.caseModel.phone}];
    [infoArray addObject:@{@"title":@"涉案部门" ,@"content":self.caseModel.involvedDept}];
    //工程信息
    [infoArray addObject:@{@"title":@"工程信息",@"special":@(BussinessFlowCellHead)}];
    [infoArray addObject:@{@"title":@"项目名称" ,@"content":self.caseModel.projectName}];
    [infoArray addObject:@{@"title":@"项目开工时间" ,@"content":[YSUtility timestampSwitchTime:self.caseModel.proStartDate andFormatter:@"yyyy-MM-dd"]}];
    [infoArray addObject:@{@"title":@"项目竣工时间" ,@"content":[YSUtility timestampSwitchTime:self.caseModel.proEndDate andFormatter:@"yyyy-MM-dd"]}];
    [infoArray addObject:@{@"title":@"项目经理" ,@"content":self.caseModel.manager}];
    [infoArray addObject:@{@"title":@"联系方式" ,@"content":self.caseModel.contact}];
    [infoArray addObject:@{@"title":@"合同金额" ,@"content":[NSString stringWithFormat:@"%.2f",self.caseModel.contractAmount]}];
    //案件信息
    [infoArray addObject:@{@"title":@"案件信息",@"special":@(BussinessFlowCellHead)}];
    [infoArray addObject:@{@"title":@"诉讼金额-本金" ,@"content":[NSString stringWithFormat:@"%.2f",self.caseModel.principal]}];
    [infoArray addObject:@{@"title":@"诉讼金额-利息" ,@"content":[NSString stringWithFormat:@"%.2f",self.caseModel.interest]}];
    [infoArray addObject:@{@"title":@"诉讼金额-违约金" ,@"content":[NSString stringWithFormat:@"%.2f",self.caseModel.penalSum]}];
    [infoArray addObject:@{@"title":@"诉讼金额-其他金额" ,@"content":[NSString stringWithFormat:@"%.2f",self.caseModel.otherAmount]}];
    [infoArray addObject:@{@"title":@"诉讼金额-受理费用" ,@"content":[NSString stringWithFormat:@"%.2f",self.caseModel.acceptAmount]}];
    [infoArray addObject:@{@"title":@"诉讼金额-合计" ,@"content":[NSString stringWithFormat:@"%.2f",self.caseModel.totalAmount]}];
    [infoArray addObject:@{@"title":@"案件概况" ,@"content":self.caseModel.caseExplan}];
    [infoArray addObject:@{@"title":@"是否有查封冻结情况" ,@"content":self.caseModel.freeze?@"是":@"否"}];
    [infoArray addObject:@{@"title":@"查封冻结金额" ,@"content":[NSString stringWithFormat:@"%.2f",self.caseModel.freezeAmount]}];
    //提交资料部门
    
    
    [infoArray addObject:@{@"title":@"提交资料部门",@"special":@(BussinessFlowCellHead)}];
    if (self.flowType == YSFlowTypeTodo && self.caseModel.operatorEdit) {//待办才可以有编辑
    //判断当前审批人属于哪个部门
    YSLawDepartModel *currentDepart = self.caseModel.lawsuitDeptList[self.caseModel.nodeNow];
         self.owerDepart = self.caseModel.lawsuitDeptList[self.caseModel.nodeNow];
//    NSString *userid = [YSUserDefaults objectForKey:@"uid"];
//    for (YSLawDepartModel *departModel in self.caseModel.lawsuitDeptList) {
//        if ([userid isEqualToString:departModel.receiverNo]) {
//            currentDepart = departModel;
//            self.owerDepart = departModel;
//            break;
//        }
//    }
    [infoArray addObject:@{@"title":currentDepart.deptName,@"special":@(BussinessFlowCellEdit)}];
    [infoArray addObject:@{@"title":@"拟提交日期",@"content":[YSUtility timestampSwitchTime:currentDepart.planSubmitDate andFormatter:@"yyyy-MM-dd"]}];
    [infoArray addObject:@{@"title":@"经办人",@"content":currentDepart.operator}];
    [infoArray addObject:@{@"title":@"经办人联系方式" ,@"content":currentDepart.operatorPhone}];
    
      [infoArray addObject:@{@"special":@(BussinessFlowCellEmpty)}];
    [infoArray addObject:@{@"title":@"接收人",@"special":@(BussinessFlowCellBG),@"content":currentDepart.receiverName}];
    [infoArray addObject:@{@"title":@"应收资料" ,@"special":@(BussinessFlowCellBG),@"content":currentDepart.receiveData}];
    [infoArray addObject:@{@"title":@"类型" ,@"special":@(BussinessFlowCellBG),@"content":currentDepart.type}];
    [infoArray addObject:@{@"title":@"提供日期",@"special":@(BussinessFlowCellBG),@"content":[YSUtility timestampSwitchTime:currentDepart.submitDate andFormatter:@"yyyy-MM-dd hh:mm"]}];
    [infoArray addObject:@{@"title":@"备注",@"special":@(BussinessFlowCellBG) ,@"content":currentDepart.remark}];
     [infoArray addObject:@{@"special":@(BussinessFlowCellEmpty)}];
    }
    [infoArray addObject:@{@"title":@"各部门资料明细",@"special":@(BussinessFlowCellTurn),@"content":[NSString stringWithFormat:@"%ld",self.caseModel.lawsuitDeptList.count]}];
    self.dataSourceArray = infoArray;
    
}
@end
