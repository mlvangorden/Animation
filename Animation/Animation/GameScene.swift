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
let acorn_width : CGFloat = 150
var screenBounds = CGRect()
var screen_width = CGFloat()
var screen_height = CGFloat()
let floor_height : CGFloat = 50

let acornCategory : UInt32 = 0x7
let floorCategory : UInt32 = 0x5
let goalCategory : UInt32 = 0x6

let nut_offset : CGFloat = 60

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    var nut1 = SKSpriteNode()
    var nut2 = SKSpriteNode()
    var nut3 = SKSpriteNode()
    var nut4 = SKSpriteNode()
    
    var nutArray = [SKSpriteNode]()
    var startArray = [CGPoint]()
    var categoryArray = [UInt32]()
    
    var floor = SKSpriteNode()
    var goal = SKSpriteNode()
    var acorn = SKSpriteNode()
    var sky = SKSpriteNode()
    
    var nut1_start = CGPoint()
    var nut2_start = CGPoint()
    var nut3_start = CGPoint()
    var nut4_start = CGPoint()
    
    override func didMove(to view: SKView) {
        screenBounds = UIScreen.main.bounds
        
        let temp_height = screenBounds.height
        let temp_width = screenBounds.width
        
        screen_width = max(temp_height, temp_width)
        screen_height = min(temp_height, temp_width)
        
        self.physicsWorld.contactDelegate = self

        floor = (self.childNode(withName: "floor") as? SKSpriteNode)!
        nut1 = (self.childNode(withName: "nut1") as? SKSpriteNode)!
        nut2 = (self.childNode(withName: "nut2") as? SKSpriteNode)!
        nut3 = (self.childNode(withName: "nut3") as? SKSpriteNode)!
        nut4 = (self.childNode(withName: "nut4") as? SKSpriteNode)!
        sky = (self.childNode(withName: "sky") as? SKSpriteNode)!
        
        nutArray.append(nut1)
        nutArray.append(nut2)
        nutArray.append(nut3)
        nutArray.append(nut4)
        
        nut1_start = nut1.position
        nut2_start = nut2.position
        nut3_start = nut3.position
        nut4_start = nut4.position
        
        startArray.append(nut1_start)
        startArray.append(nut2_start)
        startArray.append(nut3_start)
        startArray.append(nut4_start)
        
        goal = (self.childNode(withName: "goal") as? SKSpriteNode)!
        acorn = (self.childNode(withName: "acorn") as? SKSpriteNode)!
        
        acorn.physicsBody?.applyImpulse(CGVector(dx: 75, dy: 0))
        
        let border = SKPhysicsBody(edgeLoopFrom: sky.frame)
        border.friction = 0
        border.restitution = 1
        
        self.physicsBody = border
        
        //categories
        for i in 1...4 {
            categoryArray.append(UInt32(i))
        }
        
        acorn.physicsBody?.categoryBitMask = acornCategory
        acorn.physicsBody?.collisionBitMask = categoryArray[0] | categoryArray[1] | categoryArray[2] | categoryArray[3] | floorCategory
        acorn.physicsBody?.contactTestBitMask = categoryArray[0] | categoryArray[1] | categoryArray[2] | categoryArray[3] | floorCategory
        acorn.name = "acorn"
        
        nut1.physicsBody?.categoryBitMask = categoryArray[0]
        nut1.physicsBody?.collisionBitMask = acornCategory
        nut1.physicsBody?.contactTestBitMask = acornCategory
        nut1.name = "nut1"
        nut2.physicsBody?.categoryBitMask = categoryArray[1]
        nut2.physicsBody?.collisionBitMask = acornCategory
        nut2.physicsBody?.contactTestBitMask = acornCategory
        nut2.name = "nut2"
        nut3.physicsBody?.categoryBitMask = categoryArray[2]
        nut3.physicsBody?.collisionBitMask = acornCategory
        nut3.physicsBody?.contactTestBitMask = acornCategory
        nut3.name = "nut3"
        nut4.physicsBody?.categoryBitMask = categoryArray[3]
        nut4.physicsBody?.collisionBitMask = acornCategory
        nut4.physicsBody?.contactTestBitMask = acornCategory
        nut4.name = "nut4"
        
        floor.physicsBody?.categoryBitMask = floorCategory
        floor.physicsBody?.collisionBitMask = acornCategory
        floor.physicsBody?.contactTestBitMask = acornCategory
        floor.name = "floor"
        
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        //var acor : SKPhysicsBody
        var nutX = SKPhysicsBody()
        
        if( contact.bodyA.categoryBitMask == acornCategory && contact.bodyB.categoryBitMask <= categoryArray[3] ) {
            //acor = contact.bodyA
            nutX = contact.bodyB
        }
        else if( contact.bodyA.categoryBitMask <= categoryArray[3] && contact.bodyB.categoryBitMask == acornCategory ) {
            //acor = contact.bodyB
            nutX = contact.bodyA
        }

        if(nutX.categoryBitMask == categoryArray[0]) {
            acornNutCollide(nut: 1)
        } else if(nutX.categoryBitMask == categoryArray[1]) {
            acornNutCollide(nut: 2)
        } else if(nutX.categoryBitMask == categoryArray[2]) {
            acornNutCollide(nut: 3)
        } else if(nutX.categoryBitMask == categoryArray[3]) {
            acornNutCollide(nut: 4)
        }
 
    }
    
    func overNut(x: CGFloat, nut: Int) -> Bool {
        return (x >= nutArray[nut-1].position.x - (nut_width/2) - nut_offset) && (x <= nutArray[nut-1].position.x + (nut_width/2) + nut_offset)
    }
    
    //needs fine tuning
    func acornNutCollide(nut: Int) {
        acorn.physicsBody?.applyImpulse(CGVector(dx: 100, dy: 100))
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let location = touch.location(in: self)

            for i in 1...4 {
                if(overNut(x: location.x, nut: i)) {
                    moveNut(nut: i)
                }
            }
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        for touch in touches {
            
            let location = touch.location(in: self)
            let previous_location = touch.previousLocation(in: self)
            
            for i in 1...4 {
                if (overNut(x: location.x, nut: i)) {
                    moveNut(nut: i)
                } else if (overNut(x: previous_location.x, nut: i)) {
                    returnNut(nut: i)
                }
            }
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for i in 1...4 {
            returnNut(nut: i)
        }
    }
    
    func setNutFlag(nut: Int) {
        
    }
    
    func moveNut(nut: Int) {
        nutArray[nut-1].run(SKAction.moveTo(y: (nut_height / 2) + floor_height - (screen_height), duration: 0.05))
    }
    
    func returnNut(nut: Int) {
        nutArray[nut-1].run(SKAction.move(to: startArray[nut-1], duration: 0.05))
    }
    
    override func update(_ currentTime: TimeInterval){

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
