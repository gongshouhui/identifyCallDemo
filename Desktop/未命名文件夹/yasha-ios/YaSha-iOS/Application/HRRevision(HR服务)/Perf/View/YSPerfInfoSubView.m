//
//  YSPerfInfoSubView.m
//  YaSha-iOS
//
//  Created by 方鹏俊 on 2017/10/18.
//

#import "YSPerfInfoSubView.h"
#import "YSPerfInfoTopCell.h"
#import "YSPerfInfoMidCell.h"

@interface YSPerfInfoSubView ()<UITableViewDataSource, UITableViewDelegate>

//@property (nonatomic, strong) UITableView *tableView;
//@property (nonatomic, strong) QMUIButton *evaluaButton;

@end

@implementation YSPerfInfoSubView

static NSString *topCellIdentifier = @"PerfInfoTopCell";
static NSString *midCellIdentifier = @"PerfInfoMidCell";

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self initUI];
        
    }
    return self;
}

- (void)initUI {
    _sendIndexSubject = [RACSubject subject];
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kSCREEN_WIDTH, kSCREEN_HEIGHT-kTopHeight-50*kHeightScale-80) style:UITableViewStyleGrouped];
    _tableView.backgroundColor = [UIColor whiteColor];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    [_tableView registerClass:[YSPerfInfoTopCell class] forCellReuseIdentifier:topCellIdentifier];
    [_tableView registerClass:[YSPerfInfoMidCell class] forCellReuseIdentifier:midCellIdentifier];
    [self addSubview:_tableView];
}

- (void)setPerfInfoType:(PerfInfoType)perfInfoType {
    DLog(@"========%lu",(unsigned long)perfInfoType);
    _perfInfoType = perfInfoType;
    if (_perfInfoType == PerfSelfEvaluaInfoType || _perfInfoType == PerfReEvaluaInfoType) {
        _evaluaButton = [YSUIHelper generateDarkFilledButton];
        _evaluaButton.tag = self.tag;
        [_evaluaButton setTitle:_perfInfoType == PerfSelfEvaluaInfoType ? @"自评": @"复评" forState:UIControlStateNormal];
        [[_evaluaButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
            [_sendIndexSubject sendNext:_evaluaButton];
        }];
        _evaluaButton.backgroundColor = kThemeColor;
        [self addSubview:_evaluaButton];
        [_evaluaButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(self.mas_centerX);
            make.size.mas_equalTo(CGSizeMake(300*kWidthScale, 50*kHeightScale));
            make.bottom.mas_equalTo(self.mas_bottom).offset(-(kTopHeight+40));
        }];
    } else {
        [_tableView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.left.bottom.right.mas_equalTo(self);
        }];
    }
    [self.tableView reloadData];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (_perfInfoType == PerfExamInfoType ) {
        return 3;
    }else{
        return 4;
    }
   
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.row) {
        case 0:
        {
            YSPerfInfoTopCell *cell = [tableView dequeueReusableCellWithIdentifier:topCellIdentifier];
            cell = [[YSPerfInfoTopCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:topCellIdentifier];
            cell.index = _perfInfoType;
            [cell setCellModel:_cellModel];
            
            return cell;
            break;
        }
        case 1:
        {
            YSPerfInfoMidCell *cell = [tableView dequeueReusableCellWithIdentifier:midCellIdentifier];
            cell = [[YSPerfInfoMidCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:midCellIdentifier];
            
            [cell setCellModel:_cellModel indexPath:indexPath];
            
            return cell;
            break;
        }
        case 2:
        {
            YSPerfInfoMidCell *cell = [tableView dequeueReusableCellWithIdentifier:midCellIdentifier];
            cell = [[YSPerfInfoMidCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:midCellIdentifier];
            cell.index = PerfExamInfoType;
            if (_perfInfoType == PerfExamInfoType) {
                [cell setPlanCellModel:_cellModel indexPath:indexPath];
            }else{
                [cell setCellModel:_cellModel indexPath:indexPath];
            }
            return cell;
            break;
        }
        case 3:
        {
            YSPerfInfoMidCell *cell = [tableView dequeueReusableCellWithIdentifier:midCellIdentifier];
            cell = [[YSPerfInfoMidCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:midCellIdentifier];
            [cell setCellModel:_cellModel indexPath:indexPath];
            
            return cell;
            break;
        }
        default:
        {
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
            return cell;
            break;
        }
    }
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.01f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.row) {
        case 0:
        {
            return 80*kHeightScale;
            break;
        }
        case 1:
        {
            return [tableView fd_heightForCellWithIdentifier:midCellIdentifier configuration:^(YSPerfInfoMidCell *cell) {
                [cell setCellModel:_cellModel indexPath:indexPath];
            }];
            break;
        }
        case 2:
        {
            return [tableView fd_heightForCellWithIdentifier:midCellIdentifier configuration:^(YSPerfInfoMidCell *cell) {
                if (_perfInfoType == PerfExamInfoType) {
                    [cell setPlanCellModel:_cellModel indexPath:indexPath];
                }else{
                    [cell setCellModel:_cellModel indexPath:indexPath];
                }
            }];
            break;
        }
        case 3:
        {
            
            return [tableView fd_heightForCellWithIdentifier:midCellIdentifier configuration:^(YSPerfInfoMidCell *cell) {
                [cell setCellModel:_cellModel indexPath:indexPath];
            }];
          
            break;
        }
        default:
        {
            return 0.01f;
            break;
        }
    }
}

@end
