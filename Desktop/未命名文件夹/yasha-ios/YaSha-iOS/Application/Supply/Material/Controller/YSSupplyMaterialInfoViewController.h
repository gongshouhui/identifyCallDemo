//
//  YSSupplyMaterialInfoViewController.h
//  YaSha-iOS
//
//  Created by YaSha_Tom on 2017/11/14.
//

#import <UIKit/UIKit.h>

@interface YSSupplyMaterialInfoViewController : UITableViewController
@property (nonatomic,strong) NSString *materialID;
@property (nonatomic,copy) void(^cycleScrollViewRefresh)(NSArray *imageUrls);
@end
