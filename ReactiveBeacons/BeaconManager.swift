//
//  BeaconManager.swift
//  ReactiveBeacons
//
//  Created by Steve Rustom on 4/25/19.
//  Copyright © 2019 Steve Rustom. All rights reserved.
//

import Foundation
import CoreLocation
import ReactiveCocoa
import ReactiveSwift
import Result

class BeaconManager: NSObject, CLLocationManagerDelegate {
   
    var beaconArray = [Beacon]()
    let locationManager = CLLocationManager()
    var property: MutableProperty<[Beacon]> = MutableProperty([])
    
    init(beaconArray: [Beacon]) {
        self.beaconArray = beaconArray
    }

    //MARK: - CoreLocation
    
    func requestAuthorization() {
        locationManager.delegate = self
        locationManager.allowsBackgroundLocationUpdates = true
        if CLLocationManager.authorizationStatus() != .authorizedAlways {
            locationManager.requestAlwaysAuthorization()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .authorizedAlways:
            print("Authorization always granted.")
        case .authorizedWhenInUse:
            print("Authorization granted when in use.")
        default:
            print("Authorization not granted.")
        }
    }
    
    func startMonitoring() {
        print("Start Monitoring")
        for beacon in beaconArray {
            let beaconRegion = beacon.asBeaconRegion()
            beaconRegion.notifyEntryStateOnDisplay = true
            locationManager.startMonitoring(for: beaconRegion)
            locationManager.startUpdatingLocation()
            locationManager.startRangingBeacons(in: beaconRegion)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didRangeBeacons beacons: [CLBeacon], in region: CLBeaconRegion) {
        if beacons.count > 0 {
            for b in beaconArray {
                for beacon in beacons {
                    let newBeacon = Beacon(name: b.name, uuid: beacon.proximityUUID, majorValue: beacon.major as! Int, minorValue: beacon.minor as! Int)
                    if(!property.value.contains(newBeacon)) {
                        property.value.append(newBeacon)
                    }
                }
            }
            
        }
    }
}
