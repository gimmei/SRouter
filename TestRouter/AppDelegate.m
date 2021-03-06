//
//  AppDelegate.m
//  TestRouter
//
//  Created by cs on 16/4/19.
//  Copyright © 2016年 cs. All rights reserved.
//

#import "AppDelegate.h"
#import "A_ViewModuleController.h"
#import "SRouterRemote.h"
#import "publicInf_def.h"
#import "SRouter.h"

@interface AppDelegate ()<SRouterRemoteDelegate>

@end

@implementation AppDelegate
#pragma mark - SRouterRemoteDelegate
- (BOOL)routerRemote:(SRouterRemote *)srr withScheme:(NSString *)scheme withPath:(NSString *)path withParams:(NSDictionary *)dict
{
    //
    return YES;
}
#pragma mark - AppDelegate
- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<NSString *,id> *)options
{

    //远程调用要先注册哪些类可以被远程调用
    SROUTER_REGISTER_SHORTNAME_FOR_DICT((@{@"B":keyModuleClassB, @"C":keyModuleClassC, @"D":keyModuleClassD}));
    
    BOOL bRet = [[SRouterRemote routerRemoteShareInstance] handlerCommandWithURL:url completion:^(NSDictionary *dict){
        NSLog(@"收到返回数据:%@", dict);
    }];
    
    return bRet;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    self.window = [[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];

    UIViewController *vc = [[A_ViewModuleController alloc] init];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
    self.window.rootViewController = nav;
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
