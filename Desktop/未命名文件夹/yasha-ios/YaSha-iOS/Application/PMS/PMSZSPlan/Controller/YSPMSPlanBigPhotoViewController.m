//
//  YSPMSPlanBigPhotoViewController.m
//  YaSha-iOS
//
//  Created by YaSha_Tom on 2017/9/29.
//

#import "YSPMSPlanBigPhotoViewController.h"
#import "YSPMSPlanImageViewItem.h"

@interface YSPMSPlanBigPhotoViewController ()<UIScrollViewDelegate>

@property (nonatomic, strong) UIScrollView *scrollView;

@end

@implementation YSPMSPlanBigPhotoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor grayColor];
    if (![self.networkingPhoto isEqual:@"networking"]) {
        [self.data removeLastObject];
    }
    self.scrollView = [[UIScrollView alloc]initWithFrame:[UIScreen mainScreen].bounds];
    self.scrollView.contentSize = CGSizeMake(kSCREEN_WIDTH*(self.data.count), kSCREEN_HEIGHT);
    
    DLog(@"=======%@",self.data);
    for (int i = 0; i < self.data.count; i ++) {
        UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(kSCREEN_WIDTH*i, 0, kSCREEN_WIDTH, kSCREEN_HEIGHT)];
        imageView.backgroundColor = [UIColor whiteColor];
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        if ([self.networkingPhoto isEqual:@"networking"]) {
            [imageView sd_setImageWithURL:[NSURL URLWithString:_data[i]] placeholderImage:[UIImage imageNamed:@"头像"]];
        }else{
            imageView.image = self.data[i];
            
        }
        //设置响应事件
        imageView.userInteractionEnabled = YES;
        //添加手势 ---点击消失
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAct:)];
        [imageView addGestureRecognizer:tap];
        [_scrollView addSubview:imageView];
    }
    //_scrollView的属性
    _scrollView.pagingEnabled = YES;
    //设置代理
    _scrollView.delegate = self;
    //设置scollView的初始位置
    _scrollView.contentOffset = CGPointMake(self.index*kSCREEN_WIDTH, 0);
    //添加_scrollView
    [self.view addSubview:_scrollView];
}
//点击图片的响应事件
-(void)tapAct:(UITapGestureRecognizer *)tap{
    
    [self dismissViewControllerAnimated:YES completion:nil];
    

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
