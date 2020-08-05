//
//  YSPerfInfoViewController.m
//  YaSha-iOS
//
//  Created by 方鹏俊 on 2017/10/18.
//

#import "YSPerfInfoViewController.h"
#import "YSPerfInfoTopView.h"
#import "YSPerfInfoSubView.h"
#import "YSPerfExamBottomView.h"
#import "YSPerfInfoModel.h"
#import "YSKeyboardViewController.h"
#import "YSPerfEvaluaRecordListViewController.h"
#import "YSPerRemarkView.h"

@interface YSPerfInfoViewController () <UIScrollViewDelegate,QMUITextViewDelegate>

@property (nonatomic, strong) YSPerfInfoTopView *perfInfoTopView;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) YSKeyboardViewController *keyboardViewController;
@property (nonatomic, strong) NSMutableArray *contentsArray;    // 提交数组
@property (nonatomic, assign) NSInteger index;    // 当前页码
@property (nonatomic, strong) NSString *id;    // 绩效id
@property (nonatomic, strong) YSPerfExamBottomView *perfExamBottomView;
@property (nonatomic, strong) NSString *examBackReason;    // 退回原因
@property (nonatomic, strong) NSString *remark;
@property (nonatomic, strong) YSPerfInfoSubView *perfInfoSubView;
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, assign) int i;

@end

@implementation YSPerfInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSArray *titlesArray = @[@"我的绩效", @"绩效评估", @"绩效评估", @"计划审核"];
    self.title = titlesArray[_perfInfoType];
}

- (void)setNavigationItemsIsInEditMode:(BOOL)isInEditMode animated:(BOOL)animated {
    [super setNavigationItemsIsInEditMode:isInEditMode animated:animated];
    if (_perfInfoType == PerfSelfEvaluaInfoType || _perfInfoType == PerfReEvaluaInfoType) {
        self.navigationItem.rightBarButtonItem = [QMUINavigationButton barButtonItemWithType:QMUINavigationButtonTypeNormal title:@"提交" position:QMUINavigationButtonPositionRight target:self action:@selector(submit)];
    }
    if (_perfInfoType == PerfNormalInfoType) {
        self.navigationItem.rightBarButtonItem = [QMUINavigationButton barButtonItemWithType:QMUINavigationButtonTypeNormal title:@"审批记录" position:QMUINavigationButtonPositionRight target:self action:@selector(viewRecord)];
    }
}

- (void)initSubviews {
    [super initSubviews];
    _index = 0;
    _i = 0;
    _contentsArray = [NSMutableArray array];
    _perfInfoTopView = [[YSPerfInfoTopView alloc] init];
    _perfInfoTopView.nameLabel.text = _perfInfoType == PerfNormalInfoType ? _cellModel.name : _evaluaListModel.name;
    [self.view addSubview:_perfInfoTopView];
    [_perfInfoTopView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.view).offset(kTopHeight);
        make.left.right.mas_equalTo(self.view);
        make.height.mas_equalTo(40);
    }];
    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, kTopHeight+40, kSCREEN_WIDTH, kSCREEN_HEIGHT)];
    _scrollView.delegate = self;
    _scrollView.pagingEnabled = YES;
    [self.view addSubview:_scrollView];
    
    //计划审核
    if (_perfInfoType == PerfExamInfoType) {
        _perfExamBottomView = [[YSPerfExamBottomView alloc] init];
        YSWeak;
        [_perfExamBottomView.sendActionSubject subscribeNext:^(UIButton *button) {
            button.tag == 0 ? [weakSelf showKeyboardViewController] : [weakSelf confirm:button];
        }];
        [self.view addSubview:_perfExamBottomView];
        [_perfExamBottomView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(self.view.mas_centerX);
            make.bottom.mas_equalTo(self.view.mas_bottom);
            make.size.mas_equalTo(CGSizeMake(kSCREEN_WIDTH, 50*kHeightScale));
        }];
    }
    [self doNetworking];
    [self addGuideView];
}

- (void)addGuideView {
    NSUserDefaults *userdefaults =YSUserDefaults;
    BOOL isFirst = [userdefaults boolForKey:@"isFirstInter"];
    if (!isFirst) {
        switch (_perfType) {
            case PerfSelfEvaluaInfoType:
                _imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"08自评指引"]];
                break;
            case PerfReEvaluaInfoType:
                _imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"12复评指引"]];
                break;
           case PerfNormalInfoType:
                _imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"04计划审核"]];
                break;
                
            default:
                break;
        }
        
        _imageView.frame = self.view.bounds;
        _imageView.userInteractionEnabled = YES;

        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissGuideView)];
        [_imageView addGestureRecognizer:tap];

         [[UIApplication sharedApplication].keyWindow addSubview:_imageView];
        [userdefaults setBool:YES forKey:@"isFirstInter"];
        [userdefaults synchronize];
    }
}

- (void)dismissGuideView {
    _i += 1;
    if (_i == 1) {
        switch (_perfType) {
            case PerfSelfEvaluaInfoType:
                _imageView.image = [UIImage imageNamed:@"09自评指引"];
                break;
            case PerfReEvaluaInfoType:
                _imageView.image = [UIImage imageNamed:@"13复评指引"];
                break;
            case PerfNormalInfoType:
                _imageView.image = [UIImage imageNamed:@"05计划审核"];
                break;
            default:
                break;
        }        
    }else if (_i == 2) {
        switch (_perfType) {
            case PerfSelfEvaluaInfoType:
                _imageView.image = [UIImage imageNamed:@"10自评指引"];
                break;
            case PerfReEvaluaInfoType:
                _imageView.image = [UIImage imageNamed:@"14复评指引"];
                break;
            case PerfNormalInfoType:
                _imageView.image = [UIImage imageNamed:@"06计划审核"];
                break;
            default:
                break;
        }
    }else if (_i == 3){
        switch (_perfType) {
            case PerfSelfEvaluaInfoType:
                _imageView.image = [UIImage imageNamed:@"11自评指引"];
                break;
            case PerfReEvaluaInfoType:
                _imageView.image = [UIImage imageNamed:@"15复评指引"];
                break;
            case PerfNormalInfoType:
                _imageView.image = [UIImage imageNamed:@"07计划审核"];
                break;
            default:
                break;
        }
    }else{
        [_imageView removeFromSuperview];
    }
    
}

- (void)doNetworking {
    NSString *urlString;
    switch (_perfInfoType) {
        case PerfNormalInfoType:
        {
            urlString = [NSString stringWithFormat:@"%@%@/%@/%@/%@/%@/1", YSDomain, getMyPerfInfoApi, _cellModel.id, _cellModel.assessmentType, _year, _cellModel.assessmentTime];
            break;
        }
        case PerfSelfEvaluaInfoType:
        {
            urlString = [NSString stringWithFormat:@"%@%@/%@/1", YSDomain, planPersonSocoreInfoApi, _evaluaListModel.id];
            break;
        }
        case PerfReEvaluaInfoType:
        {
            urlString = [NSString stringWithFormat:@"%@%@/%@/1", YSDomain, getReEvaluationInfoApi, _evaluaListModel.id];
            break;
        }
        case PerfExamInfoType:
        {
            urlString = [NSString stringWithFormat:@"%@%@/%@", YSDomain, getPlanExamineConttentInfoApi, _evaluaListModel.id];
            break;
        }
    }
    [YSNetManager ys_request_GETWithUrlString:urlString isNeedCache:NO parameters:nil successBlock:^(id response) {
        DLog(@"获取我的绩效详情:%@", response);
        [self.dataSourceArray addObjectsFromArray:[YSDataManager getPerfInfoListData:response]];
        _id = response[@"data"][0][@"examContentForPortal"][@"id"];
        for (int i = 0; i < self.dataSourceArray.count+1; i ++) {
            if (i == self.dataSourceArray.count) {
                if (self.perfInfoType == PerfSelfEvaluaInfoType || self.perfInfoType == PerfReEvaluaInfoType  ){
                    YSPerRemarkView *perfRemarkView = [[YSPerRemarkView alloc]initWithFrame:CGRectMake(kSCREEN_WIDTH*i, 0, kSCREEN_WIDTH, kSCREEN_HEIGHT-40*kHeightScale)];
                    perfRemarkView.textView.delegate = self;
                    perfRemarkView.perfInfoType = _perfInfoType;
                    [_scrollView addSubview:perfRemarkView];
                }if([response[@"data"][0][@"examContentForPortal"][@"remark"] length] > 0){
                    YSPerRemarkView *perfRemarkView = [[YSPerRemarkView alloc]initWithFrame:CGRectMake(kSCREEN_WIDTH*i, 0, kSCREEN_WIDTH, kSCREEN_HEIGHT-40*kHeightScale)];
                    perfRemarkView.textView.text = response[@"data"][0][@"examContentForPortal"][@"remark"];
                    perfRemarkView.textView.userInteractionEnabled = NO;
                    perfRemarkView.perfInfoType = _perfInfoType;
                    [_scrollView addSubview:perfRemarkView];
                }
            } else {
                _perfInfoSubView = [[YSPerfInfoSubView alloc] initWithFrame:CGRectMake(kSCREEN_WIDTH*i, 0, kSCREEN_WIDTH, kSCREEN_HEIGHT-40*kHeightScale)];
                _perfInfoSubView.tag = i;
                _perfInfoSubView.tableView.tag = i+5;
                [_perfInfoSubView setPerfInfoType:_perfInfoType];
                YSPerfInfoModel *model = self.dataSourceArray[i];
                model.examContentForPortal = response[@"data"][0][@"examContentForPortal"];
                model.planPerson = response[@"data"][0][@"planPerson"];
                model.examContent = response[@"data"][0][@"examContent"];
                [_perfInfoSubView setCellModel:model];
                YSWeak;
                [_perfInfoSubView.sendIndexSubject subscribeNext:^(UIButton *button) {
                    [weakSelf showKeyboardViewController];
                }];
                [_scrollView addSubview:_perfInfoSubView];
            }            
        }
        if (self.perfInfoType == PerfExamInfoType) {
            _scrollView.contentSize = CGSizeMake(kSCREEN_WIDTH*(self.dataSourceArray.count), kSCREEN_HEIGHT-kTopHeight-40);
        }else{
            _scrollView.contentSize = CGSizeMake(kSCREEN_WIDTH*(self.dataSourceArray.count+1), kSCREEN_HEIGHT-kTopHeight-40);
        }
    } failureBlock:^(NSError *error) {
        DLog(@"error:%@", error);
    } progress:nil];
}

- (void)showKeyboardViewController {
    if (!self.keyboardViewController) {
        self.keyboardViewController = [[YSKeyboardViewController alloc] init];
    }
    if (!self.keyboardViewController.view.superview) {
        [self.keyboardViewController showInParentViewController:self.navigationController];
    }
    if (_perfInfoType == PerfSelfEvaluaInfoType) {
        [self.keyboardViewController hideScoreTextField];
    }
    if (_perfInfoType == PerfExamInfoType) {
        [self.keyboardViewController.scoreTextField removeFromSuperview];
        [self.keyboardViewController.textView becomeFirstResponder];
    } else {
        [self.keyboardViewController.scoreTextField becomeFirstResponder];
    }
    
    [self.keyboardViewController.publishButton addTarget:self action:@selector(review) forControlEvents:UIControlEventTouchUpInside];

}

- (void)review {
    if (_index < self.dataSourceArray.count) {
        
        YSPerfInfoModel *model = self.dataSourceArray[_index];
        NSDictionary *contentDic;
        switch (_perfInfoType) {
            case PerfSelfEvaluaInfoType:
            {
                contentDic = @{
                               @"id": model.id,
                               @"selfRating": self.keyboardViewController.textView.text
                               };
                break;
            }
            case PerfReEvaluaInfoType:
            {
                contentDic = @{
                               @"id": model.scoreId,
                               @"scoreRemark": self.keyboardViewController.textView.text,
                               @"score":self.keyboardViewController.scoreTextField.text
                               };
                break;
            }
            case PerfExamInfoType:
            {
                _examBackReason = self.keyboardViewController.textView.text;
                UIButton *button = [[UIButton alloc] init];
                [self confirm:button];
                break;
            }
        }
        [_contentsArray addObject:contentDic];
        NSInteger scrollIndex = _index++;
        if (_perfInfoType == PerfSelfEvaluaInfoType) {
            model.selfRating = self.keyboardViewController.textView.text;
            [_perfInfoSubView setCellModel:model];
        }
        if (_perfInfoType == PerfReEvaluaInfoType) {
            YSPerfSubInfoModel *SubInfoModel = [[YSPerfSubInfoModel alloc]init];
            SubInfoModel.score =self.keyboardViewController.scoreTextField.text;
            SubInfoModel.scoreRemark = self.keyboardViewController.textView.text;
            SubInfoModel.evaluatorName  = model.personName;
            DLog(@"--------%@",model.examContent[0]);
            SubInfoModel.weight = model.examContent[_index-1][@"contentWeight"];
            model.examScoreVoList = @[SubInfoModel];
            [_perfInfoSubView setCellModel:model];
        }
        UITableView *tableview = (UITableView *)[_scrollView viewWithTag:scrollIndex+5];
        [tableview reloadData];
        self.keyboardViewController.scoreTextField.text = nil;
        self.keyboardViewController.textView.text = nil;
        
        if (scrollIndex < self.dataSourceArray.count && _perfInfoType == PerfReEvaluaInfoType) {
            [_scrollView setContentOffset:CGPointMake((scrollIndex+1)*kSCREEN_WIDTH, 0) animated:YES];
        }
        if (scrollIndex < self.dataSourceArray.count && _perfInfoType == PerfSelfEvaluaInfoType) {
            DLog(@"===111111===%f",(scrollIndex+1)*kSCREEN_WIDTH);
            [_scrollView setContentOffset:CGPointMake((scrollIndex+1)*kSCREEN_WIDTH, 0) animated:YES];
        }
    }
}
#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    _index = (NSInteger)scrollView.contentOffset.x / kSCREEN_WIDTH;
    if (_index < self.dataSourceArray.count) {
        if (_perfInfoType == PerfSelfEvaluaInfoType) {
            YSPerfInfoModel *model = self.dataSourceArray[_index];
            self.keyboardViewController.textView.text = model.selfRating;
        }
        if (_perfInfoType == PerfReEvaluaInfoType) {
            YSPerfInfoModel *model = self.dataSourceArray[_index];
            DLog(@"--------------%@",model.examScoreVoList);
            YSPerfSubInfoModel *modelList = model.examScoreVoList[0];
            self.keyboardViewController.textView.text = modelList.scoreRemark;
            self.keyboardViewController.scoreTextField.text = modelList.score;
        }
       
    }
}
- (void)textViewDidChange:(UITextView *)textView {
    self.remark = textView.text;
}

/** 查看审批记录 */
- (void)viewRecord {
    YSPerfEvaluaRecordListViewController *perfEvaluaRecordListViewController = [[YSPerfEvaluaRecordListViewController alloc] initWithStyle:UITableViewStyleGrouped];
    perfEvaluaRecordListViewController.cellModel = _cellModel;
    [self.navigationController pushViewController:perfEvaluaRecordListViewController animated:YES];
}

/** 提交评价 */
- (void)submit {
    if (_index == self.dataSourceArray.count || _index == _contentsArray.count) {
    
        NSString *urlString = [NSString stringWithFormat:@"%@%@", YSDomain, _perfInfoType == PerfSelfEvaluaInfoType ? updateSelfEvaluationApi : updateLeaderScoreApi];
        NSDictionary *payload;
        switch (_perfInfoType) {
            case PerfSelfEvaluaInfoType:
            {
                payload = @{
                            @"id": _id,
                            @"examContents": _contentsArray,
                            @"remark": _remark == nil ? @"":_remark
                            };
                break;
            }
            case PerfReEvaluaInfoType:
            {
                payload = @{
                            @"reComment": _contentsArray
                            };
                break;
            }
            default:
                break;
        }
        DLog(@"=========%@----%lu=======%ld",payload,(unsigned long)_contentsArray.count,(long)_index);
        if (_contentsArray.count >= _index) {
        
            [YSNetManager ys_request_POSTWithUrlString:urlString isNeedCache:NO parameters:payload successBlock:^(id response) {
                DLog(@"提交评价:%@", response);
                if ([response[@"data"] isEqual:@1]) {
                    [self.navigationController popViewControllerAnimated:YES];
                }
            } failureBlock:^(NSError *error) {
                DLog(@"error:%@", error);
            } progress:nil];
        }else {
            [QMUITips showInfo:@"请完善评估内容" inView:self.view hideAfterDelay:1];
        }
            
        }else {
            [QMUITips showInfo:@"请向左滑动，确定你已经阅读全部考核内容" inView:self.view hideAfterDelay:1];
        }
    }


/** 审批退回、生效 */
- (void)confirm:(UIButton *)button {
    NSString *urlString = [NSString stringWithFormat:@"%@%@/%@", YSDomain, button.tag == 0 ? updatePlanRebackApi : updatePlanConfirmApi, _evaluaListModel.id];
    NSDictionary *payload = button.tag == 0 ? @{@"examBackReason": _examBackReason} : nil;
    [YSNetManager ys_request_POSTWithUrlString:urlString isNeedCache:NO parameters:payload successBlock:^(id response) {
        DLog(@"退回/生效详情:%@", response);
        self.ReturnBlock(_evaluaListModel);
        [self.navigationController popViewControllerAnimated:YES];
    } failureBlock:^(NSError *error) {
        DLog(@"error:%@", error);
    } progress:nil];
}

@end
