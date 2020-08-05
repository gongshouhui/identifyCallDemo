//
//  YSPhoneAddressBookViewController.m
//  YaSha-iOS
//
//  Created by YaSha_Tom on 2018/1/29.
//  Copyright © 2018年 亚厦装饰股份有限公司. All rights reserved.
//

#import "YSPhoneAddressBookViewController.h"
#import "YSPhoneAddressBookTableViewCell.h"
#import <AddressBook/AddressBook.h>
#import <AddressBookUI/AddressBookUI.h>
#import "YSPhoneAddressBookModel.h"
#import "NSString+PinYin.h"
#import "YSSearchViewController.h"
#import "YSInformationViewController.h"
#import "YSAddressBookInformationViewController.h"
#import "YSSingleton.h"



@interface YSPhoneAddressBookViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    NSMutableArray *dataSource;
    NSMutableArray *userSource;
    NSMutableArray *numarr1;
    NSMutableDictionary *dic1;
    UITableView *table;
    NSMutableArray *contactArray;
}

@end

@implementation YSPhoneAddressBookViewController

- (void)viewWillAppear:(BOOL)animated{
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@""]];
    self.edgesForExtendedLayout = UIRectEdgeNone;
}

- (void)initSubviews {
    [super initSubviews];
    contactArray = [NSMutableArray arrayWithCapacity:100];
    self.navigationController.navigationBar.translucent = NO;
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"手机通讯录";
    [self addressBook];
    [self sort];
    [self table];
}

- (void)textName:(nameBlock)block{
    self.blockName = block;
}

- (void)textPhine:(phoneBlock)block{
    self.blockPhone = block;
}

- (void)table {
    QMUIButton *button = [QMUIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(10*kWidthScale, 5, 355*kWidthScale, 30*kHeightScale);
    button.layer.masksToBounds = YES;
    button.layer.cornerRadius = 5;
    button.backgroundColor = kUIColor(247, 246, 245, 1);
    [button setTitle:@"找人" forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:@"放大镜"] forState:UIControlStateNormal];
    button.imagePosition = QMUIButtonImagePositionLeft;
    button.adjustsImageWhenDisabled = 4;
    button.titleLabel.font = [UIFont systemFontOfSize:14];
    [button setTitleColor:[UIColor colorWithRed:128.0/255.0 green:128.0/255.0 blue:128.0/255.0 alpha:1.0] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(choose) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    table = [[UITableView alloc]initWithFrame:CGRectMake(0, 44*kHeightScale, kSCREEN_WIDTH , kSCREEN_HEIGHT-64-44*kHeightScale) style:UITableViewStyleGrouped];
    table.dataSource = self;
    table.delegate = self;
    table.rowHeight = 48*kHeightScale;
    [self.view addSubview:table];
}
- (void)choose{
    YSSearchViewController * search = [[YSSearchViewController alloc]init];
    search.searchNumber = 4;
    search.data = contactArray;
    [self.navigationController pushViewController:search animated:YES];
}
#pragma mark - 设置section的行数
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return userSource.count;
}
#pragma mark - 设置每个section里的行数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSDictionary *dic = [userSource objectAtIndex:section];
    NSArray *array = [[dic allValues] firstObject];
    return array.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *inde = @"cell";
    YSPhoneAddressBookTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:inde];
    if (cell == nil) {
        cell = [[YSPhoneAddressBookTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:inde];
    }
    cell.selectionStyle =  UITableViewCellSelectionStyleNone;
    NSDictionary *dic = [userSource objectAtIndex:indexPath.section];
    NSArray *arr = [[dic allValues] lastObject];
    NSArray *array = [arr objectAtIndex:indexPath.row];
    NSString *name = @"";
    NSString *tel = @"";
    if (array.count != 1){
        if ([[array objectAtIndex:0] isEqualToString:@"无"]){
            tel = [array objectAtIndex:1];
        }else{
            name = [array objectAtIndex:0];
            tel = [array objectAtIndex:1];
        }
    }else{
        name = [array lastObject];
    }
    cell.namelabel.text = name;
    cell.namelabel.textColor = kUIColor(51, 51, 51, 1);
    cell.namelabel.font = [UIFont systemFontOfSize:15];
    cell.detailTextLabel.backgroundColor = [UIColor redColor];
    cell.telLabel.text = [[YSUtility replaceStr:tel] stringByReplacingOccurrencesOfString:@"-" withString:@""];
    cell.headLabel.text = [name substringToIndex:1];
    YSPhoneAddressBookModel *model = [[YSPhoneAddressBookModel alloc]init];
    model.name = name;
    model.tel = [[YSUtility replaceStr:tel]  stringByReplacingOccurrencesOfString:@"-" withString:@""];
    [contactArray addObject:model];
    return cell;
}
#pragma mark - 设置section的头部高度
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 25*kHeightScale;
}
#pragma mark - 设置section的尾部高度
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.5;
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    //获得联系人被分为多少组
    NSDictionary *dic = [userSource objectAtIndex:section];
    NSNumber *num = [[dic allKeys] lastObject];
    char *a = (char *)malloc(2);
    sprintf(a, "%c", [num charValue]);
    NSString *str = [[NSString alloc] initWithUTF8String:a];
    UIView *view = [[UIView alloc]init];
    view.frame = CGRectMake(0, 0, kSCREEN_WIDTH, 25*kHeightScale);
    UILabel *label = [[UILabel alloc]init];
    label.frame = CGRectMake(20*kHeightScale, 0, 200*kWidthScale, 25*kHeightScale);
    label.text = str;
    [view addSubview:label];
    return view;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    YSPhoneAddressBookTableViewCell * cell = (YSPhoneAddressBookTableViewCell *)[table cellForRowAtIndexPath:indexPath];//即为要得到的cell
    if ([self.source isEqualToString:@"添加"]) {
        if (self.blockName != nil||self.blockPhone != nil) {
            self.blockName(cell.namelabel.text);
            self.blockPhone(cell.telLabel.text);
        }
        [self.navigationController popViewControllerAnimated:YES];
    }else{
        
        YSAddressBookInformationViewController *information = [[YSAddressBookInformationViewController alloc]init];
        [YSSingleton getData].name = cell.namelabel.text;
        [YSSingleton getData].phone = cell.telLabel.text;
        [self.navigationController pushViewController:information animated:YES];
    }
}
#pragma mark - 索引
- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView {
    NSMutableArray *array = [[NSMutableArray alloc] init];
    //便立构造器
    for (NSDictionary *dic in userSource)
    {
        //将取出来的数据封装成NSNumber类型
        NSNumber *num = [[dic allKeys] lastObject];
        //给a开空间，并且强转成char类型
        char *a = (char *)malloc(2);
        //将num里面的数据取出放进a里面
        sprintf(a, "%c", [num charValue]);
        //把c的字符串转换成oc字符串类型
        NSString *str = [[NSString alloc]initWithUTF8String:a];
        [array addObject:str];
    }
    
    return array;
}

#pragma mark - 获取通讯录里联系人姓名和手机号
- (void)addressBook {
    dataSource = [[NSMutableArray alloc]init];
    //新建一个通讯录类
    ABAddressBookRef addressBook = nil;
    
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 6.0) {
        addressBook =  ABAddressBookCreateWithOptions(NULL, NULL);
        //获取通讯录权限
        dispatch_semaphore_t sema = dispatch_semaphore_create(0);
        
        ABAddressBookRequestAccessWithCompletion(addressBook, ^(bool granted, CFErrorRef error){dispatch_semaphore_signal(sema);});
        
        dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);
    }else{
        CFErrorRef* error=nil;
        addressBook = ABAddressBookCreateWithOptions(NULL, error);
    }
    //获取通讯录中的所有人
    CFArrayRef allPeople = ABAddressBookCopyArrayOfAllPeople(addressBook);
    //通讯录中人数
    CFIndex numberPeople = ABAddressBookGetPersonCount(addressBook);
    for (NSInteger i = 0; i < numberPeople; i++) {
        YSPhoneAddressBookModel *model = [[YSPhoneAddressBookModel alloc]init];
        //获取个人
        ABRecordRef person = CFArrayGetValueAtIndex(allPeople, i);
        //获取个人名字
        CFTypeRef abName = ABRecordCopyValue(person, kABPersonFirstNameProperty);
        CFTypeRef abLastName = ABRecordCopyValue(person, kABPersonLastNameProperty);
        CFStringRef abFullName = ABRecordCopyCompositeName(person);
        NSString *nameString = (__bridge NSString *)abName;
        NSString *lastNameString = (__bridge NSString *)abLastName;
        
        if ((__bridge id)abFullName != nil) {
            nameString = (__bridge NSString *)abFullName;
        }else {
            if ((__bridge id)abLastName != nil){
                nameString = [NSString stringWithFormat:@"%@ %@", nameString, lastNameString];
            }
        }
        model.name = nameString;
        ABPropertyID multiProperties[] = {
            kABPersonPhoneProperty,
            kABPersonEmailProperty
        };
        NSInteger multiPropertiesTotal = sizeof(multiProperties) / sizeof(ABPropertyID);
        for (NSInteger j = 0; j < multiPropertiesTotal; j++) {
            ABPropertyID property = multiProperties[j];
            ABMultiValueRef valuesRef = ABRecordCopyValue(person, property);
            NSInteger valuesCount = 0;
            if (valuesRef != nil) valuesCount = ABMultiValueGetCount(valuesRef);
            
            if (valuesCount == 0) {
                CFRelease(valuesRef);
                continue;
            }
            //获取电话号码和email
            for (NSInteger k = 0; k < valuesCount; k++) {
                CFTypeRef value = ABMultiValueCopyValueAtIndex(valuesRef, k);
                switch (j) {
                    case 0: {// Phone number
                        model.tel = (__bridge NSString*)value;
                        DLog(@"%@",model.tel);
                        break;
                    }
                }
                CFRelease(value);
            }
            CFRelease(valuesRef);
        }
        //将个人信息添加到数组中，循环完成后addressBookTemp中包含所有联系人的信息
        [dataSource addObject:model];
        
        if (abName) CFRelease(abName);
        if (abLastName) CFRelease(abLastName);
        if (abFullName) CFRelease(abFullName);
    }
    
}
#pragma mark - 将通讯录里的联系人进行排序
- (void)sort {
    userSource = [[NSMutableArray alloc] init];
    for (char i = 'A'; i<='Z'; i++)
    {
        NSMutableArray *numarr = [[NSMutableArray alloc] init];
        NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
        for (int j=0; j<dataSource.count; j++)
        {
            YSPhoneAddressBookModel *model = [dataSource objectAtIndex:j];
            //获取姓名首位
            NSString *string = [model.name substringWithRange:NSMakeRange(0, 1)];
            //将姓名首位转换成NSData类型
            NSData *data = [string dataUsingEncoding:NSUTF8StringEncoding];
            //data的长度大于等于3说明姓名首位是汉字
            if (data.length >=3)
            {
                NSString *a = [model.name   getFirstLetter];
                //                //将小写字母转成大写字母
                //                char b = a-32;
                NSString *c = [NSString stringWithFormat:@"%c",i];
                if ([a isEqual:c]){
                    NSMutableArray *array = [[NSMutableArray alloc] init];
                    [array addObject:model.name];
                    if (model.tel != nil){
                        [array addObject:model.tel];
                    }
                    [numarr addObject:array];
                    [dic setObject:numarr forKey:[NSNumber numberWithChar:i]];
                }
            }else{
                //data的长度等于1说明姓名首位是字母或者数字
                if (data.length == 1){
                    //判断姓名首位是否位小写字母
                    NSString * regex = @"^[a-z]$";
                    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
                    BOOL isMatch = [pred evaluateWithObject:string];
                    if (isMatch == YES){
                        //DLog(@"这是小写字母");
                        
                        //把大写字母转换成小写字母
                        char j = i+32;
                        //数据封装成NSNumber类型
                        NSNumber *num = [NSNumber numberWithChar:j];
                        //给a开空间，并且强转成char类型
                        char *a = (char *)malloc(2);
                        //将num里面的数据取出放进a里面
                        sprintf(a, "%c", [num charValue]);
                        //把c的字符串转换成oc字符串类型
                        NSString *str = [[NSString alloc]initWithUTF8String:a];
                        if ([string isEqualToString:str]){
                            NSMutableArray *array = [[NSMutableArray alloc] init];
                            [array addObject:model.name];
                            if (model.tel != nil){
                                [array addObject:model.tel];
                            }
                            [numarr addObject:array];
                            [dic setObject:numarr forKey:[NSNumber numberWithChar:i]];
                        }
                    }else{
                        //判断姓名首位是否为大写字母
                        NSString * regexA = @"^[A-Z]$";
                        NSPredicate *predA = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regexA];
                        BOOL isMatchA = [predA evaluateWithObject:string];
                        if (isMatchA == YES){
                            //DLog(@"这是大写字母");
                            //
                            NSNumber *num = [NSNumber numberWithChar:i];
                            //给a开空间，并且强转成char类型
                            char *a = (char *)malloc(2);
                            //将num里面的数据取出放进a里面
                            sprintf(a, "%c", [num charValue]);
                            //把c的字符串转换成oc字符串类型
                            NSString *str = [[NSString alloc]initWithUTF8String:a];
                            if ([string isEqualToString:str]){
                                
                                NSMutableArray *array = [[NSMutableArray alloc] init];
                                [array addObject:model.name];
                                if (model.tel != nil){
                                    [array addObject:model.tel];
                                }
                                [numarr addObject:array];
                                [dic setObject:numarr forKey:[NSNumber numberWithChar:i]];
                            }
                        }
                    }
                }
            }
        }
        if (dic.count != 0){
            [userSource addObject:dic];
        }
    }
    char n = '#';
    int cont = 0;
    for (int j=0; j<dataSource.count; j++){
        YSPhoneAddressBookModel *model = [dataSource objectAtIndex:j];
        //获取姓名的首位
        NSString *string = [model.name substringWithRange:NSMakeRange(0, 1)];
        //将姓名首位转化成NSData类型
        NSData *data = [string dataUsingEncoding:NSUTF8StringEncoding];
        //判断data的长度是否小于3
        if (data.length < 3){
            if (cont == 0){
                dic1 = [[NSMutableDictionary alloc] init];
                numarr1 = [[NSMutableArray alloc] init];
                cont++;
            }
            if (data.length == 1){
                //判断首位是否为数字
                NSString * regexs = @"^[0-9]$";
                NSPredicate *preds = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regexs];
                BOOL isMatch = [preds evaluateWithObject:string];
                if (isMatch == YES){
                    //如果姓名为数字
                    NSMutableArray *array = [[NSMutableArray alloc] init];
                    [array addObject:model.name];
                    if (model.tel != nil){
                        [array addObject:model.tel];
                    }
                    
                    [numarr1 addObject:array];
                    [dic1 setObject:numarr1 forKey:[NSNumber numberWithChar:n]];
                }
            }else{
                //如果姓名为空
                NSMutableArray *array = [[NSMutableArray alloc] init];
                model.name = @"无";
                [array addObject:model.name];
                if (model.tel != nil){
                    [array addObject:model.tel];
                    [numarr1 addObject:array];
                    [dic1 setObject:numarr1 forKey:[NSNumber numberWithChar:n]];
                }
            }
        }
    }
    
    if (dic1.count != 0){
        [userSource addObject:dic1];
    }
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
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
