//
//  BeaconManager.h
//  Dartle iOS SDK
//
//  Created by Leon Bij de Vaate on 01-07-14.
//  Copyright (c) 2014 Dartle. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import	"DartleBeacon.h"
#import "DartleBeaconRegion.h"

@class BeaconManager;
@protocol BeaconManagerDelegate <NSObject>
@optional
- (void) beaconManager:(BeaconManager *)manager didStartMonitoringForRegion:(CLBeaconRegion *)region;
- (void) beaconManager:(BeaconManager *)manager monitoringDidFailForRegion:(CLBeaconRegion *)region withError:(NSError *)error;
- (void) beaconManager:(BeaconManager *)manager didFetchBeaconsFromCloud:(NSArray *)beacons;
@required
- (void) beaconManager:(BeaconManager *)manager didRangeBeacons:(NSArray *)beacons inRegion:(CLBeaconRegion *)region;
@end

@interface BeaconManager : NSObject {
__weak id <BeaconManagerDelegate> delegate;
}

@property (nonatomic, weak) id <BeaconManagerDelegate> delegate;


extern NSString * const BeaconsRanged;
- (void) startMonitoringForRegion:(DartleBeaconRegion *) region;
- (void) stopMonitoringForRegion:(DartleBeaconRegion *) region;

- (void) startRangingForBeaconsInRegion:(DartleBeaconRegion *) region;
- (void) stopRangingForBeaconsInRegion:(DartleBeaconRegion *) region;
- (void) stopRangingForAllBeacons;

- (void) startAdvertisingWithProximityUUID: (NSUUID *) proximityUUID major:(CLBeaconMajorValue *)major minor:(CLBeaconMinorValue *) minor identifier:(NSString *) identifier;
- (void) stopAdvertising;

- (void) fetchCloudBeacons;

+ (BOOL) isRangingAvailable;

@end
