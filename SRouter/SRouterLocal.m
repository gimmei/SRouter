//
//  SRouter.m
//  TestRouter
//
//  Created by 陈思 on 16/4/19.
//  Copyright © 2016年 chensi. All rights reserved.
//

#import "SRouterLocal.h"
#import "publicInf_cmds.h"
#import "ModuleProtocol.h"
#import <objc/runtime.h>
#import "publicInf_macro.h"



@interface SRouterClassInfo : NSObject
@property (nonatomic, copy) NSString *className;
@property (nonatomic) NSInteger classType;
@property (nonatomic, weak) id classImp;
@property (nonatomic, copy) NSString *shortName;


+ (instancetype)routerClassInfo;
@end
@implementation SRouterClassInfo
+ (instancetype)routerClassInfo
{
    SRouterClassInfo *classInfo = [SRouterClassInfo new];
    
    return classInfo;
}
@end






/**
 *  上下文数据
 */
@interface SRouterDataContext : NSObject


//Protocol----array(className)
@property (nonatomic, strong) NSMutableDictionary *dictProtocolsAndTarget;
@property (nonatomic, strong) NSMutableDictionary *dictKeyClassAndInfo;
@property (nonatomic, strong) NSMutableDictionary *dictBlocksAndTarget;

+ (instancetype)routerDataContext;
//- (void)addClassInfo:(NSString *)keyClassName classInfo:(SRouterClassInfo *)classInfo;
//- (void)alterClassInfo:(NSString *)keyClassName classInfo:(SRouterClassInfo *)classInfo;
//- (void)removeClassInfo:(NSString *)keyClassName;
- (void)registerShortName:(NSString *)name withFullClassName:(NSString *)fullClassName;
- (void)registerShortNameForDict:(NSDictionary *)dict;
- (void)unregisterShortName:(NSString *)name;
- (NSString *)queryClassName:(NSString *)keyClassName;
- (NSArray *)queryClassImpForProtocol:(Protocol *)keyProtocol;

- (BOOL)registerProtocol:(Protocol *)keyProtocol classInstance:(id)classIns;
- (void)unregisterProtocol:(Protocol *)keyProtocol classInstance:(id)classIns;

- (BOOL)registerBlock:(SRouterHandler)block className:(NSString *)className;
- (SRouterHandler)queryBlockWithClassName:(NSString *)className;
@end
@implementation SRouterDataContext

+ (instancetype)routerDataContext
{
    SRouterDataContext *context = [SRouterDataContext new];
    return context;
}

#pragma mark - lifecycle
- (void)dealloc
{
    [self.dictProtocolsAndTarget removeAllObjects];
    [self.dictKeyClassAndInfo removeAllObjects];
    [self.dictBlocksAndTarget removeAllObjects];
}
#pragma mark -
//- (void)addClassInfo:(NSString *)keyClassName classInfo:(SRouterClassInfo *)classInfo
//{
//    NSAssert(keyClassName != nil && classInfo != nil, @"addClassInfo pass value error");
//    [self.dictKeyClassAndInfo setObject:classInfo forKey:keyClassName];
//}
//- (void)alterClassInfo:(NSString *)keyClassName classInfo:(SRouterClassInfo *)classInfo
//{
//    [self addClassInfo:keyClassName classInfo:classInfo];
//}
//- (void)removeClassInfo:(NSString *)keyClassName
//{
//    NSAssert(keyClassName != nil, @"removeClassInfo pass value error");
//    [self.dictKeyClassAndInfo removeObjectForKey:keyClassName];
//}
- (void)registerShortName:(NSString *)name withFullClassName:(NSString *)fullClassName
{
    if (name && fullClassName) {
        [self.dictKeyClassAndInfo setObject:name forKey:fullClassName];
    }
}
- (void)registerShortNameForDict:(NSDictionary *)dict
{
    if (dict) {
        [self.dictKeyClassAndInfo setDictionary:dict];
    }
}
- (void)unregisterShortName:(NSString *)name
{
    if (name) {
        [self.dictKeyClassAndInfo removeObjectForKey:name];
    }
}
- (NSString *)queryClassName:(NSString *)keyClassName
{
    NSString *fullClassName = self.dictKeyClassAndInfo[keyClassName];
    
    __block NSString *className = fullClassName;
    if (fullClassName == nil) {
        [self.dictKeyClassAndInfo enumerateKeysAndObjectsUsingBlock:^(NSString *key, NSString *value, BOOL *stop){
            if ([value isEqualToString:keyClassName]) {
                className = value;
                *stop = YES;
            }
        }];
    }
    
    return className;
}
- (NSArray *)queryClassImpForProtocol:(Protocol *)keyProtocol
{
    //查找classname
    NSString *protocol = NSStringFromProtocol(keyProtocol);
    NSSet *arrayClassNames = self.dictProtocolsAndTarget[protocol];
    
    NSMutableArray *arrayImps = [NSMutableArray array];
    [arrayClassNames enumerateObjectsUsingBlock:^(id classIns, BOOL *stop){
        [arrayImps addObject:classIns];
        
    }];
    
    
    //移除
    [self.dictProtocolsAndTarget removeObjectForKey:protocol];
    
    return arrayImps;
}
- (BOOL)registerBlock:(SRouterHandler)block className:(NSString *)className
{
    if (block == nil || className == nil) {
        return NO;
    }
    
    self.dictBlocksAndTarget[className] = [block copy];
    return YES;
}
- (SRouterHandler)queryBlockWithClassName:(NSString *)className
{
    SRouterHandler blockHandler = self.dictBlocksAndTarget[className];
    [self.dictBlocksAndTarget removeObjectForKey:className];
    
    return blockHandler;
}
- (BOOL)registerProtocol:(Protocol *)keyProtocol classInstance:(id)classIns
{
    if (keyProtocol == nil || classIns == nil) {
        return NO;
    }
    NSString *protocol = NSStringFromProtocol(keyProtocol);
    if ([self.dictProtocolsAndTarget objectForKey:protocol] == nil) {
        self.dictProtocolsAndTarget[protocol] = [NSMutableSet set];
    }

    //检查是否符合协议
    if ([classIns conformsToProtocol:keyProtocol]) {
        
        [self.dictProtocolsAndTarget[protocol] addObject:classIns];
        
        return YES;
    }
    
    
    return NO;
    
}
- (void)unregisterProtocol:(Protocol *)keyProtocol classInstance:(id)classIns
{
    NSString *protocol = NSStringFromProtocol(keyProtocol);
    if ([self.dictProtocolsAndTarget objectForKey:protocol] != nil) {
        [self.dictProtocolsAndTarget[protocol] removeObject:classIns];
        
        if ([self.dictProtocolsAndTarget[protocol] count] == 0) {
            [self.dictProtocolsAndTarget removeObjectForKey:protocol];
        }
    }
}
#pragma mark - setter and getter
- (NSMutableDictionary *)dictProtocolsAndTarget
{
    if (_dictProtocolsAndTarget == nil) {
        _dictProtocolsAndTarget = [NSMutableDictionary dictionary];
    }
    
    return _dictProtocolsAndTarget;
}
- (NSMutableDictionary *)dictKeyClassAndInfo
{
    if (_dictKeyClassAndInfo == nil) {
        _dictKeyClassAndInfo = [NSMutableDictionary dictionary];
    }
    
    return _dictKeyClassAndInfo;
}
- (NSMutableDictionary *)dictBlocksAndTarget
{
    if (_dictBlocksAndTarget == nil) {
        _dictBlocksAndTarget = [NSMutableDictionary dictionary];
    }
    
    return _dictBlocksAndTarget;
}
@end

















@implementation RouterHandlerContext
@end



@interface SRouterBase()

@property (nonatomic, weak) id<RouterHandlerInf> child;

@property (nonatomic, strong) SRouterDataContext *dataContext;
@end
@implementation SRouterBase

- (instancetype)init
{
    self = [super init];
    if ([self conformsToProtocol:@protocol(RouterHandlerInf)]) {
        self.child = (id<RouterHandlerInf>)self;
    } else {
        NSAssert(NO, @"子类必须实现RouterHandlerInf协议");
    }
    
    return self;
}

#pragma mark - setter and getter
- (SRouterDataContext *)dataContext
{
    if (_dataContext == nil) {
        _dataContext = [SRouterDataContext routerDataContext];
    }
    
    return _dataContext;
}

@end












NSString *const keySRouter_QueryCmd_Param_Cmd = @"cmd";
NSString *const keySRouter_QueryCmd_Param_Value = @"Value";

@interface SRouterLocal ()<RouterHandlerInf>
@property (nonatomic, strong) NSMutableDictionary *dictClass;    //type - class
@end

@implementation SRouterLocal


+ (id<RouterHandlerInf>)routerLocalShareInstance
{
    static SRouterLocal *router;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        router = [[SRouterLocal alloc] init];
    });
    
    return router;
}
#pragma mark - lifecycle
- (instancetype)init
{
    self = [super init];
    if (self) {
//        [self loadModulePlist:@"modulelist"];
    }
    
    return self;
}
#pragma mark - public method
- (id)handlerCommand:(RouterHandlerContext *)context finishBlock:(SRouterHandler)block
{
    id obj = [self handlerCommand:context];
    [self registerBlock:block className:NSStringFromClass([context.sourceObj class])];
    
    return obj;
}
#pragma mark - RouterHandlerInf
- (NSArray *)objectForProtocol:(Protocol *)protocol
{
    return [self.dataContext queryClassImpForProtocol:protocol];
}
- (BOOL)registerProtocol:(id)classIns forProtocol:(Protocol *)protocol
{
    return [self.dataContext registerProtocol:protocol classInstance:classIns];
}

- (void)unregisterProtocol:(id)classIns forProtocol:(Protocol *)protocol
{
    [self.dataContext unregisterProtocol:protocol classInstance:classIns];
}


- (BOOL)registerBlock:(SRouterHandler)block className:(NSString *)className
{
    return [self.dataContext registerBlock:block className:className];
}
- (SRouterHandler)blockForClassName:(NSString *)className
{
    return [self.dataContext queryBlockWithClassName:className];
}
- (id)handlerCommand:(RouterHandlerContext *)context
{
    switch (context.cmd) {
        case RouterHandlerPush:
        case RouterHandlerPresent:
        case RouterHandlerPushWithParams:
        case RouterHandlerPresentWithParams:
        {
            [self routerShowVC:context];
        }
            break;
        case RouterHandlerQuery:
        {
            return [self routerQueryCmd:context];
        }
            break;
        case RouterHandlerOther:
        {
            return [self routerOtherCmd:context];
        }
            break;
        default:
            break;
    }
    return nil;
}
#pragma mark - private method
- (UIViewController *)queryCurrentVC
{
    UIViewController *rootVC = [UIApplication sharedApplication].keyWindow.rootViewController;
    if (rootVC == nil) {
        rootVC = [[[[UIApplication sharedApplication] delegate] window] rootViewController];
    }
    UIViewController *sourceVC = nil;
    if ([rootVC isKindOfClass:[UINavigationController class]]) {
        sourceVC = [((UINavigationController *)rootVC) visibleViewController];
    } else {
        if (rootVC.presentedViewController) {
            sourceVC = rootVC.presentedViewController;
        } else {
            sourceVC = rootVC;
        }
    }
    
    return sourceVC;
}
- (void)registerShortName:(NSString *)shortName withFullClassName:(NSString *)fullClassName
{
    [self.dataContext registerShortName:shortName withFullClassName:fullClassName];
}
- (void)registerShortNameForDic:(NSDictionary *)dict
{
    [self.dataContext registerShortNameForDict:dict];
}
//- (void)loadModulePlist:(NSString *)plistName
//{
//    
//    NSString *plistPath = [[NSBundle mainBundle] pathForResource:plistName ofType:@"plist"];
//    
//    NSArray *arrayPlist = [[NSArray alloc] initWithContentsOfFile:plistPath];
//
//    [arrayPlist enumerateObjectsUsingBlock:^(NSDictionary *obj, NSUInteger idx, BOOL *stop){
//        [self addNewClassInfo:obj];
//    }];
//}
//- (void)addNewClassInfo:(NSDictionary *)dict
//{
//    SRouterClassInfo *routerData = [SRouterClassInfo routerClassInfo];
//    routerData.className = dict[@"Name"];
//    routerData.classType = [dict[@"Type"] integerValue];
//    routerData.classImp = nil;
//    routerData.shortName = dict[@"shortName"];
//    [self.dataContext addClassInfo:dict[@"shortName"] classInfo:routerData];
//}


- (id)queryVCTarget:(id)tmpTarget withParams:(NSDictionary *)dictParam
{
    id target;
    //如果不是UIViewController对象就要调对方接口拿UIViewController对象
    if ([tmpTarget isKindOfClass:[UIViewController class]]) {
        target = tmpTarget;
    } else if ([tmpTarget respondsToSelector:@selector(command:andParams:)]) {
        id obj = [tmpTarget command:RouterQueryViewControlelr andParams:dictParam];
        if ([obj isKindOfClass:[UIViewController class]]) {
            target = obj;
        }
    }

    return target;
}
- (void)routerShowRemoteVC:(RouterHandlerContext *)context
{
    NSArray *arrayTargetsClassNames = [context.targetClass componentsSeparatedByString:@"/"];
    NSMutableArray *arrayTargets = [NSMutableArray array];
    for (NSString *target in arrayTargetsClassNames) {
        NSString *targetClassName = [self.dataContext queryClassName:target];
        
        
        id<ModuleProtocol> tmpTarget = [[NSClassFromString(targetClassName) alloc] init];
        if (tmpTarget == nil) {
            SROUTER_LOG(@"routerShowRemoteVC target is nill");
            return;
        }
        
        
        id target = [self queryVCTarget:tmpTarget withParams:context.dictParam];
        
        //    [self addNewClassInfo:nil];
        if (target == nil || [target class] == [context.sourceObj class]) {
            SROUTER_LOG(@"routerShowRemoteVC target is nill");
            return;
        }
        
        [arrayTargets addObject:target];
    }
    
    UIViewController *sourceVC = [self queryCurrentVC];
    
    //多个界面动作，只有最后一个界面可以传递和返回参数
    switch (context.cmd) {
        case RouterHandlerPushWithParams:
        {
            id<ModuleProtocol> targetLast = nil;
            if ([arrayTargets.lastObject conformsToProtocol:@protocol(ModuleProtocol)]) {
                targetLast = arrayTargets.lastObject;
                if ([targetLast respondsToSelector:@selector(command:andParams:)]) {
                    [targetLast command:RouterPassParams andParams:context.dictParam];
                }
            }
            
        }
        case RouterHandlerPush:
        {
            [sourceVC.navigationController setViewControllers:arrayTargets animated:YES];
            for (int i = 0; i < arrayTargets.count - 1; ++i) {
                [sourceVC.navigationController pushViewController:arrayTargets[i] animated:NO];
            }
            [sourceVC.navigationController pushViewController:arrayTargets.lastObject animated:YES];
        }
            break;
        case RouterHandlerPresentWithParams:
        {
            id<ModuleProtocol> targetLast = nil;
            if ([arrayTargets.lastObject conformsToProtocol:@protocol(ModuleProtocol)]) {
                targetLast = arrayTargets.lastObject;
                if ([targetLast respondsToSelector:@selector(command:andParams:)]) {
                    [targetLast command:RouterPassParams andParams:context.dictParam];
                }
            }
        }
        case RouterHandlerPresent:
        {
            for (int i = 0; i < arrayTargets.count - 1; ++i) {
                [sourceVC presentViewController:arrayTargets[i] animated:NO completion:nil];
            }
            [sourceVC presentViewController:arrayTargets.lastObject animated:YES completion:nil];
        }
            break;
        default:
            break;
    }
}
- (void)routerShowLocalVC:(RouterHandlerContext *)context
{
    
    NSString *targetClassName = context.targetClass;
    id<ModuleProtocol> tmpTarget = [[NSClassFromString(targetClassName) alloc] init];
    if (tmpTarget == nil) {
        return;
    }
    
    
    id target = [self queryVCTarget:tmpTarget withParams:context.dictParam];
    
    //    [self addNewClassInfo:nil];
    if (target == nil || [target class] == [context.sourceObj class]) {
        SROUTER_LOG(@"routerShowRemoteVC target is nill");
        return;
    }
    
    
    UIViewController *sourceVC = [self queryCurrentVC];
    
    switch (context.cmd) {
        case RouterHandlerPushWithParams:
            [tmpTarget command:RouterPassParams andParams:context.dictParam];
        case RouterHandlerPush:
            [sourceVC.navigationController pushViewController:target animated:YES];
            break;
        case RouterHandlerPresentWithParams:
            [tmpTarget command:RouterPassParams andParams:context.dictParam];
        case RouterHandlerPresent:
            [sourceVC presentViewController:target animated:YES completion:nil];
            break;
        default:
            break;
    }
}
- (void)routerShowVC:(RouterHandlerContext *)context
{
    if (context.from == SRouterCmdFromLocal) {
        [self routerShowLocalVC:context];
    } else {
        [self routerShowRemoteVC:context];
    }
}
- (id)routerOtherCmd:(RouterHandlerContext *)context
{
    NSString *targetClass = context.targetClass;
    id<ModuleProtocol> target = [[NSClassFromString(targetClass) alloc] init];
    if ([target respondsToSelector:@selector(command:andParams:)]) {
        return [target command:RouterOtherCmd andParams:context.dictParam];
    }
    
    return nil;
}
- (id)routerQueryCmd:(RouterHandlerContext *)context
{
    if (context == nil) {
        return nil;
    }
    

    NSInteger cmd = [context.dictParam[keySRouter_QueryCmd_Param_Cmd] integerValue];
    switch (cmd) {
        case RouterQueryViewControlelr:
        {
            NSString *targetClass = context.dictParam[keySRouter_QueryCmd_Param_Value];
            id<ModuleProtocol> target = [[NSClassFromString(targetClass) alloc] init];
            if ([target respondsToSelector:@selector(command:andParams:)]) {
                return [target command:RouterQueryViewControlelr andParams:nil];
            }
        }
            break;
        case RouterQueryProtocol:
        {
            Protocol *protocol = context.dictParam[keySRouter_QueryCmd_Param_Value];
            return [self.dataContext queryClassImpForProtocol:protocol];
        }
            break;
        case RouterQueryBlock:
        {
            NSString *className = context.dictParam[keySRouter_QueryCmd_Param_Value];
            return [self.dataContext queryBlockWithClassName:className];
        }
            break;
        default:
            break;
    }
    
    return nil;
}
#pragma mark - setter and getter
@end
