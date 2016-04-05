//
//  NPAdsManagerTests.m
//  UnitTestingExample
//
//  Created by Nataliya Patsovska on 4/5/16.
//  Copyright © 2016 Nataliya Patsovska. All rights reserved.
//

#import <XCTest/XCTest.h>

#import "NPAdsManager.h"

@interface IDAdsManagerTest : XCTestCase

@property (strong, nonatomic) NPAdsManager *manager;

@end

@implementation IDAdsManagerTest

- (void)setUp
{
    [super setUp];
    
    self.manager = [NPAdsManager new];
}

- (void)tearDown
{
    self.manager = nil;
    
    [super tearDown];
}

- (void)testThatIfAdIdIsNotProvidedNilWillBeReturnedForWrapperId
{
    NSString *wrapperId = [self.manager wrapperIdForAdId:nil];
    XCTAssertNil(wrapperId);
}

- (void)testThatIfAdIdIsNotProvidedNilWillReturnedForSystemId
{
    NSString *systemId = [self.manager systemIdForAdId:nil];
    XCTAssertNil(systemId);
}

- (void)testThatIfAdIdIsNotStringNilWillBeReturnedForWrapperId
{
    id adId = @[];
    NSString *wrapperId = [self.manager wrapperIdForAdId:adId];
    XCTAssertNil(wrapperId);
}

- (void)testThatIfAdIdIsNotStringNilWillReturnedForSystemId
{
    id adId = @{@"a" : @1};
    NSString *systemId = [self.manager systemIdForAdId:adId];
    XCTAssertNil(systemId);
}

- (void)testThatIfAdIdIsNotFoundNilWillBeReturnedForWrapperId
{
    NSDictionary *adData = @{@"adWrapperIds" : @[@"wrapper id"]};
    
    [self.manager parseAdDataDictionary:adData];
    
    NSString *wrapperId = [self.manager wrapperIdForAdId:@"123"];
    XCTAssertNil(wrapperId);
}

- (void)testThatIfAdIdIsNotFoundNilWillReturnedForSystemId
{
    NSDictionary *adData = @{@"adSystem": @"system id"};
    
    [self.manager parseAdDataDictionary:adData];
    
    NSString *systemId = [self.manager systemIdForAdId:@"123"];
    XCTAssertNil(systemId);
}

- (void)testThatIfAdIdIsEmptyStringNilWillBeReturnedForWrapperId
{
    NSDictionary *adData = @{@"adId" : @"",
                             @"adWrapperIds" : @[@"wrapper id"]};
    
    [self.manager parseAdDataDictionary:adData];
    
    NSString *wrapperId = [self.manager wrapperIdForAdId:@""];
    XCTAssertNil(wrapperId);
}

- (void)testThatIfAdIdIsEmptyStringNilWillReturnedForSystemId
{
    NSDictionary *adData = @{@"adId" : @"",
                             @"adSystem": @"system id"};
    
    [self.manager parseAdDataDictionary:adData];
    
    NSString *systemId = [self.manager systemIdForAdId:@""];
    XCTAssertNil(systemId);
}

- (void)testThatIfDataToPersistIsNotDictioranyParsingWillThrowDebugException
{
    id adData = @[];
    XCTAssertThrowsSpecificNamed([self.manager parseAdDataDictionary:adData], NSException, NSInternalInconsistencyException);
}

- (void)testThatIfWrapperIdIsPersistedItWillBeReturned
{
    NSDictionary *adData = @{@"adId" : @"123",
                             @"adWrapperIds" : @[@"wrapper id"],
                             @"adSystem": @"system id"};
    
    [self.manager parseAdDataDictionary:adData];
    
    NSString *wrapperId = [self.manager wrapperIdForAdId:@"123"];
    XCTAssertEqualObjects(wrapperId, @"wrapper id");
}

- (void)testThatIfMultipleWrapperIdsAreProvidedForPersistingTheFirstOneWillBeReturned
{
    NSDictionary *adData = @{@"adId" : @"123",
                             @"adWrapperIds" : @[@"wrapper id 1", @"wrapper id 2"],
                             @"adSystem": @"system id"};
    
    [self.manager parseAdDataDictionary:adData];
    
    NSString *wrapperId = [self.manager wrapperIdForAdId:@"123"];
    XCTAssertEqualObjects(wrapperId, @"wrapper id 1");
}

- (void)testThatIfSystemIdIsPersistedItWillBeReturned
{
    NSDictionary *adData = @{@"adId" : @"123",
                             @"adWrapperIds" : @[@"wrapper id 1", @"wrapper id 2"],
                             @"adSystem": @"system id"};
    
    [self.manager parseAdDataDictionary:adData];
    
    NSString *systemId = [self.manager systemIdForAdId:@"123"];
    XCTAssertEqualObjects(systemId, @"system id");
}

- (void)testThatIfWrapperIdsArrayIsEmptyTheAdIdWillBeReturned
{
    NSDictionary *adData = @{@"adId" : @"123",
                             @"adWrapperIds" : @[],
                             @"adSystem": @"system id"};
    
    [self.manager parseAdDataDictionary:adData];
    
    NSString *wrapperId = [self.manager wrapperIdForAdId:@"123"];
    XCTAssertEqualObjects(wrapperId, @"123");
}

- (void)testThatIfWrapperIdIsEmptyStringTheAdIdWillBeReturned
{
    NSDictionary *adData = @{@"adId" : @"123",
                             @"adWrapperIds" : @[@""],
                             @"adSystem": @"system id"};
    
    [self.manager parseAdDataDictionary:adData];
    
    NSString *wrapperId = [self.manager wrapperIdForAdId:@"123"];
    XCTAssertEqualObjects(wrapperId, @"123");
}

- (void)testThatIfWrapperIdIsMissingTheAdIdWillBeReturned
{
    NSDictionary *adData = @{@"adId" : @"123",
                             @"adSystem": @"system id"};
    
    [self.manager parseAdDataDictionary:adData];
    
    NSString *wrapperId = [self.manager wrapperIdForAdId:@"123"];
    XCTAssertEqualObjects(wrapperId, @"123");
}

- (void)testThatIfSystemIdIsMissingNilWillBeReturned
{
    NSDictionary *adData = @{@"adId" : @"123",
                             @"adWrapperIds" : @[],
                             @"adWrapperSystems": @[@"system wrapper id"]};
    
    [self.manager parseAdDataDictionary:adData];
    
    NSString *systemId = [self.manager systemIdForAdId:@"123"];
    XCTAssertNil(systemId);
}

- (void)testThatIfSystemIdIsEmptyStringNilWillBeReturned
{
    NSDictionary *adData = @{@"adId" : @"123",
                             @"adWrapperIds" : @[],
                             @"adSystem": @"",
                             @"adWrapperSystems": @[@"system wrapper id"]};
    
    [self.manager parseAdDataDictionary:adData];
    
    NSString *systemId = [self.manager systemIdForAdId:@"123"];
    XCTAssertNil(systemId);
}

- (void)testThatDataInformationIsOverriden
{
    NSDictionary *adData1 = @{@"adId" : @"123",
                              @"adWrapperIds" : @[@"wrapper id 1"],
                              @"adSystem": @"system id"};
    
    
    [self.manager parseAdDataDictionary:adData1];
    
    NSDictionary *adData2 = @{@"adId" : @"123",
                              @"adWrapperIds" : @[@"wrapper id 2"],
                              @"adSystem": @"system id"};
    
    
    [self.manager parseAdDataDictionary:adData2];
    
    NSString *wrapperId = [self.manager wrapperIdForAdId:@"123"];
    XCTAssertEqualObjects(wrapperId, @"wrapper id 2");
}

@end
