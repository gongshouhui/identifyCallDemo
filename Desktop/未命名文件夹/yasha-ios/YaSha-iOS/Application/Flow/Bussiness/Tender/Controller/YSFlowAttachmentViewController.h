//
//  YSFlowAttachmentViewController.h
//  YaSha-iOS
//
//  Created by YaSha_Tom on 2017/11/24.
//

#import "YSCommonListViewController.h"
#import "YSNewsAttachmentModel.h"

@interface YSFlowAttachmentViewController : YSCommonListViewController

/**里面放数组，新闻页面附件*/
@property (nonatomic, strong) NSMutableArray *applyInfosArray;
/**里面放YSNewsAttachmentModel*/
@property (nonatomic,strong) NSArray<YSNewsAttachmentModel *>
*attachMentArray;
@property (nonatomic,strong) NSString *naviTitle;
@end

