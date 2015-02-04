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

@class GMBLPlace;
@protocol GMBLPlaceManagerDelegate;

/*!
 The GMBLPlaceManager defines the interface for delivering place entry and exits events to your Gimbal enabled
 application. You use an instance of this class to start or stop place monitoring. 
 
 In order to use the place manager, you must assign a class that conforms to the GMBLPlaceManagerDelegate to the 
 delegate property in order to receive place entry and exit events.
 */
@interface GMBLPlaceManager : NSObject

/// The delegate object to receive place events.
@property (weak, nonatomic) id<GMBLPlaceManagerDelegate> delegate;

/// Returns the monitoring state
+ (BOOL)isMonitoring;

/// Starts the generation of events based on the users location and proximity to geofences and beacons.
+ (void)startMonitoring;

/// Stops the generation of events.
+ (void)stopMonitoring;

@end

@class GMBLPlaceManager;

/*!
 The GMBLPlaceManagerDelegate protocol defines the methods used to receive events for the GMBLPlaceManager object.
 */
@protocol GMBLPlaceManagerDelegate <NSObject>

@optional

/*!
 Tells the delegate that the user entered the specified place
 @param manager The place manager object reporting the event
 @param place An object containing information about the place that was entered.
 @param date The date that the enter event occoured at
 */
- (void)placeManager:(GMBLPlaceManager *)manager didEnterPlace:(GMBLPlace *)place date:(NSDate *)date;

/*!
 Tells the delegate that the user exited the specified place
 @param manager The place manager object reporting the event
 @param place An object containing information about the place that was exited.
 @param entryDate The date that the entry event occoured at
 @param exitDate The date that the exit event occoured at
 */
- (void)placeManager:(GMBLPlaceManager *)manager
        didExitPlace:(GMBLPlace *)place
           entryDate:(NSDate *)entryDate
            exitDate:(NSDate *)exitDate;

@end