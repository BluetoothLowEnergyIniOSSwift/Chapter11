//
//  PeripheralTableViewCell.swift
//  Services
//
//  Created by Adonis Gaitatzis on 11/21/16.
//  Copyright © 2016 Adonis Gaitatzis. All rights reserved.
//

import UIKit
import CoreLocation

/**
 Beacon TableView Cell
 */
class BeaconTableViewCell: UITableViewCell {
    
    // MARK: UI Elements
    @IBOutlet weak var rssiLabel: UILabel!
    @IBOutlet weak var xPositionLabel: UILabel!
    @IBOutlet weak var yPositionLabel: UILabel!
    @IBOutlet weak var majorNumberLabel: UILabel!
    @IBOutlet weak var minorNumberLabel: UILabel!
    @IBOutlet weak var proximityLabel: UILabel!
    @IBOutlet weak var accuracyLabel: UILabel!
    
    
    /**
     Render the cell with Beacon properties
     */
    func renderBeacon(_ iBeacon: IBeacon) {
        
        majorNumberLabel.text = "1122"
        minorNumberLabel.text = "3344"
        rssiLabel.text = "-37"
        proximityLabel.text = "3"
        accuracyLabel.text = "3"
        
        /*
        majorNumberLabel.text = iBeacon.beacon.major.stringValue
        minorNumberLabel.text = iBeacon.beacon.minor.stringValue
        rssiLabel.text = String(iBeacon.beacon.rssi)
        proximityLabel.text = String(iBeacon.beacon.proximity.rawValue)
        accuracyLabel.text = String(iBeacon.beacon.accuracy)
        */
        
        xPositionLabel.text = String(iBeacon.xPosition_m)
        yPositionLabel.text = String(iBeacon.yPosition_m)
    }

}
