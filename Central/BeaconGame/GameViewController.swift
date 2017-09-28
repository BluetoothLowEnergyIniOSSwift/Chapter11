//
//  GameViewController.swift
//  BeaconGame
//
//  Created by Adonis Gaitatzis on 11/28/16.
//  Copyright © 2016 Adonis Gaitatzis. All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit
import CoreLocation

/**
 Main View - shows Beacon TableView and Beacon Map
 */
class GameViewController: UIViewController, UITableViewDataSource, CLLocationManagerDelegate {
    
    // MARK: UI Elements
    @IBOutlet weak var beaconTableView: UITableView!
    
    // Beacon Map Scene
    var scene:BleMapScene!
    
    // Beacon TableView Cell Reuse Identifier
    let beaconCellReuseIdentifier = "BeaconTableViewCell"
    
    
    // MARK: Beacons and Bluetooth
    
    // Location Manager includes Beacon functionality
    let locationManager = CLLocationManager()
    
    // discovered Beacons
    var foundBeacons = [IBeacon]()
    
    // Central's position
    var centralPosition:CGPoint!
    
    // number of beacons mapped
    var numBeaconsLoaded = 0

    // Beacon Region - the proximityUUID matches the identifier of the iBeacon
    let beaconRegion = CLBeaconRegion(proximityUUID: IBeacon.uuid!, identifier: "beaconRange")
    
    
    
    /**
     View Loaded
     */
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //let nib = UINib(nibName: "BeaconTableViewCell", bundle: nil)
        //beaconTableView.register(nib, forCellReuseIdentifier: beaconCellReuseIdentifier)
        
        
        // load the MapScene
        if let skView = view as! SKView? {
            skView.isMultipleTouchEnabled = true
            scene = BleMapScene(size: skView.bounds.size)
            scene.scaleMode = .aspectFill
            
            skView.presentScene(scene)
        }
        
        
        // set up Location Manager
        locationManager.delegate = self;
        
        // If location services are not enabled, request authorization
        if (CLLocationManager.authorizationStatus() != CLAuthorizationStatus.authorizedWhenInUse) {
            locationManager.requestWhenInUseAuthorization()
        } else {
            startScanning()
        }

    }
    
    
    /**
     Start scanning for Beacons
     */
    func startScanning() {
        print("starting scan")
        locationManager.startMonitoring(for: beaconRegion)
        locationManager.startRangingBeacons(in: beaconRegion)
        
        addFakeBeacons()
    }

    
    /**
     For testing the mapping engine: add fake beacons.  
     These will show up strange in the UITableView
     */
    func addFakeBeacons() {
        
        let beacon1 = IBeacon(withBeacon: CLBeacon())
        beacon1.xPosition_m = 10
        beacon1.yPosition_m = 10;
        let beacon1Position = CGPoint(x: beacon1.xPosition_m, y: beacon1.yPosition_m)
        let beacon1Distance = CGFloat(30) // 13.2
        
        let beacon2 = IBeacon(withBeacon: CLBeacon())
        beacon2.xPosition_m = 50
        beacon2.yPosition_m = 30;
        let beacon2Position = CGPoint(x: beacon2.xPosition_m, y: beacon2.yPosition_m)
        let beacon2Distance = CGFloat(24) // 7.7
        
        
        let beacon3 = IBeacon(withBeacon: CLBeacon())
        beacon3.xPosition_m = 35
        beacon3.yPosition_m = 50;
        let beacon3Position = CGPoint(x: beacon3.xPosition_m, y: beacon3.yPosition_m)
        let beacon3Distance = CGFloat(17) // 7.7
        
        foundBeacons += [beacon1, beacon2, beacon3]
        beaconTableView.reloadData()
        
        numBeaconsLoaded = 3
    
        if let scene = scene {
            print("printing beacons scene")
            scene.addBeacon(position: beacon1Position, radius: beacon1Distance)
            scene.addBeacon(position: beacon2Position, radius: beacon2Distance)
            scene.addBeacon(position: beacon3Position, radius: beacon3Distance)
        }

    }
    
    /**
     Map the Beacons and Central if possible. 
     */
    func mapBeacons() {
        for beacon in foundBeacons {
            mapBeacon(beacon)
        }
        
        if foundBeacons.count > 3 {
            // for this demo, we are done locating the Central
            locationManager.stopMonitoring(for: beaconRegion)
            locationManager.stopRangingBeacons(in: beaconRegion)
            
            mapCentralPosition()
        }
    }
    
    /**
     Put a Beacon on the map
     */
    func mapBeacon(_ iBeacon: IBeacon) {
        if scene != nil {
            let position = CGPoint(x: iBeacon.xPosition_m, y: iBeacon.yPosition_m)
            scene.addBeacon(position: position, radius: CGFloat(iBeacon.getDistance()))
        }
    }
    
    /**
     Put the Central on the map
     */
    func mapCentralPosition() {
        centralPosition = CentralLocator.trilaterate(foundBeacons)
        if let centralPosition = centralPosition {
            print("mapping location")
            if let scene = scene {
                scene.addCentral(position: centralPosition)
            }
        }
    }
    
    
    
    
    // MARK: CLLocationManagerDelegate callbacks
    
    /**
     Beacons discovered by Location Manager
     */
    func locationManager(_ manager: CLLocationManager, didRangeBeacons beacons: [CLBeacon], in region: CLBeaconRegion) {
        // inspect previously discovered beacons
        print(beacons.count)
        for beacon in beacons {
            print(beacon.proximityUUID.uuidString)
            let iBeacon = IBeacon(withBeacon: beacon)
            // if a beacon is already discovered, update.  Otherwise add to the list
            var beaconFound = false
            for i in 0..<foundBeacons.count {
                if foundBeacons[i].isEqual(to: iBeacon) {
                    beaconFound = true
                    foundBeacons[i].beacon = beacon
                }
            }
            
            if !beaconFound {
                foundBeacons.append(iBeacon)
            }

        }
        
        mapBeacons()
        
        beaconTableView.reloadData()
        
    }

    
    /**
     User enabled Location Services
     */
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if (status == .authorizedAlways) || (status == CLAuthorizationStatus.authorizedWhenInUse) {
            print("location manager authorized")
            if CLLocationManager.isMonitoringAvailable(for: CLBeaconRegion.self) {
                if CLLocationManager.isRangingAvailable() {
                    startScanning()
                } else {
                    print("ranging unavailable")
                }
            }
        } else {
            print("location manager unauthorized")
        }
    }
    
    
    
    // MARK: UITableViewDataSource
    
    /**
     Number of Table sections
     */
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    /**
     Number of iBeacons in table
     */
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return foundBeacons.count
    }
        
    /**
     Render Beacon Table cell
     */
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // create a new Beacon Table View cell
        let cell = tableView.dequeueReusableCell(withIdentifier: beaconCellReuseIdentifier, for: indexPath) as! BeaconTableViewCell
        
        // render cell
        let iBeacon = foundBeacons[indexPath.row]
        cell.renderBeacon(iBeacon)
        
        return cell
        
    }

    /**
     User selected a cell
     */
    private func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
        
}
