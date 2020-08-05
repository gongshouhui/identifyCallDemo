//
//  YSSupplyBidInvitingBaseInfoController.m
//  YaSha-iOS
//
//  Created by 龚守辉 on 2018/1/2.
//  Copyright © 2018年 亚厦装饰股份有限公司. All rights reserved.
//

#import "YSSupplyBidInvitingBaseInfoController.h"
#import "YSPMSInfoDetailHeaderCell.h"
#import "YSFlowAttachmentViewController.h"
#import "YSSupplyBidDetailModel.h"
#import "YSBidAttachmentViewController.h"
@interface YSSupplyBidInvitingBaseInfoController ()
@property (nonatomic,strong) YSSupplyBidDetailModel *bidModel;
@end

@implementation YSSupplyBidInvitingBaseInfoController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}
- (void)initTableView {
    [super initTableView];
    [self hideMJRefresh];
    [self doNetworking];
}

- (void)doNetworking {
    
    [YSNetManager ys_request_GETWithUrlString:[NSString stringWithFormat:@"%@%@/%@",YSDomain,getBidInvitingDetailAPI,self.bidID] isNeedCache:NO parameters:nil successBlock:^(id response) {
        [QMUITips hideAllTipsInView:self.view];
        if ([response[@"code"] integerValue] == 1) {
            DLog(@"======%@",response);
            self.bidModel = [YSSupplyBidDetailModel yy_modelWithJSON:response[@"data"]];
            [self setUpData];
        }
        
    } failureBlock:^(NSError *error) {
        
    } progress:nil];
    
    
}
- (void)setUpData {
    //分为拟邀供应商,  招标议价/合同盖章审批流程
    [self.dataSourceArray addObject:@{@"招标编号":self.bidModel.code?self.bidModel.code:@""}];
    [self.dataSourceArray addObject:@{@"编辑时间":self.bidModel.createTime?[YSUtility timestampSwitchTime:self.bidModel.createTime andFormatter:@"yyyy-MM-dd"]:@""}];
    [self.dataSourceArray addObject:@{@"编制人":self.bidModel.creatorText?self.bidModel.creatorText:@""}];
    [self.dataSourceArray addObject:@{@"招标材料":self.bidModel.bidMtrl?self.bidModel.bidMtrl:@""}];
    [self.dataSourceArray addObject:@{@"项目名称":self.bidModel.proNameStr?self.bidModel.proNameStr:@""}];
    [self.dataSourceArray addObject:@{@"项目地址":self.bidModel.addressStr?self.bidModel.addressStr:@""}];
    [self.dataSourceArray addObject:@{@"项目经理":self.bidModel.proManagerName?self.bidModel.proManagerName:@""}];
    [self.dataSourceArray addObject:@{@"项目性质":self.bidModel.managerModel?self.bidModel.managerModel:@""}];
    [self.dataSourceArray addObject:@{@"工程造价（万元）":self.bidModel.pmoneyStr?self.bidModel.pmoneyStr:@""}];
    [self.dataSourceArray addObject:@{@"采购模式":self.bidModel.modelStr?self.bidModel.modelStr:@""}];
    [self.dataSourceArray addObject:@{@"是否重点项目":self.bidModel.isKeyStr?self.bidModel.isKeyStr:@""}];
    
    //招标议价
    if(self.type == bidFlowTypeBid){
        [self.dataSourceArray addObject:@{@"全品是否盖章":self.bidModel.useSealUnit}];
        if (self.bidModel.contractCount) {
            if ([self.bidModel.contractType isEqualToString:@"0"]) {
                 [self.dataSourceArray addObject:@{@"采购合同版本":@"非公司统一版本"}];
                
            }else if ([self.bidModel.contractType isEqualToString:@"1"]){
                [self.dataSourceArray addObject:@{@"采购合同版本":@"公司统一版本"}];
            }else{
                [self.dataSourceArray addObject:@{@"采购合同版本":@"--"}];
            }
           
        }else{
            [self.dataSourceArray addObject:@{@"采购合同版本":@"--"}];
            
        }
      
        [self.dataSourceArray addObject:@{@"附件":@"  "}];
       
        [self.dataSourceArray addObject:@{@"备注":self.bidModel.remark?self.bidModel.remark:@""}];
        [self.dataSourceArray addObject:@{@"合同付款及工期":self.bidModel.payRemark}];
        
    }
    [self ys_reloadData];
}
#pragma mark - tableViewDataSource,tableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSourceArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *contentDic = self.dataSourceArray[indexPath.row];
    if ([[contentDic allKeys].firstObject hasPrefix:@"附件"] && !(self.type == bidFlowTypeWillInvite)) {//倒数第二行
        UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:nil];
        cell.textLabel.text = @"附件";
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.textLabel.textColor = kGrayColor(153);
        cell.textLabel.font = [UIFont systemFontOfSize:14];
        return cell;
        
    }else{
        YSPMSInfoDetailHeaderCell *cell = [tableView dequeueReusableCellWithIdentifier:@"YSPMSInfoDetailHeaderCell"];
        if (cell == nil) {
            cell = [[YSPMSInfoDetailHeaderCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"YSPMSInfoDetailHeaderCell"];
        }
        cell.dic = self.dataSourceArray[indexPath.row];
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 100;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewAutomaticDimension;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSDictionary *contentDic = self.dataSourceArray[indexPath.row];
    if ([[contentDic allKeys].firstObject hasPrefix:@"附件"] && !(self.type == bidFlowTypeWillInvite)) {//点击附件cell
//        if ([self.bidModel.useSealUnit isEqualToString:@"是"]) {//显示默认附件
            YSBidAttachmentViewController *vc = [[YSBidAttachmentViewController alloc]init];
            if (self.bidModel.mobileFiles.count) {
                [vc.dataSourceArray addObject:self.bidModel.mobileFiles];
                [vc.titleArray addObject:@"公共附件"];
            }
            if (self.bidModel.mobileFilesList.count) {
                [vc.dataSourceArray addObject:self.bidModel.mobileFilesList];
                [vc.titleArray addObject:@"合同附件"];
            }
            if (self.bidModel.mobileFilesQpList.count) {
                [vc.dataSourceArray addObject:self.bidModel.mobileFilesQpList];
                [vc.titleArray addObject:@"全品合同附件"];
            }
            [self.navigationController pushViewController:vc animated:YES];
//        }else{//展示全部附件
//            if (self.bidModel.mobileFiles.count) {
//                YSFlowAttachmentViewController *vc = [[YSFlowAttachmentViewController alloc]init];
//                vc.attachMentArray = self.bidModel.mobileFiles;
//                [self.navigationController pushViewController:vc animated:YES];
//            }else{
//                [QMUITips showInfo:@"暂无附件信息" inView:self.view hideAfterDelay:1];
//            }
        
//        }
        
        
    }
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
