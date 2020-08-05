//
//  YSPMSPlanSearchView.h
//  YaSha-iOS
//
//  Created by YaSha_Tom on 2017/10/13.
//

#import <UIKit/UIKit.h>

@interface YSPMSPlanSearchView : UIView

@property (nonatomic, strong) RACSubject *searchSubject;
@property (nonatomic, strong) RACSubject *filtSubject;

@property (nonatomic, strong) UISearchBar *searchBar;

@end
