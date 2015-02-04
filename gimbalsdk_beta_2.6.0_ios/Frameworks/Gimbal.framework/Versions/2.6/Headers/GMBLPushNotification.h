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

/**!
 The GMBLPushNotification class encapsulates Apple Push Notificaitons that
 originate from Gimbal.
 **/
// GMBLPushNotification
@interface GMBLPushNotification : NSObject

/// The message send with the Push Notification
@property (nonatomic, strong) NSString *message;

/// An Idenfitifer used to identify related content on the server
@property (nonatomic, strong) NSString *communicationIdentifier;

/// An Identifier defined in the Manager Web Portal for Instant Communications
@property (nonatomic, strong) NSString *preloadedMessageId;

@end
