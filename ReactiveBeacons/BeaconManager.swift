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
   
    let majorValue : CLBeaconMajorValue
    let minorValue : CLBeaconMinorValue
    let uuid : UUID
    let name : String
    let locationManager = CLLocationManager()
    
    var property: MutableProperty<[CLBeacon]> = MutableProperty([])
    
    init(name: String, uuid: UUID, majorValue: Int, minorValue: Int) {
        self.name = name
        self.uuid = uuid
        self.majorValue = CLBeaconMajorValue(majorValue)
        self.minorValue = CLBeaconMinorValue(minorValue)
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
    
    private func asBeaconRegion() -> CLBeaconRegion {
        let region = CLBeaconRegion(proximityUUID: uuid, major: majorValue, minor: minorValue, identifier: name)
        region.notifyOnEntry = true
        region.notifyOnExit = true
        return region
    }
    
    func startMonitoring() {
        print("Start Monitoring")
        let beaconRegion = self.asBeaconRegion()
        beaconRegion.notifyEntryStateOnDisplay = true
        locationManager.startMonitoring(for: beaconRegion)
        locationManager.startUpdatingLocation()
        locationManager.startRangingBeacons(in: beaconRegion)
    }
    
    func locationManager(_ manager: CLLocationManager, didRangeBeacons beacons: [CLBeacon], in region: CLBeaconRegion) {
        if beacons.count > 0 {
            for beacon in beacons {
                if(!property.value.contains(beacon)) {
                    property.value.append(beacon)
                }
            }
        }
    }
}
