//
//  YSChooseMorePeopleViewController.h
//  YaSha-iOS
//
//  Created by YaSha_Tom on 2017/8/7.
//
//

#import <UIKit/UIKit.h>
#import "YSChoosePeopleView.h"
#import "YSInternalPeopleModel.h"

typedef enum {
    AddressBook,
    MeetingRoom,
    CreateGroup,
    AddGroup,
    FlowSelectPeople,
    LaunchFlowSelectPeople,
} ChoosePeopleEnum;

@interface YSChooseMorePeopleViewController : UIViewController

@property (nonatomic, strong) NSArray *dataArr;
@property (nonatomic, strong) NSMutableArray *peopleArray;
@property (nonatomic, strong) NSMutableArray *organizationArray;
@property (nonatomic, strong) NSString *str;
@property (nonatomic, strong) YSChoosePeopleView *chooseView;
@property (nonatomic, strong) NSString *isFirst;

@property (nonatomic, assign) ChoosePeopleEnum type;

@property (nonatomic, strong) NSIndexPath *indexPath;

@end
