//
//  EchoServerDelegate.swift
//  sketch
//
//  Created by Adonis Gaitatzis on 1/9/17.
//  Copyright © 2017 Adonis Gaitatzis. All rights reserved.
//

import UIKit
import CoreBluetooth


/**
 Relays important status changes from iBeacon
 */
@objc protocol IBeaconPeripheralDelegate : class {
    
    /**
     iBeacon State Changed
     
     - Parameters:
     - rssi: the RSSI
     - blePeripheral: the BlePeripheral
     */
    @objc optional func iBeaconPeripheral(stateChanged state: CBManagerState)

    
    /**
     iBeacon statrted advertising
     
     - Parameters:
     - error: the error message, if any
     */
    @objc optional func iBeaconPeripheral(startedAdvertising error: Error?)

    
    /**
     iBeacon stopped advertising
     */
    @objc optional func iBeaconPeripheralStoppedAdvertising()
    
    
}
