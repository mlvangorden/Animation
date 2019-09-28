//
//  GameScene.swift
//  Animation
//
//  Created by Matthew Van Gorden on 9/23/19.
//  Copyright © 2019 Matthew Van Gorden. All rights reserved.
//

import SpriteKit
import GameplayKit

let nut_width : CGFloat = 200
let nut_height : CGFloat = 225
let acorn_width : CGFloat = 100
let screenBounds = UIScreen.main.bounds
var screen_width : CGFloat = 375
let screen_height : CGFloat = (screenBounds.height)
let floor_height : CGFloat = 50

let acornCategory : UInt32 = 0x1 << 1
let nutCategory : UInt32 = 0x1 << 2
let floorCategory : UInt32 = 0x1 << 3
let goalCategory : UInt32 = 0x1 << 4

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    var nut1 = SKSpriteNode()
    var nut2 = SKSpriteNode()
    var nut3 = SKSpriteNode()
    var nut4 = SKSpriteNode()
    var nut5 = SKSpriteNode()
    
    var nutArray = [SKSpriteNode]()
    var startArray = [CGPoint]()
    var flagArray = [false, false, false, false, false]
    
    var floor = SKSpriteNode()
    var goal = SKSpriteNode()
    var acorn = SKSpriteNode()
    
    var nut1_start = CGPoint()
    var nut2_start = CGPoint()
    var nut3_start = CGPoint()
    var nut4_start = CGPoint()
    var nut5_start = CGPoint()
    
    override func didMove(to view: SKView) {
        
        self.physicsWorld.contactDelegate = self

        floor = (self.childNode(withName: "floor") as? SKSpriteNode)!
        nut1 = (self.childNode(withName: "nut1") as? SKSpriteNode)!
        nut2 = (self.childNode(withName: "nut2") as? SKSpriteNode)!
        nut3 = (self.childNode(withName: "nut3") as? SKSpriteNode)!
        nut4 = (self.childNode(withName: "nut4") as? SKSpriteNode)!
        nut5 = (self.childNode(withName: "nut5") as? SKSpriteNode)!
        
        nutArray.append(nut1)
        nutArray.append(nut2)
        nutArray.append(nut3)
        nutArray.append(nut4)
        nutArray.append(nut5)
        
        nut1_start = nut1.position
        nut2_start = nut2.position
        nut3_start = nut3.position
        nut4_start = nut4.position
        nut5_start = nut5.position
        
        startArray.append(nut1_start)
        startArray.append(nut2_start)
        startArray.append(nut3_start)
        startArray.append(nut4_start)
        startArray.append(nut5_start)
        
        
        
        goal = (self.childNode(withName: "goal") as? SKSpriteNode)!
        acorn = (self.childNode(withName: "acorn") as? SKSpriteNode)!
        
        acorn.physicsBody?.applyImpulse(CGVector(dx: 75, dy: 0))
        
        let border = SKPhysicsBody(edgeLoopFrom: self.frame)
        border.friction = 0
        border.restitution = 1
        
        self.physicsBody = border
        
        acorn.physicsBody?.categoryBitMask = acornCategory
        acorn.physicsBody?.collisionBitMask = nutCategory | floorCategory
        acorn.physicsBody?.contactTestBitMask = nutCategory | floorCategory
        acorn.name = "acorn"
        
        nut1.physicsBody?.categoryBitMask = nutCategory
        nut1.physicsBody?.collisionBitMask = acornCategory
        nut1.physicsBody?.contactTestBitMask = acornCategory
        nut1.name = "nut1"
        nut2.physicsBody?.categoryBitMask = nutCategory
        nut2.physicsBody?.collisionBitMask = acornCategory
        nut2.physicsBody?.contactTestBitMask = acornCategory
        nut2.name = "nut2"
        nut3.physicsBody?.categoryBitMask = nutCategory
        nut3.physicsBody?.collisionBitMask = acornCategory
        nut3.physicsBody?.contactTestBitMask = acornCategory
        nut3.name = "nut3"
        nut4.physicsBody?.categoryBitMask = nutCategory
        nut4.physicsBody?.collisionBitMask = acornCategory
        nut4.physicsBody?.contactTestBitMask = acornCategory
        nut4.name = "nut4"
        nut5.physicsBody?.categoryBitMask = nutCategory
        nut5.physicsBody?.collisionBitMask = acornCategory
        nut5.physicsBody?.contactTestBitMask = acornCategory
        nut5.name = "nut5"
        
        floor.physicsBody?.categoryBitMask = floorCategory
        floor.physicsBody?.collisionBitMask = acornCategory
        floor.physicsBody?.contactTestBitMask = acornCategory
        floor.name = "floor"
        
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        //var acor : SKPhysicsBody
        //var nut : SKPhysicsBody
        
        if( contact.bodyA.categoryBitMask == 0x1 << 1 && contact.bodyB.categoryBitMask == 0x1 << 2 ) {
            //acor = contact.bodyA
            //nut = contact.bodyB
            acornNutCollide()
        }
        else if( contact.bodyB.categoryBitMask == 0x1 << 1 && contact.bodyA.categoryBitMask == 0x1 << 2 ) {
            //acor = contact.bodyB
            //nut = contact.bodyA
            acornNutCollide()
        }
    }
    
    func acornNutCollide() {
        acorn.physicsBody?.applyImpulse(CGVector(dx: 5, dy: 5))
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let location = touch.location(in: self)
            if ( ( nut1.position.x - (nut_width/2) ) <= location.x && location.x <= ( nut1.position.x + (nut_width/2) ) ) {
                flagArray[0] = true
            }
            if ( ( nut2.position.x - (nut_width/2) ) <= location.x && location.x <= ( nut2.position.x + (nut_width/2) ) ) {
                flagArray[1] = true
            }
            if ( ( nut3.position.x - (nut_width/2) ) <= location.x && location.x <= ( nut3.position.x + (nut_width/2) ) ) {
                flagArray[2] = true
            }
            if ( ( nut4.position.x - (nut_width/2) ) <= location.x && location.x <= ( nut4.position.x + (nut_width/2) ) ) {
                flagArray[3] = true
            }
            if ( ( nut5.position.x - (nut_width/2) ) <= location.x && location.x <= ( nut5.position.x + (nut_width/2) ) ) {
                flagArray[4] = true
            }
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let location = touch.location(in: self)
            if ( ( nut1.position.x - (nut_width/2) ) <= location.x && location.x <= ( nut1.position.x + (nut_width/2) ) ) {
                flagArray[0] = true
            }
            if ( ( nut2.position.x - (nut_width/2) ) <= location.x && location.x <= ( nut2.position.x + (nut_width/2) ) ) {
                flagArray[1] = true
            }
            if ( ( nut3.position.x - (nut_width/2) ) <= location.x && location.x <= ( nut3.position.x + (nut_width/2) ) ) {
                flagArray[2] = true
            }
            if ( ( nut4.position.x - (nut_width/2) ) <= location.x && location.x <= ( nut4.position.x + (nut_width/2) ) ) {
                flagArray[3] = true
            }
            if ( ( nut5.position.x - (nut_width/2) ) <= location.x && location.x <= ( nut5.position.x + (nut_width/2) ) ) {
                flagArray[4] = true
            }
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        flagArray = [false, false, false, false, false]
    }
    
    func setNutFlag(nut: Int) {
        
    }
    
    func moveNut(nut: Int) {
        nutArray[nut-1].run(SKAction.moveTo(y: (nut_height / 2) + floor_height - screen_width, duration: 0.05))
    }
    
    func returnNut(nut: Int) {
        nutArray[nut-1].run(SKAction.move(to: startArray[nut-1], duration: 0.05))
    }
    
    override func update(_ currentTime: TimeInterval){
        if(flagArray[0]){moveNut(nut: 1)}
        else{returnNut(nut: 1)}
        if(flagArray[1]){moveNut(nut: 2)}
        else{returnNut(nut: 2)}
        if(flagArray[2]){moveNut(nut: 3)}
        else{returnNut(nut: 3)}
        if(flagArray[3]){moveNut(nut: 4)}
        else{returnNut(nut: 4)}
        if(flagArray[4]){moveNut(nut: 5)}
        else{returnNut(nut: 5)}
    }
    
    /*
    func touchDown(atPoint pos : CGPoint) {
        if let n = self.spinnyNode?.copy() as! SKShapeNode? {
            n.position = pos
            n.strokeColor = SKColor.green
            self.addChild(n)
        }
    }
    
    func touchMoved(toPoint pos : CGPoint) {
        if let n = self.spinnyNode?.copy() as! SKShapeNode? {
            n.position = pos
            n.strokeColor = SKColor.blue
            self.addChild(n)
        }
    }
    
    func touchUp(atPoint pos : CGPoint) {
        if let n = self.spinnyNode?.copy() as! SKShapeNode? {
            n.position = pos
            n.strokeColor = SKColor.red
            self.addChild(n)
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let label = self.label {
            label.run(SKAction.init(named: "Pulse")!, withKey: "fadeInOut")
        }
        
        for t in touches { self.touchDown(atPoint: t.location(in: self)) }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchMoved(toPoint: t.location(in: self)) }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchUp(atPoint: t.location(in: self)) }
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchUp(atPoint: t.location(in: self)) }
    }
    
    */
}
