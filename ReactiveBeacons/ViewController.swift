//
//  ViewController.swift
//  ReactiveBeacons
//
//  Created by Steve Rustom on 4/25/19.
//  Copyright © 2019 Steve Rustom. All rights reserved.
//

import UIKit
import CoreLocation
import ReactiveCocoa
import ReactiveSwift
import Result

class ViewController: UIViewController {
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var beaconsInRange: UILabel!
    var beaconManager = BeaconManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        beaconManager.addBeacon(beacon: Beacon(name: "Green Estimote", uuid: UUID(uuidString: "B9407F30-F5F8-466E-AFF9-25556B57FE6D")! ,majorValue: 50075, minorValue: 56949))
        beaconManager.addBeacon(beacon: Beacon(name: "Blue Estimote", uuid: UUID(uuidString: "B9407F30-F5F8-466E-AFF9-25556B57FE6D")!, majorValue: 20901, minorValue: 26006))
        beaconManager.requestAuthorization()
        
        self.label.reactive.text <~ beaconManager.isAuthorized.producer.map { value in return value ? "Authorized" : "Not Authorized" }
        self.beaconsInRange.reactive.text <~ beaconManager.numberOfBeacons.producer.map { value in return "The number of beacons in range is: \(self.beaconManager.numberOfBeacons.value)"}
        
        beaconManager.property.producer.startWithValues { value in
            value.forEach({ beacon in
                print("UUID: \(beacon.uuid), major value: \(beacon.majorValue)")
            })
        }
        
        beaconManager.startMonitoring()
    }
}
