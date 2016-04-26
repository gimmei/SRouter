//
//  Header.h
//  TestRouter
//
//  Created by cs on 16/4/19.
//  Copyright © 2016年 cs. All rights reserved.
//

#ifndef publicInf_cmds_h
#define publicInf_cmds_h

typedef NS_ENUM(NSInteger, RouterHandlerCmds){
    RouterHandlerPush = 0,
    RouterHandlerPushWithParams,
    RouterHandlerPresent,
    RouterHandlerPresentWithParams,
    RouterHandlerQuery,         //查询
    RouterHandlerOther          //其他扩展命令
};


typedef NS_ENUM(NSInteger, RouterModuleCmds) {
    RouterPassParams,           //参数传递
    
    RouterQueryViewControlelr,  //vc获取
    RouterQueryProtocol,        //protocol获取
    RouterQueryBlock,           //Block获取
    
    RouterOtherCmd              //其他扩展命令
};


#endif /* Header_h */
