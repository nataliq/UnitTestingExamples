//
//  NPAdsManager.h
//  UnitTestingExample
//
//  Created by Nataliya Patsovska on 4/5/16.
//  Copyright © 2016 Nataliya Patsovska. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NPAdsManager : NSObject

/**
 *  Persists wrapper id & system id information associated with an ad id from the provided dictionary.
 *  Wrapper and system ids could be nil or non-empty strings.
 *  If the ad id is missing the wrapper & system ids will be nil.
 *  If the wrapper id is missing it will persist the ad id as a wrapper id.
 *  If the system id is missing it will be nil.
 *
 *  @param adData A dictionary which contains string "adId" key (required), 
 *                an array for "adWrapperIds" key (optional) and a string for "adSystem" key (optional)
 */
- (void)parseAdDataDictionary:(NSDictionary *)adData;

- (NSString *)wrapperIdForAdId:(NSString *)adId;
- (NSString *)systemIdForAdId:(NSString *)adId;

@end
