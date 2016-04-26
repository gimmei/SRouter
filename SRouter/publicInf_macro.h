//
//  publicInf_macro.h
//  TestRouter
//
//  Created by cs on 16/4/19.
//  Copyright © 2016年 cs. All rights reserved.
//

#ifndef publicInf_macro_h
#define publicInf_macro_h

#import "RouterHandlerInf.h"


#define _SROUTER_SHAREINSTANECE_(_class, _fun) ({\
    id _SRouter_delegate_; \
    if(!NSClassFromString(_class)){\
        _SRouter_delegate_ = nil; \
    } else {\
        id _LOCAL_CLASS_ = NSClassFromString(_class);\
        SEL _LOCAL_FUN_ = NSSelectorFromString(_fun);\
_Pragma("clang diagnostic push") \
_Pragma("clang diagnostic ignored \"-Warc-performSelector-leaks\"") \
        _SRouter_delegate_ = [_LOCAL_CLASS_ performSelector:_LOCAL_FUN_]; \
_Pragma("clang diagnostic pop") \
    }\
    _SRouter_delegate_;\
})



#define _SROUTER_HANDLER_CMD_LOCAL(_cmd, _target, _params, _from) ({\
    id obj; \
    RouterHandlerContext *context = [RouterHandlerContext new];\
    context.sourceObj = nil; \
    context.cmd = _cmd; \
    context.targetClass = _target; \
    context.dictParam = _params; \
    context.from = _from; \
    obj = [SROUTER_SHAREINSTANECE() handlerCommand:context]; \
    obj; \
})

#define _SROUTER_QUERY_(_cmd, _value) ({\
    id obj; \
    RouterHandlerContext *context = [RouterHandlerContext new];\
    context.sourceObj = nil; \
    context.cmd = RouterHandlerQuery; \
    context.targetClass = nil; \
    context.dictParam = @{keySRouter_QueryCmd_Param_Cmd:[NSNumber numberWithInteger:_cmd], keySRouter_QueryCmd_Param_Value:_value}; \
    context.from = SRouterCmdFromLocal; \
    obj = [SROUTER_SHAREINSTANECE() handlerCommand:context]; \
    obj; \
})

#define _SROUTER_PUSH(_target, _from) _SROUTER_HANDLER_CMD_LOCAL(RouterHandlerPush, _target, nil, _from)
#define _SROUTER_PUSH_PARAMS(_target, _params, _from) _SROUTER_HANDLER_CMD_LOCAL(RouterHandlerPushWithParams, _target, _params, _from)
#define _SROUTER_PRESENT(_target, _from) _SROUTER_HANDLER_CMD_LOCAL(RouterHandlerPresent, _target, nil, _from)
#define _SROUTER_PRESENT_PARAMS(_target, _params, _from) _SROUTER_HANDLER_CMD_LOCAL(RouterHandlerPresentWithParams, _target, _params, _from)




//////////////////////////////////////////////////////////////////////////////

#define SROUTER_LOG(_t) NSLog(@"%@", _t)
/**
 *  获取实例对象
 *
 *  @return SRouter实例对象
 */
#define SROUTER_SHAREINSTANECE() _SROUTER_SHAREINSTANECE_(@"SRouterLocal", @"routerLocalShareInstance")


#define SROUTER_HANDLER_OTHERCMD(_target, _params, _from) _SROUTER_HANDLER_CMD_LOCAL(RouterHandlerOther, _target, _params, _from)

//类名映射
#define SROUTER_REGISTER_SHORTNAME(_sname, _fname) [SROUTER_SHAREINSTANECE() registerShortName:_sname withFullClassName:_fname]
#define SROUTER_REGISTER_SHORTNAME_FOR_DICT(_dict) [SROUTER_SHAREINSTANECE() registerShortNameForDic:_dict]

//变量声明引用
#define SROUTER_DECLARED_NAME(_key, _name) NSString *const _key = _name
#define SROUTER_EXTERN_NAME(_name) extern NSString *const _name;

//本地调用
#define SROUTER_PUSH_LOCAL(_target) _SROUTER_PUSH(_target, SRouterCmdFromLocal)
#define SROUTER_PUSH_PARAMS_LOCAL(_target, _params) _SROUTER_PUSH_PARAMS(_target, _params, SRouterCmdFromLocal)
#define SROUTER_PRESENT_LOCAL(_target) _SROUTER_PRESENT(_target, SRouterCmdFromLocal)
#define SROUTER_PRESENT_PARAMS_LOCAL(_target, _params) _SROUTER_PRESENT_PARAMS(_target, _params, SRouterCmdFromLocal)

//远程调用
#define SROUTER_PUSH_REMOTE(_target) _SROUTER_PUSH(_target, SRouterCmdFromRemote)
#define SROUTER_PUSH_PARAMS_REMOTE(_target, _params) _SROUTER_PUSH_PARAMS(_target, _params, SRouterCmdFromRemote)
#define SROUTER_PRESENT_REMOTE(_target) _SROUTER_PRESENT(_target, SRouterCmdFromRemote)
#define SROUTER_PRESENT_PARAMS_REMOTE(_target, _params) _SROUTER_PRESENT_PARAMS(_target, _params, SRouterCmdFromRemote)



SROUTER_EXTERN_NAME(keySRouter_QueryCmd_Param_Cmd);
SROUTER_EXTERN_NAME(keySRouter_QueryCmd_Param_Value);


//获取协议，block等
#define SROUTER_QUERY_VIEWCONTROLLER(_value) _SROUTER_QUERY_(RouterQueryViewControlelr, _value)
#define SROUTER_QUERY_PROTOCOL(_value) _SROUTER_QUERY_(RouterQueryProtocol, @protocol(_value))
#define SRTOUER_QUERY_BLOCK(_value) _SROUTER_QUERY_(RouterQueryBlock, _value)
#define SROUTER_QUERY_BLOCK_SIMP() _SROUTER_QUERY_(RouterQueryBlock, NSStringFromClass([self class]))


//协议，Block注册
#define SROUTER_REGISETER_BLOCK(_name, _blk) \
    [SROUTER_SHAREINSTANECE() registerBlock:_blk className:_name];
#define SROUTER_REGISTER_PROTOCOL(_key, _protocol) \
    [SROUTER_SHAREINSTANECE() registerProtocol:_key forProtocol:@protocol(_protocol)];
#define SROUTER_REGISTER_PROTOCOL_SELF(_protocol) \
    [SROUTER_SHAREINSTANECE() registerProtocol:self forProtocol:@protocol(_protocol)];







//#define SROUTER_UNREGISTER(_key, _protocol) \
//    [SROUTER_SHAREINSTANCE() unregisterProtocol:_key forProtocol:@protocol(_protocol)];
//#define SROUTER_UNREGISTER_SELF(_protocol) \
//    [SROUTER_SHAREINSTANECE() unregisterProtocol:self forProtocol:@protocol(_protocol)];
//#define SROUTER_REGISTER(_protocol) \
//    [SROUTER_SHAREINSTANECE() registerProtocol:NSStringFromClass([self class]) forProtocol:@protocol(_protocol)];





#endif /* publicInf_macro_h */
