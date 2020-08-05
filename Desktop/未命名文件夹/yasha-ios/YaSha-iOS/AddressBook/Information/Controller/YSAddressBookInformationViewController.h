//
//  YSAddressBookInformationViewController.h
//  YaSha-iOS
//
//  Created by mHome on 2016/12/13.
//
//

#import <UIKit/UIKit.h>
#import "YSSelfNVCView.h"

@interface YSAddressBookInformationViewController : UIViewController

@property (nonatomic,assign) BOOL rightBarButtonItemFlag;

@property (nonatomic,strong) NSString *telStr;
@property (nonatomic,strong) NSString *nameStr;
@property (nonatomic,strong) YSSelfNVCView *selfNavigation;

@end
