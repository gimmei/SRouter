//
//  SRouter.h
//  TestRouter
//
//  Created by 陈思 on 16/4/19.
//  Copyright © 2016年 chensi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RouterHandlerInf.h"



@interface SRouterBase : NSObject

@end

@interface SRouterLocal : SRouterBase
+ (id<RouterHandlerInf>)routerLocalShareInstance;

@end
