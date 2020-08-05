//
//  YSFlowLawSuitEditDepartController.m
//  YaSha-iOS
//
//  Created by 罗罗诺亚索隆 on 2019/3/18.
//  Copyright © 2019 亚厦装饰股份有限公司. All rights reserved.
//

#import "YSFlowLawSuitEditDepartController.h"
#import "YSFlowBackGroundCell.h"
#import "YSFlowEmptyCell.h"
@interface YSFlowLawSuitEditDepartController ()
@property (nonatomic,strong) QMUITextView *headerView;
@end

@implementation YSFlowLawSuitEditDepartController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"流程处理";
    //设置表头
    QMUITextView *headerView = [[QMUITextView alloc]init];
    self.headerView = headerView;
    headerView.font = [UIFont systemFontOfSize:14];
    
    headerView.placeholder = @"请输入法务部接受资料情况…";
    if (self.departModel.lawsuitData.length) {
        headerView.text = self.departModel.lawsuitData;
    }
    headerView.frame = CGRectMake(0, 0, 0, 120*kHeightScale);
    headerView.delegate = self;
    self.tableView.tableHeaderView = headerView;
    //底部按钮
    UIButton *submit = [UIButton buttonWithType:UIButtonTypeCustom];
    [submit setTitle:@"提交" forState:UIControlStateNormal];
    submit.backgroundColor = [UIColor colorWithHexString:@"#2A8ADB"];
    [self.view addSubview:submit];
    [submit mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.right.mas_equalTo(-15);
        make.bottom.mas_equalTo(-kBottomHeight - 30);
        make.height.mas_equalTo(50);
    }];
    YSWeak;
    [[submit rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        [weakSelf submit];
    }];
    [self setUpData];
}
- (void)setUpData {
    
    NSMutableArray *infoArray = [NSMutableArray array];
    [infoArray addObject:@{@"special":@(BussinessFlowCellEmpty)}];
    [infoArray addObject:@{@"title":@"提交部门",@"special":@(BussinessFlowCellBG),@"content": _departModel.deptName}];
    [infoArray addObject:@{@"title":@"接收人",@"special":@(BussinessFlowCellBG),@"content": _departModel.receiverName}];
    [infoArray addObject:@{@"title":@"应收资料" ,@"special":@(BussinessFlowCellBG),@"content": _departModel.receiveData}];
    [infoArray addObject:@{@"title":@"类型" ,@"special":@(BussinessFlowCellBG),@"content": _departModel.type}];
    [infoArray addObject:@{@"title":@"提供日期",@"special":@(BussinessFlowCellBG),@"content":[YSUtility timestampSwitchTime: _departModel.submitDate andFormatter:@"yyyy-MM-dd hh:mm"]}];
    [infoArray addObject:@{@"title":@"拟提供日期",@"special":@(BussinessFlowCellBG),@"content":[YSUtility timestampSwitchTime: _departModel.planSubmitDate andFormatter:@"yyyy-MM-dd hh:mm"]}];
    [infoArray addObject:@{@"title":@"经办人" ,@"special":@(BussinessFlowCellBG),@"content": _departModel.operator}];
    [infoArray addObject:@{@"title":@"经办人联系方式" ,@"special":@(BussinessFlowCellBG),@"content": _departModel.operatorPhone}];
    [infoArray addObject:@{@"title":@"备注",@"special":@(BussinessFlowCellBG) ,@"content": _departModel.remark}];
    [infoArray addObject:@{@"special":@(BussinessFlowCellEmpty)}];
    self.dataSourceArray = infoArray;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSourceArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSDictionary *dataDic = self.dataSourceArray[indexPath.row];
    if([dataDic[@"special"] integerValue] == BussinessFlowCellBG){
        YSFlowBackGroundCell *cell = [tableView dequeueReusableCellWithIdentifier:@"YSFlowBackGroundCell"];
        if (cell == nil) {
            cell = [[YSFlowBackGroundCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"YSFlowBackGroundCell"];
        }
        cell.lableNameLabel.text = dataDic[@"title"];
        cell.valueLabel.text = dataDic[@"content"];
        cell.separatorInset = UIEdgeInsetsMake(0, 0, 0, kSCREEN_WIDTH);
        return cell;
        
    }else{
        YSFlowEmptyCell *cell = [[YSFlowEmptyCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        cell.separatorInset = UIEdgeInsetsMake(0, 0, 0, kSCREEN_WIDTH);
        return cell;
        
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 15;
}
- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 30*kHeightScale;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return UITableViewAutomaticDimension;
    
}
- (void)submit {
    NSMutableDictionary *paraDic = [[NSMutableDictionary alloc]initWithCapacity:10];
    [paraDic setValue:_departModel.id forKey:@"id"];
    [paraDic setValue:self.headerView.text forKey:@"lawsuitData"];
    [QMUITips showLoadingInView:self.view];
    [YSNetManager ys_request_POSTWithUrlString:[NSString stringWithFormat:@"%@%@/%@",YSDomain,updatePexpShareDetailForFlow,self.bussinessKey] isNeedCache:NO parameters:@[paraDic] successBlock:^(id response) {
        [QMUITips hideAllToastInView:self.view animated:YES];
        if ([response[@"data"] integerValue] == 1) {
            [QMUITips showInfo:@"提交成功" inView:self.view hideAfterDelay:1.5];
            if (self.headerView.text.length) {
                self.departModel.lawsuitData = self.headerView.text;//数据记录在model里，回去刷新界面
            }
            if (self.editBlock) {
                
                self.editBlock();
            }
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.navigationController popViewControllerAnimated:YES];
            });
            
        }
    } failureBlock:^(NSError *error) {
        
    } progress:nil];
}
@end
