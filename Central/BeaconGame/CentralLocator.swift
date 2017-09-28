//
//  BeaconLocator.swift
//  BeaconLocator
//
//  Created by Adonis Gaitatzis on 11/28/16.
//  Copyright © 2016 Adonis Gaitatzis. All rights reserved.
//

import UIKit

/**
 Trilaterates a Central position from three known Beacon positions
 */
class CentralLocator: NSObject {
    
    /**
     Trilaterates a Central position from three known Beacon positions
     */
    static func trilaterate(_ iBeacons: [IBeacon]) -> CGPoint? {
        if iBeacons.count < 3 {
            return nil
        }
        
        // establish known values
        let p1 = iBeacons[0]
        let p2 = iBeacons[1]
        let p3 = iBeacons[2]
        let r1 = p1.getDistance()
        let r2 = p2.getDistance()
        let r3 = p3.getDistance()
        
        
        //unit vector in a direction from point1 to point 2
        let p1p2Distance = sqrt(
            pow(p2.xPosition_m - p1.xPosition_m, 2) +
                pow(p2.yPosition_m - p1.yPosition_m, 2)
        )
        
        let exx = (p2.xPosition_m - p1.xPosition_m) / p1p2Distance
        let exy = (p2.yPosition_m - p1.yPosition_m) / p1p2Distance
        
        //signed magnitude of the x component
        let i = exx * (p3.xPosition_m - p1.xPosition_m) + exy * (p3.yPosition_m - p1.yPosition_m)
        
        //the unit vector in the y direction.
        let eyx = (p3.xPosition_m - p1.xPosition_m - i * exx) / sqrt(
            pow(p3.xPosition_m - p1.xPosition_m - i * exx, 2) +
                pow(p3.yPosition_m - p1.yPosition_m - i * exy, 2)
        )
        
        let eyy_denominator = sqrt(
            pow(p3.xPosition_m - p1.xPosition_m - i * exx, 2) +
                pow(p3.yPosition_m - p1.yPosition_m - i * exy, 2)
        )
        
        let eyy = (p3.yPosition_m - p1.yPosition_m - i * exy) / eyy_denominator
        
        //the signed magnitude of the y component
        let j = exy * (p2.xPosition_m - p3.yPosition_m) + eyy * (p3.yPosition_m - p1.yPosition_m)
        
        // coordinates
        let x = (pow(Double(r1), 2) - pow(Double(r2), 2) + pow(p1p2Distance, 2) ) / (2 * p1p2Distance)
        let y = (pow(Double(r1), 2) - pow(Double(r3), 2) + pow(i, 2) + pow(j, 2)) / (2 * j) - i * x / j
        
        // result coordinates
        let finalX = p1.xPosition_m + x * exx + y * eyx
        let finalY = p1.yPosition_m + x * exy + y * eyy
        
        return CGPoint(x: finalX, y: finalY)
    }
    
}


