//
//  YSChoosePeopleViewController.m
//  YaSha-iOS
//
//  Created by mHome on 2016/12/1.
//
//

#import "YSChoosePeopleViewController.h"
#import "YSExternalViewController.h"
//#import "YSSelectMeetingPeopleController.h"
#import "YSDataManager.h"
#import "YSExternalModel.h"
#import "YSInternalPeopleModel.h"
#import "YSChoosePeopleTableViewCell.h"
#import "YSInternalModel.h"

@interface YSChoosePeopleViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    NSMutableArray *selectDataArr;
    NSArray *_dataSourceArray;
    UIButton *button;
    UITableView *table;
    NSMutableDictionary *dic;
    YSSingleton*si;
    //    YSExternalModel *model;
    YSInternalPeopleModel *peopleModel;
    BOOL selected;
}

@property(nonatomic,assign)BOOL isADD;

@end

@implementation YSChoosePeopleViewController


- (void)viewDidLoad {
    DLog(@"=====12120------121====%@",si.selectDataArr);
    [super viewDidLoad];
    self.title = @"选择人员";
    si=[YSSingleton getData];
    dic = [NSMutableDictionary dictionaryWithCapacity:100];
    self.view.backgroundColor = [UIColor grayColor];
    DLog(@"======-----%@",self.string);
    
    [self table];
    if([self.string isEqual:@"内部"])
    {
        [self nextGetServeManager:self.id];
    }else{
        
        [self getServeManager];
    }
    
}
-(void) nextGetServeManager:(NSString *) strId
{
    NSMutableDictionary  *diction = [NSMutableDictionary dictionaryWithCapacity:100];
    [diction setObject:[NSString stringWithFormat:@"%@",strId] forKey:@"deptId"];
    [diction setObject:[YSUtility getUID] forKey:@"loginName"];
    
    [YSNetManager ys_request_POSTWithUrlString:[NSString stringWithFormat:@"%@%@",YSDomain,getDepartmentMembers] isNeedCache:NO parameters:diction successBlock:^(id response) {
        _dataSourceArray = [YSDataManager getInternallMemberData:response];
        [table reloadData];
        DLog(@"=======%@",response);
    } failureBlock:^(NSError *error) {
        DLog(@"=======%@",error);
    } progress:nil];
}

-(void)  getServeManager
{
    
    [YSNetManager ys_request_GETWithUrlString:[NSString stringWithFormat:@"%@%@",YSDomain,outerPersons] isNeedCache:NO parameters:nil successBlock:^(id response) {
        DLog(@"----------%@",response);
        _dataSourceArray = [YSDataManager getChoosegetExternalData:response];
               DLog(@"=======%@",response);
        if (_dataSourceArray.count > 0 || _dataSourceArray == nil) {
            [table reloadData];
        }else{
            [table removeFromSuperview];
            [self.chooseView removeFromSuperview];
            self.view.backgroundColor = [UIColor whiteColor];
            UIImageView *image = [[UIImageView alloc]initWithFrame:CGRectMake(82*BIZ, 116*BIZ, 210*BIZ, 200*BIZ)];
            image.image = [UIImage imageNamed:@"无数据"];
            [self.view addSubview:image];
        }
    } failureBlock:^(NSError *error) {
        
    } progress:^(int64_t bytesProgress, int64_t totalBytesProgress) {
        
    }];
}
-(void)  table
{
    table = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kSCREEN_WIDTH, kSCREEN_HEIGHT-104) style:UITableViewStyleGrouped];
    table.delegate = self;
    table.dataSource = self;
    table.rowHeight = 48*BIZ;
    [self.view addSubview:table];
    self.chooseView = [[YSChoosePeopleView alloc]initWithFrame:CGRectMake(0, kSCREEN_HEIGHT-104, kSCREEN_WIDTH, 40)];
    
    self.chooseView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.chooseView];
    [self.chooseView.chooseButton addTarget:self action:@selector(Choose:) forControlEvents:UIControlEventTouchUpInside];
    self.chooseView.numLabel.text = [NSString stringWithFormat:@"共选择%lu人",(unsigned long)si.selectDataArr.count];
    [self.chooseView.allChooseButton addTarget:self action:@selector(allChoose:) forControlEvents:UIControlEventTouchUpInside];
    
    
}
-(void) allChoose :(UIButton *) btn
{
    [si.selectDataArr removeAllObjects];
    if (btn.selected) {
        
        [btn setImage:[UIImage imageNamed:@"未选"] forState:UIControlStateNormal];
        btn.selected = NO;
        [si.selectDataArr removeAllObjects];
        
        
    }else{
        [btn setImage:[UIImage imageNamed:@"选择1"] forState:UIControlStateNormal];
        btn.selected = YES;
        for (int row=0; row<_dataSourceArray.count; row++) {
            YSInternalModel *model = _dataSourceArray[row];
            [si.selectDataArr addObject:model.id];
        }
    }
    DLog(@"=======%@",si.selectDataArr);
    self.chooseView.numLabel.text = [NSString stringWithFormat:@"共选择%lu人",(unsigned long)si.selectDataArr.count];
    [table reloadData];
    
}
-(void)Choose:(UIButton *)action{
    NSString *strUrl = [[NSString alloc]init];
    if ([self.string isEqual:@"内部"])
    {
        strUrl = addInnerPersonToCommonPerson;
    }else{
        strUrl = addOuterPersonToCommonPerson;
    }
    [YSNetManager ys_request_POSTWithUrlString:[NSString stringWithFormat:@"%@%@/%@/%@",YSDomain,strUrl,[si.selectDataArr  componentsJoinedByString:@","],@"out"] isNeedCache:NO parameters:nil successBlock:^(id response) {
        DLog(@"========%@",response);
        [QMUITips hideAllTipsInView:self.view];
        if ([response[@"data"] integerValue] == 1) {
            [si.selectDataArr removeAllObjects];
            for (UIViewController *VC in self.rt_navigationController.rt_viewControllers) {
                if ([VC isKindOfClass:[YSExternalViewController class]]) {
                    [self.navigationController popToViewController:VC animated:YES];
                }
            }
        }
    } failureBlock:^(NSError *error) {
        DLog(@"========%@",error);
    } progress:^(int64_t bytesProgress, int64_t totalBytesProgress) {
        
    }];
}
-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataSourceArray.count;
}
-(CGFloat) tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.5;
}
-(CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.5;
}
-(UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString  *inde = @"cell";
    YSChoosePeopleTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:inde];
    if (cell == nil) {
        cell = [[YSChoosePeopleTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:inde];
    }
    peopleModel = _dataSourceArray[indexPath.row];
    for (int i=0 ; i < si.selectDataArr.count; i++) {
        DLog(@"=====%@-------%@",peopleModel.id,si.selectDataArr[i]);
        if ([peopleModel.id isEqual:si.selectDataArr[i]]) {
            cell.chooseImage.image = [UIImage imageNamed:@"选择1"];
        }
    }
    if (si.selectDataArr.count == 0) {
        cell.chooseImage.image = [UIImage imageNamed:@"未选"];
    }
    cell.titleLabel.text = peopleModel.name;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    YSInternalModel *model1 =  _dataSourceArray[indexPath.row];
    for (int i = 0; i< si.selectDataArr.count; i++) {
        if ([model1.id isEqual:si.selectDataArr[i]]) {
            [si.selectDataArr removeObjectAtIndex:i];
            _isADD = YES;
        }
    }
    if (_isADD == NO) {
        [si.selectDataArr addObject:model1.id];
    }else{
        _isADD = NO;
    }
    self.chooseView.numLabel.text = [NSString stringWithFormat:@"共选择%lu人",(unsigned long)si.selectDataArr.count];
    DLog(@"====1111111====%@",si.selectDataArr);
    [table reloadData];
    
}
- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    
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
