//
//  C_ViewModuleController.h
//  TestRouter
//
//  Created by 陈思 on 16/4/19.
//  Copyright © 2016年 chensi. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CModuleDelegate <NSObject>
- (void)cmodule:(NSString *)msg;
@end





@interface C_ViewModuleController : UIViewController

@end
