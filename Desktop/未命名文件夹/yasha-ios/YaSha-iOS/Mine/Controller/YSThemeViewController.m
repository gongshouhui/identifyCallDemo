//
//  YSThemeViewController.m
//  YaSha-iOS
//
//  Created by 方鹏俊 on 2017/12/7.
//

#import "YSThemeViewController.h"
#import "YSUIConfigurationTemplate.h"
#import "YSUIConfigurationTemplateGrapefruit.h"
#import "YSUIConfigurationTemplateGrass.h"
#import "YSUIConfigurationTemplatePinkRose.h"
#import "YSUIConfigurationTemplateNewYear.h"

@interface YSThemeViewController ()

@property(nonatomic, copy) NSArray<NSObject<YSThemeProtocol> *> *themes;
@property(nonatomic, strong) UIScrollView *scrollView;

@end

@implementation YSThemeViewController

- (void)initTableView {
    [super initTableView];
    self.themes = @[[[YSUIConfigurationTemplate alloc] init],
                    [[YSUIConfigurationTemplateGrapefruit alloc] init],
                    [[YSUIConfigurationTemplateGrass alloc] init],
                    [[YSUIConfigurationTemplatePinkRose alloc] init],
                    [[YSUIConfigurationTemplateNewYear alloc] init]];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.themes.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"Cell"];
    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
    cell.textLabel.text = @"点点试试啊";
//    NSDictionary *dic = self.themes[indexPath.row];
//    cell = dic[@"name"];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [YSThemeManager sharedInstance].currentTheme = self.themes[indexPath.row];
    [YSUserDefaults setObject:NSStringFromClass(self.themes[indexPath.row].class) forKey:YSSelectedThemeClassName];
}

@end
