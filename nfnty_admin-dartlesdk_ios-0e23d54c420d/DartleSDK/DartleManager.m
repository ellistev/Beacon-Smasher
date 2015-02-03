//
//  DartleManager.m
//  Dartle iOS SDK
//
//  Created by Leon Bij de Vaate on 01-07-14.
//  Copyright (c) 2014 Dartle. All rights reserved.
//

#import "DartleManager.h"
#import "FDKeychain.h"
#import "OAuthHandler.h"

@implementation DartleManager
@synthesize delegate;

+ (DartleManager *)sharedInstance
{
	// structure used to test whether the block has completed or not
	static dispatch_once_t p = 0;

	// initialize sharedObject as nil (first call only)
	__strong static DartleManager *_sharedObject = nil;

	// executes a block object once and only once for the lifetime of an application
	dispatch_once(&p, ^{
		_sharedObject = [[self alloc] init];
	});

	// returns the same object each time
	return _sharedObject;
}

-(BeaconManager*) beaconManager {
	if (!_beaconManager) _beaconManager = [[BeaconManager alloc]init];
	return _beaconManager;
}

- (void) initWithQRCode:(NSString *) qrcode {
	NSDictionary *oauthConsumer =  [DartleUtility OAuthCredentialsFromQR:qrcode];
	NSError *error = nil;
	if(oauthConsumer) {
		[FDKeychain saveItem:[oauthConsumer objectForKey:@"consumerKey"] forKey:@"consumerKey" forService:@"DartleSDK" error:&error];
		[FDKeychain saveItem:[oauthConsumer objectForKey:@"consumerSecret"] forKey:@"consumerSecret" forService:@"DartleSDK" error:&error];

		//Now authorize with OAUth to get an OAuth token.
        [[OAuthHandler sharedInstance] requestAccessTokenWithConsumerKey:[oauthConsumer objectForKey:@"consumerKey"]
                                                               andSecret:[oauthConsumer objectForKey:@"consumerSecret"]].then(^{
            NSLog(@"DELEGATE");
            NSError *error = nil;
            NSString *oauthToken = [FDKeychain itemForKey: @"oauthToken" forService: @"DartleSDK" error: &error];
            [[self delegate] dartleManager:self didConnectWithDartleApi:oauthToken];
        });
        
	}
}

- (PMKPromise *) getAllBeacons {
	return [[RestHandler sharedInstance] fetchAll:@"poi"];
}

- (BOOL) isConnectedWithDartle {
    NSError *error = nil;
    NSString *oauthToken = [FDKeychain itemForKey: @"oauthToken" forService: @"DartleSDK" error: &error];
    if(oauthToken != nil) {
        return YES;
    } else {
        return NO;
    }
}

- (void) unlinkAPI {
    NSError *error = nil;
    [FDKeychain deleteItemForKey: @"oauthToken"
                      forService: @"DartleSDK"
                           error: &error];
    [FDKeychain deleteItemForKey: @"consumerKey"
                      forService: @"DartleSDK"
                           error: &error];
    [FDKeychain deleteItemForKey: @"consumerSecret"
                      forService: @"DartleSDK"
                           error: &error];
}

- (NSString *) getOAuthToken {
    NSError *error = nil;
    return[FDKeychain itemForKey: @"oauthToken" forService: @"DartleSDK" error: &error];
}

@end
