//
//  YSVoiceInfoController.m
//  YaSha-iOS
//
//  Created by 蘑菇加 on 2017/12/11.
//  Copyright © 2017年 亚厦装饰股份有限公司. All rights reserved.
//

#import "YSHRVoiceInfoController.h"
#import "YSHRPersonalInfoCell.h"
#import "YSHRInfoFirstCell.h"
#import "YSHRLanguageModel.h"
@interface YSHRVoiceInfoController ()

@end

@implementation YSHRVoiceInfoController

- (void)setNavigationItemsIsInEditMode:(BOOL)isInEditMode animated:(BOOL)animated {
    [super setNavigationItemsIsInEditMode:isInEditMode animated:animated];
    self.title = @"语言信息";
}

- (void)initTableView
{
    [super initTableView];
    [self.tableView registerClass:[YSHRPersonalInfoCell class] forCellReuseIdentifier:@"YSPersonalInfoCell"];
   [self hideMJRefresh];
    self.tableView.sectionFooterHeight = 0.0;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = kUIColor(229, 229, 229, 1);
    [self doNetworking];
}
- (void)doNetworking{
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        for (YSHRLanguageModel *model in _modelArr) {
            NSMutableArray *mutableArr = [NSMutableArray arrayWithCapacity:10];
            [mutableArr addObject:@{@"语种":model.langsort,@"熟练度":model.langskill}];
            [mutableArr addObject:@{@"掌握语种水平的等级":model.langlev}];
            [mutableArr addObject:@{@"证书名称":model.certifname}];
            [mutableArr addObject:@{@"证书编号":model.certifcode}];
            [mutableArr addObject:@{@"获证日期":model.certifdate}];
            //[mutableArr addObject:@{@"备注":model.langsort}];
            [self.dataSourceArray addObject:mutableArr];
        }
        
       
        
        dispatch_sync(dispatch_get_main_queue(), ^{
            
            [self ys_reloadDataWithImageName:@"ic_info_bg_language" text:@"暂无语言信息\n快去后台添加吧"];
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
    if (indexPath.row == 0) {
        YSHRInfoFirstCell *cell = [[YSHRInfoFirstCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@""];
        cell.langDic = dic;
        return cell;
    }
    YSHRPersonalInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:@"YSPersonalInfoCell" forIndexPath:indexPath];
    cell.dic = dic;
    return cell;
    
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view = [[UIView alloc]init];
    view.backgroundColor = kUIColor(229, 229, 229, 1);
    return view;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 15;
}
- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewAutomaticDimension;
}
// 重新绘制cell边框

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    //这里获取的frame比较准确，cell赋值后为什么获取不到正确的frame（预估高度影响？）？
    if ([cell respondsToSelector:@selector(tintColor)]) {
        
        // if (tableView == self.tableView) {
        
        CGFloat cornerRadius = 10.f;
        
        // cell.backgroundColor = UIColor.clearColor;
        
        CAShapeLayer *layer = [[CAShapeLayer alloc] init];
        
        CGMutablePathRef pathRef = CGPathCreateMutable();
        
        CGRect bounds = CGRectInset(cell.bounds, 15, 0);
        
        BOOL addLine = NO;
        
        //用UIBezierPath准备路径配合 CAShapeLayer也可以
        if (indexPath.row == 0 && indexPath.row == [tableView numberOfRowsInSection:indexPath.section]-1) {
            
            CGPathAddRoundedRect(pathRef, nil, bounds, cornerRadius, cornerRadius);
            
        } else if (indexPath.row == 0) {
            
            CGPathMoveToPoint(pathRef, nil, CGRectGetMinX(bounds), CGRectGetMaxY(bounds));
            
            CGPathAddArcToPoint(pathRef, nil, CGRectGetMinX(bounds), CGRectGetMinY(bounds), CGRectGetMidX(bounds), CGRectGetMinY(bounds), cornerRadius);
            
            CGPathAddArcToPoint(pathRef, nil, CGRectGetMaxX(bounds), CGRectGetMinY(bounds), CGRectGetMaxX(bounds), CGRectGetMidY(bounds), cornerRadius);
            
            CGPathAddLineToPoint(pathRef, nil, CGRectGetMaxX(bounds), CGRectGetMaxY(bounds));
            
            addLine = YES;//不需要分割线
            
        } else if (indexPath.row == [tableView numberOfRowsInSection:indexPath.section]-1) {
            
            CGPathMoveToPoint(pathRef, nil, CGRectGetMinX(bounds), CGRectGetMinY(bounds));
            
            CGPathAddArcToPoint(pathRef, nil, CGRectGetMinX(bounds), CGRectGetMaxY(bounds), CGRectGetMidX(bounds), CGRectGetMaxY(bounds), cornerRadius);
            
            CGPathAddArcToPoint(pathRef, nil, CGRectGetMaxX(bounds), CGRectGetMaxY(bounds), CGRectGetMaxX(bounds), CGRectGetMidY(bounds), cornerRadius);
            
            CGPathAddLineToPoint(pathRef, nil, CGRectGetMaxX(bounds), CGRectGetMinY(bounds));
            
        } else {
            
            CGPathAddRect(pathRef, nil, bounds);
            
            addLine = NO;
            
        }
        
        layer.path = pathRef;
        
        CFRelease(pathRef);
        
        //颜色修改
        
        layer.fillColor = [UIColor whiteColor].CGColor;
        
        layer.strokeColor=[UIColor whiteColor].CGColor;//边框线颜色
        
        if (addLine == YES) {//分割线
            
            CALayer *lineLayer = [[CALayer alloc] init];
            
            CGFloat lineHeight = (1.f / [UIScreen mainScreen].scale);
            
            lineLayer.frame = CGRectMake(CGRectGetMinX(bounds), bounds.size.height-lineHeight, bounds.size.width, lineHeight);
            
            lineLayer.backgroundColor = tableView.separatorColor.CGColor;
            
            [layer addSublayer:lineLayer];
            
        }
        
        UIView *testView = [[UIView alloc] initWithFrame:bounds];//点击效果会影响圆角，自己覆盖一个view
        
        [testView.layer insertSublayer:layer atIndex:0];
        
        testView.backgroundColor = UIColor.clearColor;
        
        cell.backgroundView = testView;
        
    }
    
    // }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
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
