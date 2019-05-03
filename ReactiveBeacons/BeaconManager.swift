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
    private var beaconArray = [Beacon]()
    let locationManager = CLLocationManager()
    var property = MutableProperty(Set<Beacon>())
    var numberOfBeacons : MutableProperty<Int> = MutableProperty(0)
    var isAuthorized : MutableProperty<Bool> = MutableProperty(false)
    
    //MARK: - BeaconManager Method
    func addBeacon(beacon: Beacon) {
        beaconArray.append(beacon)
    }
    
    //MARK: - CoreLocation
    func requestAuthorization() {
        locationManager.delegate = self
        if CLLocationManager.authorizationStatus() != .authorizedAlways {
            locationManager.requestAlwaysAuthorization()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .authorizedAlways:
            isAuthorized.value = true
        case .authorizedWhenInUse:
            isAuthorized.value = true
        default:
            isAuthorized.value = false
        }
    }
    
    func startMonitoring() {
        beaconArray.forEach { beacon in
            let beaconRegion = beacon.asBeaconRegion()
            beaconRegion.notifyEntryStateOnDisplay = true
            locationManager.startMonitoring(for: beaconRegion)
            locationManager.startUpdatingLocation()
            locationManager.startRangingBeacons(in: beaconRegion)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didRangeBeacons beacons: [CLBeacon], in region: CLBeaconRegion) {
        self.property.value.removeAll()
        beacons.forEach { beacon in
            property.value.insert(Beacon(name: "", uuid: beacon.proximityUUID, majorValue: beacon.major.intValue, minorValue: beacon.minor.intValue))
        }
        numberOfBeacons.value = property.value.count
    }
    
    func locationManager(_ manager: CLLocationManager, didEnterRegion region: CLRegion) {
        print("Did enter.")
    }
    
    func locationManager(_ manager: CLLocationManager, didExitRegion region: CLRegion) {
        print("Did exit.")
    }
}
