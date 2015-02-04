/**
 * Copyright (C) 2014 Gimbal, Inc. All rights reserved.
 *
 * This software is the confidential and proprietary information of Gimbal, Inc.
 *
 * The following sample code illustrates various aspects of the Gimbal iOS SDK.
 *
 * The sample code herein is provided for your convenience, and has not been
 * tested or designed to work on any particular system configuration. It is
 * provided pursuant to the License Agreement for Gimbal Software AS IS, and
 * your use of this sample code, whether as provided or with any modification,
 * is at your own risk. Neither Gimbal, Inc. nor any affiliate takes any
 * liability nor responsibility with respect to the sample code, and disclaims
 * all warranties, express and implied, including without limitation warranties
 *  on merchantability, fitness for a specified purpose, and against infringement.
 */
#import <Foundation/Foundation.h>

/*!
 Defines the battery level of a beacon.
 */
typedef NS_ENUM(NSInteger, GMBLBatteryLevel) {
    /// The battery level on the beacon is low and should be replaced soon.
    GMBLBatteryLevelLow = 0,
    /// The battery level on the beacon is good.
    GMBLBatteryLevelGood
};

@interface GMBLBeacon : NSObject

/// A unique string identifier (factory id) that represents the beacon
@property (nonatomic, readonly) NSString *identifier;

/// The name for the GMBLBeacon that can be assigned via the Gimbal Manager
@property (nonatomic, readonly) NSString *name;

/// The iconUrl for the GMBLBeacon
@property (nonatomic, readonly) NSString *iconURL;

/// The battery level for the GMBLBeacon
@property (nonatomic, readonly) GMBLBatteryLevel batteryLevel;

/// The ambient temperature surrounding the Beacon in Fahrenheit, the value is equal will be NSIntegerMax if no temperature reading is available for this beacon
@property (nonatomic, readonly) NSInteger temperature;

@end