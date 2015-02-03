//
//  BeaconController.swift
//  Beacon Smasher
//
//  Created by steven elliott on 2015-02-01.
//  Copyright (c) 2015 Steven Peter Elliott. All rights reserved.
//

import Foundation
import CoreLocation

class BeaconController: NSObject, CLLocationManagerDelegate{
    
    let locationManager = CLLocationManager()
    let region = CLBeaconRegion(proximityUUID: NSUUID(UUIDString: "f7826da6-4fa2-4e98-8024-bc5b71e0893e"), identifier: "Kontakt.io")


    
    override init(){
        super.init()
        //start scanning right away
        locationManager.delegate = self;
    }
    
    func startRanging(){
        if (CLLocationManager.authorizationStatus() != CLAuthorizationStatus.AuthorizedWhenInUse) {
            locationManager.requestWhenInUseAuthorization()
        }
        locationManager.startRangingBeaconsInRegion(region)
    }
    
    func locationManager(manager: CLLocationManager!, didRangeBeacons beacons: [AnyObject]!, inRegion region: CLBeaconRegion!) {
        let knownBeacons = beacons.filter{ $0.proximity != CLProximity.Unknown }
        if (knownBeacons.count > 0) {
            let closestBeacon = knownBeacons[0] as CLBeacon
            //self.view.backgroundColor = self.colors[closestBeacon.minor.integerValue]
            //beaconsFoundText.text = closestBeacon.description + " " + closestBeacon.proximityUUID.description + " " + closestBeacon.major.description + " " + closestBeacon.minor.description + " " + closestBeacon.proximity.hashValue.description
            
            
        }
    }
        

}