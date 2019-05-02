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
    
    var isAuthorized : MutableProperty<Bool> = MutableProperty(false)
    
    
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
            isAuthorized.value = true

            print("Authorization always granted.")
        case .authorizedWhenInUse:
            print("Authorization granted when in use.")
        default:
            isAuthorized.value = false
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
    
    func locationManager(_ manager: CLLocationManager, didEnterRegion region: CLRegion) {
        print("Did enter.")
        UserDefaults.standard.set("0", forKey: "steve")
        var steve = 0
        Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { (timer) in
            steve += 1
            UserDefaults.standard.set(String(steve), forKey: "steve")
            UserDefaults.standard.synchronize()
            print(steve)
        }
        
    }
    
    func locationManager(_ manager: CLLocationManager, didExitRegion region: CLRegion) {
        print("Did exit.")
    }
}
