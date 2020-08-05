//
//  YSChoosePeopleVC.h
//  YaSha-iOS
//
//  Created by mHome on 2017/4/17.
//
//

#import <UIKit/UIKit.h>
#import "YSChoosePeopleView.h"
#import "YSInternalPeopleModel.h"



@interface YSChoosePeopleVC : UIViewController

@property (nonatomic,strong) NSArray *dataArr;//缓存请求的数据
@property (nonatomic,strong) NSMutableArray *peopleArray;//缓存人员信息数组
@property (nonatomic,strong) NSMutableArray *organizationArray;//缓存组织信息数组
@property (nonatomic,strong) NSString *sourceStr;
@property (nonatomic,strong) NSString *str;
@property (nonatomic,strong) YSChoosePeopleView *chooseView;
@property (nonatomic,strong) NSString *isFirst; //是否是第一层界面
@property (nonatomic, strong) NSIndexPath *indexPath;

@end
