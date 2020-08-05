//
//  YSInformationViewController.m
//  YaSha-iOS
//
//  Created by mHome on 2016/11/29.
//  Copyright © 2016年 方鹏俊. All rights reserved.
//

#import "YSInformationViewController.h"
#import "YSModifyViewController.h"
#import "YSModifyViewController.h"
#import "YSSddressBookViewController.h"
#import "YSDataManager.h"
#import "YSInformationModel.h"
#import "YSExternalViewController.h"
#import "UIImage+GIF.h"
#import "YSInfoTableViewCell.h"
#import <MessageUI/MessageUI.h>
#import "YSAddressBookHelper.h"

@interface YSInformationViewController ()<UITableViewDelegate, UITableViewDataSource, UINavigationControllerDelegate, MFMessageComposeViewControllerDelegate, QMUIImagePreviewViewDelegate,UINavigationControllerDelegate>

{
    NSArray *arr;
    NSArray *array;
    UIButton *optionsButton;
    NSArray *itemsArray;
    UIView *showview;
    YSInformationModel *model;
    NSArray *dataArray;
    UIButton *btn;//添加到常用联系人
    YSSingleton *si;
    
}

@property (nonatomic, strong) QMUIPopupMenuView *popupMenuView;
@property (nonatomic, strong) UIButton *avatarButton;
@property (nonatomic, strong) QMUIImagePreviewViewController *imagePreviewViewController;
@property (nonatomic, strong) UIButton *rightButton;
@property (nonatomic, strong) UITableView *tableview;

@end

@implementation YSInformationViewController

/*
 self.number = 2 : 外部和常用联系人详情
 self.number = 3 : 内部联系人详情
 
 */
- (void)viewWillAppear:(BOOL)animated {
    if (self.number == 2) {
        [self getServeManager];
        [self setupPopMenu];
    }else if (self.number == 3){
        [self getInternalServeManager];
    }
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.translucent = NO;
    self.title = @"个人信息";
    self.view.backgroundColor = kUIColor(247, 247, 247, 1);
    si = [YSSingleton getData];
    self.navigationController.delegate = self;
    
    self.navigationController.navigationBar.titleTextAttributes = [NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor], NSForegroundColorAttributeName, [UIFont systemFontOfSize:18], NSFontAttributeName,nil];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"导航栏背景"]
                                                  forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage = [UIImage new];
    
    _rightButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
    [_rightButton addTarget:self action:@selector(options:) forControlEvents:UIControlEventTouchUpInside];
    
//    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"返回（white）"] style:UIBarButtonItemStylePlain target:self action:@selector(back)];
    
    
    switch (self.number) {
        case 2: {
            arr = @[@"公司",@"职位",@"邮箱"];
            if ([self.str isEqualToString:@"外部通讯录"]) {
                [_rightButton setImage:UIImageMake(@"点点点") forState:UIControlStateNormal];
                _rightButton.tag = 10;
                 self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:_rightButton];
                
            }else{
                [_rightButton setImage:UIImageMake(@"删除") forState:UIControlStateNormal];
                _rightButton.tag = 20;
                self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:_rightButton];
               
            }
            break;
        }
        case 3: {
            arr = @[@"工号",@"部门",@"岗位",@"个人手机",@"单位手机",@"短号",@"办公电话",@"办公地址",@"企业邮箱"];
            [_rightButton setTitle:@"关闭" forState:UIControlStateNormal];
            self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:_rightButton];
            break;
        }
    }
}

//- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
//    viewController.navigationItem.leftBarButtonItem.tintColor = [UIColor whiteColor];
//    viewController.navigationItem.rightBarButtonItem.tintColor = [UIColor whiteColor];
//}

- (void)back {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)creatTable {
    if (self.peopleModel.addbool == 1) {
        _tableview = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kSCREEN_WIDTH, kSCREEN_HEIGHT-kTopHeight) style:UITableViewStyleGrouped];
    }else{
        _tableview = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kSCREEN_WIDTH, kSCREEN_HEIGHT-(50*kHeightScale+kTopHeight)) style:UITableViewStyleGrouped];
    }
    _tableview.backgroundColor = kUIColor(247, 247, 247, 1);
    _tableview.delegate = self;
    _tableview.dataSource = self;
    _tableview.rowHeight = 48*kHeightScale;
    _tableview.bounces = NO;
    _tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableview.estimatedRowHeight = 0;
    _tableview.estimatedSectionHeaderHeight = 0;
    _tableview.estimatedSectionFooterHeight = 0;
    [self.view addSubview:_tableview];
}

- (void)getServeManager {
    NSString *url;
    if ([self.str isEqualToString:@"外部通讯录"] ){
        url = [NSString stringWithFormat:@"%@%@/%@/%@/%@",YSDomain, getCommonOrOuterPersons, self.id, @"2", @"out"];
    }else{
        if ([self.source isEqual:@"inner"]) {
            url = [NSString stringWithFormat:@"%@%@/%@/%@/%@",YSDomain, getCommonOrOuterPersons, self.id, @"1", @"2"];
        }else {
            url = [NSString stringWithFormat:@"%@%@/%@/%@/%@",YSDomain, getCommonOrOuterPersons, self.id, @"2", @"2"];
        }
    }
    [YSNetManager ys_request_GETWithUrlString:url isNeedCache:NO parameters:nil successBlock:^(id response) {
        DLog(@"========%@",response);
        array = [YSDataManager getExternalDetailsData:response];
        model = array[0];
        if ([self.str isEqual:@"外部通讯录"] && (![model.isCommon isEqual:@"1"])) {
            [self addButton];
        }
        [self creatTable];
    } failureBlock:^(NSError *error) {
        DLog(@"=========%@",error);
    } progress:nil];
}

//获取内部联系人详情
- (void)getInternalServeManager {
    NSString *url = [NSString stringWithFormat:@"%@%@/%@",YSDomain,getInnerPersons,self.id];
    [YSNetManager ys_request_GETWithUrlString:url isNeedCache:NO parameters:nil successBlock:^(id response) {
        DLog(@"=======%@",response);
        NSArray *arr1 = [YSDataManager getInternPeopleMemberData:response];
        YSInternalPeopleModel *internalModel = arr1[0];
        self.peopleModel = internalModel;
        if (self.peopleModel.addbool != 1 ) {
            [self addButton];
        }
        [self creatTable];
    } failureBlock:^(NSError *error) {
        DLog(@"=========%@",error);
    } progress:nil];
}

//添加常用联系人按钮
- (void)addButton {
    btn = [UIButton  buttonWithType:UIButtonTypeCustom];
    [btn setTitle:@"添加常用联系人" forState:UIControlStateNormal];
    btn.backgroundColor = kThemeColor;
    [btn addTarget:self action:@selector(addContent) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.view.mas_bottom);
        make.size.mas_equalTo(CGSizeMake(kSCREEN_WIDTH, 50*kHeightScale));
    }];
}

//添加常用联系人提交数据
- (void)addContent {
    switch (self.number) {
        case 1:
        {
            YSModifyViewController *modify = [[YSModifyViewController alloc]init];
            [self.navigationController pushViewController:modify animated:YES];
             break;
        }
        case 2:
        {
            NSString *strUrl = [[NSString alloc]init];
            strUrl = addOuterPersonToCommonPerson;
            [YSNetManager ys_request_POSTWithUrlString:[NSString stringWithFormat:@"%@%@/%@/%@",YSDomain,strUrl,model.id,@"out"] isNeedCache:NO parameters:nil successBlock:^(id response) {
                [QMUITips hideAllTipsInView:self.view];
                if ([response[@"data"] integerValue] == 1) {
                    [self showMessage:@"添加成功！"];
                }
            } failureBlock:^(NSError *error) {
                
            } progress:nil];
             break;
        }
        case 3:
        {
            NSString *strUrl = [[NSString alloc]init];
            strUrl = addInnerPersonToCommonPerson;
            [YSNetManager ys_request_POSTWithUrlString:[NSString stringWithFormat:@"%@%@/%@",YSDomain,strUrl,self.peopleModel.id ] isNeedCache:NO parameters:nil successBlock:^(id response) {
                [self showMessage:@"添加成功！"];
            } failureBlock:^(NSError *error) {
                DLog(@"========%@",error);
            } progress:nil];
            break;
        }
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    switch (self.number) {
        case 2:
            return 2;
            break;
        case 3:
            return 1;
            break;
    }
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    switch (self.number) {
        case 2:{
            if (section == 0) {
                return model.mobileList.count;
            }else{
                return arr.count;
            }
            break;
        }
        case 3:
            return arr.count;
            break;
    }
    return 0;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *inde = @"cell";
    YSInfoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:inde];
    if (cell == nil) {
        cell = [[YSInfoTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:inde];
        
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    UILabel *line = [[UILabel alloc]init];
    line.backgroundColor = kUIColor(247, 240, 247, 1);
    line.frame = CGRects(10, 47, 355, 1);
    [cell addSubview:line];
    if (self.number == 3) {
        cell.titleLabel.text = arr[indexPath.row];
        switch (indexPath.row) {
            case 0:
                cell.conterLabel.text =self.peopleModel.no;
                break;
            case 1:
                cell.conterLabel.text =self.peopleModel.deptName;
                break;
            case 2:
                cell.conterLabel.text =self.peopleModel.position;
                break;
            case 3:
                cell.conterLabel.text =self.peopleModel.selfMobile;
                cell.conterLabel.textColor = [UIColor blueColor];
                break;
            case 4:
                cell.conterLabel.text =self.peopleModel.companyMobile;
                cell.conterLabel.textColor = [UIColor blueColor];
                break;
            case 5:
                cell.conterLabel.text =self.peopleModel.shortPhone;
                cell.conterLabel.textColor = [UIColor blueColor];
                break;
            case 6:
                cell.conterLabel.text =self.peopleModel.phone;
                cell.conterLabel.textColor = [UIColor blueColor];
                break;
            case 7:
                cell.conterLabel.text =self.peopleModel.workAddress;
                break;
            case 8:
                cell.conterLabel.text =self.peopleModel.companyEmail;
                break;
        }
    } else{
        if (indexPath.section == 0) {
            cell.conterLabel.textColor =  [UIColor colorWithRed:42.0/255.0 green:138.0/255.0 blue:229.0/255.0 alpha:1.0];
            switch (indexPath.row) {
                case 0:
                    cell.titleLabel.text = model.mobileList[indexPath.row][@"mobileType"];
                    cell.conterLabel.text =model.mobileList[indexPath.row][@"mobile"];
                    break;
                case 1:
                    cell.titleLabel.text = model.mobileList[indexPath.row][@"mobileType"];
                    cell.conterLabel.text =model.mobileList[indexPath.row][@"mobile"];
                    break;
                case 2:
                    cell.titleLabel.text = model.mobileList[indexPath.row][@"mobileType"];
                    cell.conterLabel.text =model.mobileList[indexPath.row][@"mobile"];
                    break;
                case 3:
                    cell.titleLabel.text = model.mobileList[indexPath.row][@"mobileType"];
                    cell.conterLabel.text =model.mobileList[indexPath.row][@"mobile"];
                    break;
            }
        }else{
            cell.titleLabel.text = arr[indexPath.row];
            switch (indexPath.row) {
                case 0:
                    cell.conterLabel.text =model.company;
                    break;
                case 1:
                    cell.conterLabel.text =model.job;
                    break;
                case 2:
                    cell.conterLabel.text =model.mail;
                    break;
                case 3:
                    cell.conterLabel.text =model.mark;
                    break;
            }
        }
    }
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return 200*kHeightScale;
    }else{
        return 0.01;
    }
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        UIImageView *view = [[UIImageView alloc]init];
        view.frame = CGRectMake(0, 0, kSCREEN_WIDTH, 200*kHeightScale);
        view.backgroundColor = [UIColor whiteColor];
        view.userInteractionEnabled = YES;
        view.image = YSThemeManagerShare.currentTheme.themeContactBackgroundImage;
        
        _avatarButton = [[UIButton alloc] init];
        _avatarButton.layer.masksToBounds = YES;
        _avatarButton.layer.cornerRadius = 37*kWidthScale;
        [_avatarButton addTarget:self action:@selector(handleImageButtonEvent:) forControlEvents:UIControlEventTouchUpInside];
        if (self.peopleModel.headImage.length > 0){
            [_avatarButton sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", YSImageDomain, [YSUtility getAvatarUrlString:self.peopleModel.headImage]]] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"头像"]];
        } else {
            [_avatarButton setImage:[UIImage imageNamed:@"头像"] forState:UIControlStateNormal];
        }
        [view addSubview:_avatarButton];
        [_avatarButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(view.mas_centerX);
            make.top.mas_equalTo(view.mas_top).offset(15);
            make.size.mas_equalTo(CGSizeMake(74*kWidthScale, 74*kWidthScale));
        }];
        UILabel *label = [[UILabel alloc]init];
        if ([self.str isEqual:@"内部"]) {
            label.text = self.peopleModel.name;
        }else{
            label.text = model.name;
        }
        label.textColor = [UIColor whiteColor];
        label.adjustsFontSizeToFitWidth = YES;
        [view addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(view.mas_top).offset(93*kHeightScale);
            if (self.number == 3) {
                label.textAlignment = NSTextAlignmentCenter;
                make.left.mas_equalTo(view.mas_left).offset(156*kWidthScale);
            }else{
                label.textAlignment = NSTextAlignmentCenter;
                make.left.mas_equalTo(view.mas_left).offset(162*kWidthScale);
            }
            make.size.mas_equalTo(CGSizeMake(55*kWidthScale, 20*kWidthScale));
        }];
        
        if ([self.str isEqual:@"内部"]) {
            UIImageView *genderImg = [[UIImageView alloc]init];
            if ( ![self.peopleModel.sex isEqual:@"1"] ) {
                genderImg.image = [UIImage imageNamed:@"女性"];
            }else{
                genderImg.image = [UIImage imageNamed:@"男性"];
            }
            [view addSubview:genderImg];
            [genderImg mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(view.mas_top).offset(97*kHeightScale);
                make.left.mas_equalTo(label.mas_right).offset(0);
                make.size.mas_equalTo(CGSizeMake(15*kWidthScale, 15*kWidthScale));
            }];
        }
        if (self.number == 3) {
            NSArray *titleName = @[@"聊天",@"呼叫",@"短信"];
            NSArray *iamgeArray = @[@"聊天",@"呼叫",@"短信"];
            for (int  i = 0; i < 3; i++) {
                QMUIButton *chatButton = [QMUIButton buttonWithType:UIButtonTypeCustom];
                [chatButton setImage:[UIImage imageNamed:iamgeArray[i]] forState:UIControlStateNormal];
                [chatButton setTitle:titleName[i] forState:UIControlStateNormal];
                chatButton.backgroundColor = [UIColor clearColor];
                chatButton.titleLabel.font = [UIFont systemFontOfSize:14];
                chatButton.frame = CGRectMake((100 + 65*i)*kWidthScale, 120*kHeightScale, 40*kWidthScale, 60*kHeightScale);
                [chatButton addTarget:self action:@selector(chatEvent:) forControlEvents:UIControlEventTouchUpInside];
                chatButton.imagePosition = QMUIButtonImagePositionTop;
                chatButton.spacingBetweenImageAndTitle = 8;
                [chatButton setTitleColor:UIColorWhite forState:UIControlStateNormal];
                chatButton.tag = 40 + i;
                [view addSubview:chatButton];
            }
        }
        return view;
    }
    return 0;
}

- (void)handleImageButtonEvent:(UIButton *)button {
    if (!self.imagePreviewViewController) {
        self.imagePreviewViewController = [[QMUIImagePreviewViewController alloc] init];
        self.imagePreviewViewController.imagePreviewView.delegate = self;
        self.imagePreviewViewController.imagePreviewView.currentImageIndex = 0;
    }
    [self.imagePreviewViewController startPreviewFromRectInScreen:[_avatarButton convertRect:_avatarButton.imageView.frame toView:nil]];
}

#pragma mark - QMUIImagePreviewViewDelegate

- (NSUInteger)numberOfImagesInImagePreviewView:(QMUIImagePreviewView *)imagePreviewView {
    return 1;
}

- (void)imagePreviewView:(QMUIImagePreviewView *)imagePreviewView renderZoomImageView:(QMUIZoomImageView *)zoomImageView atIndex:(NSUInteger)index {
    zoomImageView.image = _avatarButton.imageView.image;
}

- (QMUIImagePreviewMediaType)imagePreviewView:(QMUIImagePreviewView *)imagePreviewView assetTypeAtIndex:(NSUInteger)index {
    return QMUIImagePreviewMediaTypeImage;
}

#pragma mark - QMUIZoomImageViewDelegate

- (void)singleTouchInZoomingImageView:(QMUIZoomImageView *)zoomImageView location:(CGPoint)location {
    [_avatarButton setImage:zoomImageView.image forState:UIControlStateNormal];
    [_imagePreviewViewController endPreviewToRectInScreen:[_avatarButton convertRect:_avatarButton.imageView.frame toView:nil]];
}

-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    YSInfoTableViewCell *cell = (YSInfoTableViewCell *) [_tableview cellForRowAtIndexPath:indexPath];
    if(indexPath.row >= 3&& indexPath.row < 7 && self.number == 3 && cell.conterLabel.text.length>2){
        //        [self remindBox:cell.conterLabel.text];
        NSString *str;
        switch (indexPath.row) {
            case 3:
                str =self.peopleModel.selfMobile;
                break;
            case 4:
                str =self.peopleModel.companyMobile;
                break;
            case 5:
                str =self.peopleModel.shortPhone;
                break;
            case 6:
                str =self.peopleModel.phone;
                break;
        }
        [self callPhone:str];
    }
    if (self.number == 2 &&  indexPath.row <= model.mobileList.count && indexPath.section == 0 && cell.conterLabel.text.length>2) {
        //        [self remindBox:cell.conterLabel.text];
        [self callPhone:model.mobileList[indexPath.row][@"mobile"]];
    }
}

- (void)callPhone:(NSString *)phone {
    DLog(@"拨打电话");
    NSString *callPhone = [NSString stringWithFormat:@"telprompt://%@", phone];
    NSString *versionPhone = [[UIDevice currentDevice] systemVersion];
    if ([versionPhone compare:@"10.0"options:NSNumericSearch] ==NSOrderedDescending || [versionPhone compare:@"10.0"options:NSNumericSearch] ==NSOrderedSame) {
        /// 大于等于10.0系统使用此openURL方法
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:callPhone] options:@{}completionHandler:nil];
    }else{
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:callPhone]];
    }
}

//将手机号码添加到手机通讯录中
- (void)remindBox:(NSString *)str{
    NSString *phone = str;
    if ([YSUtility isPhomeNumber:str]) {
        if ([YSAddressBookHelper existPhone:phone] == ABHelperExistSpecificContact)
        {
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"消息提示" message:[NSString stringWithFormat:@"手机号码：%@已存在通讯录",str] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alert show];
        }else{
            QMUIAlertAction *action1 = [QMUIAlertAction actionWithTitle:@"取消" style:QMUIAlertActionStyleCancel handler:^(QMUIAlertAction *action) {
            }];
            QMUIAlertAction *action2 = [QMUIAlertAction actionWithTitle:@"确定" style:QMUIAlertActionStyleDestructive handler:^(QMUIAlertAction *action) {
                DLog(@"前往更新");
                [YSAddressBookHelper addContactName:self.peopleModel.name phoneNum:str withLabel:@"工作"];
                
            }];
             DLog(@"currentThread------%@",[NSThread currentThread]);
            QMUIAlertController *alertController = [QMUIAlertController alertControllerWithTitle:@"提示" message:@"是否将号码添加到手机通讯录中" preferredStyle:QMUIAlertControllerStyleAlert];
            [alertController addAction:action1];
            [alertController addAction:action2];
            [alertController showWithAnimated:YES];
        }
    }
}
- (void)chatEvent:(UIButton *)btnTag {
    
    if (btnTag.tag == 40) {
      [QMUITips showError:@"暂不可用" inView:self.view hideAfterDelay:1];
    }else if(btnTag.tag == 41){
        if (self.peopleModel.selfMobile.length > 0) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel://%@",self.peopleModel.selfMobile]]];
        }else{
            [QMUITips showError:@"当前无可用电话号码" inView:self.view hideAfterDelay:1];
        }
    }else{
        if (self.peopleModel.selfMobile.length > 0) {
            [self showMessageView:[NSArray arrayWithObjects:self.peopleModel.selfMobile, nil] title:@"消息" body:@""];
        }else{
             [QMUITips showError:@"当前无可用电话号码" inView:self.view hideAfterDelay:1];
        }
    }
}
- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result {
    [self dismissViewControllerAnimated:YES completion:^{
        switch (result) {
            case MessageComposeResultSent:
                //信息传送成功
                [QMUITips showSucceed:@"发送成功" inView:self.view hideAfterDelay:1];
                break;
            case MessageComposeResultFailed:
                //信息传送失败
                [QMUITips showError:@"发送失败,请重试" inView:self.view hideAfterDelay:1];
                break;
            case MessageComposeResultCancelled:
                //信息被用户取消传送
                [QMUITips showInfo:@"取消发送" inView:self.view hideAfterDelay:1];
                break;
         
        }
    }];
}
- (void)showMessageView:(NSArray *)phones title:(NSString *)title body:(NSString *)body
{
    if( [MFMessageComposeViewController canSendText] )
    {
        MFMessageComposeViewController * controller = [[MFMessageComposeViewController alloc] init];
        controller.recipients = phones;
        controller.navigationBar.tintColor = [UIColor redColor];
        controller.body = body;
        controller.messageComposeDelegate = self;
        [self presentViewController:controller animated:YES completion:nil];
        [[[[controller viewControllers] lastObject] navigationItem] setTitle:title];//修改短信界面标题
    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示信息"
                                                        message:@"该设备不支持短信功能"
                                                       delegate:nil
                                              cancelButtonTitle:@"确定"
                                              otherButtonTitles:nil, nil];
        [alert show];
    }
}

- (void)setupPopMenu {
    
    __weak __typeof(self)weakSelf = self;
    
    self.popupMenuView = [[QMUIPopupMenuView alloc] init];
    self.popupMenuView.automaticallyHidesWhenUserTap = YES;
    self.popupMenuView.maskViewBackgroundColor = UIColorMaskWhite;
    self.popupMenuView.maximumWidth = 180;
    self.popupMenuView.shouldShowItemSeparator = YES;
    self.popupMenuView.separatorInset = UIEdgeInsetsMake(0, self.popupMenuView.padding.left, 0, self.popupMenuView.padding.right);
    if ([self.str isEqual:@"外部通讯录"]) {
        self.popupMenuView.items = @[
                                     [QMUIPopupMenuItem itemWithImage:[UIImageMake(@"修改") imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] title:@"修改" handler:^{
                                         YSModifyViewController *addPeople = [[YSModifyViewController alloc]init];
                                         model = array[0];
                                         addPeople.modifyModel = model;
                                         [self.navigationController pushViewController:addPeople animated:YES];
                                         [weakSelf.popupMenuView hideWithAnimated:YES];
                                     }],
                                     [QMUIPopupMenuItem itemWithImage:[UIImageMake(@"删除") imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] title:@"删除" handler:^{
                                         [self delete];
                                         [weakSelf.popupMenuView hideWithAnimated:YES];
                                     }]];
    } else {
        self.popupMenuView.items = @[
                                     [QMUIPopupMenuItem itemWithImage:[UIImageMake(@"删除") imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] title:@"删除" handler:^{
                                         [self delete];
                                         [weakSelf.popupMenuView hideWithAnimated:YES];
                                     }]];
    }
}

- (void)viewDidLayoutSubviews {
    [self.popupMenuView layoutWithTargetView:self.view];
}

- (void)options:(UIButton *)button {
    if (button.tag == 10) {
        [self.popupMenuView showWithAnimated:YES];
    }else if(button.tag == 20){
        [self delete];
    }else{
        [self.navigationController setNavigationBarHidden:NO animated:YES];
        for (UIViewController *controller in self.rt_navigationController.rt_viewControllers) {
            if ([controller isKindOfClass:[YSSddressBookViewController class]]) {
                [self.navigationController popToViewController:controller animated:NO];
            }
        }
    }
    
}

- (void)modify {
    YSModifyViewController *addPeople = [[YSModifyViewController alloc]init];
    [self.navigationController pushViewController:addPeople animated:YES];
}
- (void)delete {
    //初始化提示框；
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"该联系人将会被删除" preferredStyle:  UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        //点击按钮的响应事件；
        NSString *url;
        if([self.str isEqualToString:@"外部通讯录"]){
            url = [NSString stringWithFormat:@"%@%@/%@/%@/%@", YSDomain, delCommonOrOuterPersons, model.id, @"2",@"123"];
        }else{
            url = [NSString stringWithFormat:@"%@%@/%@/%@/%@",YSDomain,delCommonOrOuterPersons, model.id, @"3", @"out"];
        }
        [YSNetManager ys_request_DELETEWithUrlString:url parameters:nil successBlock:^(id response) {
            [QMUITips hideAllTipsInView:self.view];
            if ([response[@"data"] integerValue] == 1) {
                for (UIViewController *vc in self.rt_navigationController.rt_viewControllers) {
                    if ([vc isKindOfClass:[YSExternalViewController class]]) {
                        [self.navigationController popToViewController:vc animated:YES];
                    }
                }
            }
        } failureBlock:^(NSError *error) {
            
        } progress:nil];
    }]];
    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        //点击按钮的响应事件；
        DLog(@"取消删除");
    }]];
    //弹出提示框；
    [self presentViewController:alert animated:true completion:nil];
}

- (void)showMessage:(NSString *)message{
    UIWindow * window = [UIApplication sharedApplication].keyWindow;
    showview =  [[UIView alloc]init];
    showview.backgroundColor = [UIColor blackColor];
    showview.frame = CGRectMake(1, 1, 1, 1);
    showview.alpha = 1.0f;
    showview.layer.cornerRadius = 5.0f;
    showview.layer.masksToBounds = YES;
    showview.center = self.view.center;
    showview.bounds = CGRects(0, 0, 177, 142);
    [window addSubview:showview];
    UIImageView *imageView = [[UIImageView alloc]init];
    imageView.frame = CGRects(61, 33, 56, 56);
    imageView.image = [UIImage imageNamed:@"添加成功"];
    [showview addSubview:imageView];
    UILabel *msgLabel = [[UILabel alloc]init];
    msgLabel.frame = CGRects(10, 105, 177, 20);
    msgLabel.textColor = [UIColor whiteColor];
    msgLabel.text = message;
    msgLabel.textAlignment = NSTextAlignmentCenter;
    [showview addSubview:msgLabel];
    [btn removeFromSuperview];
    _tableview.frame =  CGRectMake(0, 0, kSCREEN_WIDTH, kSCREEN_HEIGHT-64);
    [UIView animateWithDuration:3.0f animations:^{
        showview.alpha = 0;
    } completion:^(BOOL finished) {
        [showview removeFromSuperview];
        
    }];
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [showview removeFromSuperview];
}

//设置状态栏字体颜色
//- (UIStatusBarStyle)preferredStatusBarStyle {
//    return UIStatusBarStyleLightContent;
//}

@end
