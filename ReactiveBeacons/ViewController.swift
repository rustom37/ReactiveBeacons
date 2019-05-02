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

class ViewController: UIViewController, CLLocationManagerDelegate {
    
    let locationManager = CLLocationManager()
    var beaconsArray : [CLBeacon] = []
    
    var disposable: Disposable?

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
//        requestAuthorization()
        
        let observer = Signal<[CLBeacon], NoError>.Observer( value: { value in
            var beaconUUIDs = [UUID]()
            for beacon in value {
                beaconUUIDs.append(beacon.proximityUUID)
            }

            print("UUID: \(beaconUUIDs)")
        })

        let sp = SignalProducer<[CLBeacon], NoError> { observer, lifetime in
            
//            self.requestAuthorization()

//            self.startMonitoring()
            DispatchQueue.main.async(execute: {
                self.requestAuthorization()
                self.startMonitoring()
//                observer.send(value: self.beaconsArray)
//                observer.sendCompleted()
            })
            observer.send(value: self.beaconsArray)
            observer.sendCompleted()
        }

        disposable = sp.start(observer)
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
        let region = CLBeaconRegion(proximityUUID: UUID(uuidString: "B9407F30-F5F8-466E-AFF9-25556B57FE6D")!, major: 50075, minor: 56949, identifier: "Estimote.")
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
    
//    func locationManager(_ manager: CLLocationManager, didEnterRegion region: CLRegion) {
//        print("Did enter.")
//        UserDefaults.standard.set("0", forKey: "steve")
//        var steve = 0
//        Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { (timer) in
//            steve += 1
//            UserDefaults.standard.set(String(steve), forKey: "steve")
//            UserDefaults.standard.synchronize()
//            print(steve)
//        }
//        
//    }
//    
//    func locationManager(_ manager: CLLocationManager, didExitRegion region: CLRegion) {
//        print("Did exit.")
//    }
    
    func locationManager(_ manager: CLLocationManager, didRangeBeacons beacons: [CLBeacon], in region: CLBeaconRegion) {
        if beacons.count > 0 {
            updateDistance(beacons[0].proximity)
            
            for beacon in beacons {
                beaconsArray.append(beacon)
            }
        } else {
            updateDistance(.unknown)
        }
    }
    
    private func updateDistance(_ distance: CLProximity) {
        UIView.animate(withDuration: 0.8) {
            switch distance {
            case .unknown:
                self.view.backgroundColor = UIColor.gray
                
            case .far:
                self.view.backgroundColor = UIColor.red
                
            case .near:
                self.view.backgroundColor = UIColor.orange
                
            case .immediate:
                self.view.backgroundColor = UIColor.green

            @unknown default:
                fatalError()
            }
        }
    }
}

