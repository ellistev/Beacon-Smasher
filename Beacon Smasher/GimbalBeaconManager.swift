//
//  GimbalBeaconManager.swift
//  Beacon Smasher
//
//  Created by steven elliott on 2015-02-17.
//  Copyright (c) 2015 Steven Peter Elliott. All rights reserved.
//

import Foundation


protocol BeaconManagerDelegate {
    func didReceiveSighting(transmitter: FYXTransmitter, strength: NSNumber)
    func didDepartFrom(transmitter: FYXTransmitter)
    func discoveredNewBeacon(transmitter: CHABeacon)
}

class CHABeacon: NSObject {
    var identifier: NSString
    var rssiStrength: NSNumber
    
    init(identifier: NSString, rssiStrength strength: NSNumber) {
        self.identifier = identifier
        self.rssiStrength = strength
        
        super.init()
    }
}

class GimbalBeaconManager: NSObject, FYXVisitDelegate, FYXSessionDelegate, FYXBluetoothStateUpdateDelegate {
    
    var sightingManager: FYXSightingManager?
    var visitManager: FYXVisitManager?
    var delegate: BeaconManagerDelegate?
    var sightedBeacons: [CHABeacon] = [CHABeacon]()
    
    weak var currentViewController: UIViewController?
    
    
    init(sightingManager: FYXSightingManager, currentViewController: UIViewController, delegate: BeaconManagerDelegate) {
        super.init()
        self.currentViewController = currentViewController
        
        self.sightingManager = sightingManager
        
        // make sure to get arrivals and departures
        self.visitManager = FYXVisitManager()
        self.visitManager!.delegate = self
        self.delegate = delegate
    }
    

    func didArrive(visit: FYXVisit!) {
        NSLog("arrived at beacon \(visit.transmitter.identifier)")
        var arrivalBeacon: CHABeacon? = CHABeacon(identifier: visit.transmitter.identifier, rssiStrength: 0)
        if !containsBeacon(beaconCollection: sightedBeacons, identifier: arrivalBeacon!.identifier) {
            sightedBeacons.append(arrivalBeacon!)
            delegate?.discoveredNewBeacon(arrivalBeacon!)
        }
    }
    
    func receivedSighting(visit: FYXVisit!, updateTime: NSDate!, RSSI: NSNumber!) {
        if !containsBeacon(beaconCollection: sightedBeacons, identifier: visit.transmitter.identifier) {
            var sightedBeacon: CHABeacon = CHABeacon(identifier: visit.transmitter.identifier, rssiStrength: RSSI)
            sightedBeacons.append(sightedBeacon)
            delegate?.discoveredNewBeacon(sightedBeacon)
        }
        delegate?.didReceiveSighting(visit.transmitter,strength:RSSI)
    }
    
    func didDepart(visit: FYXVisit!) {
        sightedBeacons = removeBeacon(beaconCollection: sightedBeacons, identifier: visit.transmitter.identifier)
        delegate?.didDepartFrom(visit.transmitter)
    }
    
    
    func sessionStarted() {
        self.sightingManager!.scanWithOptions([FYXSightingOptionSignalStrengthWindowKey:NSNumber(int: FYXSightingOptionSignalStrengthWindowLarge)])
        self.visitManager!.start()
    }
    
    func sessionCreateFailed(error: NSError!) {
        NSLog("\nError creating beacon session: \(error)\n\(error.userInfo)")
    }
    
    
    func bluetoothBecameAvailable() {
        FYX.enableLocationUpdates()
        NSLog("\nBluetooth has become available: started location updates")
        self.startBeaconService()
    }
    
    func bluetoothBecameUnavailable() {
        FYX.disableLocationUpdates()
        NSLog("\nBluetooth has been disabled: ended location updates")
    }
    
   
    func startBeaconService() {
        // retrieve our application info from the plist to authorize with Gimbal Servers
        var applicationInfo = loadPlist("GimbalManagerApplicationInfo")
        
        FYX.setAppId(applicationInfo["GimbalApplicationID"]!.string,
            appSecret:applicationInfo["GimbalSecret"] as String,
            callbackUrl:applicationInfo["CallbackURL"] as String)
        FYX.startServiceAndAuthorizeWithViewController(currentViewController, delegate: self)
    }
    
    func loadPlist(plistName: String) -> NSDictionary {
        var anError: NSError? = nil
        var propertyListFilePath = NSBundle.mainBundle().pathForResource(plistName, ofType: "plist")?
        var propertyListData: NSData? = NSData(contentsOfFile:propertyListFilePath!, options: NSDataReadingOptions.DataReadingMappedIfSafe, error: &anError)
        var listFormat = NSPropertyListFormat.XMLFormat_v1_0
        return NSPropertyListSerialization.propertyListWithData(propertyListData!, options:0, format: &listFormat, error:&anError) as NSDictionary
    }
    
    func containsBeacon(beaconCollection beacons: [CHABeacon], identifier: NSString) -> Bool {
        for beacon: CHABeacon in beacons {
            if beacon.identifier == identifier {
                return true
            }
        }
        return false
    }
    
    func removeBeacon(beaconCollection beacons: [CHABeacon], identifier: NSString) -> [CHABeacon] {
        return beacons.filter {
            var beacon: CHABeacon = $0
            var matchesIdentifiers = beacon.identifier != identifier
            return matchesIdentifiers
        }
    }
    
    func retrieveLocalBeacon(identifier: NSString) -> CHABeacon? {
        var matchingBeacon: CHABeacon
        for beacon in sightedBeacons {
            if beacon.identifier == identifier {
                return beacon
            }
        }
        return nil
    }
}