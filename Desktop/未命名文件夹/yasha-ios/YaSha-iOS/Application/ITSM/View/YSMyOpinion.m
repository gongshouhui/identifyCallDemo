//
//  YSMyOpinion.m
//  YaSha-iOS
//
//  Created by YaSha_Tom on 2017/7/31.
//
//

#import "YSMyOpinion.h"
//#import "UITextView+PlaceHolder.h"

@implementation YSMyOpinion

-(instancetype) initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        
        
        UIView *backView = [[UIView alloc] init];
        //        backView.backgroundColor = [UIColor grayColor];
        [self addSubview:backView];
        [backView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.mas_top);
            make.left.mas_equalTo(self.mas_left);
            make.size.mas_equalTo(CGSizeMake(375*kWidthScale, 269*kHeightScale));
        }];
        
        self.textView = [[QMUITextView alloc]init];
        self.textView.font = [UIFont systemFontOfSize:14];
        self.textView.placeholder = @"说点什么吧!";
        self.textView.autoResizable = YES;
        self.textView.maximumTextLength = 200;
        self.textView.layer.borderColor = kUIColor(229, 229, 229, 1.0).CGColor;
        self.textView.layer.borderWidth = 1;
        self.textView.layer.cornerRadius = 3;
        self.textView.layer.masksToBounds = YES;
        
        //监测textView文本的变化
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textViewEditChanged:) name:UITextViewTextDidChangeNotification object:nil];
        [backView addSubview:self.textView];
        
        [self.textView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(backView.mas_top).offset(18);
            make.left.mas_equalTo(backView.mas_left).offset(15);
            make.size.mas_equalTo(CGSizeMake(345*kWidthScale, 164*kHeightScale));
        }];
        
        self.wordLabel = [[UILabel alloc]init];
        self.wordLabel.text = @"0/200";
        self.wordLabel.textAlignment = NSTextAlignmentRight;
        self.wordLabel.font = [UIFont systemFontOfSize:14];
        self.wordLabel.textColor = kUIColor(204.0, 204.0, 204.0, 1.0);
        [self.textView addSubview:self.wordLabel];
        [self.wordLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(backView.mas_top).offset(160*kHeightScale);
            make.left.mas_equalTo(backView.mas_left).offset(240*kWidthScale);
            make.size.mas_equalTo(CGSizeMake(100*kWidthScale, 13*kHeightScale));
        }];
        
        UIToolbar * topView = [[UIToolbar alloc]init];
        [topView setBarStyle:UIBarStyleDefault];
        UIBarButtonItem * btnSpace = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
        _doneButton = [[UIBarButtonItem alloc]initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(dismissKeyBoard)];
        NSArray * buttonsArray = [NSArray arrayWithObjects:btnSpace,_doneButton,nil];
        [topView setItems:buttonsArray];
        [self.textView setInputAccessoryView:topView];
        [topView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_offset(CGSizeMake(375*kWidthScale, 30*kHeightScale));
        }];
        
        
        _submitButton = [[UIButton alloc]init];
        _submitButton.backgroundColor = kUIColor(42, 138, 219, 1.0);
        [_submitButton setTitle:@"提交" forState:UIControlStateNormal];
        [backView addSubview:_submitButton];
        [_submitButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(backView.mas_top).offset(208*kHeightScale);
            make.left.mas_equalTo(backView.mas_left).offset(15*kWidthScale);
            make.size.mas_equalTo(CGSizeMake(345*kWidthScale, 39*kHeightScale));
        }];
        
    }
    return self;
}

- (void)dismissKeyBoard {
    [self.textView resignFirstResponder];
}

// 文本字数限制
- (void)textViewEditChanged:(NSNotification*)obj {
    UITextView *textView = self.textView;
    NSString *textStr = textView.text;
    //    NSInteger fontNum = 200 - textStr.length;
    //    fontNum = fontNum < 0 ? 0 : fontNum;
    //    self.wordLabel.text = [NSString stringWithFormat:@"%@/200",@(fontNum)];
    if (textStr.length > 200) {
        textView.text = [textStr substringToIndex:200];
    }else{
        self.wordLabel.text = [NSString stringWithFormat:@"%@/200",@(textStr.length)];
    }
}


@end
