//
//  YSSupplyMaterialInfoViewController.m
//  YaSha-iOS
//
//  Created by YaSha_Tom on 2017/11/14.
//

#import "YSSupplyMaterialInfoViewController.h"
#import "YSPMSInfoDetailHeaderCell.h"
#import "YSMaterialInfoModel.h"
#import "YSMaterialImageModel.h"
@interface YSSupplyMaterialInfoViewController ()

@property (nonatomic, strong) NSArray *titleArray;
@property (nonatomic,strong) YSMaterialInfoModel *materialModel;
@property (nonatomic,strong) NSMutableArray *datasourceArr;
@end

@implementation YSSupplyMaterialInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.tableView registerClass:[YSPMSInfoDetailHeaderCell class] forCellReuseIdentifier:@"SupplyMaterialInfoCell"];
    self.tableView.estimatedSectionFooterHeight = 0.0;
    self.tableView.estimatedSectionHeaderHeight = 0.0;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
   [self doNetworking];
}
- (void)doNetworking{
    
    [YSNetManager ys_request_GETWithUrlString:[NSString stringWithFormat:@"%@%@/%@",YSDomain,getMaterialDetailInfoApp,self.materialID] isNeedCache:NO parameters:nil successBlock:^(id response) {
        if ([response[@"code"] integerValue] == 1) {
            DLog(@"=======%@",response);
            self.materialModel = [YSMaterialInfoModel yy_modelWithJSON:response[@"data"]];
            [self setUpData];
            [self.tableView reloadData];
            //刷新轮播图
            NSMutableArray *imageArr = [NSMutableArray arrayWithCapacity:10];
            for (YSMaterialImageModel *model in self.materialModel.files) {
                [imageArr addObject:model.filePath];
            }
            self.cycleScrollViewRefresh(imageArr);
        }else{
            [QMUITips showError:response[@"msg"] inView:self.view];
        }
    } failureBlock:^(NSError *error) {
        
    } progress:nil];
}
- (void)setUpData {
    self.datasourceArr  = [NSMutableArray array];
    [self.datasourceArr addObject:@{@"材料名称":_materialModel.name?_materialModel.name:@"--"}];
    
    [self.datasourceArr addObject:@{@"状态":_materialModel.status == 10?@"启用":@"禁用"}];
     [self.datasourceArr addObject:@{@"材料编号":_materialModel.no?_materialModel.no:@"--"}];
     [self.datasourceArr addObject:@{@"物料类别":[NSString stringWithFormat:@"%@  %@  %@  %@",_materialModel.mtrlOne,_materialModel.mtrlTwo,_materialModel.mtrlThree,_materialModel.mtrlFour]}];
     [self.datasourceArr addObject:@{@"材料规格":_materialModel.standard?_materialModel.standard:@"--"}];
     [self.datasourceArr addObject:@{@"品牌":_materialModel.brand?_materialModel.brand:@"--"}];
     [self.datasourceArr addObject:@{@"供方型号":_materialModel.model?_materialModel.model:@"--"}];
     [self.datasourceArr addObject:@{@"主单位":_materialModel.unit?_materialModel.unit:@"--"}];
    [self.datasourceArr addObject:@{@"供货周期(天)":_materialModel.cycle? _materialModel.cycle:@"--"}];
    [self.datasourceArr addObject:@{@"采购单位":_materialModel.purUnit?_materialModel.purUnit:@"--"}];
//    if (_materialModel.purRate > 0) {
//
//       [self.datasourceArr addObject:@{@"采购转化率":[NSString stringWithFormat:@"%.2f",_materialModel.purRate]}];
//    }else{
//        [self.datasourceArr addObject:@{@"采购转化率":@"--"}];
//    }
    [self.datasourceArr addObject:@{@"使用单位":_materialModel.useCompany?_materialModel.useCompany:@"--"}];
    [self.datasourceArr addObject:@{@"包装":_materialModel.pack?_materialModel.pack:@"--"}];
    [self.datasourceArr addObject:@{@"容量":_materialModel.capacity?_materialModel.capacity:@"--"}];
    [self.datasourceArr addObject:@{@"材质":_materialModel.quality?_materialModel.quality:@"--"}];
    [self.datasourceArr addObject:@{@"颜色":_materialModel.color?_materialModel.color:@"--"}];
    [self.datasourceArr addObject:@{@"辅助单位":_materialModel.assistUnit?_materialModel.assistUnit:@"--"}];
    if (_materialModel.stockRate > 0) {
        [self.datasourceArr addObject:@{@"转化率(主/辅)":[NSString stringWithFormat:@"%.2f",_materialModel.stockRate]}];
    }else{
        [self.datasourceArr addObject:@{@"转化率(主/辅)":@"--"}];
    }
    [self.datasourceArr addObject:@{@"备注":_materialModel.remark?_materialModel.remark:@"--"}];
}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.datasourceArr.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    YSPMSInfoDetailHeaderCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SupplyMaterialInfoCell" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.dic = self.datasourceArr[indexPath.row];
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
        return [tableView fd_heightForCellWithIdentifier:@"SupplyMaterialInfoCell" cacheByIndexPath:indexPath configuration:^(YSPMSInfoDetailHeaderCell *cell) {
            NSDictionary *dic = self.datasourceArr[indexPath.row];
            if ([[dic allValues].firstObject isEqualToString:@""] || [[dic allValues].firstObject isEqual:[NSNull null]] || [dic allValues].firstObject == nil ) {
                cell.contentLabel.text = @"备注";
            }else{
                cell.contentLabel.text = [dic allValues].firstObject;
            }            
        }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
