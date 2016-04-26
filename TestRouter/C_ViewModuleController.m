//
//  C_ViewModuleController.m
//  TestRouter
//
//  Created by 陈思 on 16/4/19.
//  Copyright © 2016年 chensi. All rights reserved.
//

#import "C_ViewModuleController.h"
#import "SRouter.h"
#import "publicInf_def.h"

NSString *const keyModuleClassC = @"C_ViewModuleController";

@interface C_ViewModuleController ()
@property (nonatomic, strong) UILabel *labelTitle;
@property (nonatomic, weak) id<CModuleDelegate> delegate;
@end



@implementation C_ViewModuleController
- (void)dealloc
{
    NSLog(@"dealloc");
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];

    UIButton *button = [UIButton new];
    button.frame = CGRectMake(100, 100, 160, 50);
    [button setTitle:@"delegate传值" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:button];
    
    UIButton *button2 = [UIButton new];
    button2.frame = CGRectMake(100, 200, 160, 50);
    [button2 setTitle:@"present D 界面" forState:UIControlStateNormal];
    [button2 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [button2 addTarget:self action:@selector(buttonClicked2:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:button2];
    
    NSArray *array = SROUTER_QUERY_PROTOCOL(CModuleDelegate);

    self.delegate = array.firstObject;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)buttonClicked2:(id)sender
{
    SROUTER_PRESENT_LOCAL(keyModuleClassD);
}
- (void)buttonClicked:(id)sender
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(cmodule:)]) {
        [self.delegate cmodule:@"我是来自C的delegate传值"];
    }
}


@end
