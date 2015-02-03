//
//  ViewController.swift
//  Beacon Smasher
//
//  Created by steven elliott on 2015-01-31.
//  Copyright (c) 2015 Steven Peter Elliott. All rights reserved.
//

import UIKit
import CoreLocation
import CoreBluetooth


class ViewController: UIViewController, CLLocationManagerDelegate, CBCentralManagerDelegate {

    let locationManager = CLLocationManager()
    let region = CLBeaconRegion(proximityUUID: NSUUID(UUIDString: "f7826da6-4fa2-4e98-8024-bc5b71e0893e"), identifier: "Kontakt.io")
    let hackedRegion = CLBeaconRegion(proximityUUID: NSUUID(UUIDString: "f7826da6-4fa2-4e98-8024-bc5b71e0893e"), identifier: <#String!#>)
    
    var centralManager:CBCentralManager!
    var blueToothReady = false
    
    let colors = [
        62288: UIColor(red: 84/255, green: 77/255, blue: 160/255, alpha: 1),
        36039: UIColor(red: 142/255, green: 212/255, blue: 220/255, alpha: 1),
        1810: UIColor(red: 162/255, green: 213/255, blue: 181/255, alpha: 1)
    ]

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        locationManager.delegate = self;
        if (CLLocationManager.authorizationStatus() != CLAuthorizationStatus.AuthorizedWhenInUse) {
            locationManager.requestWhenInUseAuthorization()
        }
        locationManager.startRangingBeaconsInRegion(region)
        
        //startUpCentralManager()

    }
    
    func startUpCentralManager() {
        println("Initializing central manager")
        centralManager = CBCentralManager(delegate: self, queue: nil)
    }
    
    func discoverDevices() {
        println("discovering devices")
        centralManager.scanForPeripheralsWithServices(nil, options: nil)
    }
    
    func centralManager(central: CBCentralManager!, didDiscoverPeripheral peripheral: CBPeripheral!, advertisementData: [NSObject : AnyObject]!, RSSI: NSNumber!) {
        println("Discovered \(peripheral.name)")
        if let manufacturerData: AnyObject = advertisementData["kCBAdvDataServiceData"]{
            var data: AnyObject? = advertisementData["CBAdvertisementDataManufacturerDataKey"]
            parseAdvertisementData(manufacturerData as NSDictionary)
        }else{
            println("Shit, not a beacon")
        }
        
    }
    

    func centralManagerDidUpdateState(central: CBCentralManager!) {
        println("checking state")
        switch (central.state) {
        case .PoweredOff:
            println("CoreBluetooth BLE hardware is powered off")
            
        case .PoweredOn:
            println("CoreBluetooth BLE hardware is powered on and ready")
            blueToothReady = true;
            
        case .Resetting:
            println("CoreBluetooth BLE hardware is resetting")
            
        case .Unauthorized:
            println("CoreBluetooth BLE state is unauthorized")
            
        case .Unknown:
            println("CoreBluetooth BLE state is unknown");
            
        case .Unsupported:
            println("CoreBluetooth BLE hardware is unsupported on this platform");
            
        }
        if blueToothReady {
            discoverDevices()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func locationManager(manager: CLLocationManager!, didRangeBeacons beacons: [AnyObject]!, inRegion region: CLBeaconRegion!) {
        let knownBeacons = beacons.filter{ $0.proximity != CLProximity.Unknown }
        if (knownBeacons.count > 0) {
            let closestBeacon = knownBeacons[0] as CLBeacon
            self.view.backgroundColor = self.colors[closestBeacon.minor.integerValue]
        }
    }
    
    @IBOutlet weak var beaconsFoundText: UILabel!
    
    func parseAdvertisementData(advertisementData: AnyObject) -> NSData? {
        if ([advertisementData.count] != 25) {
            return nil
        }
    
        var companyIdentifier:UInt16 = 0
        var major: UInt16 = 0
        var minor: UInt16 = 0
        var measuredPower:UInt8 = 0
        var dataType: UInt8 = 0
        var dataLength: UInt8 = 0
        var uuidBytes = [Character](count: 17, repeatedValue: "0")
        var companyIDRange: NSRange = NSMakeRange(0,2);
        
//    [data getBytes:&companyIdentifier range:companyIDRange];
//    if (companyIdentifier != 0x4C) {
//    return nil;
//    }
//    NSRange dataTypeRange = NSMakeRange(2,1);
//    [data getBytes:&dataType range:dataTypeRange];
//    if (dataType != 0x02) {
//    return nil;
//    }
//    NSRange dataLengthRange = NSMakeRange(3,1);
//    [data getBytes:&dataLength range:dataLengthRange];
//    if (dataLength != 0x15) {
//    return nil;
//    }
//    NSRange uuidRange = NSMakeRange(4, 16);
//    NSRange majorRange = NSMakeRange(20, 2);
//    NSRange minorRange = NSMakeRange(22, 2);
//    NSRange powerRange = NSMakeRange(24, 1);
//    [data getBytes:&uuidBytes range:uuidRange];
//    NSUUID *proximityUUID = [[NSUUID alloc] initWithUUIDBytes:(const unsigned char*)&uuidBytes];
//    [data getBytes:&major range:majorRange];
//    major = (major >> 8) | (major << 8);
//    [data getBytes:&minor range:minorRange];
//    minor = (minor >> 8) | (minor << 8);
//    [data getBytes:&measuredPower range:powerRange];
//    HGBeacon *beaconAdvertisementData = [[HGBeacon alloc] initWithProximityUUID:proximityUUID
//    major:[NSNumber numberWithUnsignedInteger:major]
//    minor:[NSNumber numberWithUnsignedInteger:minor]
//    measuredPower:[NSNumber numberWithShort:measuredPower]];
        return nil
    }
    
    

}

