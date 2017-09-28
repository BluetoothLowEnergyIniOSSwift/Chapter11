//
//  ViewController.swift
//  sketch
//
//  Created by Adonis Gaitatzis on 1/9/17.
//  Copyright © 2017 Adonis Gaitatzis. All rights reserved.
//

import UIKit
import CoreBluetooth
import AVFoundation

/**
 This view displays the state of a BlePeripheral
 */
class ViewController: UIViewController, IBeaconPeripheralDelegate {
    
    // MARK: UI Elements
    @IBOutlet weak var advertisingSwitch: UISwitch!

    
    // MARK: BlePeripheral
    
    // BlePeripheral
    var iBeacon:IBeaconPeripheral!
    
    
    
    /**
     UIView loaded
     */
    override func viewDidLoad() {
        super.viewDidLoad()        
    }
    
    /**
     View appeared.  Start the Peripheral
     */
    override func viewDidAppear(_ animated: Bool) {
        iBeacon = IBeaconPeripheral(delegate: self)
    }
    
    /**
     View will appear.  Stop transmitting random data
     */
    override func viewWillDisappear(_ animated: Bool) {
        iBeacon.stopAdvertising()
    }
    
    /**
     View disappeared.  Stop advertising
     */
    override func viewDidDisappear(_ animated: Bool) {
        advertisingSwitch.setOn(false, animated: true)
    }
    

    // MARK: IBeaconPeripheralDelegate
    
    /**
     RemoteLed state changed
     
     - Parameters:
     - state: the CBManagerState representing the new state
     */
    func iBeaconPeripheral(stateChanged state: CBManagerState) {
        switch (state) {
        case CBManagerState.poweredOn:
            print("Bluetooth on")
        case CBManagerState.poweredOff:
            print("Bluetooth off")
        default:
            print("Bluetooth not ready yet...")
        }
    }
    
    
    /**
     RemoteLed statrted adertising
     
     - Parameters:
     - error: the error message, if any
     */
    func iBeaconPeripheral(startedAdvertising error: Error?) {
        if error != nil {
            print("Problem starting advertising: " + error.debugDescription)
        } else {
            print("adertising started")
            advertisingSwitch.setOn(true, animated: true)
        }
    }

    
    /**
     RemoteLed statrted adertising
     */
    func iBeaconPeripheralStoppedAdvertising() {
        print("adertising stopped")
    }

    
}

