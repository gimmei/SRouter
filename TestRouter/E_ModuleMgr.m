//
//  E_ModuleMgr.m
//  TestRouter
//
//  Created by 陈思 on 16/4/20.
//  Copyright © 2016年 chensi. All rights reserved.
//

#import "E_ModuleMgr.h"
#import "publicInf_cmds.h"
#import "TestViewController.h"

NSString *const keyModuleClassE = @"E_ModuleMgr";

@implementation E_ModuleMgr
- (id)command:(NSInteger)cmd andParams:(NSDictionary *)dictParam
{
    switch (cmd) {
        case RouterQueryViewControlelr:
            return [TestViewController new];
            break;
            
        default:
            break;
    }
    
    return nil;
}
@end
