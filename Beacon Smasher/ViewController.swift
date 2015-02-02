//
//  ViewController.swift
//  Beacon Smasher
//
//  Created by steven elliott on 2015-01-31.
//  Copyright (c) 2015 Steven Peter Elliott. All rights reserved.
//

import UIKit


class ViewController: UIViewController {

    let colors = [
        62288: UIColor(red: 84/255, green: 77/255, blue: 160/255, alpha: 1),
        36039: UIColor(red: 142/255, green: 212/255, blue: 220/255, alpha: 1),
        1810: UIColor(red: 162/255, green: 213/255, blue: 181/255, alpha: 1)
    ]

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        var beaconController = BeaconController()
        
        

    }
    
    @IBOutlet weak var beaconsFoundText: UILabel!
    

}

