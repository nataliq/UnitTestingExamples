//
//  NPAdsManager.m
//  UnitTestingExample
//
//  Created by Nataliya Patsovska on 4/5/16.
//  Copyright © 2016 Nataliya Patsovska. All rights reserved.
//

#import "NPAdsManager.h"

NSString *const AdWrapperIdKey = @"adWrapperId";
NSString *const AdSystemIdKey = @"adSystemId";

@interface NPAdsManager ()

@property (strong, nonatomic) NSMutableDictionary *adWrapperIdsForCreditingByAdIds;

@end

@implementation NPAdsManager

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.adWrapperIdsForCreditingByAdIds = [NSMutableDictionary new];
    }
    return self;
}

- (void)parseAdDataDictionary:(NSDictionary *)adData
{
    [self parseAdDataDictionary:adData completion:nil];
}

- (void)parseAdDataDictionary:(NSDictionary *)adData completion:(NPAdsManagerBlock)completion
{
    NSAssert([adData isKindOfClass:[NSDictionary class]], @"Cannot parse ad data which is not a dectionary");
    if (![adData isKindOfClass:[NSDictionary class]]) {
        return;
    }
    
    NSString *adId = adData[@"adId"];
    NSArray *wrapperIds = adData[@"adWrapperIds"];
    NSString *system = adData[@"adSystem"];
    
    [self persistInfoForAdId:adId wrapperIds:wrapperIds system:system];
    
    if (completion) {
        dispatch_async(dispatch_get_main_queue(), ^{
            completion([self wrapperIdForAdId:adId], [self systemIdForAdId:adId]);
        });
    }
}

- (void)parseAdDataWithProvider:(id<NPAdDataProvider>)dataProvider
{
    [self persistInfoForAdId:[dataProvider adId]
                  wrapperIds:[dataProvider wrapperIds]
                      system:[dataProvider system]];
}

- (void)persistInfoForAdId:(NSString *)adId wrapperIds:(NSArray *)wrapperIds system:(NSString *)system
{
    if (![adId isKindOfClass:[NSString class]] || adId.length == 0) {
        return;
    }
    
    NSMutableDictionary *adIdDict = [NSMutableDictionary new];
    self.adWrapperIdsForCreditingByAdIds[adId] = adIdDict;
    
    NSString *wrapperId = [wrapperIds isKindOfClass:[NSArray class] ] ? [wrapperIds firstObject] : nil;
    if (![wrapperId isKindOfClass:[NSString class]] || wrapperId.length == 0) {
        wrapperId = adId;
    }
    
    adIdDict[AdWrapperIdKey] = wrapperId;
    
    if ([system isKindOfClass:[NSString class]] && system.length > 0) {
        adIdDict[AdSystemIdKey] = system;
    }
}

- (NSString *)wrapperIdForAdId:(NSString *)adId
{
    NSDictionary *adIdDict = self.adWrapperIdsForCreditingByAdIds[adId];
    NSString *wrapperId = adIdDict[AdWrapperIdKey];
    
    return wrapperId;
}

- (NSString *)systemIdForAdId:(NSString *)adId
{
    NSDictionary *adIdDict = self.adWrapperIdsForCreditingByAdIds[adId];
    NSString *systemId = adIdDict[AdSystemIdKey];

    return systemId;
}

@end
