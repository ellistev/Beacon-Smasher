//
//  DartleManager.h
//  Dartle iOS SDK
//
//  Created by Leon Bij de Vaate on 01-07-14.
//  Copyright (c) 2014 Dartle. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BeaconManager.h"
#import "DartleAPI.h"
#import "DartleUtility.h"

@class DartleManager;
@protocol DartleManagerDelegate <NSObject>
@optional
- (void) dartleManager:(DartleManager *)manager didConnectWithDartleApi:(NSString *) oauthToken;
@end

@interface DartleManager : NSObject {
    __weak id <DartleManagerDelegate> delegate;
}

@property (nonatomic, weak) id <DartleManagerDelegate> delegate;

@property (nonatomic,strong) BeaconManager* beaconManager;
// singleton object
+ (DartleManager *) sharedInstance;
- (PMKPromise *) getAllBeacons;
- (void) initWithQRCode:(NSString *) qrcode;
- (BOOL) isConnectedWithDartle;
- (void) unlinkAPI;
- (NSString *) getOAuthToken;
@end
