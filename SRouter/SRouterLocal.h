//
//  SRouter.h
//  TestRouter
//
//  Created by cs on 16/4/19.
//  Copyright © 2016年 cs. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RouterHandlerInf.h"



@interface SRouterBase : NSObject

@end

@interface SRouterLocal : SRouterBase
+ (id<RouterHandlerInf>)routerLocalShareInstance;

@end
