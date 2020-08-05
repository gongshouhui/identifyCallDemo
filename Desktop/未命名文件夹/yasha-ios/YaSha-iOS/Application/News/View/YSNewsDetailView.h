//
//  YSNewsDetailView.h
//  YaSha-iOS
//
//  Created by 方鹏俊 on 2017/9/30.
//

#import <UIKit/UIKit.h>
#import "YSNewsListModel.h"
#import "YSNewsAttachmentModel.h"
@protocol YSNewsDetailViewDelegate <NSObject>
- (void)attachCellDidSelected:(YSNewsAttachmentModel *)attachmentModel;
@end
@interface YSNewsDetailView : UIView

@property (nonatomic, strong) YSNewsListModel *cellModel;
@property (nonatomic, strong) NSString *content;
@property (nonatomic, strong) NSDictionary *dataDict;
@property (nonatomic, strong) NSArray *dataSourceArray;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, weak) id<YSNewsDetailViewDelegate> delegate;
@end
