//
//  GameScene.swift
//  Animation
//
//  Created by Matthew Van Gorden on 9/23/19.
//  Copyright © 2019 Matthew Van Gorden. All rights reserved.
//

import SpriteKit
import GameplayKit

let nutWidth : CGFloat = 125
let nutHeight : CGFloat = 130

class GameScene: SKScene {
    
    var nut1 = SKSpriteNode()
    var nut2 = SKSpriteNode()
    var nut3 = SKSpriteNode()
    var nut4 = SKSpriteNode()
    var nut5 = SKSpriteNode()
    var nut6 = SKSpriteNode()
    var nut7 = SKSpriteNode()
    var nut8 = SKSpriteNode()
    
    let nutArray = ["nut1", "nut2", "nut3", "nut4", "nut5", "nut6", "nut7", "nut8"]
    
    var goal = SKSpriteNode()
    var acorn = SKSpriteNode()
    
    var nut1_start = CGPoint()
    var nut2_start = CGPoint()
    var nut3_start = CGPoint()
    var nut4_start = CGPoint()
    var nut5_start = CGPoint()
    var nut6_start = CGPoint()
    var nut7_start = CGPoint()
    var nut8_start = CGPoint()
    
    var nut1_flag = false
    var nut2_flag = false
    var nut3_flag = false
    var nut4_flag = false
    var nut5_flag = false
    var nut6_flag = false
    var nut7_flag = false
    var nut8_flag = false
    
    override func didMove(to view: SKView) {

        nut1 = (self.childNode(withName: "nut1") as? SKSpriteNode)!
        nut2 = (self.childNode(withName: "nut2") as? SKSpriteNode)!
        nut3 = (self.childNode(withName: "nut3") as? SKSpriteNode)!
        nut4 = (self.childNode(withName: "nut4") as? SKSpriteNode)!
        nut5 = (self.childNode(withName: "nut5") as? SKSpriteNode)!
        nut6 = (self.childNode(withName: "nut6") as? SKSpriteNode)!
        nut7 = (self.childNode(withName: "nut7") as? SKSpriteNode)!
        nut8 = (self.childNode(withName: "nut8") as? SKSpriteNode)!
        
        nut1_start = nut1.position
        nut2_start = nut2.position
        nut3_start = nut3.position
        nut4_start = nut4.position
        nut5_start = nut5.position
        nut6_start = nut6.position
        nut7_start = nut7.position
        nut8_start = nut8.position
        
        goal = (self.childNode(withName: "goal") as? SKSpriteNode)!
        acorn = (self.childNode(withName: "acorn") as? SKSpriteNode)!
        
        acorn.physicsBody?.applyImpulse(CGVector(dx: 30, dy: -30))
        
        let border = SKPhysicsBody(edgeLoopFrom: self.frame)
        border.friction = 0
        border.restitution = 1
        
        self.physicsBody = border
        
        /*
        if let label = self.label {
            label.alpha = 0.0
            label.run(SKAction.fadeIn(withDuration: 2.0))
        }
        
        // Create shape node to use during mouse interaction
        let w = (self.size.width + self.size.height) * 0.05
        self.spinnyNode = SKShapeNode.init(rectOf: CGSize.init(width: w, height: w), cornerRadius: w * 0.3)
        
        if let spinnyNode = self.spinnyNode {
            spinnyNode.lineWidth = 2.5
            
            spinnyNode.run(SKAction.repeatForever(SKAction.rotate(byAngle: CGFloat(Double.pi), duration: 1)))
            spinnyNode.run(SKAction.sequence([SKAction.wait(forDuration: 0.5),
                                              SKAction.fadeOut(withDuration: 0.5),
                                              SKAction.removeFromParent()]))
        }
        */
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let location = touch.location(in: self)
            
            if ( ( nut1.position.x - (nutWidth/2) ) <= location.x && location.x <= ( nut1.position.x + (nutWidth/2) ) ) {
                nut1_flag = true
            }
            if ( ( nut2.position.x - (nutWidth/2) ) <= location.x && location.x <= ( nut2.position.x + (nutWidth/2) ) ) {
                nut2_flag = true
            }
            if ( ( nut3.position.x - (nutWidth/2) ) <= location.x && location.x <= ( nut3.position.x + (nutWidth/2) ) ) {
                nut3_flag = true
            }
            if ( ( nut4.position.x - (nutWidth/2) ) <= location.x && location.x <= ( nut4.position.x + (nutWidth/2) ) ) {
                nut4_flag = true
            }
            if ( ( nut5.position.x - (nutWidth/2) ) <= location.x && location.x <= ( nut5.position.x + (nutWidth/2) ) ) {
                nut5_flag = true
            }
            if ( ( nut6.position.x - (nutWidth/2) ) <= location.x && location.x <= ( nut6.position.x + (nutWidth/2) ) ) {
                nut6_flag = true
            }
            if ( ( nut7.position.x - (nutWidth/2) ) <= location.x && location.x <= ( nut7.position.x + (nutWidth/2) ) ) {
                nut7_flag = true
            }
            if ( ( nut8.position.x - (nutWidth/2) ) <= location.x && location.x <= ( nut8.position.x + (nutWidth/2) ) ) {
                nut8_flag = true
            }
 
        }
    }

    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let location = touch.location(in: self)
            if ( ( nut1.position.x - (nutWidth/2) ) <= location.x && location.x <= ( nut1.position.x + (nutWidth/2) ) ) {
                nut1_flag = true
                nut2_flag = false
                nut3_flag = false
                nut4_flag = false
                nut5_flag = false
                nut6_flag = false
                nut7_flag = false
                nut8_flag = false
            }
            if ( ( nut2.position.x - (nutWidth/2) ) <= location.x && location.x <= ( nut2.position.x + (nutWidth/2) ) ) {
                nut1_flag = false
                nut2_flag = true
                nut3_flag = false
                nut4_flag = false
                nut5_flag = false
                nut6_flag = false
                nut7_flag = false
                nut8_flag = false
            }
            if ( ( nut3.position.x - (nutWidth/2) ) <= location.x && location.x <= ( nut3.position.x + (nutWidth/2) ) ) {
                moveNut(nut: 3)
                nut1_flag = false
                nut2_flag = false
                nut3_flag = true
                nut4_flag = false
                nut5_flag = false
                nut6_flag = false
                nut7_flag = false
                nut8_flag = false
            }
            if ( ( nut4.position.x - (nutWidth/2) ) <= location.x && location.x <= ( nut4.position.x + (nutWidth/2) ) ) {
                nut1_flag = false
                nut2_flag = false
                nut3_flag = false
                nut4_flag = true
                nut5_flag = false
                nut6_flag = false
                nut7_flag = false
                nut8_flag = false
            }
            if ( ( nut5.position.x - (nutWidth/2) ) <= location.x && location.x <= ( nut5.position.x + (nutWidth/2) ) ) {
                nut1_flag = false
                nut2_flag = false
                nut3_flag = false
                nut4_flag = false
                nut5_flag = true
                nut6_flag = false
                nut7_flag = false
                nut8_flag = false
            }
            if ( ( nut6.position.x - (nutWidth/2) ) <= location.x && location.x <= ( nut6.position.x + (nutWidth/2) ) ) {
                nut1_flag = false
                nut2_flag = false
                nut3_flag = false
                nut4_flag = false
                nut5_flag = false
                nut6_flag = true
                nut7_flag = false
                nut8_flag = false
            }
            if ( ( nut7.position.x - (nutWidth/2) ) <= location.x && location.x <= ( nut7.position.x + (nutWidth/2) ) ) {
                nut1_flag = false
                nut2_flag = false
                nut3_flag = false
                nut4_flag = false
                nut5_flag = false
                nut6_flag = false
                nut7_flag = true
                nut8_flag = false
            }
            if ( ( nut8.position.x - (nutWidth/2) ) <= location.x && location.x <= ( nut8.position.x + (nutWidth/2) ) ) {
                nut1_flag = false
                nut2_flag = false
                nut3_flag = false
                nut4_flag = false
                nut5_flag = false
                nut6_flag = false
                nut7_flag = false
                nut8_flag = true
            }
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        nut1_flag = false
        nut2_flag = false
        nut3_flag = false
        nut4_flag = false
        nut5_flag = false
        nut6_flag = false
        nut7_flag = false
        nut8_flag = false
    }
    
    func moveNut(nut: Int){
        let current = self.childNode(withName: nutArray[nut-1])
        if(nut == 1){
            current!.run(SKAction.moveTo(y: (nut1_start.y + nutHeight), duration: 0.05))
        }
        if(nut == 2){
            current!.run(SKAction.moveTo(y: (nut1_start.y + nutHeight), duration: 0.05))
        }
        if(nut == 3){
            current!.run(SKAction.moveTo(y: (nut1_start.y + nutHeight), duration: 0.05))
        }
        if(nut == 4){
            current!.run(SKAction.moveTo(y: (nut1_start.y + nutHeight), duration: 0.05))
        }
        if(nut == 5){
            current!.run(SKAction.moveTo(y: (nut1_start.y + nutHeight), duration: 0.05))
        }
        if(nut == 6){
            current!.run(SKAction.moveTo(y: (nut1_start.y + nutHeight), duration: 0.05))
        }
        if(nut == 7){
            current!.run(SKAction.moveTo(y: (nut1_start.y + nutHeight), duration: 0.05))
        }
        if(nut == 8){
            current!.run(SKAction.moveTo(y: (nut1_start.y + nutHeight), duration: 0.05))
        }
    }
    
    func returnNut(nut: Int){
        let current = self.childNode(withName: nutArray[nut-1])
        var placement = CGPoint()
        if(nut == 1){placement = nut1_start}
        if(nut == 2){placement = nut2_start}
        if(nut == 3){placement = nut3_start}
        if(nut == 4){placement = nut4_start}
        if(nut == 5){placement = nut5_start}
        if(nut == 6){placement = nut6_start}
        if(nut == 7){placement = nut7_start}
        if(nut == 8){placement = nut8_start}
        
        current!.run(SKAction.move(to: placement, duration: 0.2))
    }
    
    
    
    override func update(_ currentTime: TimeInterval){
        if(nut1_flag){moveNut(nut: 1)}
        else{returnNut(nut: 1)}
        if(nut2_flag){moveNut(nut: 2)}
        else{returnNut(nut: 2)}
        if(nut3_flag){moveNut(nut: 3)}
        else{returnNut(nut: 3)}
        if(nut4_flag){moveNut(nut: 4)}
        else{returnNut(nut: 4)}
        if(nut5_flag){moveNut(nut: 5)}
        else{returnNut(nut: 5)}
        if(nut6_flag){moveNut(nut: 6)}
        else{returnNut(nut: 6)}
        if(nut7_flag){moveNut(nut: 7)}
        else{returnNut(nut: 7)}
        if(nut8_flag){moveNut(nut: 8)}
        else{returnNut(nut: 8)}
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
