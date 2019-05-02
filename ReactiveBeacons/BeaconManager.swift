//
//  BeaconManager.swift
//  ReactiveBeacons
//
//  Created by Steve Rustom on 4/25/19.
//  Copyright © 2019 Steve Rustom. All rights reserved.
//

//import Foundation
//import CoreLocation
//import ReactiveCocoa
//import ReactiveSwift
//import Result
//
//class BeaconManager: NSObject, CLLocationManagerDelegate {
//   
//    var disposable: Disposable?
//    let locationManager : CLLocationManager? = nil
//    
////    init(locationManager: CLLocationManager) {
////        self.locationManager = locationManager
////        requestAuthorization()
////    }
////    
////    func requestAuthorization() {
////        locationManager!.delegate = self
////        locationManager!.allowsBackgroundLocationUpdates = true
////        if CLLocationManager.authorizationStatus() != .authorizedAlways {
////            locationManager!.requestAlwaysAuthorization()
////        }
////    }
////    
////    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
////        switch status {
////        case .authorizedAlways:
////            print("Authorization always granted.")
////        case .authorizedWhenInUse:
////            print("Authorization granted when in use.")
////        default:
////            print("Authorization not granted.")
////        }
////    }
//    
//    let sp = SignalProducer<[CLBeacon], NoError> { observer, lifetime in
//        let beaconsArray : [CLBeacon] = []
//        
//        print("Start Monitoring")
//        let region = CLBeaconRegion(proximityUUID: UUID(uuidString: "B9407F30-F5F8-466E-AFF9-25556B57FE6D")!, major: 50075, minor: 56949, identifier: "Estimote.")
//        region.notifyOnEntry = true
//        region.notifyOnExit = true
//        region.notifyEntryStateOnDisplay = true
////        locationManager.startRangingBeaconsInRegion(region)
////        locationManager.startMonitoring(for: region)
////        locationManager.startUpdatingLocation()
////        locationManager.startRangingBeacons(in: region)
//    }
//    
//}
