//
//  ViewController.swift
//  Beacon Smasher
//
//  Created by steven elliott on 2015-01-31.
//  Copyright (c) 2015 Steven Peter Elliott. All rights reserved.
//

import UIKit
import CoreLocation

class ViewController: UIViewController, CLLocationManagerDelegate {
    let locationManager = CLLocationManager()
    let region = CLBeaconRegion(proximityUUID: NSUUID(UUIDString: "f7826da6-4fa2-4e98-8024-bc5b71e0893e"), identifier: "Kontakt.io")
    let colors = [
        62288: UIColor(red: 84/255, green: 77/255, blue: 160/255, alpha: 1),
        36039: UIColor(red: 142/255, green: 212/255, blue: 220/255, alpha: 1),
        1810: UIColor(red: 162/255, green: 213/255, blue: 181/255, alpha: 1)
    ]

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        //start scanning right away
        locationManager.delegate = self;
        if (CLLocationManager.authorizationStatus() != CLAuthorizationStatus.AuthorizedWhenInUse) {
            locationManager.requestWhenInUseAuthorization()
        }
        locationManager.startRangingBeaconsInRegion(region)
        
        
        
    }
    
    @IBOutlet weak var beaconsFoundText: UILabel!
    
    func locationManager(manager: CLLocationManager!, didRangeBeacons beacons: [AnyObject]!, inRegion region: CLBeaconRegion!) {
        let knownBeacons = beacons.filter{ $0.proximity != CLProximity.Unknown }
        if (knownBeacons.count > 0) {
            let closestBeacon = knownBeacons[0] as CLBeacon
            self.view.backgroundColor = self.colors[closestBeacon.minor.integerValue]
            beaconsFoundText.text = closestBeacon.description + " " + closestBeacon.proximityUUID.description + " " + closestBeacon.major.description + " " + closestBeacon.minor.description + " " + closestBeacon.proximity.hashValue.description
            
            
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

