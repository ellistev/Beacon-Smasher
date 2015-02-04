/**
 * Copyright (C) 2014 Gimbal, Inc. All rights reserved.
 *
 * This software is the confidential and proprietary information of Gimbal, Inc.
 *
 * The following sample code illustrates various aspects of the Gimbal SDK.
 *
 * The sample code herein is provided for your convenience, and has not been
 * tested or designed to work on any particular system configuration. It is
 * provided AS IS and your use of this sample code, whether as provided or with
 * any modification, is at your own risk. Neither Gimbal, Inc. nor any
 * affiliate takes any liability nor responsibility with respect to the sample
 * code, and disclaims all warranties, express and implied, including without
 * limitation warranties on merchantability, fitness for a specified purpose,
 * and against infringement.
 */

#import <Foundation/Foundation.h>

@class GMBLAttributes;

/*!
 The GMBLCommunication class defines a communication that was defined on the Gimbal Manager Portal
 */
@interface GMBLCommunication : NSObject

/// The identifier for the GMBLCommnication
@property (nonatomic, readonly) NSString *identifier;

/// The title for the GMBLCommunication
@property (nonatomic, readonly) NSString *title;

/// The description for the GMBLCommunication
@property (nonatomic, readonly) NSString *description;

/// The URL for the GMBLCommunication
@property (nonatomic, readonly) NSString *URL;

/// The expiry date for the GMBLCommunication
@property (nonatomic, readonly) NSDate *expiryDate;

/// The attributes for the GMBLCommunication
@property (nonatomic, readonly) GMBLAttributes *attributes;

@end
