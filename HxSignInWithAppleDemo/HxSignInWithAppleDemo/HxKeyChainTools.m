//
//  HxKeyChainTools.m
//  HxSignInWithAppleDemo
//
//  Created by han xiao on 2020/8/29.
//  Copyright © 2020 han xiao. All rights reserved.
//

#import "HxKeyChainTools.h"

 //定义存入keychain中的账号 一个标识 表示是某个app存储的内容 bundle id最好
NSString * const KEY_USERNAME = @"com.wanda.wealth.username";
NSString * const KEY_PASSWORD = @"com.wanda.wealth.password";

@implementation HxKeyChainTools
+ (NSString *)getUserID

{
    //测试用 清除keychain中的内容
//    [HxKeyChainTools delete:KEY_USERNAME];
    
    //读取账号中保存的内容
    NSString *userID = (NSString *)[HxKeyChainTools load:KEY_USERNAME];
    if(userID){
        return userID;
    }
  
    return nil;
        
}

//储存
+ (void)saveData:(id)data
{
    //Get search dictionary
    NSMutableDictionary *keychainQuery = [self getKeychainQuery:KEY_USERNAME];
    
    //Delete old item before add new item
    SecItemDelete((__bridge CFDictionaryRef)keychainQuery);
    
    //Add new object to search dictionary(Attention:the data format)
    [keychainQuery setObject:[NSKeyedArchiver archivedDataWithRootObject:data] forKey:(__bridge id)kSecValueData];
    
    //Add item to keychain with the search dictionary
    SecItemAdd((__bridge CFDictionaryRef)keychainQuery, NULL);
}

+ (NSMutableDictionary *)getKeychainQuery:(NSString *)service
{
    return [NSMutableDictionary dictionaryWithObjectsAndKeys: (__bridge id)kSecClassGenericPassword,(__bridge id)kSecClass, service, (__bridge id)kSecAttrService, service, (__bridge id)kSecAttrAccount, (__bridge id)kSecAttrAccessibleAfterFirstUnlock,(__bridge id)kSecAttrAccessible, nil];
}

//取出
+ (id)load:(NSString *)service
{
    id ret = nil;
    
    NSMutableDictionary *keychainQuery = [self getKeychainQuery:service];
    
    //Configure the search setting
    
    //Since in our simple case we are expecting only a single attribute to be returned (the password) we can set the attribute kSecReturnData to kCFBooleanTrue
    
    [keychainQuery setObject:(__bridge id)kCFBooleanTrue forKey:(__bridge id)kSecReturnData];
    
    [keychainQuery setObject:(__bridge id)kSecMatchLimitOne forKey:(__bridge id)kSecMatchLimit];
    
    CFDataRef keyData = NULL;
    
    if (SecItemCopyMatching((__bridge CFDictionaryRef)keychainQuery, (CFTypeRef *)&keyData) == noErr)
    {
        @try
        {
            ret = [NSKeyedUnarchiver unarchiveObjectWithData:(__bridge NSData *)keyData];
        }
        @catch (NSException *e)
        {
            NSLog(@"Unarchive of %@ failed: %@", service, e);
            
        }
        @finally
        {}
    }
    
    if (keyData)
        CFRelease(keyData);
    
    return ret;
}

//删除
+ (void)delete:(NSString *)service
{
    NSMutableDictionary *keychainQuery = [self getKeychainQuery:service];
    SecItemDelete((__bridge CFDictionaryRef)keychainQuery);
}
@end
