//
//  GameScene.swift
//  BeaconGame
//
//  Created by Adonis Gaitatzis on 11/28/16.
//  Copyright © 2016 Adonis Gaitatzis. All rights reserved.
//

import SpriteKit
import GameplayKit

/**
 Displays Beacons and Central locations on screen
 */
class BleMapScene: SKScene {
    
    // sprite scale
    let iconScale = CGFloat(0.1)
    
    // size of room in meters - must same x/y ratio as screen bounds
    let roomBounds = CGSize(width: 50, height: 37)
    
    
    /**
     Initialize Map Scene with a coder (required but not implemented)
     */
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    /**
     Initialize Map Scene
     */
    override init(size: CGSize) {
        super.init(size: size)
        backgroundColor = SKColor.white
    }
    
    /**
      Update scene
     */
    override func update(_ currentTime: TimeInterval) {
        super.update(currentTime)
    }
    
    
    /**
     Add Central to map
     
     - Parameters:
        - position: the x,y location of the central in meters from some origin
     */
    func addCentral(position: CGPoint) {
        // load sprite
        let central = SKSpriteNode(imageNamed: "central")
        
        // scale and position sprite
        central.size = CGSize(
            width: central.size.width * iconScale,
            height: central.size.height * iconScale)
        
        central.position = getMapPosition(position)
        
        // add sprite to map
        addChild(central)
    }
    
    
    /**
     Add a Beacon to the Map
     
     - Parameters:
        - position: the x,y location of the Beacon in meters from some origin
        - radius: the beacon's distance from the central in meters
     */
    func addBeacon(position: CGPoint, radius: CGFloat) {
        // load sprite
        let peripheral = SKSpriteNode(imageNamed: "peripheral")
        
        // scale sprite
        peripheral.size = CGSize(
            width: peripheral.size.width * iconScale,
            height: peripheral.size.height * iconScale)
        
        let mapPosition = getMapPosition(position)
        
        // position and add sprite to map
        peripheral.position = mapPosition
        addChild(peripheral)
        
        // add a circle for central's distance from beacon
        let circle = SKShapeNode(circleOfRadius: CGFloat(getMapScale(radius)))
        circle.position = mapPosition
        circle.strokeColor = SKColor.blue
        addChild(circle)
        
    }
    

    /**
     Convert Real world coordinates into map coordinates
     */
    private func getMapPosition(_ position: CGPoint) -> CGPoint {
        var xPosition = getMapScale(position.x)
        var yPosition = getMapScale(position.y)
        
        // offset by 50% of screen
        xPosition -= 0 // (size.width / 2)
        yPosition -= (size.height + 50)
        
        yPosition *= -1
        
        return CGPoint(x: xPosition, y: yPosition)
    }
    
    /**
     Convert real world distances into map distances
     */
    private func getMapScale(_ scalar: CGFloat) -> CGFloat {
        return scalar * size.width / roomBounds.width
    }
    
}
