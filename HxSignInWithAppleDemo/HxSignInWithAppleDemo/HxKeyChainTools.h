//
//  HxKeyChainTools.h
//  HxSignInWithAppleDemo
//
//  Created by han xiao on 2020/8/29.
//  Copyright © 2020 han xiao. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface HxKeyChainTools : NSObject

//获取
+ (NSString *)getUserID;

//保存
+ (void)saveData:(id)data;

//删除
+ (void)delete:(NSString *)service;


@end

NS_ASSUME_NONNULL_END
