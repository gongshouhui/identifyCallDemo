//
//  YSAddPeopleViewController.m
//  YaSha-iOS
//
//  Created by YaSha_Tom on 2018/1/29.
//  Copyright © 2018年 亚厦装饰股份有限公司. All rights reserved.
//

#import "YSAddPeopleViewController.h"
#import "YSAddPeopleTableViewCell.h"
#import "ActionSheetPicker.h"
#import "YSPhoneAddressBookViewController.h"
#import "YSExternalViewController.h"
#import "YSSddressBookViewController.h"

@interface YSAddPeopleViewController ()<UITableViewDataSource,UITableViewDelegate,UITextViewDelegate,UIGestureRecognizerDelegate,UITextFieldDelegate>{
    UITableView *table;
    NSMutableArray *arr;
    NSMutableArray *remindArr;
    
    UITextView *textview;//意见
    NSString *string;
    UILabel*lab;
    NSArray *mutableArray;
    NSIndexPath * indexPaths;
    NSMutableDictionary *dataDit;
    NSMutableArray *mobileArr;
    NSInteger select;
    NSString *name;
    NSString *phone;
    NSString *address;
    NSString *detectionPhone;
    NSString *email;
    YSSingleton *si;
    
}

@end

@implementation YSAddPeopleViewController

- (void)initSubviews {
    [super initSubviews];
    DLog(@"=====%@=======%@",self.addName,self.Phone);
    phone = [self.Phone stringByReplacingOccurrencesOfString:@" " withString:@""];
    detectionPhone = phone;
    name = self.addName;
    si = [YSSingleton getData];
    self.view.backgroundColor = [UIColor whiteColor];
    dataDit = [NSMutableDictionary dictionaryWithCapacity:100];
    mobileArr = [NSMutableArray arrayWithCapacity:100];
    self.title = @"添加人员";
    mutableArray = @[@"手机",@"住宅",@"单位"];
    arr = [NSMutableArray arrayWithObjects:@"姓名",@"手机",@"公司",@"职位",@"邮箱", nil];
    remindArr = [NSMutableArray arrayWithObjects:@"联系人姓名",@"联系人手机号码(必填)",@"公司名称",@"职位名称",@"联系人邮箱", nil];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"保存" style:UIBarButtonItemStylePlain target:self action:@selector(submit)];
    [self table];
}
- (void)submit{
    
    if ([self.addStr isEqualToString:@"通讯录"]) {
        if ([detectionPhone isEqual:phone]) {
            NSMutableDictionary *dictionary = [NSMutableDictionary dictionaryWithCapacity:100];
            [dictionary setObject:phone forKey:@"mobile"];
            [dictionary setObject:@"手机"forKey:@"mobileType"];
            [mobileArr addObject:dictionary];
            [dataDit setObject:mobileArr forKey:@"mobileList"];
        }
        [dataDit setObject:name forKey:@"name"];
        [dataDit setObject:@3 forKey:@"type"];
        address = addCommonPerson ;
    }else{
        DLog(@"------%@",detectionPhone);
        if ([YSUtility isPhomeNumber:detectionPhone]) {
            NSMutableDictionary *dictionary = [NSMutableDictionary dictionaryWithCapacity:100];
            [dictionary setObject:detectionPhone forKey:@"mobile"];
            [dictionary setObject:@"手机"forKey:@"mobileType"];
            [mobileArr addObject:dictionary];
            [dataDit setObject:mobileArr forKey:@"mobileList"];
            [dataDit setObject:name forKey:@"name"];
            address = updateOrAddOuter ;
        }
    }
    if (![YSUtility isPhomeNumber:detectionPhone]) {
        [self remind:@"请输入正确的手机号"];
    }
    if(![YSUtility isEmail:email] && ![email isEqual:@"(null)"] && email != nil){
        [self remind:@"请输入正确的邮箱"];
    }
    if(dataDit[@"name"] != nil && [YSUtility isPhomeNumber:detectionPhone] &&(email == nil || [YSUtility isEmail:email]) ){
        [self getServeManager];
    }
}
-(void)getServeManager
{
    [YSNetManager ys_request_POSTWithUrlString:[NSString stringWithFormat:@"%@%@",YSDomain, address]  isNeedCache:NO parameters:dataDit successBlock:^(id response) {
        DLog(@"%@",response);
        if ([response[@"data"] integerValue] == 0) {
            [QMUITips showError:response[@"msg"] inView:self.view hideAfterDelay:1];
        }else{
            si.cacheBool = @"No";
            if ([self.addStr isEqualToString:@"通讯录"]) {
                [self.navigationController popToRootViewControllerAnimated:YES];
            }
            for (UIViewController *controller in self.rt_navigationController.rt_viewControllers) {
                if ([controller isKindOfClass:[YSExternalViewController class]]) {
                    [self.navigationController popToViewController:controller animated:YES];
                }
            }
        }
    } failureBlock:^(NSError *error) {
        
    } progress:nil];
}

- (void)table{
    table = [[UITableView alloc]initWithFrame:[UIScreen mainScreen].bounds style:UITableViewStyleGrouped];
    table.delegate = self;
    table.dataSource = self;
    table.rowHeight = 48*BIZ;
    [self.view addSubview:table];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return arr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.01;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return nil;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *inde = @"cell";
    YSAddPeopleTableViewCell  *cell = [tableView dequeueReusableCellWithIdentifier:inde];
    if (cell == nil) {
        cell = [[YSAddPeopleTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:inde];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell.titleBtn setTitle:arr[indexPath.row] forState:UIControlStateNormal];
    cell.content.placeholder = remindArr[indexPath.row];
    if (indexPath.row == 0) {
        if (name != nil) {
            cell.content.text = name;
        }
    }
    if (indexPath.row == 1) {
        if (phone != nil ) {
            cell.content.text = phone;
        }
    }
    cell.content.delegate = self;
    cell.titleBtn.tag = indexPath.row;
    cell.content.tag = indexPath.row+10;
    [cell.content addTarget:self action:@selector(onChange:) forControlEvents:UIControlEventEditingChanged];// 可在自定义selector处理
    [cell.titleBtn addTarget:self action:@selector(choose:) forControlEvents:UIControlEventTouchUpInside];
    //    if (indexPath.row == 0) {
    //        if ([self.addStr isEqualToString:@"通讯录"]) {
    //
    //        }else{
    //            UIButton *button = [[UIButton alloc]init];
    //            [button setImage:[UIImage imageNamed:@"通讯录b"] forState:UIControlStateNormal];
    //            [button addTarget:self action:@selector(addressBook) forControlEvents:UIControlEventTouchUpInside];
    //            [cell addSubview:button];
    //            [button mas_makeConstraints:^(MASConstraintMaker *make) {
    //                make.top.mas_equalTo(cell.mas_top).offset(15*BIZ);
    //                make.right.mas_equalTo(cell.mas_right).offset(-24*BIZ);
    //                make.size.mas_equalTo(CGSizeMake(16*BIZ, 16*BIZ));
    //            }];
    //            [cell.img removeFromSuperview];
    //        }
    //    }
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
            make.top.mas_equalTo(cell.mas_top).offset(15);
            make.right.mas_equalTo(cell.mas_right).offset(-24);
            make.size.mas_equalTo(CGSizeMake(16*kWidthScale, 16*kWidthScale));
        }];
    }
    return cell;
}
//监听textFiled文本文字的变化
- (void)onChange:(UITextField *)textField {
    if ([textField.placeholder isEqualToString:@"联系人姓名"]) {
        name = textField.text;
    }else if([textField.placeholder isEqualToString:@"公司名称"]){
        [dataDit setObject:textField.text forKey:@"company"];
        
    }else if([textField.placeholder isEqualToString:@"职位名称"]){
        [dataDit setObject:textField.text forKey:@"job"];
        
    }else if([textField.placeholder isEqualToString:@"联系人邮箱"]){
        [dataDit setObject:textField.text forKey:@"mail"];
        email = textField.text;
    }else{
        if (textField.tag == 11) {
            detectionPhone = textField.text;
        }
        if (textField.text.length == 11) {
            if ([YSUtility isPhomeNumber:textField.text] && textField.tag != 11) {
                NSMutableDictionary *dictionary = [NSMutableDictionary dictionaryWithCapacity:100];
                [dictionary setObject:textField.text forKey:@"mobile"];
                [dictionary setObject:mutableArray[select] forKey:@"mobileType"];
                [mobileArr addObject:dictionary];
                [dataDit setObject:mobileArr forKey:@"mobileList"];
            }
        }
    }
    
}
//键盘消失
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [table endEditing:YES];
}

- (void)remind:(NSString *)str {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:str preferredStyle:  UIAlertControllerStyleAlert];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"知道了" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        //点击按钮的响应事件；
        DLog(@"执行删除");
    }]];
    [self presentViewController:alert animated:true completion:nil];
}
- (void)textFieldDidBeginEditing:(UITextField *)textField {
    if ([textField.placeholder isEqualToString:@"联系人手机号码(必填)"] ||[textField.placeholder isEqualToString:@"联系人手机号码(可删除)"]) {
        textField.keyboardType = UIKeyboardTypeNumberPad;
    }
}
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        if (tableView == table) {
            [arr removeObjectAtIndex:indexPath.row];
            [remindArr removeObjectAtIndex:indexPath.row];
            [table beginUpdates];
            [table deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
            [table endUpdates];
        }
    }
}
// 指定哪一行可以编辑 哪行不能编辑
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row >1 && indexPath.row <= arr.count-4) {
        return YES;
    }
    return NO;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    DLog(@"跳转到通讯录");
    //    if (indexPath.row == 0) {
    //        YSPhoneAddressBookViewController *phoneAddressBook = [[YSPhoneAddressBookViewController alloc]init];
    //        phoneAddressBook.blockPhone = ^(NSString *str){
    //            DLog(@"======%@",[YSUtility replaceStr:str]);
    //            phone = [[YSUtility replaceStr:str] stringByReplacingOccurrencesOfString:@"-" withString:@""];
    //            detectionPhone = phone;
    //            [table reloadData];
    //        };
    //        phoneAddressBook.blockName = ^(NSString *str){
    //            name = str;
    //            [table reloadData];
    //        };
    //        phoneAddressBook.source = @"添加";
    //        [self.navigationController pushViewController:phoneAddressBook animated:YES];
    //    }
}

- (void)choose:(UIButton *)button {
    if (button.tag >0 && button.tag <= arr.count-4) {
        QMUIDialogSelectionViewController *dialogViewController = [[QMUIDialogSelectionViewController alloc] init];
        dialogViewController.title = @"";
        dialogViewController.items = [mutableArray copy];
        [dialogViewController addCancelButtonWithText:@"取消" block:nil];
        [dialogViewController addSubmitButtonWithText:@"确定" block:^(QMUIDialogViewController *aDialogViewController) {
            QMUIDialogSelectionViewController *dialogSelectionViewController = (QMUIDialogSelectionViewController *)aDialogViewController;
            if (dialogSelectionViewController.selectedItemIndex == QMUIDialogSelectionViewControllerSelectedItemIndexNone) {
                [QMUITips showError:@"请至少选一个" inView:self.view hideAfterDelay:1.2];
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
        [arr insertObject:@"手机" atIndex:arr.count-4];
        [remindArr insertObject:@"联系人手机号码(可删除)" atIndex:arr.count-4];
        [table reloadData];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
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
