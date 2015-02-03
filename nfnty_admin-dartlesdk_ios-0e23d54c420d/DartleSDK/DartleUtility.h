//
//  DartleUtility.h
//  DartleSDK
//
//  Created by Gert-Jan Vercauteren on 26/01/15.
//  Copyright (c) 2015 Dartle B.V. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DartleUtility : NSObject
+ (NSDictionary *) OAuthCredentialsFromQR:(NSString *)qrcode;
@end
