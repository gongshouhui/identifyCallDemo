//
//  YSCalendarEditEventViewController.m
//  YaSha-iOS
//
//  Created by 方鹏俊 on 2017/8/7.
//

#import "YSCalendarEditEventViewController.h"
#import "YSCalendarEditEventCell.h"
#import <FTPickerView.h>

@interface YSCalendarEditEventViewController ()<QMUITextViewDelegate, UITextFieldDelegate>

@property (nonatomic, strong) NSArray *dataSourceArray;
@property (nonatomic, strong) NSMutableDictionary *payload;
@property (nonatomic, assign) BOOL allDay;

@end

@implementation YSCalendarEditEventViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = _isEdit ? @"编辑事项" : @"新建事项";
    _dataSourceArray = @[
                         @{@"title": @"标题", @"placeholder": @"事项主题"},
                         @{@"title": @"全天", @"placeholder": @""},
                         @{@"title": @"开始时间", @"placeholder": @""},
                         @{@"title": @"结束时间", @"placeholder": @""},
                         @{@"title": @"地点", @"placeholder": @"事项地址"},
                         @{@"title": @"", @"placeholder": @""},
                         ];
    _payload = [[NSMutableDictionary alloc] initWithDictionary:@{
                                                                 @"title": _model.title,
                                                                 @"start": _model.start,
                                                                 @"end": _model.end,
                                                                 @"address": _model.address,
                                                                 @"content": _model.content,
                                                                 }];
    // 如果添加别人的事项需要添加相应人员的工号
    _isEdit ? nil : [_payload setObject:_receiveNo forKey:@"receiveNo"];
    self.navigationItem.rightBarButtonItem = [QMUINavigationButton barButtonItemWithType:QMUINavigationButtonTypeNormal title:@"保存" position:QMUINavigationButtonPositionRight target:self action:@selector(saveCalendarEvent)];
    [self.tableView registerClass:[YSCalendarEditEventCell class] forCellReuseIdentifier:@"CalendarEditEventCell"];
}

- (void)saveCalendarEvent {
    if (![YSUtility containEmpty:_payload]) {
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init] ;
        [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        
        [_payload setObject:[NSString stringWithFormat:@"%@:00", _model.start] forKey:@"start"];
        [_payload setObject:[NSString stringWithFormat:@"%@:00", _model.end] forKey:@"end"];
        if ([[[formatter dateFromString:_model.end] dateByAddingHours:8] isEarlierThan:[[formatter dateFromString:_model.start] dateByAddingHours:8]]) {
            [QMUITips showError:@"结束时间不能早于开始时间！" inView:self.view hideAfterDelay:1.0];
        } else {
            [QMUITips showLoading:@"保存中..." inView:self.view];
            NSString *urlString = [NSString stringWithFormat:@"%@%@", YSDomain, _isEdit ? editScheduleEvent : addScheduleEvent];
            _isEdit ? [_payload setObject:_model.id forKey:@"id"] : nil;
            [YSNetManager ys_request_POSTWithUrlString:urlString isNeedCache:NO parameters:_payload successBlock:^(id response) {
                DLog(@"添加日程:%@", response);
                if ([response[@"code"] intValue] == 1) {
                    [QMUITips hideAllToastInView:self.view animated:YES];
                    YSCalendarEventModel *model = [YSCalendarEventModel yy_modelWithDictionary:_payload];
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"CalendarEditEvent" object:self userInfo:@{@"model": model}];
                    self.ReturnBlock(model);
                    [self.navigationController popViewControllerAnimated:YES];
                }
            } failureBlock:^(NSError *error) {
                DLog(@"error:%@", error);
            } progress:nil];
        }
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataSourceArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    YSCalendarEditEventCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"CalendarEditEventCell"];
    cell = [[YSCalendarEditEventCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CalendarEditEventCell"];
    NSDictionary *rowDic = _dataSourceArray[indexPath.row];
    [cell setStyle:rowDic indexPath:indexPath];
    [[cell.allDaySwitch rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        _allDay = !_allDay;
    }];
    [[cell.detailTextField rac_signalForControlEvents:UIControlEventEditingChanged] subscribeNext:^(id x) {
        [_payload setObject:cell.detailTextField.text forKey:indexPath.row == 0 ? @"title" : @"address"];
    }];
    cell.textView.delegate = self;
    switch (indexPath.row) {
        case 0:
        {
            cell.detailTextField.text = _payload[@"title"];
            break;
        }
        case 2:
        {
            cell.detailLabel.text = _payload[@"start"];
            break;
        }
        case 3:
        {
            cell.detailLabel.text = _payload[@"end"];
            break;
        }
        case 4:
        {
            cell.detailTextField.text = _payload[@"address"];
            break;
        }
        case 5:
        {
            cell.textView.text = _payload[@"content"];
            break;
        }
    }
    return cell;
}

#pragma mark - QMUITextViewDelegate

- (void)textViewDidChange:(UITextView *)textView {
    [_payload setObject:textView.text forKey:@"content"];
}

- (void)textView:(QMUITextView *)textView didPreventTextChangeInRange:(NSRange)range replacementText:(NSString *)replacementText {
    [QMUITips showWithText:[NSString stringWithFormat:@"文字不能超过 %@ 个字符", @(textView.maximumTextLength)] inView:self.view hideAfterDelay:1.0];
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return indexPath.row == 5 ? 175*kHeightScale : 40*kHeightScale;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.01;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 2 || indexPath.row == 3) {
        [FTDatePickerView showWithTitle:@"" selectDate:[NSDate date] datePickerMode:_allDay ? UIDatePickerModeDate : UIDatePickerModeDateAndTime doneBlock:^(NSDate *selectedDate) {
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setDateFormat:_allDay ? @"yyyy-MM-dd" : @"yyyy-MM-dd HH:mm"];
            NSString *dateString = [dateFormatter stringFromDate:selectedDate];
            
            YSCalendarEditEventCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
            cell.detailLabel.text = dateString;
            indexPath.row == 2 ? (_model.start = (_allDay ? [NSString stringWithFormat:@"%@ 00:00:00", dateString] : [NSString stringWithFormat:@"%@:00", dateString])) : (_model.end = (_allDay ? [NSString stringWithFormat:@"%@ 00:00:00", dateString] : [NSString stringWithFormat:@"%@:00", dateString]));
            [_payload setObject:_allDay ? [NSString stringWithFormat:@"%@ 00:00:00", dateString] : [NSString stringWithFormat:@"%@:00", dateString] forKey:indexPath.row == 2 ? @"start" : @"end"];
        } cancelBlock:^{
            
        }];
    }
}
#pragma mark - <QMUINavigationControllerDelegate>

- (BOOL)shouldSetStatusBarStyleLight {
    return StatusbarStyleLightInitially;
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return StatusbarStyleLightInitially ? UIStatusBarStyleLightContent : UIStatusBarStyleDefault;
}
@end
