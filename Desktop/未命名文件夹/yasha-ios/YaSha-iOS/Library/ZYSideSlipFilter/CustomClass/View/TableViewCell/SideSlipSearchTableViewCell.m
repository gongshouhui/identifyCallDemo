//
//  SideSlipSearchTableViewCell.m
//  YaSha-iOS
//
//  Created by 方鹏俊 on 2017/8/30.
//
//

#import "SideSlipSearchTableViewCell.h"
#import "UIColor+hexColor.h"
#import "ZYSideSlipFilterConfig.h"
#import "CommonItemModel.h"

#define TEXTFIELD_MAX_LENGTH 6

#define ACCESSORY_VIEW_HEIGHT 34
#define ACCESSORY_BUTTON_WIDTH 50
#define ACCESSORY_BUTTON_LEADING_TRAILING 0

@interface SideSlipSearchTableViewCell ()
@property (weak, nonatomic) IBOutlet UILabel *titleName;

@property (weak, nonatomic) IBOutlet UITextField *searchTextField;
@property (strong, nonatomic) ZYSideSlipFilterRegionModel *regionModel;

@end

@implementation SideSlipSearchTableViewCell
+ (NSString *)cellReuseIdentifier {
    return @"SideSlipSearchTableViewCell";
}

+ (instancetype)createCellWithIndexPath:(NSIndexPath *)indexPath {
    SideSlipSearchTableViewCell *cell = [[NSBundle mainBundle] loadNibNamed:@"SideSlipSearchTableViewCell" owner:nil options:nil][0];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell.searchTextField addTarget:cell action:@selector(setRegionTitle:) forControlEvents:UIControlEventEditingChanged];
    [cell configureKeyboard];
    return cell;
}

- (void)configureKeyboard {
    UIView *keyBoardAccessoryView = [self createKeyBoardAccessoryView];
    _searchTextField.inputAccessoryView = keyBoardAccessoryView;
}

- (void)updateCellWithModel:(ZYSideSlipFilterRegionModel *__autoreleasing *)model
                  indexPath:(NSIndexPath *)indexPath {
    self.regionModel = *model;
    [self.titleName setText:_regionModel.regionTitle];
    self.searchTextField.placeholder = @"请输入";
}

- (void)resetData {
    [_searchTextField setText:@""];
}

- (UIView *)createKeyBoardAccessoryView {
    UIView *keyBoardAccessoryView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, ACCESSORY_VIEW_HEIGHT)];
    [keyBoardAccessoryView setBackgroundColor:[UIColor hexColor:@"e1e1e1"]];
    UIButton *backButton = [[UIButton alloc] initWithFrame:CGRectMake(ACCESSORY_BUTTON_LEADING_TRAILING, 0, ACCESSORY_BUTTON_WIDTH, ACCESSORY_VIEW_HEIGHT)];
    [backButton setTitle:@"取消" forState:UIControlStateNormal];
    [backButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [backButton.titleLabel setFont:[UIFont systemFontOfSize:14.f]];
    [backButton addTarget:self action:@selector(accessoryButtonBack) forControlEvents:UIControlEventTouchUpInside];
    UIButton *doneButton = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - ACCESSORY_BUTTON_LEADING_TRAILING - ACCESSORY_BUTTON_WIDTH, 0, ACCESSORY_BUTTON_WIDTH, ACCESSORY_VIEW_HEIGHT)];
    [doneButton setTitle:@"完成" forState:UIControlStateNormal];
    [doneButton setTitleColor:[UIColor hexColor:FILTER_RED_STRING] forState:UIControlStateNormal];
    [doneButton.titleLabel setFont:[UIFont systemFontOfSize:14.f]];
    [doneButton addTarget:self action:@selector(accessoryButtonDone) forControlEvents:UIControlEventTouchUpInside];
    [keyBoardAccessoryView addSubview:backButton];
    [keyBoardAccessoryView addSubview:doneButton];
    return keyBoardAccessoryView;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if (textField.text.length >= TEXTFIELD_MAX_LENGTH && ![string isEqualToString:@""]) {
        return NO;
    }
    return YES;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [_searchTextField resignFirstResponder];
}

- (void)accessoryButtonBack {
    [_searchTextField setText:@""];
    [_searchTextField resignFirstResponder];
}

- (void)accessoryButtonDone {
    [_searchTextField resignFirstResponder];
}

- (void)setRegionTitle:(UITextField *)textField {
    DLog(@"======%@", textField.text);
    CommonItemModel *commonItemModel = [[CommonItemModel alloc] init];
    commonItemModel.itemName = textField.text;
    _regionModel.selectedItemList = @[commonItemModel];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
