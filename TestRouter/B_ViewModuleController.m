//
//  B_ViewModuleController.m
//  TestRouter
//
//  Created by 陈思 on 16/4/19.
//  Copyright © 2016年 chensi. All rights reserved.
//

#import "B_ViewModuleController.h"
#import "publicInf_cmds.h"
#import "SRouter.h"

NSString *const keyModuleClassB = @"B_ViewModuleController";
NSString *const keyParamsClassB_Content = @"content";
SROUTER_DECLARED_NAME(keyParamsClassB_Title, @"title");

@interface B_ViewModuleController ()
@property (nonatomic, copy) NSString *paramsTitle;
@property (nonatomic, copy) NSString *paramsContent;
@property (nonatomic, copy) SRouterHandler blk;
@end

@implementation B_ViewModuleController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor whiteColor];
    
    UILabel *labelTitle  = [UILabel new];
    labelTitle.frame = CGRectMake(50, 100, 200, 60);
    [labelTitle setTextColor:[UIColor blackColor]];
    [self.view addSubview:labelTitle];
    
    
    [labelTitle setText:self.paramsContent];
    self.title = self.paramsTitle;
    
    UIButton *button = [UIButton new];
    button.frame = CGRectMake(100, 200, 160, 50);
    [button setTitle:@"点我传参数" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    
    self.blk = SROUTER_QUERY_BLOCK_SIMP();
}


- (void)buttonClicked:(id)sender
{
    
    if (self.blk) {
        self.blk(@{@"msg":@"我被传回去啦"});
    }
}
/**
 *  传递参数要实现ModuleProtocol协议
 */
- (id)command:(NSInteger)cmd andParams:(NSDictionary *)dictParam
{
    switch (cmd) {
        case RouterPassParams:
            self.paramsTitle = dictParam[keyParamsClassB_Title];
            self.paramsContent = dictParam[keyParamsClassB_Content];
            break;
            
        default:
            break;
    }
    return nil;
}


@end
