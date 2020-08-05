//
//  YSFlowOfficeAndDrinksViewModel.m
//  YaSha-iOS
//
//  Created by 罗罗诺亚索隆 on 2019/4/9.
//  Copyright © 2019 亚厦装饰股份有限公司. All rights reserved.
//

#import "YSFlowOfficeAndDrinksViewModel.h"
#import "YSFlowOfficeAndDrinkModel.h"
#import "YSFlowDrinksEditController.h"
#import "YSDrinkEditProspectController.h"
#import "YSFlowAttachmentViewController.h"
@interface YSFlowOfficeAndDrinksViewModel()

@end
@implementation YSFlowOfficeAndDrinksViewModel
- (void)getFlowlistComplete:(fetchDataCompleteBlock)comleteBlock failue:(fetchDataFailueBlock)fetchFailueBlock {
    [YSNetManager ys_request_GETWithUrlString:[NSString stringWithFormat:@"%@%@/%@?taskId=%@",YSDomain,getOfficeAndDrinksInfo,self.flowModel.businessKey,self.flowModel.taskId] isNeedCache:NO parameters:nil successBlock:^(id response) {
        if ([response[@"code"] intValue] == 1) {
            self.flowFormModel = [YSFlowFormModel yy_modelWithJSON:response[@"data"]];
            self.drinkModel = [YSFlowOfficeAndDrinkModel yy_modelWithJSON:self.flowFormModel.info];
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
    [self.dataSourceArray removeAllObjects];
    [self.dataSourceArray addObject:@{@"title":@"申请信息",@"special":@(BussinessFlowCellHead)}];
    [self.dataSourceArray addObject:@{@"title":@"申请人" ,@"content":self.drinkModel.apply.applyManName}];
    [self.dataSourceArray addObject:@{@"title":@"实际使用人" ,@"content":self.drinkModel.apply.useManName}];
    [self.dataSourceArray addObject:@{@"title":@"所属单位" ,@"content":self.drinkModel.apply.useCompany}];
    
    [self.dataSourceArray addObject:@{@"title":@"所在部门" ,@"content":self.drinkModel.apply.useDept}];
    [self.dataSourceArray addObject:@{@"title":@"员工级别" ,@"content":self.drinkModel.apply.useManLevel}];
    [self.dataSourceArray addObject:@{@"title":@"上级部门" ,@"content":self.drinkModel.apply.useManParentDept}];
    [self.dataSourceArray addObject:@{@"title":@"需求时间" ,@"content":self.drinkModel.apply.demandDateStr}];
    [self.dataSourceArray addObject:@{@"title":@"需求内容" ,@"content":self.drinkModel.apply.demandContent}];
    [self.dataSourceArray addObject:@{@"title":@"申请事由" ,@"content":self.drinkModel.apply.reason}];
    [self.dataSourceArray addObject:@{@"title":@"品名附件" ,@"special":@(BussinessFlowCellTurn),@"content":[NSString stringWithFormat:@"%ld",self.drinkModel.apply.fileListFormMobile.count],@"file":self.drinkModel.apply.fileListFormMobile}];
    
    if (self.drinkModel.apply.acceptMode.length || (self.drinkModel.isEditData && [self.drinkModel.activityName containsString:@"行政仓库管理员"] && self.flowType == YSFlowTypeTodo)) {//已经编辑过的有值的显示标题， 或者是编辑节点也显示标题
        [self.dataSourceArray addObject:@{@"title":@"行政仓管专员",@"special":@(BussinessFlowCellHead)}];
    }
    if (self.drinkModel.isEditData && [self.drinkModel.activityName containsString:@"行政仓库管理员"] && self.flowType == YSFlowTypeTodo) {//行政仓管专员节点
        [self.dataSourceArray addObject:@{@"title":@"需求信息",@"special":@(BussinessFlowCellEdit)}];
    }
    
    if ([self.drinkModel.apply.acceptMode isEqualToString:@"CG"]) {
        [self.dataSourceArray addObject:@{@"title":@"受理方式" ,@"content":@"采购"}];
    }
    
    if ([self.drinkModel.apply.acceptMode isEqualToString:@"LY"]) {
        [self.dataSourceArray addObject:@{@"title":@"受理方式" ,@"content":@"领用"}];
        [self.dataSourceArray addObject:@{@"title":@"领用金额" ,@"content":self.drinkModel.apply.receiveMoney}];
    }
    
    
    if (self.drinkModel.apply.prospectMoney.length || (self.drinkModel.isEditData && [self.drinkModel.activityName containsString:@"行政采购专员"] && self.flowType == YSFlowTypeTodo)) {
        [self.dataSourceArray addObject:@{@"title":@"行政采购专员",@"special":@(BussinessFlowCellHead)}];
    }
    
    
    if (self.drinkModel.isEditData && [self.drinkModel.activityName containsString:@"行政采购专员"] && self.flowType == YSFlowTypeTodo) {//行政采购专员节点
        [self.dataSourceArray addObject:@{@"title":@"预估信息",@"special":@(BussinessFlowCellEdit)}];
    }
    
    if (self.drinkModel.apply.prospectMoney.length) {
        [self.dataSourceArray addObject:@{@"title":@"预估金额" ,@"content":self.drinkModel.apply.prospectMoney}];
    }
    if (self.drinkModel.apply.purchaseNumber) {
        [self.dataSourceArray addObject:@{@"title":@"采购数量" ,@"content":[NSString stringWithFormat:@"%ld",self.drinkModel.apply.purchaseNumber]}];
    }
    
    
    
    if (self.drinkModel.apply.actualPurchaseMoney.length || (self.drinkModel.isEditData && [self.drinkModel.activityName containsString:@"行政部采购专员"] && self.flowType == YSFlowTypeTodo)) {
        [self.dataSourceArray addObject:@{@"title":@"行政采购信息",@"special":@(BussinessFlowCellHead)}];
    }
    
    
    if (self.drinkModel.isEditData && [self.drinkModel.activityName containsString:@"行政部采购专员"] && self.flowType == YSFlowTypeTodo) {//区域负责人节点
        [self.dataSourceArray addObject:@{@"title":@"实际采购信息",@"special":@(BussinessFlowCellEdit)}];
    }
    
    if (self.drinkModel.apply.actualPurchaseMoney.length) {
        [self.dataSourceArray addObject:@{@"title":@"实际采购金额" ,@"content":self.drinkModel.apply.actualPurchaseMoney}];
    }
    if (self.drinkModel.apply.actualPurchaseNumber) {
        [self.dataSourceArray addObject:@{@"title":@"实际采购数量" ,@"content":[NSString stringWithFormat:@"%ld",self.drinkModel.apply.actualPurchaseNumber]}];
    }
    
    
    
}
- (void)turnOtherViewControllerWith:(UIViewController *)viewController andIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *cellDic = self.dataSourceArray[indexPath.row];
    if ([cellDic[@"title"] isEqualToString:@"需求信息"] && [cellDic[@"special"] integerValue] == BussinessFlowCellEdit) {
        YSFlowDrinksEditController *vc = [[YSFlowDrinksEditController alloc]init];
        vc.title = [NSString stringWithFormat:@"%@填写",cellDic[@"title"]];
        vc.drinkdModel = self.drinkModel;
        vc.editSuccessBlock = ^(NSString * _Nonnull acceptMode, NSString * _Nonnull receiveMoney) {
            self.drinkModel.apply.acceptMode = acceptMode;
            self.drinkModel.apply.receiveMoney = receiveMoney;
            [self setUpData];
            //变量赋值用于监听
            self.acceptMode = acceptMode;
        };
        [viewController.navigationController pushViewController:vc animated:YES];
        
    }
    
    if ([cellDic[@"title"] isEqualToString:@"预估信息"] && [cellDic[@"special"] integerValue] == BussinessFlowCellEdit) {
        YSDrinkEditProspectController *vc = [[YSDrinkEditProspectController alloc]init];
        vc.drinkdModel = self.drinkModel;
        vc.title = @"预估信息填写";
        vc.editSuccessBlock = ^(NSString * _Nonnull money, NSInteger number) {
            self.drinkModel.apply.prospectMoney = money;
            self.drinkModel.apply.purchaseNumber = number;
            [self setUpData];
            //变量赋值用于监听
            self.prospectMoney = money;
        };
        
        [viewController.navigationController pushViewController:vc animated:YES];
    }
    
    if ([cellDic[@"title"] isEqualToString:@"实际采购信息"] && [cellDic[@"special"] integerValue] == BussinessFlowCellEdit) {
        YSDrinkEditProspectController *vc = [[YSDrinkEditProspectController alloc]init];
        vc.drinkdModel = self.drinkModel;
        vc.title = @"实际采购信息填写";
        vc.editSuccessBlock = ^(NSString * _Nonnull money, NSInteger number) {
            self.drinkModel.apply.actualPurchaseMoney = money;
            self.drinkModel.apply.actualPurchaseNumber = number;
            [self setUpData];
            //变量赋值用于监听
            self.prospectMoney = money;
        };
        [viewController.navigationController pushViewController:vc animated:YES];
    }
    
    if ([cellDic[@"special"] integerValue] == BussinessFlowCellTurn) {
        YSFlowAttachmentViewController *vc = [[YSFlowAttachmentViewController alloc]init];
        vc.naviTitle = cellDic[@"title"];
        vc.attachMentArray = cellDic[@"file"];
        if ([cellDic[@"file"] count]) {
            [viewController.navigationController pushViewController:vc animated:YES];
        }else{
            [QMUITips showInfo:[NSString stringWithFormat:@"暂无%@",cellDic[@"title"]] inView:viewController.view hideAfterDelay:1.5];
        }
    }
    
    
}
-(void)editOfficeAndDrinksComeplete:(fetchDataCompleteBlock)comepleteBlock failue:(fetchDataFailueBlock)failueBlock {
    //不需要编辑的直接返回
    if (!self.drinkModel.isEditData) {
        if (comepleteBlock) {
            comepleteBlock();
        }
    }
    
    if (self.drinkModel.isEditData && [self.drinkModel.activityName containsString:@"行政仓库管理员"]) {//行政仓管专员节点
        //条件判定
        if (!self.drinkModel.apply.acceptMode.length) {
            failueBlock(@"请填写需求信息");
            return;
        }
        if ([self.drinkModel.apply.acceptMode isEqualToString:@"LY"] && !self.drinkModel.apply.receiveMoney.length) {
            failueBlock(@"请填写完整需求信息");
            return;
        }
        NSMutableDictionary *paraDic = [[NSMutableDictionary alloc]init];
        [paraDic setValue:self.drinkModel.apply.id forKey:@"id"];
        
        if ([self.drinkModel.apply.acceptMode isEqualToString:@"CG"]) {
            [paraDic setValue:@"CG" forKey:@"acceptMode"];
        }else{
            [paraDic setValue:@"LY" forKey:@"acceptMode"];
            [paraDic setValue:self.drinkModel.apply.receiveMoney forKey:@"receiveMoney"];
        }
        
        [YSNetManager ys_request_POSTWithUrlString:[NSString stringWithFormat:@"%@%@",YSDomain,saveOfficeAndDrinks] isNeedCache:NO parameters:paraDic successBlock:^(id response) {
            if ([response[@"code"] integerValue] == 1) {
                comepleteBlock();
                return;
            }
        } failureBlock:^(NSError *error) {
            
        } progress:nil];
        
        
    }
    
    
    
    if (self.drinkModel.isEditData && [self.drinkModel.activityName containsString:@"行政采购专员"]) {//行政采购专员节点
        //条件判定
        if (!self.drinkModel.apply.prospectMoney.length) {
            failueBlock(@"请填写需求信息");
            return;
        }
        if (!self.drinkModel.apply.purchaseNumber) {
            failueBlock(@"请填写完整需求信息");
            return;
        }
        NSMutableDictionary *paraDic = [[NSMutableDictionary alloc]init];
        [paraDic setValue:self.drinkModel.apply.id forKey:@"id"];
        
        
        [paraDic setValue:self.drinkModel.apply.acceptMode forKey:@"acceptMode"];
        [paraDic setValue:self.drinkModel.apply.prospectMoney forKey:@"prospectMoney"];
        [paraDic setValue:@(self.drinkModel.apply.purchaseNumber) forKey:@"purchaseNumber"];
        
        
        
        [YSNetManager ys_request_POSTWithUrlString:[NSString stringWithFormat:@"%@%@",YSDomain,saveOfficeAndDrinks] isNeedCache:NO parameters:paraDic successBlock:^(id response) {
            if ([response[@"code"] integerValue] == 1) {
                comepleteBlock();
                return ;
            }
        } failureBlock:^(NSError *error) {
            
        } progress:nil];
        
        
    }
    if (self.drinkModel.isEditData && [self.drinkModel.activityName containsString:@"行政部采购专员"]) {//行政采购专员节点
        //条件判定
        if (!self.drinkModel.apply.actualPurchaseMoney.length) {
            failueBlock(@"请填写需求信息");
            return;
        }
        if (!self.drinkModel.apply.actualPurchaseNumber) {
            failueBlock(@"请填写完整需求信息");
            return;
        }
        NSMutableDictionary *paraDic = [[NSMutableDictionary alloc]init];
        [paraDic setValue:self.drinkModel.apply.id forKey:@"id"];
        
        
        [paraDic setValue:self.drinkModel.apply.acceptMode forKey:@"acceptMode"];
        [paraDic setValue:self.drinkModel.apply.actualPurchaseMoney forKey:@"actualPurchaseMoney"];
        [paraDic setValue:@(self.drinkModel.apply.actualPurchaseNumber) forKey:@"actualPurchaseNumber"];
        [YSNetManager ys_request_POSTWithUrlString:[NSString stringWithFormat:@"%@%@",YSDomain,saveOfficeAndDrinks] isNeedCache:NO parameters:paraDic successBlock:^(id response) {
            if ([response[@"code"] integerValue] == 1) {
                comepleteBlock();
                return ;
            }
        } failureBlock:^(NSError *error) {
            
        } progress:nil];
    }
   
    
    
}
@end
