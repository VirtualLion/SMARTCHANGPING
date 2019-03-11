//
//  YZKeyChain.m
//  SMARTCHANGPING
//
//  Created by 韩云智 on 2017/1/14.
//  Copyright © 2017年 韩云智. All rights reserved.
//

#import "YZKeyChain.h"

#define YZKeyChainKey @"com.yzKeyChain.SMARTCHANGPING"
#define YZKeyChainUUID @"com.yzKeyChainUUID.SMARTCHANGPING"

@implementation YZKeyChain

+ (NSString *)getUUID{
    NSString *uuid = [self loadKeyChain:YZKeyChainUUID];
    if (!(uuid&&uuid.length>0)) {
        uuid = [[NSUUID UUID] UUIDString];
        [self saveKeyChain:YZKeyChainUUID data:uuid];
    }
    return uuid;
}

+ (void)saveKeyChain:(NSString *)key data:(id)data{
    NSMutableDictionary *tempDic = [NSMutableDictionary dictionaryWithDictionary:[self load:YZKeyChainKey]];
    [tempDic setObject:data forKey:key];
    [self save:YZKeyChainKey data:tempDic];
}
+ (id)loadKeyChain:(NSString *)key{
    NSMutableDictionary *tempDic = (NSMutableDictionary *)[self load:YZKeyChainKey];
    return [tempDic objectForKey:key];
}
+ (void)deleteKeyChain:(NSString *)key{
    NSMutableDictionary *tempDic = [NSMutableDictionary dictionaryWithDictionary:[self load:YZKeyChainKey]];
    [tempDic removeObjectForKey:key];
    [self save:YZKeyChainKey data:tempDic];
}
+ (void)deleteKeyChain{
    [self delete:YZKeyChainKey];
}


+ (NSMutableDictionary *)getKeychainQuery:(NSString *)service {
    return [NSMutableDictionary dictionaryWithObjectsAndKeys:
            (id)kSecClassGenericPassword,(id)kSecClass,
            service, (id)kSecAttrService,
            service, (id)kSecAttrAccount,
            (id)kSecAttrAccessibleAfterFirstUnlock,(id)kSecAttrAccessible,
            nil];
}

+ (void)save:(NSString *)service data:(id)data {
    //Get search dictionary
    NSMutableDictionary *keychainQuery = [self getKeychainQuery:service];
    //Delete old item before add new item
    SecItemDelete((CFDictionaryRef)keychainQuery);
    //Add new object to search dictionary(Attention:the data format)
    [keychainQuery setObject:[NSKeyedArchiver archivedDataWithRootObject:data] forKey:(id)kSecValueData];
    //Add item to keychain with the search dictionary
    SecItemAdd((CFDictionaryRef)keychainQuery, NULL);
}

+ (id)load:(NSString *)service {
    id ret = nil;
    NSMutableDictionary *keychainQuery = [self getKeychainQuery:service];
    //Configure the search setting
    //Since in our simple case we are expecting only a single attribute to be returned (the password) we can set the attribute kSecReturnData to kCFBooleanTrue
    [keychainQuery setObject:(id)kCFBooleanTrue forKey:(id)kSecReturnData];
    [keychainQuery setObject:(id)kSecMatchLimitOne forKey:(id)kSecMatchLimit];
    CFDataRef keyData = NULL;
    if (SecItemCopyMatching((CFDictionaryRef)keychainQuery, (CFTypeRef *)&keyData) == noErr) {
        @try {
            ret = [NSKeyedUnarchiver unarchiveObjectWithData:(__bridge NSData *)keyData];
        } @catch (NSException *e) {
            NSLog(@"Unarchive of %@ failed: %@", service, e);
        } @finally {
        }
    }
    if (keyData)
        CFRelease(keyData);
    return ret;
}

+ (void)delete:(NSString *)service {
    NSMutableDictionary *keychainQuery = [self getKeychainQuery:service];
    SecItemDelete((CFDictionaryRef)keychainQuery);
}

@end
