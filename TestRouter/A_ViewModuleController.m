//
//  A_ViewModuleControllerViewController.m
//  TestRouter
//
//  Created by cs on 16/4/19.
//  Copyright © 2016年 cs. All rights reserved.
//

#import "A_ViewModuleController.h"
#import "SRouter.h"
#import "C_ViewModuleController.h"
#import "publicInf_def.h"



NSString *const keyModuleClassA = @"A_ViewModuleController";


@interface A_ViewModuleController ()<UITableViewDataSource, UITableViewDelegate, CModuleDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *arrayDataSource;
@end

@implementation A_ViewModuleController

#pragma mark - lifecycle
- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = @"A界面";
    
    [self.view addSubview:self.tableView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - UITabelViewDataSource and UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.arrayDataSource.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell =[tableView dequeueReusableCellWithIdentifier:@"routercell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"routercell"];
    }
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.textLabel.text = self.arrayDataSource[indexPath.row];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    switch (indexPath.row) {
        case 0: //PUSH
        {
            SROUTER_PUSH_LOCAL(keyModuleClassC);
        }
            break;
        case 1: //push－传第参数
        {
            SROUTER_PUSH_PARAMS_LOCAL(keyModuleClassB, (@{keyParamsClassB_Content:@"push:pass param from A", keyParamsClassB_Title:@"我是B界面"}));
        }
            break;
        case 2: //Present
        {
            SROUTER_PRESENT_LOCAL(keyModuleClassD);
        }
            break;
        case 3: //present-传第参数
        {
            SROUTER_PRESENT_PARAMS_LOCAL(keyModuleClassD, (@{keyParamsClassD_Content:@"present:pass param from A", keyParamsClassD_Title:@"我是D界面"}));
        }
            break;
        case 4: //push-传参－返回(push跟present一样)
        {
            //1是使用block返回
//            SROUTER_PUSH_LOCAL(keyModuleClassB);
            SROUTER_PUSH_PARAMS_LOCAL(keyModuleClassB, (@{keyParamsClassB_Content:@"push:pass param from A", keyParamsClassB_Title:@"我是B界面"}));
            SROUTER_REGISETER_BLOCK(keyModuleClassB, ^(NSDictionary *dict){
                NSLog(@"返回数据:%@", dict[@"msg"]);
            });
        }
            break;
        case 5:
        {
            UIViewController *vc = SROUTER_QUERY_VIEWCONTROLLER(keyModuleClassE);
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case 6:
        {
            SROUTER_PUSH_LOCAL(keyModuleClassC);
            SROUTER_REGISTER_PROTOCOL_SELF(CModuleDelegate);
        }
            break;
        default:
            break;
    }
}
#pragma mark - CModuleDelegate
- (void)cmodule:(NSString *)msg
{
    NSLog(@"我是来自返回的数据:%@", msg);
}
#pragma mark - setter and getter
- (UITableView *)tableView
{
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource= self;
    }
    
    return _tableView;
}
- (NSArray *)arrayDataSource
{
    if (_arrayDataSource == nil) {
        _arrayDataSource = @[@"简单push界面", @"push并传递参数", @"pesent界面", @"present并传递参数", @"push－传递参数－block返回数据", @"主动获取界面并手动push或是present", @"push-delegate返回数据"];
    }
    
    return _arrayDataSource;
}

@end
