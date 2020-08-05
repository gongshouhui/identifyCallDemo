//
//  YSPMSMQEarlyPreHandleController.m
//  YaSha-iOS
//
//  Created by 罗罗诺亚索隆 on 2018/10/25.
//  Copyright © 2018年 亚厦装饰股份有限公司. All rights reserved.
//

#import "YSPMSMQEarlyPreHandleController.h"
#import "YSMQCellModel.h"
#import "YSMQDateSelectCell.h"
#import "YSMQRemarkInputCell.h"
#import "YSMQSwitchCell.h"
#import "YSMQImageSelectCellCell.h"
#import "YSMQTextFieldCell.h"
@interface YSPMSMQEarlyPreHandleController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong) NSMutableDictionary *paraDic;
@end

@implementation YSPMSMQEarlyPreHandleController
- (NSMutableDictionary *)paraDic {
    if (!_paraDic) {
        _paraDic = [NSMutableDictionary dictionaryWithCapacity:10];
    }
    return _paraDic;
}
- (void)initTableView {
    [super initTableView];
    [self hideMJRefresh];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"提交" style:UIBarButtonItemStylePlain target:self action:@selector(submit)];
    switch (self.status) {
        case PrePareStatusStart:
        {
            self.title = @"开工";
            NSMutableArray *array = [NSMutableArray array];
            YSMQCellModel *model1 = [[YSMQCellModel alloc]init];
            model1.className = @"YSMQDateSelectCell";
            model1.title = @"日期*";
            model1.necessary = YES;
            model1.content = [YSUtility stringWithDate:[NSDate date] andFormatter:@"yyyy-MM-dd"];//默认当前时间
            [array addObject:model1];
 
            YSMQCellModel *model2 = [[YSMQCellModel alloc]init];
            model2.className = @"YSMQRemarkInputCell";
            model2.title = @"开工情况说明";
            [array addObject:model2];
            
            YSMQCellModel *model3 = [[YSMQCellModel alloc]init];
            model3.className = @"YSMQImageSelectCellCell";
          NSMutableArray *imageArray = [NSMutableArray arrayWithCapacity:20];
          [imageArray addObject:@"添加照片"];
            model3.imageArray = imageArray;
            [array addObject:model3];
            [self.dataSourceArray addObject:array];
        }
            break;
            
        case PrePareStatusStartHold:
        {
            self.title = @"跟踪";
            NSMutableArray *array = [NSMutableArray array];
            YSMQCellModel *model1 = [[YSMQCellModel alloc]init];
            model1.className = @"YSMQDateSelectCell";
            model1.title = @"日期*";
            model1.necessary = YES;
            model1.content = [YSUtility stringWithDate:[NSDate date] andFormatter:@"yyyy-MM-dd"];//默认当前时间
            [array addObject:model1];
            
            YSMQCellModel *model2 = [[YSMQCellModel alloc]init];
            model2.className = @"YSMQTextFieldCell";
            model2.title = @"实际形象进度*";
            [array addObject:model2];
            
            YSMQCellModel *model3 = [[YSMQCellModel alloc]init];
            model3.className = @"YSMQRemarkInputCell";
            model3.title = @"完工情况说明";
            [array addObject:model3];
            
            YSMQCellModel *model4 = [[YSMQCellModel alloc]init];
            model4.className = @"YSMQImageSelectCellCell";
            NSMutableArray *imageArray = [NSMutableArray arrayWithCapacity:20];
            [imageArray addObject:@"添加照片"];
            model4.imageArray = imageArray;
            [array addObject:model4];
            [self.dataSourceArray addObject:array];
            
            NSMutableArray *array2 = [NSMutableArray array];
            YSMQCellModel *model5 = [[YSMQCellModel alloc]init];
            model5.className = @"YSMQSwitchCell";
            model5.title = @"是否影响总工期";
            [array2 addObject:model5];
            [self.dataSourceArray addObject:array2];
        }
            break;
        case PrePareStatusStartComplete:
        {
            self.title = @"完工";
            NSMutableArray *array = [NSMutableArray array];
            YSMQCellModel *model1 = [[YSMQCellModel alloc]init];
            model1.className = @"YSMQDateSelectCell";
            model1.title = @"日期*";
            model1.necessary = YES;
            model1.content = [YSUtility stringWithDate:[NSDate date] andFormatter:@"yyyy-MM-dd"];//默认当前时间
            [array addObject:model1];
            
            YSMQCellModel *model2 = [[YSMQCellModel alloc]init];
            model2.className = @"YSMQTextFieldCell";
            model2.title = @"实际形象进度*";
            [array addObject:model2];
            
            YSMQCellModel *model3 = [[YSMQCellModel alloc]init];
            model3.className = @"YSMQRemarkInputCell";
            model3.title = @"完工情况说明";
            [array addObject:model3];
            
            YSMQCellModel *model4 = [[YSMQCellModel alloc]init];
            model4.className = @"YSMQImageSelectCellCell";
            NSMutableArray *imageArray = [NSMutableArray arrayWithCapacity:20];
            [imageArray addObject:@"添加照片"];
            model4.imageArray = imageArray;
            [array addObject:model4];
            [self.dataSourceArray addObject:array];
            
            NSMutableArray *array2 = [NSMutableArray array];
            YSMQCellModel *model5 = [[YSMQCellModel alloc]init];
            model5.className = @"YSMQSwitchCell";
            model5.title = @"是否影响总工期";
            [array2 addObject:model5];
            [self.dataSourceArray addObject:array2];
    }
            break;
            
        default:
            break;
    }
}
#pragma mark - UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataSourceArray.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.dataSourceArray[section] count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    YSMQCellModel *model = self.dataSourceArray[indexPath.section][indexPath.row];
    
    if ([model.className isEqualToString:@"YSMQDateSelectCell"]) {
        YSMQDateSelectCell *cell = [[YSMQDateSelectCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        [cell setDataForCell:model];
         [self.paraDic setValue:model.content forKey:@"sdate"];
        YSWeak;
        cell.dateBlock = ^(NSString * _Nonnull date) {
            model.content = date;
             [weakSelf.paraDic setValue:date forKey:@"sdate"];//日期参数
        };
        return cell;
    }
    if ([model.className isEqualToString:@"YSMQTextFieldCell"]) {
        YSMQTextFieldCell *cell = [[NSBundle mainBundle] loadNibNamed:@"YSMQTextFieldCell" owner:self options:nil].firstObject;
        if ([model.title containsString:@"*"]) {
            NSMutableAttributedString *attiStr = [[NSMutableAttributedString alloc]initWithString:model.title];
            [attiStr addAttributes:@{NSForegroundColorAttributeName:[UIColor redColor]} range:[model.title rangeOfString:@"*"]];
            cell.titleLb.attributedText = attiStr;
        }else{
            cell.titleLb.text = model.title;
        }
        YSWeak;
        cell.textFieldBlock = ^(NSString * _Nonnull text) {
            if (text.length) {
                [weakSelf.paraDic setValue:[NSNumber numberWithDouble:[text doubleValue]]  forKey:@"graphicProgress"];//实际进度参数
            }
           
        };
        return cell;
    }
  
    if ([model.className isEqualToString:@"YSMQRemarkInputCell"]) {
       
        YSMQRemarkInputCell *cell = [[YSMQRemarkInputCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
         cell.separatorInset = UIEdgeInsetsMake(0, 0, 0, kSCREEN_WIDTH);
        [cell setDataForCell:model];
        YSWeak;
        cell.remarkBlock = ^(NSString * _Nonnull remark) {
            model.content = remark;
            //存在两个textViewcell
            if ([model.title isEqualToString:@"说明"]) {//影响总工期说明
                 [weakSelf.paraDic setValue:remark forKey:@"isLimitRemark"];
            }else{//操作说明
                [weakSelf.paraDic setValue:remark forKey:@"finishRemark"];
            }
            
        };
        return cell;
    }
    if ([model.className isEqualToString:@"YSMQImageSelectCellCell"]) {
        YSMQImageSelectCellCell *cell = [[YSMQImageSelectCellCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        cell.dataArray = model.imageArray;
        YSWeak;
        cell.selectedImageBlock = ^(NSMutableArray * _Nonnull imageArray) {
            model.imageArray = imageArray;
            [weakSelf.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
            
        };
        return cell;
    }
    if ([model.className isEqualToString:@"YSMQSwitchCell"]) {
        YSMQSwitchCell *cell = [[NSBundle mainBundle] loadNibNamed:@"YSMQSwitchCell" owner:self options:nil].firstObject;
        YSWeak;
        cell.titleLb.text = model.title;
        [self.paraDic setValue:@(cell.switchBtn.isOn) forKey:@"isLimit"];//默认值是关闭的
        cell.switchBlock = ^(BOOL switchValue) {
            YSStrong;
            
            [strongSelf.paraDic setValue:@(switchValue) forKey:@"isLimit"];//实际进度参数//
            //刷新最后一行cell
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:1 inSection:1];
            if (switchValue) {
                YSMQCellModel *model6 = [[YSMQCellModel alloc]init];
                model6.className = @"YSMQRemarkInputCell";
                model6.title = @"说明";
                [strongSelf.dataSourceArray[indexPath.section] addObject:model6];
                [strongSelf.tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationBottom];
            }else{
                [strongSelf.dataSourceArray[1] removeLastObject];
                [strongSelf.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationBottom];
            }
            
        };
        return cell;
    }
    return [UITableViewCell new];
}
- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 100;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewAutomaticDimension;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
      YSMQCellModel *model = self.dataSourceArray[indexPath.section][indexPath.row];
  
    
    if ([model.className isEqualToString:@"YSMQDateSelectCell"]) {
       
    }
    
    
    if ([model.className isEqualToString:@"YSMQRemarkInputCell"]) {
        
    }
    if ([model.className isEqualToString:@"YSMQImageSelectCellCell"]) {
        
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 10;
}
#pragma mark - 导航栏按钮点击事件
- (void)submit {
    [self.view endEditing:YES];
    //判断必填项
    switch (self.status) {
        case PrePareStatusStart:
            if (![self.paraDic[@"sdate"] length]) {
                [QMUITips showInfo:@"请选择日期" inView:self.view hideAfterDelay:1.5];
                return;
            }
            break;
            
        default:
            if (![self.paraDic[@"sdate"] length]) {
                [QMUITips showInfo:@"请选择日期" inView:self.view hideAfterDelay:1.5];
                return;
            }
            if (!self.paraDic[@"graphicProgress"]) {
                [QMUITips showInfo:@"请填写实际形象进度" inView:self.view hideAfterDelay:1.5];
                return;
            }
            if ([self.paraDic[@"isLimit"] boolValue]) {//原因必填
                if (![self.paraDic[@"isLimitRemark"] length]) {
                    [QMUITips showInfo:@"请填写影响工期原因" inView:self.view hideAfterDelay:1.5];
                    return;
                }
                
            }
            break;
    }
    //前期准备ID
     [self.paraDic setValue:_model.id forKey:@"planPrepareId"];
    //操作标题
    NSString *status = nil;
    if (self.status == PrePareStatusStart) {
        status = @"开工";
    }else if (self.status == PrePareStatusStartHold){
        status = @"跟踪";
    }else {
         status = @"完工";
    }
    NSString *title = [NSString stringWithFormat:@"%@%@",self.model.name,status];
    [self.paraDic setValue:title forKey:@"title"];
   //照片数组
    NSMutableArray *imageArr = nil;
    for (NSArray *array in self.dataSourceArray) {
        for (YSMQCellModel *model in array) {
            if ([model.className isEqualToString:@"YSMQImageSelectCellCell"]) {
                imageArr = model.imageArray;
            }
        }
    }
    [imageArr removeLastObject];//去除添加张片
    [QMUITips showLoading:@"..." inView:self.view];
    [YSNetManager ys_uploadImageWithUrlString:[NSString stringWithFormat:@"%@%@/%@/%ld",YSDomain,updatePlanPrepareProgress,[YSUtility getUID],self.status] parameters:self.paraDic imageArray:imageArr file:@"file" successBlock:^(id response) {
        [QMUITips hideAllTipsInView:self.view];
        if ([response[@"code"] integerValue] == 1) {
            self.refreshEarlyPreBlock();
            [self.navigationController popViewControllerAnimated:YES];
            
        }else{
            [QMUITips showError:response[@"msg"] inView:self.view hideAfterDelay:1.5];
        }
    } failurBlock:^(NSError *error) {
        [QMUITips hideAllTipsInView:self.view];
    } upLoadProgress:^(int64_t bytesProgress, int64_t totalBytesProgress) {
    }];
    
    
}
@end
