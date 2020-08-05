//
//  YSClassificationViewController.m
//  YaSha-iOS
//
//  Created by YaSha_Tom on 2018/1/29.
//  Copyright © 2018年 亚厦装饰股份有限公司. All rights reserved.
//

#import "YSClassificationViewController.h"
#import "KJPoint.h"
#import "Node.h"
#import "TreeTableView.h"
#import "YSRepairViewController.h"

@interface YSClassificationViewController ()<TreeTableCellDelegate>

@property (strong,nonatomic)NSMutableArray *Points;
@property (strong,nonatomic)NSMutableArray *allPoints;
@property (strong,nonatomic)NSString *name;

@end

@implementation YSClassificationViewController

- (void)initSubviews {
    [super initSubviews];
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"问题分类";
    self.name = @"";
    self.view.frame = [UIScreen mainScreen].bounds;
}

- (void) initPoints:(NSArray *)dataSourceArray {
    //封装参数
    _Points = [NSMutableArray array];
    _allPoints = [NSMutableArray array];
    [dataSourceArray enumerateObjectsUsingBlock:^(NSDictionary *pointDic, NSUInteger idx, BOOL * _Nonnull stop) {
        KJPoint *point = [[KJPoint alloc]initWithPointDic:pointDic];
        point.point_depth = @"0";
        point.point_expand = YES;
        point.point_pid = @"13";
        [_Points addObject:point];
    }];
    [self recursiveAllPoints:_Points];
    //创建Node节点
    NSMutableArray *nodes = [NSMutableArray array];
    [_allPoints enumerateObjectsUsingBlock:^(KJPoint *point, NSUInteger idx, BOOL * _Nonnull stop) {
        Node *node = [[Node alloc] initWithParentId:point.point_pid  nodeId:point.point_knowid  name:point.point_name depth: [point.point_depth integerValue] expand:point.point_expand sonFlag:point.point_son classCode :point.point_id linkCode:point.point_qNum ] ;
        [nodes addObject:node];
    }];
    
    //TreeTableView
    TreeTableView *tableview = [[TreeTableView alloc] initWithFrame:CGRectMake(0, 0, kSCREEN_WIDTH, kSCREEN_HEIGHT) withData:nodes];
    tableview.treeTableCellDelegate = self;
    [self.view addSubview:tableview];
    
}
//递归所有的知识点
- (void)recursiveAllPoints:(NSMutableArray *)point_arrM {
    __block int i = 0 ;
    __block NSString *parentId = nil ;
    [point_arrM enumerateObjectsUsingBlock:^(KJPoint *point, NSUInteger idx, BOOL * _Nonnull stop) {
        [_allPoints addObject:point];
        i = [point.point_depth intValue];
        parentId = point.point_knowid;
        if ([[NSString stringWithFormat:@"%@",point.point_son] isEqual:@"1"]) {
            i = i + 1;
            NSMutableArray *sonPoints = [NSMutableArray array];
            [point.point_son1 enumerateObjectsUsingBlock:^(NSDictionary *pointDic, NSUInteger idx, BOOL * _Nonnull stop) {
                KJPoint *point = [[KJPoint alloc]initWithPointDic:pointDic];
                point.point_depth = [NSString stringWithFormat:@"%d",i];
                point.point_pid = parentId;
                point.point_expand = NO;
                [sonPoints addObject:point];
            }];
            [self recursiveAllPoints:sonPoints];
        }else{
            i = 0 ;
        }
    }];
}


- (void)cellClick:(Node *)node  name:(NSString *)nameStr{
    if (![[NSString stringWithFormat:@"%@",node.sonFlag] isEqual:@"1"]) {
        for (UIViewController *controller in self.rt_navigationController.rt_viewControllers) {
            if ([controller isKindOfClass:[YSRepairViewController class]]) {
                [self.navigationController popToViewController:controller animated:YES];
            }
        }
        if ([[nameStr substringToIndex:1] isEqual:@"/"]) {
            self.block([nameStr substringFromIndex:1],node.classCode,node.linkCode ,node.name);
        }else{
            self.block(nameStr,node.classCode,node.linkCode ,node.name);
        }
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
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
