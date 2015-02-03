//
//  DartleAPI.m
//  DartleSDK
//
//  Created by Gert-Jan Vercauteren on 19/11/14.
//  Copyright (c) 2014 Dartle B.V. All rights reserved.
//

#import "DartleAPI.h"

@implementation DartleAPI

- (PMKPromise *) getBeacons {
    return nil;
}

- (PMKPromise *) getAllContent {
    return nil;
}

- (PMKPromise *) getContentForBeacon:(NSString *) dartleId {
    return nil;
}

- (PMKPromise *) getNotificationsForBeacon:(NSString *) dartleId {
    return nil;
}

- (PMKPromise *) createBeaconWithBeacon:(DartleBeacon *) beacon andName:(NSString *)name {
    return nil;
}

- (PMKPromise *) createBeaconWithBeacon:(DartleBeacon *) beacon {
    NSDictionary *data = @{};
    return [[RestHandler sharedInstance] create:@"poi" withData:data];
}

@end
