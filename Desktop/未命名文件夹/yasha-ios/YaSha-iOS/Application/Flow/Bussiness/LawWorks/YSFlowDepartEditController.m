//
//  YSFlowDepartEditController.m
//  YaSha-iOS
//
//  Created by 罗罗诺亚索隆 on 2019/3/15.
//  Copyright © 2019 亚厦装饰股份有限公司. All rights reserved.
//

#import "YSFlowDepartEditController.h"
#import "YSFormDatePickerCell.h"
#import "YSFormJumpCell.h"
#import "YSFormTextFieldCell.h"
#import "YSFormRowModel.h"
#import "YSFlowBackGroundCell.h"
#import "YSFlowEmptyCell.h"
#import "YSContactSelectPersonViewController.h"
#import "YSContactModel.h"
@interface YSFlowDepartEditController()
@property (nonatomic,strong) NSMutableArray *infoArray;
@end
@implementation YSFlowDepartEditController
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"资料明细";
    UIButton *submit = [UIButton buttonWithType:UIButtonTypeCustom];
    [submit setTitle:@"提交" forState:UIControlStateNormal];
    submit.backgroundColor = [UIColor colorWithHexString:@"#2A8ADB"];
    [self.view addSubview:submit];
    [submit mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.right.mas_equalTo(-15);
        make.bottom.mas_equalTo(-kBottomHeight-30);
        make.height.mas_equalTo(50);
    }];
    YSWeak;
    [[submit rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        [weakSelf submit];
    }];
    [self setUpData];
     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(selectPerson:) name:KNotificationPostSelectedPerson object:nil];
}
- (void)setUpData {
    YSFormRowModel *model1 = [[YSFormRowModel alloc] init];
    model1.rowName = @"YSFormDatePickerCell";
    model1.title = @"拟提交日期";
    model1.detailTitle = [YSUtility timestampSwitchTime:self.departModel.planSubmitDate andFormatter:@"yyyy-MM-dd"];
    model1.accessoryType =UITableViewCellAccessoryDisclosureIndicator;
    model1.datePickerMode = PGDatePickerModeDate;
    [self.dataSourceArray addObject:model1];
    
    YSFormRowModel *model2 = [[YSFormRowModel alloc] init];
    model2.rowName = @"YSFormJumpCell";
    model2.title = @"经办人";
    model2.type = @"user";
    model2.detailTitle = self.departModel.operator;
    model2.accessoryType =UITableViewCellAccessoryDisclosureIndicator;
    [self.dataSourceArray addObject:model2];
    
    YSFormRowModel *model3 = [[YSFormRowModel alloc] init];
    model3.rowName = @"YSFormTextFieldCell";
    model3.title = @"经办人联系方式";
    model3.detailTitle = self.departModel.operatorPhone;
    model3.accessoryType =UITableViewCellAccessoryDisclosureIndicator;
    model3.checkoutType = YSCheckoutNone;
    
    [self.dataSourceArray addObject:model3];
    
    
    
    
    
    
    NSMutableArray *infoArray = [NSMutableArray array];
    self.infoArray = infoArray;
    [infoArray addObject:@{@"special":@(BussinessFlowCellEmpty)}];
    [infoArray addObject:@{@"title":@"接收人",@"special":@(BussinessFlowCellBG),@"content":self.departModel.receiverName}];
    [infoArray addObject:@{@"title":@"应收资料" ,@"special":@(BussinessFlowCellBG),@"content":self.departModel.receiveData}];
    [infoArray addObject:@{@"title":@"类型" ,@"special":@(BussinessFlowCellBG),@"content":self.departModel.type}];
    [infoArray addObject:@{@"title":@"提供日期",@"special":@(BussinessFlowCellBG),@"content":[YSUtility timestampSwitchTime:self.departModel.submitDate andFormatter:@"yyyy-MM-dd hh:mm"]}];
    [infoArray addObject:@{@"title":@"备注",@"special":@(BussinessFlowCellBG) ,@"content":self.departModel.remark}];
    [infoArray addObject:@{@"special":@(BussinessFlowCellEmpty)}];
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return self.dataSourceArray.count;
    }else{
        return self.infoArray.count;
    }
   
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.section) {
        case 0:
        {
            YSFormRowModel *model = self.dataSourceArray[indexPath.row];
            YSFormCommonCell *cell = [[NSClassFromString(model.rowName) alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
            [cell setCellModel:model];//当cell编辑的时候，数据记录在model里了
            return cell;
        }
            break;
           
        default:
        {
            NSDictionary *cellDic = self.infoArray[indexPath.row];
            if ([cellDic[@"special"] integerValue] == BussinessFlowCellBG) {
                YSFlowBackGroundCell *cell = [[YSFlowBackGroundCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"YSFlowBackGroundCell"];
                cell.lableNameLabel.text = cellDic[@"title"];
                cell.valueLabel.text = cellDic[@"content"];
                return cell;
            }else {
                YSFlowEmptyCell * cell = [[YSFlowEmptyCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
                cell.separatorInset = UIEdgeInsetsMake(0, 0, 0, kSCREEN_WIDTH);
                return cell;
        }
            break;
    }
    
    }
}
- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewAutomaticDimension;
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        YSFormRowModel *model = self.dataSourceArray[indexPath.row];
        if ([model.type isEqualToString:@"user"]) {
            YSContactSelectPersonViewController *contactSelectPersonViewController = [[YSContactSelectPersonViewController alloc]init];
            contactSelectPersonViewController.jumpSourceStr = @"law";
            [self.navigationController pushViewController:contactSelectPersonViewController animated:YES];
        }
        
    }
    
   
}
- (void)submit {
    NSMutableDictionary *paraDic = [[NSMutableDictionary alloc]initWithCapacity:10];
    [paraDic setValue:_departModel.id forKey:@"id"];
    [paraDic setValue:[self.dataSourceArray[1] detailTitle] forKey:@"operator"];
    [paraDic setValue:[self.dataSourceArray[2] detailTitle] forKey:@"operatorPhone"];
    [paraDic setValue:[self.dataSourceArray[0] detailTitle] forKey:@"planSubmitDate"];
    [QMUITips showLoadingInView:self.view];
    [YSNetManager ys_request_POSTWithUrlString:[NSString stringWithFormat:@"%@%@/%@",YSDomain,updatePexpShareDetailForFlow,self.bussinessKey] isNeedCache:NO parameters:@[paraDic] successBlock:^(id response) {
         [QMUITips hideAllToastInView:self.view animated:YES];
        if ([response[@"data"] integerValue] == 1) {
              [QMUITips showInfo:@"提交成功" inView:self.view hideAfterDelay:2];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
               
                [self.navigationController popViewControllerAnimated:YES];
            });
           
        }
    } failureBlock:^(NSError *error) {
        
    } progress:nil];
}
#pragma mark - 选择联系人
- (void)selectPerson:(NSNotification *)notification {
    NSArray *array = notification.userInfo[@"selectedArray"];
    YSContactModel *internalModel = array[0];
    YSFormRowModel *rowModel = self.dataSourceArray[1];
    rowModel.detailTitle = internalModel.name;
    [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:1 inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
}
- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
@end
