//
//  YSFlowAttachmentViewController.m
//  YaSha-iOS
//
//  Created by YaSha_Tom on 2017/11/24.
//

#import "YSFlowAttachmentViewController.h"
#import "YSNewsAttachmentViewController.h"
#import "YSNewsAttachmentCell.h"
#import "YSNewsAttachmentViewController.h"
#import "YSNewsAttachmentModel.h"

@interface YSFlowAttachmentViewController ()

@end

@implementation YSFlowAttachmentViewController
- (void)viewDidLoad {
    [super viewDidLoad];
	//附件列表页
    if (self.naviTitle.length) {
        self.title = self.naviTitle;
    }else{
    self.title = @"附件";
    }
}
- (void)initTableView {
    [super initTableView];
    [self hideMJRefresh];
    [self.tableView registerClass:[YSNewsAttachmentCell class] forCellReuseIdentifier:@"FlowAttachmentCell"];
    [self doNetworking];
    
}
- (void)doNetworking {
    
    [QMUITips hideAllToastInView:self.view animated:YES];
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.applyInfosArray?self.applyInfosArray.count:self.attachMentArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60*kHeightScale;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    YSNewsAttachmentCell *cell = [tableView dequeueReusableCellWithIdentifier:@"FlowAttachmentCell"];
    if (cell == nil) {
        cell = [[YSNewsAttachmentCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"FlowAttachmentCell"];
    }
    //
    if (self.applyInfosArray) {
        [cell setAttachmentData:self.applyInfosArray[indexPath.row]];
    }else{
        cell.cellModel = self.attachMentArray[indexPath.row];
    }
   
    return cell;
}
- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    YSNewsAttachmentModel *model = nil;
    if (self.applyInfosArray) {
        model = [[YSNewsAttachmentModel alloc]init];
        model.viewPath = self.applyInfosArray[indexPath.row][2];
        model.filePath = self.applyInfosArray[indexPath.row][1];
        
    }else{
        model = self.attachMentArray[indexPath.row];
    }
    
    YSNewsAttachmentViewController *NewsAttachmentViewController = [[YSNewsAttachmentViewController alloc]init];
    NewsAttachmentViewController.attachmentModel = model;
    [self.navigationController pushViewController:NewsAttachmentViewController animated:YES];
    
   
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
