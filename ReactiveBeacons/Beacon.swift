//
//  Beacon.swift
//  ReactiveBeacons
//
//  Created by Steve Rustom on 5/2/19.
//  Copyright © 2019 Steve Rustom. All rights reserved.
//

import Foundation
import CoreLocation

class Beacon: CLBeacon {
    
    var majorValue : CLBeaconMajorValue
    var minorValue : CLBeaconMinorValue
    var uuid : UUID
    var name : String
    
    init(name: String, uuid: UUID, majorValue: Int, minorValue: Int) {
        self.majorValue = CLBeaconMajorValue(majorValue)
        self.minorValue = CLBeaconMinorValue(minorValue)
        self.uuid = uuid
        self.name = name
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func asBeaconRegion() -> CLBeaconRegion {
        let region = CLBeaconRegion(proximityUUID: uuid, major: majorValue, minor: minorValue, identifier: name)
        region.notifyOnEntry = true
        region.notifyOnExit = true
        return region
    }
}
