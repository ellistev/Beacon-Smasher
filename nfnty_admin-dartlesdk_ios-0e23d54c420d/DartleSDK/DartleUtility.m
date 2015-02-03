//
//  DartleUtility.m
//  DartleSDK
//
//  Created by Gert-Jan Vercauteren on 26/01/15.
//  Copyright (c) 2015 Dartle B.V. All rights reserved.
//

#import "DartleUtility.h"

@implementation DartleUtility

+ (NSDictionary *) OAuthCredentialsFromQR:(NSString *)qrcode {
	NSArray *splitted = [qrcode componentsSeparatedByString:@"|"];

	if([splitted count] == 2) {
		return @{@"consumerKey":[splitted objectAtIndex:0], @"consumerSecret":[splitted objectAtIndex:1]};
	} else {
		NSLog(@"This is not a valid QR");
		return nil;
	}
}
@end
