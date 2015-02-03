//
//  BeaconManager.m
//  Dartle iOS SDK
//
//  Created by Leon Bij de Vaate on 01-07-14.
//  Copyright (c) 2014 Dartle. All rights reserved.
//

#import "BeaconManager.h"
#import <CoreBluetooth/CoreBluetooth.h>
#import "RestHandler.h"
#import "DartleManager.h"
#import "DartleBeacon.h"

@interface BeaconManager() <CLLocationManagerDelegate, CBPeripheralManagerDelegate>
@property (strong, nonatomic) CLLocationManager *locationManager;

//@property (strong, nonatomic) NSMutableArray *activeRangingBeacons;
@property (strong, nonatomic) NSMutableArray *activeMonitoringBeacons;

@property (strong, nonatomic) NSMutableDictionary *rangedRegions;
@property (strong, nonatomic) NSMutableArray *rangedBeacons;

@property (strong, nonatomic) NSMutableArray *activeRegions;

@property (strong, nonatomic) CBPeripheralManager *peripheralManager;
@property (strong, nonatomic) NSMutableDictionary *beaconPeripheralData;

@property (strong, nonatomic) NSMutableArray *cloudBeacons;

@end

@implementation BeaconManager
@synthesize delegate;

#pragma mark constants
NSString * const BeaconsRanged = @"DRTBeaconManagerDidRangeBeacons";

#pragma mark initializers
- (id) init {
    self = [super init];
    if(self) {
        _locationManager = [[CLLocationManager alloc] init];
        _locationManager.delegate = self;
        
        if([_locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]){
            [_locationManager requestWhenInUseAuthorization];
        }
    }
    return self;
}

#pragma mark Getters

- (NSMutableArray *) activeRangingBeacons {
    if(!_activeMonitoringBeacons) _activeMonitoringBeacons = [[NSMutableArray alloc] init];
    return _activeMonitoringBeacons;
}

- (NSMutableArray *) activeMonitoringBeacons {
    if(!_activeMonitoringBeacons) _activeMonitoringBeacons = [[NSMutableArray alloc] init];
    return _activeMonitoringBeacons;
}

- (NSMutableArray *) rangedBeacons {
    if(!_rangedBeacons) _rangedBeacons = [[NSMutableArray alloc] init];
    return _rangedBeacons;
}

- (NSMutableDictionary *) rangedRegions {
    if(!_rangedRegions) _rangedRegions = [[NSMutableDictionary alloc] init];
    return _rangedRegions;
}

- (NSMutableArray *) activeRegions {
    if(!_activeRegions) _activeRegions = [[NSMutableArray alloc] init];
    return _activeRegions;
}

- (NSMutableArray *) cloudBeacons {
    if(!_cloudBeacons) _cloudBeacons = [[NSMutableArray alloc] init];
    return _cloudBeacons;
}


#pragma mark CoreLocation based scanning

/**
 *  Start monitoring for the specified region
 *
 *  @param region The region object that defines the identifying information for the targeted beacons. The amount of beacons returned are based on the information you provide in the region.
 */
- (void) startMonitoringForRegion:(DartleBeaconRegion *) region {
    if (region != nil) {
        [self.locationManager startMonitoringForRegion:region];
    }
}

/**
 *  Stops monitoring for the specified region
 *
 *  @param region The region you are currently monitoring. The object does not have to be the same, but the beacon parameters should match.
 */
- (void) stopMonitoringForRegion:(DartleBeaconRegion *) region {
    if (region != nil) {
        [self.locationManager stopMonitoringForRegion:region];
       
    }
}

/**
 *  Start ranging for beacons in the specified region
 *
 *  @param region The region object that defines the identifying information for the targeted beacons. The amount of beacons returned are based on the information you provide in the region.
 */
- (void) startRangingForBeaconsInRegion:(DartleBeaconRegion *) region {
    if (region != nil) {
        [self.activeRegions addObject:region];
        [self.locationManager startRangingBeaconsInRegion:region];
    }
}

/**
 *  Stop ranging for beacons on the specified region
 *
 *  @param region The region you are currently ranging. The object does not have to be the same, but the beacon parameters should match.
 */
- (void) stopRangingForBeaconsInRegion:(DartleBeaconRegion *) region {
    if (region != nil) {
        [self.locationManager stopRangingBeaconsInRegion:region];
        [self.activeRegions removeObject:region];
    }
}

/**
 *  Stop ranging for all beacons that are currently ranged
 */
- (void) stopRangingForAllBeacons {
    for (CLBeaconRegion *region in [self.locationManager rangedRegions]) {
        [self.locationManager stopRangingBeaconsInRegion:region];
    }
    [self.activeRegions removeAllObjects];
    self.rangedBeacons = [[NSMutableArray alloc] init];
    self.rangedRegions = [[NSMutableDictionary alloc] init];
}


#pragma mark Advertising as an iBeacon

/**
 *  Start advertising as the beacon you specified
 *
 *  @param proximityUUID The UUID you want to broadcast
 *  @param major         The major value of your beacon
 *  @param minor         The minor value of your beacon
 *  @param identifier    The name you want to broadcast your beacons as.
 */
- (void) startAdvertisingWithProximityUUID: (NSUUID *) proximityUUID major:(CLBeaconMajorValue *)major minor:(CLBeaconMinorValue *) minor identifier:(NSString *) identifier {
    CLBeaconRegion* beaconRegion = [[CLBeaconRegion alloc] initWithProximityUUID:proximityUUID
                                                                major:(int)major
                                                                minor:(int)minor
                                                           identifier:identifier];
    self.beaconPeripheralData = [beaconRegion peripheralDataWithMeasuredPower:nil];
    self.peripheralManager = [[CBPeripheralManager alloc] initWithDelegate:self
                                                                     queue:nil
                                                                   options:nil];
}

/**
 *  Stop advertising as a beacon.
 */
- (void) stopAdvertising {
    [self.peripheralManager stopAdvertising];
}

-(void)peripheralManagerDidUpdateState:(CBPeripheralManager *)peripheral {
    if (peripheral.state == CBPeripheralManagerStatePoweredOn) {
        NSLog(@"Powered On");
        [self.peripheralManager startAdvertising:self.beaconPeripheralData];
    } else if (peripheral.state == CBPeripheralManagerStatePoweredOff) {
        NSLog(@"Powered Off");
        [self.peripheralManager stopAdvertising];
    }
}


#pragma mark Corelocation delegate

/**
 *  Called when a beacons are found
 *
 *  @param manager The manager used to find the beacons
 *  @param beacons A list of beacons or nil
 *  @param region  The region used to find the beacons
 */
- (void) locationManager:(CLLocationManager *)manager didRangeBeacons:(NSArray *)beacons inRegion:(CLBeaconRegion *)region {
    NSMutableArray *rangedBeacons = [beacons mutableCopy];
    NSMutableArray *seenBeacons = [[NSMutableArray alloc] init];
    
    if([self.activeRegions count] > 0) {
        BOOL foundRegion = NO;
        for (DartleBeaconRegion *dartleRegion in self.activeRegions) {
            if([dartleRegion.proximityUUID isEqual:region.proximityUUID] &&
               ([dartleRegion.major isEqual:region.major] || (region.major == nil && dartleRegion.major == nil)) &&
               ([dartleRegion.minor isEqual:region.minor] || (region.minor == nil && dartleRegion.minor == nil))){
                foundRegion = YES;
            }
        }
        
        if(!foundRegion) {
           [self.rangedRegions removeObjectForKey:region];
           return;
        }
    } else {
        return;
    }
    
    //Determine the beacons we are ranging for
    if([self.activeRangingBeacons count] > 0) {
        for(DartleBeacon *beacon in self.activeRangingBeacons) {
            if([beacon determineState:rangedBeacons]) {
                [seenBeacons addObject:beacon];
            }
        }
    }

    if([rangedBeacons count] > 0) {
        for(CLBeacon *rangedBeacon in rangedBeacons) {
            BOOL seen = NO;
            if([self.cloudBeacons count] > 0){
                for (DartleBeacon *cloudBeacon in self.cloudBeacons) {
                    if([cloudBeacon equals:rangedBeacon]) {
                        seen = YES;
                        [seenBeacons addObject:[[DartleBeacon alloc] initWithBeacon:rangedBeacon identifier:cloudBeacon.name andDartleIdentifier:cloudBeacon.dartleId]];
                    }
                }
            }
            
            if(!seen) {
                [seenBeacons addObject:[[DartleBeacon alloc] initWithBeacon:rangedBeacon identifier:region.identifier]];
            }
        }
    }
    
    if([seenBeacons count] > 0) {
        [self.rangedRegions setObject:seenBeacons forKey:region];
        [self rangedBeaconChanged];
    }
}

- (void) rangedBeaconChanged {
    [self.rangedBeacons removeAllObjects];
    for(NSArray *beacons in [self.rangedRegions allValues]) {
        for(DartleBeacon *beacon in beacons) {
            if(![self.rangedBeacons containsObject:beacon]) {
                [self.rangedBeacons addObject:beacon];
            }
        }
    }
    [[self delegate] beaconManager:self didRangeBeacons:[self filterBeacons:self.rangedBeacons] inRegion:nil];
}

- (void) fetchCloudBeacons {
    [[RestHandler sharedInstance] fetchAll:@"poi"].then(^(NSDictionary *poi){
        self.cloudBeacons = [self createDartleBeaconsFromCloudBeacons:[poi objectForKey:@"ble"]];
        [self.delegate beaconManager:self didFetchBeaconsFromCloud:self.cloudBeacons];
    });
}

- (NSMutableArray *) createDartleBeaconsFromCloudBeacons:(NSArray *) cloudBeacons {
    NSMutableArray *dartleBeacons = [[NSMutableArray alloc] init];
    for (NSDictionary *dict in cloudBeacons) {
        DartleBeacon *beacon = [[DartleBeacon alloc] initWithJSON:dict];
        [dartleBeacons addObject:beacon];
    }
    return dartleBeacons;
}

/**
 *  Get an NSArray of the relevant bacons. Filter out beacons with an unknown or far proximity, or a negative accuracy
 *
 *  @param beaconList A list of found iBeacons
 *  @return NSArray
 */
- (NSArray *) filterBeacons:(NSArray *)beaconList {
    NSPredicate *predicateIrrelevantBeacons = [NSPredicate predicateWithFormat:@"(self.accuracy != -1) AND (self.proximity != %d)", CLProximityUnknown];
    NSArray *relevantBeacons = [beaconList filteredArrayUsingPredicate:predicateIrrelevantBeacons];
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"accuracy" ascending:YES];
    
    return [relevantBeacons sortedArrayUsingDescriptors:[NSArray arrayWithObjects:sortDescriptor,nil]];
}

- (void)locationManager:(CLLocationManager *)manager didStartMonitoringForRegion:(CLRegion *)region {
    
}

- (void)locationManager:(CLLocationManager *)manager monitoringDidFailForRegion:(CLRegion *)region withError:(NSError *)error {
    
}

#pragma mark Utility

+ (BOOL) isRangingAvailable {
    return [CLLocationManager isRangingAvailable];
}

@end
