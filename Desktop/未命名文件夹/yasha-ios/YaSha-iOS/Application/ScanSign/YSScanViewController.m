//
//  YSScanViewController.m
//  YaSha-iOS
//
//  Created by 罗罗诺亚索隆 on 2019/12/11.
//  Copyright © 2019 亚厦装饰股份有限公司. All rights reserved.
//

#import "YSScanViewController.h"
#import <AVFoundation/AVFoundation.h>
#import <AudioToolbox/AudioToolbox.h>
@interface YSScanViewController ()<AVCaptureMetadataOutputObjectsDelegate,CAAnimationDelegate>
@property (nonatomic,strong) AVCaptureSession *session;
@property (nonatomic,strong) UIView *highlightView;
@property (nonatomic,assign) NSInteger line_tag;
@end

@implementation YSScanViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
	 [self instanceDevice];
}
- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	 //修改导航栏颜色
	   [self.navigationController.navigationBar setBackgroundImage:[UIImage imageWithColor:kUIColor(108, 108, 108, 108)] forBarMetrics:UIBarMetricsDefault];
}
- (void)dealloc {
	 [self.session removeObserver:self forKeyPath:@"running" context:nil];
}

/**
 *
 *  配置相机属性
 */
- (void)instanceDevice{
    
    self.line_tag = 1872637;
    //获取摄像设备
    AVCaptureDevice * device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    //创建输入流
    AVCaptureDeviceInput * input = [AVCaptureDeviceInput deviceInputWithDevice:device error:nil];
    //创建输出流
    AVCaptureMetadataOutput * output = [[AVCaptureMetadataOutput alloc]init];
    //设置代理 在主线程里刷新
    [output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
    
    //初始化链接对象
    self.session = [[AVCaptureSession alloc]init];
    //高质量采集率
    [self.session setSessionPreset:AVCaptureSessionPresetHigh];
    if (input) {
        [self.session addInput:input];
    }
    if (output) {
        [self.session addOutput:output];
        //设置扫码支持的编码格式(如下设置条形码和二维码兼容)
        NSMutableArray *a = [[NSMutableArray alloc] init];
        if ([output.availableMetadataObjectTypes containsObject:AVMetadataObjectTypeQRCode]) {
            [a addObject:AVMetadataObjectTypeQRCode];
        }
        if ([output.availableMetadataObjectTypes containsObject:AVMetadataObjectTypeEAN13Code]) {
            [a addObject:AVMetadataObjectTypeEAN13Code];
        }
        if ([output.availableMetadataObjectTypes containsObject:AVMetadataObjectTypeEAN8Code]) {
            [a addObject:AVMetadataObjectTypeEAN8Code];
        }
        if ([output.availableMetadataObjectTypes containsObject:AVMetadataObjectTypeCode128Code]) {
            [a addObject:AVMetadataObjectTypeCode128Code];
        }
        output.metadataObjectTypes=a;
    }
    AVCaptureVideoPreviewLayer * layer = [AVCaptureVideoPreviewLayer layerWithSession:self.session];
    layer.videoGravity=AVLayerVideoGravityResizeAspectFill;
    layer.frame=self.view.layer.bounds;
    [self.view.layer insertSublayer:layer atIndex:0];
    
    [self setOverlayPickerView];
    
    [self.session addObserver:self forKeyPath:@"running" options:NSKeyValueObservingOptionNew context:nil];
    
    //开始捕获
    [self.session startRunning];
}

/**
 *
 *  监听扫码状态-修改扫描动画
 *
 */
- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context{
    if ([object isKindOfClass:[AVCaptureSession class]]) {
        BOOL isRunning = ((AVCaptureSession *)object).isRunning;
        if (isRunning) {
            [self addAnimation];
        }else{
            [self removeAnimation];
        }
    }
}

/**
 *
 *  获取扫码结果
 */
-(void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection{
    if (metadataObjects.count>0) {
        [self.session stopRunning];
        NSURL *url=[[NSBundle mainBundle]URLForResource:@"scanSuccess.wav" withExtension:nil];
            //2.加载音效文件，创建音效ID（SoundID,一个ID对应一个音效文件）
             SystemSoundID soundID=8787;
             AudioServicesCreateSystemSoundID((__bridge CFURLRef)url, &soundID);
             //3.播放音效文件
             //下面的两个函数都可以用来播放音效文件，第一个函数伴随有震动效果
             AudioServicesPlayAlertSound(soundID);
        
        AudioServicesPlaySystemSound(8787);

        AVMetadataMachineReadableCodeObject * metadataObject = [metadataObjects objectAtIndex :0];
		
		[QMUITips showLoadingInView:self.view];
		[YSNetManager ys_request_GETWithUrlString:[NSString stringWithFormat:@"%@/%@",metadataObject.stringValue,[YSUtility getUID]] isNeedCache:NO parameters:nil successBlock:^(id response) {
			[QMUITips hideAllTipsInView:self.view];
			[QMUITips showInfo:@"签到成功" inView:self.view hideAfterDelay:2];
			
			dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
				[self.navigationController popViewControllerAnimated:YES];
			});
		} failureBlock:^(NSError *error) {
			[QMUITips hideAllTipsInView:self.view];
			[QMUITips showInfo:@"签到失败" inView:self.view hideAfterDelay:1];
			//开始捕获
			[self.session startRunning];
		} progress:nil];
		
	
        
        //输出扫描字符串
//        NSString *data = metadataObject.stringValue;
//        ScanResultViewController *resultVC = [[ScanResultViewController alloc] init];
//        resultVC.title = @"扫描结果";
//        resultVC.result = data;
//        [self.navigationController pushViewController:resultVC animated:YES];
        
    }
}





/**
 *
 *  创建扫码页面
 */
- (void)setOverlayPickerView
{
    //左侧的view
    UIImageView *leftView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 30, kSCREEN_HEIGHT)];
    leftView.alpha = 0.5;
    leftView.backgroundColor = [UIColor blackColor];
    [self.view addSubview:leftView];
    //右侧的view
    UIImageView *rightView = [[UIImageView alloc] initWithFrame:CGRectMake(kSCREEN_WIDTH-30, 0, 30, kSCREEN_HEIGHT)];
    rightView.alpha = 0.5;
    rightView.backgroundColor = [UIColor blackColor];
    [self.view addSubview:rightView];
    
    //最上部view
    UIImageView* upView = [[UIImageView alloc] initWithFrame:CGRectMake(30, 0, kSCREEN_WIDTH - 60, (self.view.center.y-(kSCREEN_WIDTH-60)/2))];
    upView.alpha = 0.5;
    upView.backgroundColor = [UIColor blackColor];
    [self.view addSubview:upView];
    
    //底部view
    UIImageView * downView = [[UIImageView alloc] initWithFrame:CGRectMake(30, (self.view.center.y+(kSCREEN_WIDTH-60)/2), (kSCREEN_WIDTH-60), (kSCREEN_HEIGHT-(self.view.center.y-(kSCREEN_WIDTH-60)/2)))];
    downView.alpha = 0.5;
    downView.backgroundColor = [UIColor blackColor];
    [self.view addSubview:downView];
    
    UIImageView *centerView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kSCREEN_WIDTH-60, kSCREEN_HEIGHT-60)];
    centerView.center = self.view.center;
    centerView.image = [UIImage imageNamed:@"scan_circle"];
    centerView.contentMode = UIViewContentModeScaleAspectFit;
    centerView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:centerView];
    
    UIImageView *line = [[UIImageView alloc] initWithFrame:CGRectMake(30, CGRectGetMaxY(upView.frame), kSCREEN_WIDTH-60, 2)];
    line.tag = self.line_tag;
    line.image = [UIImage imageNamed:@"scan_line"];
    line.contentMode = UIViewContentModeScaleAspectFill;
    line.backgroundColor = [UIColor clearColor];
    [self.view addSubview:line];
    
    UILabel *msg = [[UILabel alloc] initWithFrame:CGRectMake(30, CGRectGetMinY(downView.frame), kSCREEN_WIDTH-60, 60)];
    msg.backgroundColor = [UIColor clearColor];
    msg.textColor = [UIColor whiteColor];
    msg.textAlignment = NSTextAlignmentCenter;
    msg.font = [UIFont systemFontOfSize:16];
    msg.text = @"将二维码放入框内,即可自动扫描";
    [self.view addSubview:msg];
    
//    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, kSCREEN_HEIGHT-100, kSCREEN_WIDTH, 100)];
//    label.backgroundColor = [UIColor clearColor];
//    label.textColor = [UIColor whiteColor];
//    label.textAlignment = NSTextAlignmentCenter;
//    label.font = [UIFont systemFontOfSize:15];
//    label.text = @"";
//    [self.view addSubview:label];
    
    
    
    
    
    
    
}

/**
 *
 *  添加扫码动画
 */
- (void)addAnimation{
    UIView *line = [self.view viewWithTag:self.line_tag];
    line.hidden = NO;
    CABasicAnimation *animation = [YSScanViewController moveYTime:2 fromY:[NSNumber numberWithFloat:0] toY:[NSNumber numberWithFloat:kSCREEN_WIDTH-60-2] rep:OPEN_MAX];
    [line.layer addAnimation:animation forKey:@"LineAnimation"];
}

+ (CABasicAnimation *)moveYTime:(float)time fromY:(NSNumber *)fromY toY:(NSNumber *)toY rep:(int)rep
{
    CABasicAnimation *animationMove = [CABasicAnimation animationWithKeyPath:@"transform.translation.y"];
    [animationMove setFromValue:fromY];
    [animationMove setToValue:toY];
    animationMove.duration = time;
    animationMove.delegate = self;
    animationMove.repeatCount  = rep;
    animationMove.fillMode = kCAFillModeForwards;
    animationMove.removedOnCompletion = NO;
    animationMove.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    return animationMove;
}


/**
 *  @author Whde
 *
 *  去除扫码动画
 */
- (void)removeAnimation{
    UIView *line = [self.view viewWithTag:self.line_tag];
    [line.layer removeAnimationForKey:@"LineAnimation"];
    line.hidden = YES;
}

- (void)cancleBtnClick
{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
