//
//  RestHandler.h
//  Woonlinked iOS
//
//  Created by Gert-Jan Vercauteren on 18/09/14.
//  Copyright (c) 2014 Nfnty. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AFHTTPRequestOperation.h>
#import <PromiseKit.h>

@interface RestHandler : NSObject

@property (weak, nonatomic) NSString* endPoint;
+ (RestHandler *)sharedInstance;
- (PMKPromise *) fetch:(NSString *) endpoint withId:(NSString *) id;
- (PMKPromise *) fetchAll:(NSString *) endpoint;
- (PMKPromise *) create:(NSString *) endpoint withData:(NSDictionary *) data;
- (PMKPromise *) delete:(NSString *) endpoint withId:(NSString *) id;
- (PMKPromise *)uploadImage:(NSString *)endpoint withImage:(UIImage *)image;
@end
