//
//  YSClockTimeViewController.m
//  YaSha-iOS
//
//  Created by YaSha_Tom on 2019/1/10.
//  Copyright © 2019年 亚厦装饰股份有限公司. All rights reserved.
//

#import "YSClockTimeViewController.h"
#import "YSClockTimeTableViewCell.h"
#import "YSFormDatePickerCell.h"
#import "YSFormRowModel.h"


@interface YSClockTimeViewController ()
@property (nonatomic,strong)UIButton *yearButton;
@property (nonatomic,strong)NSMutableArray *clockArray;
@property (nonatomic,strong)NSString *timeStr;
@end

@implementation YSClockTimeViewController

- (NSMutableArray *)clockArray {
    if (!_clockArray) {
        _clockArray = [NSMutableArray array];
    }
    return _clockArray;
}
- (void)initTableView {
    [super initTableView];
    @weakify(self);
    // 点击迟到早退cell 跳转详情
    [[[NSNotificationCenter defaultCenter] rac_addObserverForName:@"YSChoseClockTime" object:nil] subscribeNext:^(NSNotification * _Nullable x) {
        @strongify(self);
        if ([x.userInfo objectForKey:@"YSChoseTime"]) {            
            NSString *monthStr;
            if ([[[x.userInfo objectForKey:@"YSChoseTime"] substringWithRange:(NSMakeRange(5, 1))] isEqualToString:@"0"]) {
                monthStr = [[x.userInfo objectForKey:@"YSChoseTime"] substringWithRange:(NSMakeRange(6, 1))];
            }else {
                monthStr = [[x.userInfo objectForKey:@"YSChoseTime"] substringWithRange:(NSMakeRange(5, 2))];

            }
            NSString *btnTitle = [NSString stringWithFormat:@"%@.%@", [[x.userInfo objectForKey:@"YSChoseTime"] substringToIndex:4], monthStr];
            [self.yearButton setTitle:btnTitle forState:UIControlStateNormal];
            
            self.timeStr = [NSString stringWithFormat:@"%@/%@",[[x.userInfo objectForKey:@"YSChoseTime"] substringToIndex:4],monthStr];
            [self doNetworking];

        }
        
    }];
    [self hideMJRefresh];
    self.timeStr = [NSString stringWithFormat:@"%ld/%ld",[[[NSDate date] dateByAddingHours:0] year],[[[NSDate date] dateByAddingHours:0] month]];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.separatorColor = [UIColor clearColor];
    [self doNetworking];
}
- (void)doNetworking {
    NSDictionary *paramDic = [NSDictionary new];
    if (self.teamDic) {
        // 跟记录一样 时间没有变换
        paramDic = @{@"no":[self.teamDic objectForKey:@"no"]};
    }
    [YSNetManager ys_request_GETWithUrlString:[NSString stringWithFormat:@"%@%@/%@",YSDomain, getClock,self.timeStr] isNeedCache:NO parameters:paramDic successBlock:^(id response) {
        DLog(@"=======%@",response);
        if ([response[@"data"] count] > 0) {
            [self processData:response[@"data"][0]];
        }
    } failureBlock:^(NSError *error) {
        DLog(@"------%@",error);
    } progress:nil];
    
}
- (void)processData:(NSDictionary *)dict {
    [self.clockArray removeAllObjects];
    for (int i = 31; i > 0; i--) {
        NSString *dayKey = [NSString stringWithFormat:@"day%d",i];
        NSString *value = dict[dayKey];
        if (value) {
            [self.clockArray addObject:[self dictionaryWithJsonString:value]];
        }
    }
    [self.tableView reloadData];
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 1;
    }else {
        return self.clockArray.count;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50*kHeightScale;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        YSFormDatePickerCell *cell = [tableView dequeueReusableCellWithIdentifier:@"timeCell"];
        if (cell == nil) {
            cell = [[YSFormDatePickerCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"timeCell"];
        }
        cell.arrowView.hidden = YES;
        cell.detailLabel.hidden = YES;
        YSFormRowModel *cellModel = [[YSFormRowModel alloc]init];
        cellModel.datePickerMode = PGDatePickerModeYearAndMonth;
        [cell setCellModel:cellModel];
        [cell addSubview:self.yearButton];
        YSWeak;
        [cell.sendFormCellModelSubject subscribeNext:^(YSFormCellModel *model) {
            YSStrong;
            [strongSelf.yearButton setTitle:model.value forState:UIControlStateNormal];
            strongSelf.timeStr = [NSString stringWithFormat:@"%@/%@",[model.value substringToIndex:4],[model.value substringFromIndex:5]];
            [strongSelf doNetworking];
            
        }];
        return cell;
    }else{
        YSClockTimeTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        if (cell == nil) {
            cell = [[YSClockTimeTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        }
        [cell setClockTimeData:self.clockArray[indexPath.row]];
        return cell;
    }
}
- (UIButton *)yearButton {
    if (!_yearButton) {
        _yearButton = [[UIButton alloc]init];
        _yearButton.frame = CGRects(16, 18*kHeightScale, 100, 20);
        _yearButton.titleLabel.font = [UIFont systemFontOfSize:18];
        _yearButton.imageView.contentMode = UIViewContentModeScaleAspectFit;
        [_yearButton setImage:[UIImage imageNamed:@"向下箭头"] forState:UIControlStateNormal];
        [_yearButton setTitle:[NSString stringWithFormat:@"%ld . %ld",(long)[[[NSDate date] dateByAddingHours:0] year],(long)[[[NSDate date] dateByAddingHours:0] month]] forState:UIControlStateNormal];
        [_yearButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        _yearButton.userInteractionEnabled = NO;
        [_yearButton sizeToFit];
        _yearButton.titleEdgeInsets = UIEdgeInsetsMake(0, -_yearButton.imageView.frame.size.width - _yearButton.frame.size.width + _yearButton.titleLabel.frame.size.width, 0, 0);
        
        _yearButton.imageEdgeInsets = UIEdgeInsetsMake(0, 15, 0, -_yearButton.titleLabel.frame.size.width - _yearButton.frame.size.width + _yearButton.imageView.frame.size.width);
    }
    
    return _yearButton;
}
- (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString
{
    
    jsonString = [jsonString stringByReplacingOccurrencesOfString:@"\'"withString:@"\""];
    if (jsonString == nil) {
        return nil;
    }
	
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:&err];
    if(err) {
       
        return nil;
    }
    return dic;
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
