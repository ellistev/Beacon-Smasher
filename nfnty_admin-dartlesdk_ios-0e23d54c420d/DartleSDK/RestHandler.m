//
//  RestHandler.m
//  DartleSDK iOS
//
//  Created by Gert-Jan Vercauteren on 18/09/14.
//  Copyright (c) 2014 Nfnty. All rights reserved.
//

#import "RestHandler.h"
#import <PromiseKit.h>
#import <AFNetworking.h>
#import <AFNetworking+PromiseKit.h>
#import "OAuthHandler.h"
#import "FDKeychain.h"
#import "DartleManager.h"

#define BASE_URL  @"http://jurgen-api.dartle.intern.nfnty.nl"

@interface RestHandler ()
@property (strong, nonatomic) AFHTTPRequestOperationManager* manager;
@end

@implementation RestHandler


+ (RestHandler *)sharedInstance
{
	// structure used to test whether the block has completed or not
	static dispatch_once_t p = 0;

	// initialize sharedObject as nil (first call only)
	__strong static RestHandler* _sharedObject = nil;

	// executes a block object once and only once for the lifetime of an application
	dispatch_once(&p, ^{
		_sharedObject = [[self alloc] init];
	});

	// returns the same object each time
	return _sharedObject;
}

- (RestHandler *) init {
	self.manager = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:[NSURL URLWithString:BASE_URL]];

	AFJSONResponseSerializer *responseSerializer = [ AFJSONResponseSerializer serializerWithReadingOptions:NSJSONReadingAllowFragments];
	NSMutableSet *contentTypes = [NSMutableSet setWithSet:[responseSerializer acceptableContentTypes]];
	[contentTypes addObject:@"application/problem+json"];
	responseSerializer.acceptableContentTypes = [NSSet setWithSet:contentTypes];


	self.manager.responseSerializer = responseSerializer;
	self.manager.requestSerializer = [AFJSONRequestSerializer serializer];

	[self.manager.requestSerializer setValue:[NSString stringWithFormat:@"Bearer %@", [[DartleManager sharedInstance] getOAuthToken]] forHTTPHeaderField:@"Authorization"];

	return self;
}

/**
 *  Fetch a single entity from the API
 *
 *  @param endpoint The endpoint we want to reach
 *  @param id       The id of the item we want to fecth
 *
 *  @return A promise for the response
 */
- (PMKPromise *) fetch:(NSString *) endpoint withId:(NSString *) identifier {
	// Encode the ID
	NSString *encodedString = [self percentEscapeString:identifier];
	NSString *urlString = [NSString stringWithFormat:@"%@/%@",endpoint, encodedString];
	NSLog(@"GET %@", urlString);
	return [self.manager GET:urlString parameters:nil].catch(^(NSError *error){
		[self handleError:error];
	});
}

/**
 *  Fetch all the entities from the API
 *
 *  @param endpoint The endpoint we want to reach
 *
 *  @return A promise for the response
 */
- (PMKPromise *) fetchAll:(NSString *) endpoint {
	NSLog(@"GET %@", endpoint);
	return [self.manager GET:endpoint parameters:nil].catch(^(NSError *error){
		[self handleError:error];
	});
}

/**
 *  Create a new entity with the provided data
 *
 *  @param endpoint The endpoint we want to reach
 *  @param data     The data we need to create the entity
 *
 *  @return A promise for the response
 */
- (PMKPromise *) create:(NSString *) endpoint withData:(NSDictionary *) data {
	NSLog(@"POST %@", endpoint);
    return [self.manager POST:endpoint parameters:data];
//    .catch(^(NSError *error){
//        [self handleError:error];
//    });
}

/**
 *  Delete an entity with the provided id
 *
 *  @param endpoint The endpoint we want to reach
 *  @param id       The id of the item we want to delete
 *
 *  @return A promise for the response
 */
- (PMKPromise *) delete:(NSString *) endpoint withId:(NSString *) identifier {

	// Escape the identifier
	NSString *encodedString = [self percentEscapeString:identifier];
	NSString *urlString = [NSString stringWithFormat:@"%@/%@",endpoint, encodedString];
	NSLog(@"DELETE %@", urlString);

	return [self.manager DELETE:urlString parameters:nil].catch(^(NSError *error){
		[self handleError:error].then(^{
			NSLog(@"Gelukt");
		});
	});
}

- (PMKPromise *) handleError:(NSError *) error {
	AFHTTPRequestOperation *reqOp =  error.userInfo[AFHTTPRequestOperationErrorKey];
	NSInteger statusCode = reqOp.response.statusCode;

	if(statusCode == 403) {
		return [[OAuthHandler sharedInstance] refreshToken].catch(^(NSError *error){
			NSLog(@"Something wrong");
		});
	}

	return [PMKPromise new];
}

- (NSString *)percentEscapeString:(NSString *)string
{
	NSString *result = CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
	                                                                             (CFStringRef)string,
	                                                                             (CFStringRef)@" ",
	                                                                             (CFStringRef)@":/?@!$&'()*+,;=",
	                                                                             kCFStringEncodingUTF8));
	return [result stringByReplacingOccurrencesOfString:@" " withString:@"+"];
}
@end
