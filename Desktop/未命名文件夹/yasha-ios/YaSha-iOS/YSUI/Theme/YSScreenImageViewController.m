//
//  YSScreenImageViewController.m
//  YaSha-iOS
//
//  Created by 罗罗诺亚索隆 on 2018/12/4.
//  Copyright © 2018 亚厦装饰股份有限公司. All rights reserved.
//

#import "YSScreenImageViewController.h"

@interface YSScreenImageViewController ()
@property (nonatomic,strong) UIWindow *window;
@end

@implementation YSScreenImageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
   
    // Do any additional setup after loading the view.
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:[UIScreen mainScreen].bounds];
    [self.view addSubview:imageView];
    imageView.image = self.image;
    [self.view addSubview:imageView];
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
