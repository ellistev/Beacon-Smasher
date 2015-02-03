//
//  DartleBeacon.m
//  Dartle iOS SDK
//
//  Created by Leon Bij de Vaate on 01-07-14.
//  Copyright (c) 2014 Dartle. All rights reserved.
//

#import "DartleBeacon.h"
#import "RestHandler.h"

@interface DartleBeacon() 

@property (nonatomic,strong) CLBeacon* beacon;
//@property (nonatomic,strong) NSNumber* dartleId;
@property (nonatomic) BOOL ranged;
@property (nonatomic, strong) NSDictionary *content;

@end

@implementation DartleBeacon
@synthesize delegate;

#pragma mark constants
NSString * const BeaconChanged = @"DRTBeaconChanged";

#pragma mark lifecycle
/*
 * Init a beacon
 */
-(id) initWithProximityUUID:(NSUUID*)uuid
            major:(int)major
            minor:(int)minor
      	identifier:(NSString*)identifier{
    
	return [self initWithProximityUUID:uuid major:major minor:minor identifier:identifier dartleId:nil];
}

/*
 * Init from a found Beacon.
 */
- (id) initWithBeacon:(CLBeacon*)beacon
           identifier:(NSString*)identifier{
    DartleBeacon* dartleBeacon = [self initWithProximityUUID:beacon.proximityUUID major:[beacon.major intValue] minor:[beacon.minor intValue] identifier:identifier dartleId:nil];
    dartleBeacon.beacon = beacon;
    return dartleBeacon;
}

- (id) initWithBeacon:(CLBeacon*)beacon
           identifier:(NSString*)identifier
          andDartleIdentifier:(NSString *)dartleIdentifier {
    DartleBeacon* dartleBeacon = [self initWithProximityUUID:beacon.proximityUUID major:[beacon.major intValue] minor:[beacon.minor intValue] identifier:identifier dartleId:nil];
    dartleBeacon.beacon = beacon;
    dartleBeacon.dartleId = dartleIdentifier;
    return dartleBeacon;
}

/*
 * Init a beacon with its corrospending Dartle Id
 */
-(id) initWithProximityUUID:(NSUUID*)uuid
            major:(int)major
            minor:(int)minor
    	identifier:(NSString*)identifier
        	dartleId:(NSString*)dartleId{
    
    self = [super init];
    if(self){
        if(!identifier) identifier = @"beacon";
        
    	_beaconRegion = [[DartleBeaconRegion alloc]initWithProximityUUID:uuid major:major minor:minor identifier:identifier];
    	_name = identifier;
    	_dartleId = dartleId;
        
        _major = [[NSNumber alloc]initWithInt:major];
        _minor = [[NSNumber alloc]initWithInt:minor];
        _proximityUUID = uuid;
    }
    
    return self;
}

- (id) initWithJSON:(NSDictionary *) JSON {
    NSUUID *beaconUUID = [[NSUUID alloc] initWithUUIDString:[JSON objectForKey:@"uuid"]];
        
    if(!beaconUUID){
        return self;
    }
        
    DartleBeacon *dartleBeacon = [self initWithProximityUUID:beaconUUID major:[[JSON objectForKey:@"major"] intValue] minor:[[JSON objectForKey:@"minor"] intValue] identifier:[JSON objectForKey:@"name"]];
    dartleBeacon.dartleId = [JSON objectForKey:@"id"];
    return dartleBeacon;
}

#pragma mark getters and setters

-(CLProximity) proximity {
    return self.beacon.proximity;
}

-(CLLocationAccuracy) accuracy{
    return self.beacon.accuracy;
}

- (NSInteger) rssi {
    return self.beacon.rssi;
}


#pragma mark public method

-(void) setiBeacon:(CLBeacon*)ibeacon{
    self.beacon = ibeacon;
}

/*
 * Determine the state of this beacon.
 */
- (BOOL) determineState:(NSMutableArray*)ibeacons{
    for (CLBeacon *beacon in ibeacons){
        if([self equals:beacon]){
            self.ranged = true;
            self.beacon = beacon;
            
            [ibeacons removeObject:beacon];
            [[NSNotificationCenter defaultCenter] postNotificationName:BeaconChanged object:self];
            return true;
        }
    }
    
    // Beacon is not in the beacon list.
    self.ranged = false;
    self.beacon = nil;
    
    return false;
}

/*
 * Check or an iBeacon is equal to this Dartle Beacon.
 */
- (BOOL) equals:(CLBeacon *)beacon{
    if([self.major isEqualToNumber:beacon.major] &&
       [self.minor isEqualToNumber:beacon.minor] &&
       [self.proximityUUID isEqual:beacon.proximityUUID]) return true;
    return false;
}

- (PMKPromise *) getContent {
    return [[RestHandler sharedInstance] fetch:@"content" withId:self.dartleId].then(^(NSDictionary *response){
        [self.delegate dartleBeacon:self didFetchContent:response];
    });
}


@end
