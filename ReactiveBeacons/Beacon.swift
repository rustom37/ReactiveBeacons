//
//  Beacon.swift
//  ReactiveBeacons
//
//  Created by Steve Rustom on 5/2/19.
//  Copyright © 2019 Steve Rustom. All rights reserved.
//

import Foundation
import CoreLocation

class Beacon: NSObject {
    
    var majorValue : CLBeaconMajorValue
    var minorValue : CLBeaconMinorValue
    var uuid : UUID
    var name : String
    
    init(name: String, uuid: UUID, majorValue: Int, minorValue: Int) {
        self.majorValue = CLBeaconMajorValue(majorValue)
        self.minorValue = CLBeaconMinorValue(minorValue)
        self.uuid = uuid
        self.name = name
    }
    
    func asBeaconRegion() -> CLBeaconRegion {
        let region = CLBeaconRegion(proximityUUID: uuid, identifier: name)
        region.notifyOnEntry = true
        region.notifyOnExit = true
        return region
    }
    
    override func isEqual(_ object: Any?) -> Bool {
        let beacon = object as? Beacon
        return majorValue == beacon?.majorValue && minorValue == beacon?.minorValue && uuid.uuidString == beacon?.uuid.uuidString
    }
    
    static func ==(lhs: Beacon, rhs: Beacon) -> Bool {
        return lhs.isEqual(rhs)
    }
    
    static func !=(lhs: Beacon, rhs: Beacon) -> Bool {
        return !lhs.isEqual(rhs)
    }
    
    override var hash: Int {
        return (uuid.uuidString + "" + String(majorValue) + "" + String(minorValue)).hash
    }
}
