//
//  YSHRFamilyInfoController.m
//  YaSha-iOS
//
//  Created by 方鹏俊 on 2017/12/21.
//  Copyright © 2017年 亚厦装饰股份有限公司. All rights reserved.
//

#import "YSHRFamilyInfoController.h"
#import "YSHRPersonalInfoCell.h"
#import "YSHRInfoFirstCell.h"
#import "YSHRFamilyModel.h"
#import "YSHRLinkManModel.h"

@interface YSHRFamilyInfoController ()
@property (nonatomic,strong)NSMutableArray *familyArray;

@end

@implementation YSHRFamilyInfoController
- (NSMutableArray *)familyArray {
    if (!_familyArray) {
        _familyArray = [NSMutableArray array];
    }
    return _familyArray;
}
- (void)setNavigationItemsIsInEditMode:(BOOL)isInEditMode animated:(BOOL)animated {
    [super setNavigationItemsIsInEditMode:isInEditMode animated:animated];
    self.title = @"家庭信息";
}

- (void)initTableView
{
    [super initTableView];
    [self.tableView registerClass:[YSHRPersonalInfoCell class] forCellReuseIdentifier:@"YSPersonalInfoCell"];
    [self hideMJRefresh];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = kUIColor(229, 229, 229, 1);
    [self doNetworking];
}
- (void)doNetworking{
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        for (YSHRFamilyModel *model in _modelArr) {
            NSMutableArray *mutableArr = [NSMutableArray arrayWithCapacity:10];
            [self.familyArray addObject:[NSString stringWithFormat:@"%@ (%@)",model.mem_name,model.mem_relation]];
            [mutableArr addObject:@{@"工作单位":model.mem_corp}];
            [mutableArr addObject:@{@"职务":model.mem_job}];
            [mutableArr addObject:@{@"联系地址":model.relaaddr}];
            [mutableArr addObject:@{@"联系电话":model.relaphone}];
//            [mutableArr addObject:@{@"职业":model.profession}];
            [self.dataSourceArray addObject:mutableArr];
            
        }
        for(YSHRLinkManModel *model in _linkmansArr) {
            NSMutableArray *mutableArr = [NSMutableArray arrayWithCapacity:10];
            [self.familyArray addObject:[NSString stringWithFormat:@"%@ (%@)",model.linkman,@"紧急联系人"]];
            [mutableArr addObject:@{@"工作单位":@""}];
            [mutableArr addObject:@{@"联系地址":@""}];
            [mutableArr addObject:@{@"联系电话":model.mobile}];;
            [self.dataSourceArray addObject:mutableArr];
        }
  
        
    dispatch_sync(dispatch_get_main_queue(), ^{
            
            [self ys_reloadDataWithImageName:@"ic_info_bg_family" text:@"暂无家庭信息\n快去后台添加吧"];
        });
    });
    
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataSourceArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [self.dataSourceArray[section] count];
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSDictionary *dic = self.dataSourceArray[indexPath.section][indexPath.row];
//    if (indexPath.row == 0) {
//        YSHRInfoFirstCell *cell = [[YSHRInfoFirstCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@""];
//        cell.langDic = dic;
//        return cell;
//    }
    YSHRPersonalInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:@"YSPersonalInfoCell" forIndexPath:indexPath];
    cell.dic = dic;
    return cell;
    
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view = [[UIView alloc]init];
    view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    UILabel *label = [[UILabel alloc]init];
    [view addSubview:label];
    [label sizeToFit];
    label.font = [UIFont systemFontOfSize:13];
    label.textColor = kUIColor(25, 31, 37, 1);
    
    label.text = self.familyArray[section];
    label.frame = CGRectMake(15, (38 - 20)/2, kSCREEN_WIDTH, 20);
    return view;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 32*kHeightScale;
}
- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 30;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewAutomaticDimension;
}
//// 重新绘制cell边框
//
//- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
//    
//    //这里获取的frame比较准确，cell赋值后为什么获取不到正确的frame（预估高度影响？）？
//    if ([cell respondsToSelector:@selector(tintColor)]) {
//        
//        // if (tableView == self.tableView) {
//        
//        CGFloat cornerRadius = 10.f;
//        
//        // cell.backgroundColor = UIColor.clearColor;
//        
//        CAShapeLayer *layer = [[CAShapeLayer alloc] init];
//        
//        CGMutablePathRef pathRef = CGPathCreateMutable();
//        
//        CGRect bounds = CGRectInset(cell.bounds, 15, 0);
//        
//        BOOL addLine = NO;
//        
//        //用UIBezierPath准备路径配合 CAShapeLayer也可以
//        if (indexPath.row == 0 && indexPath.row == [tableView numberOfRowsInSection:indexPath.section]-1) {
//            
//            CGPathAddRoundedRect(pathRef, nil, bounds, cornerRadius, cornerRadius);
//            
//        } else if (indexPath.row == 0) {
//            
//            CGPathMoveToPoint(pathRef, nil, CGRectGetMinX(bounds), CGRectGetMaxY(bounds));
//            
//            CGPathAddArcToPoint(pathRef, nil, CGRectGetMinX(bounds), CGRectGetMinY(bounds), CGRectGetMidX(bounds), CGRectGetMinY(bounds), cornerRadius);
//            
//            CGPathAddArcToPoint(pathRef, nil, CGRectGetMaxX(bounds), CGRectGetMinY(bounds), CGRectGetMaxX(bounds), CGRectGetMidY(bounds), cornerRadius);
//            
//            CGPathAddLineToPoint(pathRef, nil, CGRectGetMaxX(bounds), CGRectGetMaxY(bounds));
//            
//            addLine = YES;//不需要分割线
//            
//        } else if (indexPath.row == [tableView numberOfRowsInSection:indexPath.section]-1) {
//            
//            CGPathMoveToPoint(pathRef, nil, CGRectGetMinX(bounds), CGRectGetMinY(bounds));
//            
//            CGPathAddArcToPoint(pathRef, nil, CGRectGetMinX(bounds), CGRectGetMaxY(bounds), CGRectGetMidX(bounds), CGRectGetMaxY(bounds), cornerRadius);
//            
//            CGPathAddArcToPoint(pathRef, nil, CGRectGetMaxX(bounds), CGRectGetMaxY(bounds), CGRectGetMaxX(bounds), CGRectGetMidY(bounds), cornerRadius);
//            
//            CGPathAddLineToPoint(pathRef, nil, CGRectGetMaxX(bounds), CGRectGetMinY(bounds));
//            
//        } else {
//            
//            CGPathAddRect(pathRef, nil, bounds);
//            
//            addLine = NO;
//            
//        }
//        
//        layer.path = pathRef;
//        
//        CFRelease(pathRef);
//        
//        //颜色修改
//        
//        layer.fillColor = [UIColor whiteColor].CGColor;
//        
//        layer.strokeColor=[UIColor whiteColor].CGColor;//边框线颜色
//        
//        if (addLine == YES) {//分割线
//            
//            CALayer *lineLayer = [[CALayer alloc] init];
//            
//            CGFloat lineHeight = (1.f / [UIScreen mainScreen].scale);
//            
//            lineLayer.frame = CGRectMake(CGRectGetMinX(bounds), bounds.size.height-lineHeight, bounds.size.width, lineHeight);
//            
//            lineLayer.backgroundColor = tableView.separatorColor.CGColor;
//            
//            [layer addSublayer:lineLayer];
//            
//        }
//        
//        UIView *testView = [[UIView alloc] initWithFrame:bounds];//点击效果会影响圆角，自己覆盖一个view
//        
//        [testView.layer insertSublayer:layer atIndex:0];
//        
//        testView.backgroundColor = UIColor.clearColor;
//        
//        cell.backgroundView = testView;
//        
//    }
//    
//    // }
//    
//}

@end
