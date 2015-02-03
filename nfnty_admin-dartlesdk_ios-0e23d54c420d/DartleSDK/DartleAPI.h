//
//  DartleAPI.h
//  DartleSDK
//
//  Created by Gert-Jan Vercauteren on 19/11/14.
//  Copyright (c) 2014 Dartle B.V. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OAuthHandler.h"
#import "RestHandler.h"
#import "DartleBeacon.h"

@interface DartleAPI : NSObject

- (PMKPromise *) getBeacons;
- (PMKPromise *) getAllContent;
- (PMKPromise *) getContentForBeacon:(NSString *) dartleId;
- (PMKPromise *) getNotificationsForBeacon:(NSString *) dartleId;
- (PMKPromise *) createBeaconWithBeacon:(DartleBeacon *) beacon andName:(NSString *)name;
- (PMKPromise *) createBeaconWithBeacon:(DartleBeacon *) beacon;
@end
