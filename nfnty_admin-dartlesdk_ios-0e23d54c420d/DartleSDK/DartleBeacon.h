//
//  DartleBeacon.h
//  Dartle iOS SDK
//
//  Created by Leon Bij de Vaate on 01-07-14.
//  Copyright (c) 2014 Dartle. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import "DartleBeaconRegion.h"
#import <PromiseKit.h>

@class DartleBeacon;
@protocol DartleBeaconDelegate <NSObject>
@optional
- (void) dartleBeacon:(DartleBeacon *)beacon didFetchContent:(NSDictionary *)content;
@end

@interface DartleBeacon : NSObject {
__weak id <DartleBeaconDelegate> delegate;
}

@property (nonatomic, weak) id <DartleBeaconDelegate> delegate;

/* Dartle Properties */
@property (nonatomic,strong) NSString* 			name;
@property (nonatomic,strong) DartleBeaconRegion* 	beaconRegion;

@property (nonatomic,strong,readonly) NSNumber* 	major;
@property (nonatomic,strong,readonly) NSNumber* 	minor;
@property (nonatomic,strong,readonly) NSUUID* 	proximityUUID;
@property (nonatomic,readonly) CLProximity 	proximity;
@property (nonatomic,readonly) CLLocationAccuracy 	accuracy;
@property (nonatomic, readonly) NSInteger rssi;

//Dartle properties
@property (nonatomic, strong) NSString *dartleId;


// beacon changed notification
extern NSString * const BeaconChanged;


/* init methods */
- (id) initWithProximityUUID:(NSUUID*)uuid
              major:(int)major
              minor:(int)minor
      	identifier:(NSString*)identifier;

- (id) initWithProximityUUID:(NSUUID*)uuid
              major:(int)major
              minor:(int)minor
        identifier:(NSString*)identifier
       	 dartleId:(NSNumber*)dartleId;

- (id) initWithBeacon:(CLBeacon*)beacon
           identifier:(NSString*)identifier;
-(id) initWithBeacon:(CLBeacon*)beacon
          identifier:(NSString*)identifier
 andDartleIdentifier:(NSString *)dartleIdentifier;

- (id) initWithJSON:(NSDictionary *) JSON;

/* 
 * Is a beacon in range 
 */
- (BOOL) determineState:(NSArray*)ibeacons;
- (PMKPromise *) getContent;
- (BOOL) equals:(CLBeacon *)beacon;
@end

