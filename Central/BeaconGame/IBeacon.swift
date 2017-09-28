//
//  iBeacon.swift
//  BeaconLocator
//
//  Created by Adonis Gaitatzis on 12/13/16.
//  Copyright © 2016 Adonis Gaitatzis. All rights reserved.
//

import UIKit
import CoreLocation

class IBeacon: NSObject {
    
    static let uuid = UUID(uuidString: "e20a39f4-73f5-4bc4-a12f-17d1ad07a961")
    
    // Bluetooth transmit power programmed into the device in dB
    let referenceRssi = -57
    
    // Beacon Peripheral
    var beacon:CLBeacon!
    
    // Beacon's position in physical space
    var xPosition_m:Double = 0
    var yPosition_m:Double = 0
    
    
    /**
     Initialize the IBEacon
     */
    init(withBeacon beacon: CLBeacon) {
        self.beacon = beacon
    }
    
    /**
     Get Beacon distance from Central in meters
    */
    func getDistance() -> Int {
        return beacon.proximity.rawValue
    }
    
    /**
     Compare beacons
     
     - Parameters:
        - to: An IBeacon to compare
     
     - Returns: true if same beacon, false otherwise.
     */
    func isEqual(to: IBeacon) -> Bool {
        if let thisBeacon = beacon {
            if let thatBeacon = to.beacon {
                return thisBeacon.major == thatBeacon.major && thisBeacon.minor == thatBeacon.minor && thisBeacon.proximityUUID == thatBeacon.proximityUUID
            }
        }
        return false
    }
    
}
