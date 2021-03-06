//
//  MobileIdentityManagerTests.m
//  EngageSDK
//
//  Created by andrew zuercher on 1/19/15.
//  Copyright (c) 2015 Silverpop. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import "EngageConnectionManager.h"
#import "UBFClient.h"
#import "EngageBaseTest_IT.h"


@interface EngageConnectionManager_IT : XCTestCase

@property NSString *clientId;
@property NSString *secret;
@property NSString *refreshToken;
@property NSString *host;
@property NSString *listId;

@end

@implementation EngageConnectionManager_IT

- (void)setUp {
    [super setUp];
    
    //TODO: move to a single place
    self.clientId = @"02eb567b-3674-4c48-8418-dbf17e0194fc";
    self.secret = @"9c650c5b-bcb8-4eb3-bf0a-cc8ad9f41580";
    self.refreshToken = @"676476e8-2d1f-45f9-9460-a2489640f41a";
    self.host = @"https://apipilot.silverpop.com/";
    self.listId = @"23949";
}

- (void)tearDown {
    [super tearDown];
}

- (void)testCreateMobileManagerViaClient {
    XCTestExpectation *expectation = [self expectationWithDescription:@"Mobile Manager Created"];
    
    [UBFClient createClient:self.clientId secret:self.secret token:self.refreshToken host:self.host connectSuccess:^(AFOAuthCredential *credential) {
        NSLog(@"Mobile Manager created successfully!");
        XCTAssertNotNil([EngageConnectionManager sharedInstance]);
        [expectation fulfill];
        
    } failure:^(NSError *error) {
        NSLog(@"Mobile Manager creation failed");
        XCTFail(@"Mobile manager creation failed");
    }];
    
    [self waitForExpectationsWithTimeout:5.0 handler:^(NSError *error) {
        if (error) {
            NSLog(@"Timeout Error: %@", error);
        }
    }];
}

- (void)testCreateMobileManagerDirect {
    // Create an expectation object.
    XCTestExpectation *successfulAuthExpectation = [self expectationWithDescription:@"Auth Successful"];
    
    [EngageConnectionManager createInstanceWithHost: self.host clientId:self.clientId secret:self.secret token:self.refreshToken];
    [[EngageConnectionManager sharedInstance] authenticate: ^(AFOAuthCredential *credential) {
        NSLog(@"Auth was successful!");
        XCTAssertTrue([[EngageConnectionManager sharedInstance] isAuthenticated]);
        [successfulAuthExpectation fulfill];
        
    } failure:^(NSError *error) {
        NSLog(@"Auth failed");
        XCTFail(@"Auth failed");
    }];
    
    // The test will pause here, running the run loop, until the timeout is hit
    // or all expectations are fulfilled.
    [self waitForExpectationsWithTimeout:5.0 handler:^(NSError *error) {
        if (error) {
            NSLog(@"Timeout Error: %@", error);
        }
    }];
}

@end
