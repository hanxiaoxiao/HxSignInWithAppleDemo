//
//  AppDelegate.m
//  HxSignInWithAppleDemo
//
//  Created by han xiao on 2020/8/29.
//  Copyright © 2020 han xiao. All rights reserved.
//

#import "AppDelegate.h"
#import "ViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    self.window = [[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor whiteColor];
    
    UINavigationController* nav = [[UINavigationController alloc]initWithRootViewController:[ViewController new]];
    
    self.window.rootViewController = nav;
    
    [self.window makeKeyAndVisible];
    
    //
    [self observeAuthticationState];
    
    
    return YES;
}

//观察授权状态
//用户终止 App 中使用 Sign in with Apple 功能,用户在设置里注销了 AppleId
//这些情况下，App 需要获取到这些状态，然后做退出登录操作，或者重新登录。
//我们需要在 App 启动的时候，通过 getCredentialState:completion: 来获取当前用户的授权状态。
- (void)observeAuthticationState {
    
    // 基于用户的Apple ID 生成授权用户请求的机制
    ASAuthorizationAppleIDProvider *appleIDProvider = [ASAuthorizationAppleIDProvider new];
    // 注意 存储用户标识信息需要使用钥匙串来存储 这里使用NSUserDefaults 做的简单示例
    NSString* userIdentifier = [HxKeyChainTools getUserID];
    
    if (userIdentifier) {
        
        // 在回调中返回用户的授权状态
        [appleIDProvider getCredentialStateForUserID:userIdentifier completion:^(ASAuthorizationAppleIDProviderCredentialState credentialState, NSError * _Nullable error) {
            
            // 苹果证书的授权状态
            switch (credentialState) {
                case ASAuthorizationAppleIDProviderCredentialRevoked:
                    // 苹果授权凭证失效
                    dispatch_async(dispatch_get_main_queue(), ^{
                        //做对应处理
                    });
                    break;
                case ASAuthorizationAppleIDProviderCredentialAuthorized:
                    // 苹果授权凭证状态良好
                    dispatch_async(dispatch_get_main_queue(), ^{
                        //做对应处理
                    });
                    break;
                case ASAuthorizationAppleIDProviderCredentialNotFound:
                    // 未发现苹果授权凭证
                    // 可以引导用户重新登录
                    dispatch_async(dispatch_get_main_queue(), ^{
                        //做对应处理
                    });
                    break;
                    
                default:
                    break;
            }
            
        }];
    }
}

@end
