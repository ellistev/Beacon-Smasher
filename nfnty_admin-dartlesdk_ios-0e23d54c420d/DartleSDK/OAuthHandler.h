//
//  OAuthHandler.h
//  Woonlinked
//
//  Created by Gert-Jan Vercauteren on 27/10/14.
//  Copyright (c) 2014 Nfnty. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PromiseKit.h"
@interface OAuthHandler : NSObject

+ (OAuthHandler *)sharedInstance;

- (PMKPromise *) requestAccessTokenWithUsername:(NSString *) username andPassword:(NSString *) password;
- (PMKPromise *) requestAccessTokenWithConsumerKey:(NSString *) consumerKey andSecret:(NSString *) consumerSecret;
- (PMKPromise *) refreshToken;
@end
