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

@class GMBLPushNotification;

/*!
 The GMBLPushManager manages push notifications from the Apple Push Notification Service (APNs). To receive push notifications on a device you must send Gimbal a Device Token.
 */
@interface GMBLPushManager : NSObject

/*!
 Allows Gimbal to send push notifications through Apple's APN system to a specific device
 @param deviceToken The device token from the ApplicationDelegate callback application:didRegisterForRemoteNotificationsWithDeviceToken:
 */
+ (void)setPushDeviceToken:(NSData *)deviceToken;

/*!
 Generates a GMBLPushNotification
 @param userInfo dictionary parameter from application delegate application:didReceiveRemoteNotification:
 @return the userInfo dictionary parsed as a GMBLNotification or nil if push was not from Gimbal
 */
+ (GMBLPushNotification *)pushNotificationForRemoteNotification:(NSDictionary *)userInfo;

@end
