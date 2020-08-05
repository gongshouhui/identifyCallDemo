//
//  YSModifyViewController.m
//  YaSha-iOS
//
//  Created by mHome on 2016/11/30.
//  Copyright © 2016年 方鹏俊. All rights reserved.
//

#import "YSModifyViewController.h"
#import "YSAddPeopleTableViewCell.h"
#import "ActionSheetPicker.h"
#import "YSExternalViewController.h"
#import "YSInformationViewController.h"

@interface YSModifyViewController ()<UITableViewDelegate,UITableViewDataSource,UITextViewDelegate,UIGestureRecognizerDelegate,UITextFieldDelegate,UINavigationControllerDelegate>
{
    UITableView *table;
    NSMutableArray *arr; //标题数组
    NSMutableArray *array; //人员信息数组
    
    UITextView *textview;//意见
    NSString *string;
    UILabel*lab;
    NSArray *mutableArray;//存储手机类型数组
    
    NSMutableArray *remindArr;//信息提示语句数组
    NSMutableDictionary *modifyDic;
    NSMutableArray *mobileArr;
    NSInteger select;
    NSMutableArray *changeArray;
    NSMutableDictionary *dic;
    
    
     NSString *detectionPhone;
    
}

@end

@implementation YSModifyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"修改人员信息";
    mutableArray = @[@"手机",@"单位",@"住宅"];
    remindArr = [NSMutableArray arrayWithObjects:@"联系人姓名",@"联系人手机号码(必填)",@"公司名称",@"职位名称",@"联系人邮箱", nil];
    dic = [NSMutableDictionary dictionaryWithCapacity:100];
    arr = [NSMutableArray arrayWithCapacity:100];
    array = [NSMutableArray arrayWithCapacity:100];
    mobileArr = [NSMutableArray arrayWithCapacity:100];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"保存" style:UIBarButtonItemStylePlain target:self action:@selector(saveData)];
    [arr addObject:@"姓名"];
    for (int i = 0; i < self.modifyModel.mobileList.count; i++) {
        [arr addObject:self.modifyModel.mobileList[i][@"mobileType"]];
    }
    [arr addObject:@"公司"];
    [arr addObject:@"职位"];
    [arr addObject:@"邮箱"];
    [array addObject:self.modifyModel.name];
    for (int i = 0; i < self.modifyModel.mobileList.count; i++) {
        [array addObject:self.modifyModel.mobileList[i][@"mobile"]];
        detectionPhone = self.modifyModel.mobileList[i][@"mobile"];
    }
    [array addObject:self.modifyModel.company?self.modifyModel.company:@""];
    [array addObject:self.modifyModel.job?self.modifyModel.job:@""];
    [array addObject:self.modifyModel.mail?self.modifyModel.mail:@""];
    [self creatTable];
    self.navigationController.delegate = self;
}

//- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
//    viewController.navigationItem.leftBarButtonItem.tintColor = [UIColor blackColor];
//    viewController.navigationItem.rightBarButtonItem.tintColor = [UIColor blackColor];
//}
- (void)saveData {
    if (![YSUtility isPhomeNumber:detectionPhone]) {
        [self remind:@"请输入正确的手机号"];
    }else{
        [self getServeManager];
    }
}
- (void)creatTable{
    
    table = [[UITableView alloc]initWithFrame:[UIScreen mainScreen].bounds style:UITableViewStyleGrouped];
    table.delegate = self;
    table.dataSource = self;
    table.rowHeight = 48*kHeightScale;
    [self.view addSubview:table];
}
//提交修改的数据
- (void)getServeManager {
    [dic setObject:self.modifyModel.id forKey:@"id"];
    [YSNetManager ys_request_POSTWithUrlString:[NSString stringWithFormat:@"%@%@",YSDomain,updateOrAddOuter] isNeedCache:NO parameters:dic successBlock:^(id response) {
        DLog(@"%@",response[@"msg"]);
        [QMUITips hideAllTipsInView:self.view];
        if ([response[@"data"] integerValue] == 1) {
            for (UIViewController *controller in self.rt_navigationController.rt_viewControllers) {
                if ([controller isKindOfClass:[YSInformationViewController class]]) {
                    [self.navigationController popToViewController:controller animated:YES];
                }
            }
        }
        
    } failureBlock:^(NSError *error) {
        DLog(@"123123131-----%@",error.localizedDescription);
    } progress:nil];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return arr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.01;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return nil;
}

//键盘消失
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [table endEditing:YES];
}

-(UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *inde = @"cell";
    YSAddPeopleTableViewCell  *cell = [tableView dequeueReusableCellWithIdentifier:inde];
    if (cell == nil){
        cell = [[YSAddPeopleTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:inde];
       }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.content.text = array[indexPath.row];
    [cell.titleBtn setTitle:arr[indexPath.row] forState:UIControlStateNormal];
    cell.content.delegate = self;
    cell.titleBtn.tag = indexPath.row+10;
    cell.content.tag = indexPath.row;
    [cell.content addTarget:self action:@selector(onChange:) forControlEvents:UIControlEventEditingChanged];// 可在自定义selector处理
    [cell.titleBtn addTarget:self action:@selector(choose:) forControlEvents:UIControlEventTouchUpInside];
    if (indexPath.row == 0) {
        [cell.img removeFromSuperview];
    }
    if (indexPath.row >= arr.count -3) {
        [cell.img setHidden:YES];
    }else{
        [cell.img setHidden:NO];
    }
    if (indexPath.row == 1) {
        UIButton *button = [[UIButton alloc]init];
        [button setImage:[UIImage imageNamed:@"添加手机号"] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(addPhone) forControlEvents:UIControlEventTouchUpInside];
        [cell addSubview:button];
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(cell.mas_top).offset(15*BIZ);
            make.right.mas_equalTo(cell.mas_right).offset(-24*BIZ);
            make.size.mas_equalTo(CGSizeMake(16*BIZ, 16*BIZ));
        }];
    }
    return cell;
}

//监听textFiled文本文字的变化
-(void) onChange:(UITextField *) textField{
    DLog(@"------%@-----",textField.text);
    if (textField.tag == 0) {
        [dic setObject:textField.text forKey:@"name"];
    }
    else if (textField.tag == arr.count -1) {
        [dic setObject:textField.text forKey:@"mail"];
    }
    else if (textField.tag == arr.count -2) {
        [dic setObject:textField.text forKey:@"job"];
    }
    else if (textField.tag == arr.count -3) {
        [dic setObject:textField.text forKey:@"company"];
    }
    else {
        if (textField.tag <= self.modifyModel.mobileList.count) {
            changeArray = [NSMutableArray arrayWithArray:self.modifyModel.mobileList];
            DLog(@"======%@",changeArray);
            [changeArray removeObjectAtIndex:textField.tag-1];
            NSMutableDictionary *dictionary = [NSMutableDictionary dictionaryWithCapacity:100];
            [dictionary setObject:textField.text forKey:@"mobile"];
            [dictionary setObject:arr[textField.tag] forKey:@"mobileType"];
            [changeArray addObject:dictionary];
            DLog(@"===========%@",changeArray);
            [dic setObject:changeArray forKey:@"mobileList"];
        }else{
            detectionPhone = textField.text;
            changeArray = [NSMutableArray arrayWithArray:self.modifyModel.mobileList];
            NSMutableDictionary *dictionary = [NSMutableDictionary dictionaryWithCapacity:100];
            [dictionary setObject:textField.text forKey:@"mobile"];
            [dictionary setObject:mutableArray[select] forKey:@"mobileType"];
            [changeArray addObject:dictionary];
            [dic setObject:changeArray forKey:@"mobileList"];
        }
        changeArray = [NSMutableArray arrayWithArray:self.modifyModel.mobileList];
    }
}
-(void) textFieldDidBeginEditing:(UITextField *)textField
{
    if(textField.tag > 0 && textField.tag < arr.count -3){
         textField.keyboardType = UIKeyboardTypeNumberPad;
    }
}
- (void)remind:(NSString *)str {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:str preferredStyle:  UIAlertControllerStyleAlert];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"知道了" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        //点击按钮的响应事件；
        DLog(@"执行删除");
    }]];
    [self presentViewController:alert animated:true completion:nil];
}
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        if (tableView == table) {
            [arr removeObjectAtIndex:indexPath.row];
            changeArray = [NSMutableArray arrayWithArray:self.modifyModel.mobileList];
            [changeArray removeObjectAtIndex:indexPath.row-1];
            [dic setObject:changeArray forKey:@"mobileList"];
            [table beginUpdates];
            [table deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
            [table endUpdates];
        }
    }
}
// 指定哪一行可以编辑 哪行不能编辑
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row >1 && indexPath.row <= arr.count-4) {
        return YES;
    }
    return NO;
}

- (void)choose:(UIButton *)button {
     if (button.tag >10 && button.tag <= arr.count-4-10) {
         QMUIDialogSelectionViewController *dialogViewController = [[QMUIDialogSelectionViewController alloc] init];
         dialogViewController.title = @"";
         dialogViewController.items = [mutableArray copy];
         [dialogViewController addCancelButtonWithText:@"取消" block:nil];
         [dialogViewController addSubmitButtonWithText:@"确定" block:^(QMUIDialogViewController *aDialogViewController) {
             QMUIDialogSelectionViewController *dialogSelectionViewController = (QMUIDialogSelectionViewController *)aDialogViewController;
             if (dialogSelectionViewController.selectedItemIndex == QMUIDialogSelectionViewControllerSelectedItemIndexNone) {
                 [QMUITips showError:@"请至少选一个" inView:self.view hideAfterDelay:1.0];
                 return;
             }
             NSString *resultString = dialogSelectionViewController.items[dialogSelectionViewController.selectedItemIndex];
             UIButton *cell = (UIButton *)[self.view viewWithTag:button.tag];
             [cell setTitle:resultString forState:UIControlStateNormal];
             select = dialogSelectionViewController.selectedItemIndex;
             [aDialogViewController hideWithAnimated:YES completion:^(BOOL finished) {
             }];
         }];
         [dialogViewController show];
     }
}

- (void)addPhone {
    if (arr.count < 9) {
        [arr insertObject:@"手机" atIndex:arr.count-3];
        [array insertObject:@"" atIndex:arr.count-4];
        [table reloadData];
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
