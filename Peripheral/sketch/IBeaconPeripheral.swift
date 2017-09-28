//
//  EchoServer.swift
//  sketch
//
//  Created by Adonis Gaitatzis on 1/9/17.
//  Copyright © 2017 Adonis Gaitatzis. All rights reserved.
//

import UIKit
import CoreBluetooth
import CoreLocation


class IBeaconPeripheral: NSObject, CBPeripheralManagerDelegate {
    
    
    // MARK: BEacon properties
    
    // Advertized name
    let advertisingName = "LedRemote"
    
    // Device identifier
    let beaconIdentifier = "com.example.ibeacon"
    
    // UUID
    let beaconUuid = UUID(uuidString: "e20a39f4-73f5-4bc4-a12f-17d1ad07a961")
    
    // Major Number
    let majorNumber:CLBeaconMajorValue = UInt16(1122)
    
    // Minor Number
    let minorNumber:CLBeaconMinorValue = UInt16(3344)
    
    // Transmission power
    let transmissionPower_db:NSNumber? = -56
    
    
    // MARK: Peripheral State
    
    // Beacon Region
    var beaconRegion: CLBeaconRegion!

    // Peripheral Manager
    var peripheralManager:CBPeripheralManager!
    
    // Connected Central
    var central:CBCentral!
    
    // delegate
    var delegate:IBeaconPeripheralDelegate!
    
    
    
    
    /**
     Initialize BlePeripheral with a corresponding Peripheral
     
     - Parameters:
     - delegate: The BlePeripheralDelegate
     - peripheral: The discovered Peripheral
     */
    init(delegate: IBeaconPeripheralDelegate?) {
        super.init()
        
        self.delegate = delegate
        
        print("initializing beacon region")
        
        if let beaconUuid = beaconUuid {
            beaconRegion = CLBeaconRegion(proximityUUID: beaconUuid, major: majorNumber, minor: minorNumber, identifier: beaconIdentifier)
            
            print("initializing peripheral manager")
            peripheralManager = CBPeripheralManager(delegate: self, queue: nil, options: nil)
        } else {
            print("invalid UUID")
        }
        
        
    }

    /**
     Stop advertising, shut down the Peripheral
     */
    func stopAdvertising() {
        peripheralManager.stopAdvertising()
        delegate?.iBeaconPeripheralStoppedAdvertising?()
        
    }
    
    /**
     Start Bluetooth Advertising.  This must be after building the GATT profile
     */
    func startAdvertising() {
        print("loading peripheral data")
        let advertisementDictionary = beaconRegion.peripheralData(withMeasuredPower: transmissionPower_db)
        
        print("building advertisement data")
        var advertisementData = [String: Any]()
        for (key, value) in advertisementDictionary {
            advertisementData[key as! String] = value
        }
        
        print("begininng advertising")
        peripheralManager.startAdvertising(advertisementData as [String:Any])
    }
    

    // MARK: CBPeripheralManagerDelegate
    
    /**
     Peripheral will become active
     */
    func peripheralManager(_ peripheral: CBPeripheralManager, willRestoreState dict: [String : Any]) {
        print("restoring peripheral state")
    }
    
    /**
     Peripheral started advertising
     */
    func peripheralManagerDidStartAdvertising(_ peripheral: CBPeripheralManager, error: Error?) {
        if error != nil {
            print ("Error advertising peripheral")
            print(error.debugDescription)
        }
        self.peripheralManager = peripheral
        
        delegate?.iBeaconPeripheral?(startedAdvertising: error)
    }
    
    /**
     Bluetooth Radio state changed
     */
    func peripheralManagerDidUpdateState(_ peripheral: CBPeripheralManager) {
        peripheralManager = peripheral
        switch peripheral.state {
        case CBManagerState.poweredOn:
            startAdvertising()
        case CBManagerState.poweredOff:
            stopAdvertising()
        default: break
        }
        delegate?.iBeaconPeripheral?(stateChanged: peripheral.state)
        
    }
    
    
    
    
}
