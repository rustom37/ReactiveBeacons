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
    
     let beaconManager = BeaconManager(name: "Estimote", uuid: UUID(uuidString: "B9407F30-F5F8-466E-AFF9-25556B57FE6D")! ,majorValue: 50075, minorValue: 56949)

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    
        self.beaconManager.requestAuthorization()
        self.beaconManager.startMonitoring()

        let sp = SignalProducer<[CLBeacon], NoError> { observer, lifetime in
            
            guard !lifetime.hasEnded else {
                observer.sendInterrupted()
                return
            }
            
            observer.send(value: self.beaconManager.property.value)
            observer.sendCompleted()
        }
        
        let property = beaconManager.property
        
        property.producer.startWithValues { (value) in
            for beacon in value {
                print("UUID: \(beacon.proximityUUID), RSSI: \(beacon.rssi)")
            }
        }

        property <~ sp
    }
}

