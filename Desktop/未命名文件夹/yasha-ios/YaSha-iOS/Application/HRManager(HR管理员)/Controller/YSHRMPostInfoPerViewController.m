//
//  YSHRMPostInfoPerViewController.m
//  YaSha-iOS
//
//  Created by GZl on 2019/4/22.
//  Copyright © 2019 亚厦装饰股份有限公司. All rights reserved.
//

#import "YSHRMPostInfoPerViewController.h"
#import "YSHRPersonalInfoCell.h"
#import <WebKit/WebKit.h>

@interface YSHRMPostInfoPerViewController ()<WKNavigationDelegate, WKUIDelegate>
@property (nonatomic, strong) NSArray *titleArray;
@property (nonatomic, strong) NSMutableArray *channelArray;
@property (nonatomic, strong) NSMutableArray *fileArray;
@property (nonatomic, strong) NSMutableArray *resultsArray;
@property (nonatomic, strong) WKWebView *myWebView;

@end

@implementation YSHRMPostInfoPerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"入职信息";
     [self doNetworking];
    self.tableView.mj_footer = nil;
    self.tableView.mj_header = nil;
}
- (void)initTableView {
    [super initTableView];
    [self.tableView registerClass:[YSHRPersonalInfoCell class] forCellReuseIdentifier:@"infoPostiCell"];
    self.tableView.sectionFooterHeight = 0.0;
    
    
}
- (void)doNetworking {
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        self.channelArray = [NSMutableArray array];
        self.fileArray = [NSMutableArray array];
        self.resultsArray = [NSMutableArray array];
        
        [self.channelArray addObject:@{@"应聘渠道":[YSUtility cancelNullData:[[self.profileModel.entry objectForKey:@"candidateMessage"] objectForKey:@"channel"]]}];
        [self.channelArray addObject:@{@"投递时间":[YSUtility timestampSwitchTime:[YSUtility cancelNullData:[[self.profileModel.entry objectForKey:@"candidateMessage"] objectForKey:@"createTime"]] andFormatter:@"yyyy-MM-dd hh:mm"]}];
        [self.channelArray addObject:@{@"面试时间":[YSUtility timestampSwitchTime:[YSUtility cancelNullData:[[self.profileModel.entry objectForKey:@"candidateMessage"] objectForKey:@"interviewTime"]] andFormatter:@"yyyy-MM-dd hh:mm"]}];
        [self.channelArray addObject:@{@"职位等级":[YSUtility cancelNullData:self.profileModel.cover.levelId]}];
        
        // 简历
        [self.fileArray addObject:@{@"简历文件":@""}];
        
        
        // 面试结果result
        [self.resultsArray addObject:@{@"面试结果":@""}];
        if ([[[self.profileModel.entry objectForKey:@"inerviewResult"] objectForKey:@"result"] integerValue] == 1) {
            [self.resultsArray removeLastObject];
            [self.resultsArray addObject:@{@"面试结果":@"通过"}];
        }else if ([[[self.profileModel.entry objectForKey:@"inerviewResult"] objectForKey:@"result"] integerValue] == 2) {
            [self.resultsArray removeLastObject];
            [self.resultsArray addObject:@{@"面试结果":@"待定"}];
        }else if ([[[self.profileModel.entry objectForKey:@"inerviewResult"] objectForKey:@"result"] integerValue] == 3) {
            [self.resultsArray removeLastObject];
            [self.resultsArray addObject:@{@"面试结果":@"淘汰"}];
        }
        [self.resultsArray addObject:@{@"人才观得分":[NSString stringWithFormat:@"%@分", [YSUtility cancelNullData:[[self.profileModel.entry objectForKey:@"inerviewResult"] objectForKey:@"score"]]]}];
        [self.resultsArray addObject:@{@"任职资格得分":[NSString stringWithFormat:@"%@分", [YSUtility cancelNullData:[[self.profileModel.entry objectForKey:@"inerviewResult"] objectForKey:@"jobScore"]]]}];
        [self.resultsArray addObject:@{@"面试评价": [YSUtility cancelNullData:[[self.profileModel.entry objectForKey:@"inerviewResult"] objectForKey:@"evaluate"]]}];
        
        [self.dataSourceArray addObject:_channelArray];
        [self.dataSourceArray addObject:_fileArray];
        [self.dataSourceArray addObject:_resultsArray];
        
        dispatch_sync(dispatch_get_main_queue(), ^{
            [self ys_reloadDataWithImageName:@"ic_info_bg_personal" text:@"暂无入职信息\n快去后台添加吧"];
        });
    });
    
}
#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataSourceArray.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [(NSArray *)(self.dataSourceArray[section]) count];
    
}
- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 200*kHeightScale;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return UITableViewAutomaticDimension;
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    YSHRPersonalInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:@"infoPostiCell" forIndexPath:indexPath];
    cell.dic = self.dataSourceArray[indexPath.section][indexPath.row];
    if (indexPath.section == 1 && [self.profileModel.entry objectForKey:@"viewCandidateFile"]) {
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }else {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 1 ) {
        NSString *urlStr = @"";
        if ([[self.profileModel.entry objectForKey:@"viewCandidateFile"] length] > 5) {
            [self strUTF8Encoding:[[self.profileModel.entry objectForKey:@"viewCandidateFile"] substringFromIndex:5]];//@"//10.10.20.39:19081/fileX/2018-12-28/C00125834-李敬会-投标预算员(J10091)-原始简历_1545991273438.pdf"
        }else {
            /*
            [QMUITips showInfo:@"请去PC端查看" inView:self.view hideAfterDelay:0.6];
             */
            return;
        }
        NSURL *filePath = [NSURL URLWithString:[NSString stringWithFormat:@"http:%@", urlStr]];
        NSURLRequest *request = [NSURLRequest requestWithURL: filePath];
        [_myWebView loadRequest:request];
        DLog(@"简历信息");
        [self.view addSubview:self.myWebView];
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view = [[UIView alloc]init];
    view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    UILabel *label = [[UILabel alloc]init];
    [view addSubview:label];
    [label sizeToFit];
    label.font = [UIFont systemFontOfSize:13];
    label.textColor = kUIColor(25, 31, 37, 1);
    
    label.text = self.titleArray[section];
    label.frame = CGRectMake(15, (38 - 20)/2, kSCREEN_WIDTH, 20);
    return view;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 32*kHeightScale;
}

#pragma mark--WKWebView
// 页面开始加载时调用
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation {
    [QMUITips showLoadingInView:self.view];
    
}
// 当内容开始返回时调用
- (void)webView:(WKWebView *)webView didCommitNavigation:(WKNavigation *)navigation {
    
}
// 页面加载完成之后调用
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    [QMUITips hideAllTipsInView:self.view];
}
// 页面加载失败时调用
- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation {
    [QMUITips hideAllTipsInView:self.view];
    [QMUITips showError:@"加载失败" inView:self.view hideAfterDelay:0.5];
    [self.myWebView removeFromSuperview];
}


#pragma mark - setter&&getter
- (WKWebView *)myWebView {
    if (!_myWebView) {
       _myWebView = [[WKWebView alloc] initWithFrame:(CGRectMake(0, kTopHeight, kSCREEN_WIDTH, kSCREEN_HEIGHT-kTopHeight))];
        _myWebView.backgroundColor = [UIColor whiteColor];
        _myWebView.UIDelegate = self;
        _myWebView.navigationDelegate = self;
    }
    return _myWebView;
}

- (NSArray *)titleArray{
    if (!_titleArray) {
        _titleArray = @[@"应聘渠道", @"简历文件",@"面试结果"];
    }
    return _titleArray;
}

- (NSString*)strUTF8Encoding:(NSString*)str {
    /*! ios9适配的话 打开第一个 */
    if ([[UIDevice currentDevice] systemVersion].floatValue >= 9.0) {
        return [str stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLPathAllowedCharacterSet]];
    } else {
        return [str stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    }
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
