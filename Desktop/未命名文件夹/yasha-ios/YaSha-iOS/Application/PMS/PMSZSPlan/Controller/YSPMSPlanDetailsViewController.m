//
//  YSPMSPlanDetailsViewController.m
//  YaSha-iOS
//
//  Created by YaSha_Tom on 2018/1/29.
//  Copyright © 2018年 亚厦装饰股份有限公司. All rights reserved.
//

#import "YSPMSPlanDetailsViewController.h"
#import "YSPMSPlanBigPhotoViewController.h"
#import "YSPMSPlanDetailsViewCell.h"
#import "YSPMSPlanHeaderView.h"
#import "YSPMSPlanListModel.h"
#import "YSPMSPlanPhotoViewCell.h"

@interface YSPMSPlanDetailsViewController ()

@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) NSMutableArray *photoArray;
@property (nonatomic, strong) NSMutableDictionary *contentOffsetDictionary;
@property (nonatomic, strong) YSPMSPlanHeaderView *PMSPlanHeaderView;
@property (nonatomic, strong) NSString *titleName;
@property (nonatomic, strong) NSString *percentage;
@property (nonatomic, strong) NSString *startTime;
@property (nonatomic, strong) NSString *endTime;
@property (nonatomic, strong) NSString *day;
@property (nonatomic, strong) NSDictionary *diction;

@end

@implementation YSPMSPlanDetailsViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}
- (void)initTableView {
    [super initTableView];
    [self hideMJRefresh];
    self.title = @"详情";
    self.dataArray = [NSMutableArray array];
    self.photoArray = [NSMutableArray array];
    [self.tableView registerClass:[YSPMSPlanDetailsViewCell class] forCellReuseIdentifier:@"PlanDetailsCell"];
   [self doNetworking];
}

- (void)doNetworking {
    [YSNetManager ys_request_GETWithUrlString:[NSString stringWithFormat:@"%@%@/%@",YSDomain,getPlanTaskDetail,self.code] isNeedCache:NO parameters:nil successBlock:^(id response) {
        DLog(@"=======%@",response);
        if ([response[@"data"] count] > 0) {
            self.diction = response[@"data"];
            for (NSDictionary *dic  in response[@"data"][@"progresses"]) {
                [self.dataArray addObject:[YSPMSPlanListModel yy_modelWithJSON:dic]];
            }
            [self.tableView reloadData];
        }
    } failureBlock:^(NSError *error) {
        DLog(@"-------%@",error);
    } progress:nil];
}

#pragma mark - UITableViewDataSource Methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    YSPMSPlanDetailsViewCell *cell = (YSPMSPlanDetailsViewCell *)[tableView cellForRowAtIndexPath:indexPath];
    if (!cell){
        cell = [[YSPMSPlanDetailsViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"PlanDetailsCell"];
    }
    [cell setPlanDetailsDataCell:self.dataArray[indexPath.row]];
    return cell;
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(YSPMSPlanDetailsViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    YSPMSPlanListModel *model = self.dataArray[indexPath.row];
    [cell setCollectionViewDataSourceDelegate:self indexPath:indexPath];
    cell.collectionView.frame = CGRectMake(0, 80*kHeightScale, kSCREEN_WIDTH, 120*(model.filePathStr.count%3 == 0 ? model.filePathStr.count/3 :  model.filePathStr.count/3+ 1)*kHeightScale);
    
}

#pragma mark - UITableViewDelegate Methods

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    YSPMSPlanListModel *model = self.dataArray[indexPath.row];
    return [tableView fd_heightForCellWithIdentifier:@"PlanDetailsCell" cacheByIndexPath:indexPath configuration:^(YSPMSPlanDetailsViewCell *cell) {
        
        cell.contentLabel.font = [UIFont systemFontOfSize:16];
        cell.contentLabel.text = model.remark;
    }];
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 245*kHeightScale;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(0, 10, kSCREEN_WIDTH, 235*kHeightScale)];
    backView.backgroundColor = [UIColor whiteColor];
    
    self.PMSPlanHeaderView = [[YSPMSPlanHeaderView alloc]initWithFrame:CGRectMake(0, 0, kSCREEN_WIDTH, 235*kHeightScale)];
    [self.PMSPlanHeaderView setData:self.diction];
    [backView addSubview:self.PMSPlanHeaderView];
    
    return backView;
}

#pragma mark - UICollectionViewDataSource Methods

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    YSPMSPlanListModel *model = self.dataArray[[(AFIndexedCollectionView *)collectionView indexPath].row];
    return model.filePathStr.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    YSPMSPlanPhotoViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CollectionViewCellIdentifier forIndexPath:indexPath];
    YSPMSPlanListModel *model = self.dataArray[[(AFIndexedCollectionView *)collectionView indexPath].row];
    NSMutableArray *photoArray = [NSMutableArray array];
    for (NSDictionary *dic in model.filePathStr) {
        [photoArray addObject:[NSString stringWithFormat:@"%@",[dic[@"filePath"] stringByReplacingOccurrencesOfString:@"_L" withString:@"_S"]]];
    }
    DLog(@"---------%@",photoArray);
    [cell.photoImageView sd_setImageWithURL:[NSURL URLWithString:photoArray[indexPath.row]] placeholderImage:[UIImage imageNamed:@"头像"]];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    YSPMSPlanListModel *model = self.dataArray[[(AFIndexedCollectionView *)collectionView indexPath].row];
    NSMutableArray *photoArray = [NSMutableArray array];
    for (NSDictionary *dic in model.filePathStr) {
        [photoArray addObject:[NSString stringWithFormat:@"%@",dic[@"filePath"]]];
    }
    YSPMSPlanBigPhotoViewController *PMSPlanBigPhotoViewController = [[YSPMSPlanBigPhotoViewController alloc]init];
    PMSPlanBigPhotoViewController.data = [photoArray copy];
    PMSPlanBigPhotoViewController.index = indexPath.row;
    PMSPlanBigPhotoViewController.networkingPhoto = @"networking";
    [self presentViewController:PMSPlanBigPhotoViewController animated:YES completion:nil];
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
