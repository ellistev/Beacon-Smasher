//
//  OAuthHandler.m
//  DartleSDK
//
//  Created by Gert-Jan Vercauteren on 27/10/14.
//  Copyright (c) 2014 Nfnty. All rights reserved.
//

#import "OAuthHandler.h"
#import <AFNetworking.h>
#import <AFNetworking+PromiseKit.h>

#import <Security/Security.h>
#import "Constants.h"
#import "FDKeychain.h"

@interface OAuthHandler ()
@property (strong, nonatomic) AFHTTPRequestOperationManager* manager;
@end

@implementation OAuthHandler

+ (OAuthHandler *)sharedInstance
{
	// structure used to test whether the block has completed or not
	static dispatch_once_t p = 0;

	// initialize sharedObject as nil (first call only)
	__strong static OAuthHandler* _sharedObject = nil;

	// executes a block object once and only once for the lifetime of an application
	dispatch_once(&p, ^{
		_sharedObject = [[self alloc] init];
	});

	// returns the same object each time
	return _sharedObject;
}

- (OAuthHandler *) init {
	self.manager = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:[NSURL URLWithString:BASE_URL]];
	self.manager.responseSerializer = [AFJSONResponseSerializer serializer];
	self.manager.requestSerializer = [AFJSONRequestSerializer serializer];
	return self;
}

- (PMKPromise *) requestAccessTokenWithConsumerKey:(NSString *) consumerKey andSecret:(NSString *) consumerSecret {
	NSDictionary *parameters = @{@"grant_type":@"client_credentials", @"client_id":consumerKey, @"client_secret":consumerSecret};
    return [self.manager POST:@"oauth" parameters:parameters].then(^(NSDictionary *response) {
        NSError *error = nil;
        [FDKeychain saveItem:[response objectForKey:@"access_token"] forKey:@"oauthToken" forService:@"DartleSDK" error:&error];
    }).catch(^(NSError *error){
		return error;
	});
}

/**
 *  Save credentials for the OAuth flow
 *
 *  @param credentials Credentials that were received from an OAuth request
 */
- (void) saveOauthCredentials:(NSDictionary *) credentials {
    NSLog(@"ALLO!");
#warning This HAS to be converted to KeyChain access
//	NSMutableDictionary *oauthCredentials = [credentials mutableCopy];
//	[oauthCredentials removeObjectForKey:@"scope"];
//
//	if([[[NSUserDefaults standardUserDefaults] objectForKey:@"oauth"] objectForKey:@"refresh_token"]) {
//		[oauthCredentials setObject:[[[NSUserDefaults standardUserDefaults] objectForKey:@"oauth"] objectForKey:@"refresh_token"] forKey:@"refresh_token"];
//	}
//
//	[oauthCredentials setObject:[[[NSDate alloc] init] dateByAddingTimeInterval:3600] forKey:@"expireDate"];
//
//	NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
//	[prefs setObject:oauthCredentials forKey:@"oauth"];
//	[prefs synchronize];

	//    NSLog(@"Creds: %@", oauthCredentials);
}

@end
