//
//  GameScene.swift
//  Animation
//
//  Created by Matthew Van Gorden on 9/23/19.
//  Copyright © 2019 Matthew Van Gorden. All rights reserved.
//

import SpriteKit
import GameplayKit
import AVFoundation

let nut_width : CGFloat = 200
let nut_height : CGFloat = 225
let acorn_width : CGFloat = 150
var screenBounds = CGRect()
var screen_width = CGFloat()
var screen_height = CGFloat()
let floor_height : CGFloat = 50
let score_height : CGFloat = 150
let score_width : CGFloat = 400

struct category {
    static let acorn : UInt32 = 0x7
    static let finish : UInt32 = 0x6
    static let floor : UInt32 = 0x5
    static let nuts : [UInt32] = [0x1, 0x2, 0x3, 0x4]
}

struct game_mode {
    static let title : Int = 0
    static let game : Int = 1
    static let over : Int = 2
}

let nut_offset : CGFloat = 60

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    var backgroundMusic : SKAudioNode!
    
    var game_scene = game_mode.title
    
    var nut1 = SKSpriteNode()
    var nut2 = SKSpriteNode()
    var nut3 = SKSpriteNode()
    var nut4 = SKSpriteNode()
    
    var floor = SKSpriteNode()
    var sky = SKSpriteNode()
    var finish = SKSpriteNode()
    
    var nut1_start = CGPoint()
    var nut2_start = CGPoint()
    var nut3_start = CGPoint()
    var nut4_start = CGPoint()
    
    var nutArray = [SKSpriteNode]()
    var startArray = [CGPoint]()
    
    var acornTimer = Timer()
    var scoreDisplay = SKLabelNode()
    
    var score = 0
    var number_of_acorns = 0
    
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
        finish = (self.childNode(withName: "wall_right") as? SKSpriteNode)!
        
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
        
        nut1.physicsBody?.categoryBitMask = category.nuts[0]
        nut1.physicsBody?.collisionBitMask = category.acorn
        nut1.physicsBody?.contactTestBitMask = category.acorn
        nut1.name = "nut1"
        nut2.physicsBody?.categoryBitMask = category.nuts[1]
        nut2.physicsBody?.collisionBitMask = category.acorn
        nut2.physicsBody?.contactTestBitMask = category.acorn
        nut2.name = "nut2"
        nut3.physicsBody?.categoryBitMask = category.nuts[2]
        nut3.physicsBody?.collisionBitMask = category.acorn
        nut3.physicsBody?.contactTestBitMask = category.acorn
        nut3.name = "nut3"
        nut4.physicsBody?.categoryBitMask = category.nuts[3]
        nut4.physicsBody?.collisionBitMask = category.acorn
        nut4.physicsBody?.contactTestBitMask = category.acorn
        nut4.name = "nut4"
        
        floor.physicsBody?.categoryBitMask = category.floor
        floor.physicsBody?.collisionBitMask = category.acorn
        floor.physicsBody?.contactTestBitMask = category.acorn
        floor.name = "floor"
        
        finish.physicsBody?.categoryBitMask = category.finish
        finish.physicsBody?.collisionBitMask = category.acorn
        finish.physicsBody?.contactTestBitMask = category.acorn
        finish.name = "finish"
        
        startGame()
        
        
        /*
        scoreDisplay = UILabel(frame: CGRect(x: ((screen_width / 2) - (score_width / 2)), y: 20, width: score_width, height: score_height))
        view.addSubview(scoreDisplay)
        scoreDisplay.textColor = UIColor(red: 34/255, green: 13/255, blue: 0/255, alpha: 1)
        let customFont = UIFont(name: "ARCO Typography", size: UIFont.labelFontSize)
        //scoreDisplay.font = UIFontMetrics.default.scaledFont(for: customFont!)
        scoreDisplay.font = customFont!
        scoreDisplay.adjustsFontForContentSizeCategory = true
        scoreDisplay.text = String(score)
        self.view!.addSubview(scoreDisplay)
         
         
        
        for fontFamilyName in UIFont.familyNames{
            for fontName in UIFont.fontNames(forFamilyName: fontFamilyName){
                print("Family: \(fontFamilyName)     Font: \(fontName)")
            }
        }
        */
        
        
        if let musicURL = Bundle.main.url(forResource: "banana_breeze", withExtension: "wav") {
            backgroundMusic = SKAudioNode(url: musicURL)
            addChild(backgroundMusic)
        }
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        var acor = SKPhysicsBody()
        var nutX = SKPhysicsBody()
        
        if( contact.bodyA.categoryBitMask == category.acorn && contact.bodyB.categoryBitMask == category.finish ) {
            acor = contact.bodyA
            scoreAcorn(acorn: acor)
        }
        else if( contact.bodyA.categoryBitMask == category.finish && contact.bodyB.categoryBitMask == category.acorn ) {
            acor = contact.bodyB
            scoreAcorn(acorn: acor)
        }
        
        if( contact.bodyA.categoryBitMask == category.acorn && contact.bodyB.categoryBitMask <= category.nuts[3] ) {
            acor = contact.bodyA
            nutX = contact.bodyB
        }
        else if( contact.bodyA.categoryBitMask <= category.nuts[3] && contact.bodyB.categoryBitMask == category.acorn ) {
            acor = contact.bodyB
            nutX = contact.bodyA
        }

        if(nutX.categoryBitMask == category.nuts[0]) {
            acornNutCollide(nut: 1, acorn: acor)
        } else if(nutX.categoryBitMask == category.nuts[1]) {
            acornNutCollide(nut: 2, acorn: acor)
        } else if(nutX.categoryBitMask == category.nuts[2]) {
            acornNutCollide(nut: 3, acorn: acor)
        } else if(nutX.categoryBitMask == category.nuts[3]) {
            acornNutCollide(nut: 4, acorn: acor)
        }
 
    }
    
    func startTitle() {
        game_scene = game_mode.title
    }
    
    func startGame() {
        game_scene = game_mode.game
        acornTimer = Timer.scheduledTimer(timeInterval: 2.25, target: self, selector: #selector(GameScene.spawnAcorn), userInfo: nil, repeats: true)
        
        scoreDisplay.fontName = "ARCO"
        scoreDisplay.horizontalAlignmentMode = .center
        scoreDisplay.position = CGPoint(x: 0, y: 280)
        scoreDisplay.fontColor = UIColor(red: 39/255, green: 15/255, blue: 0/255, alpha: 1)
        scoreDisplay.fontSize = 80
        scoreDisplay.text = String(score)
        self.addChild(scoreDisplay)
    }
    
    func gameOver() {
        game_scene = game_mode.over
    }
    
    @objc func spawnAcorn(){
        let acorn = SKSpriteNode(imageNamed: "acorn")
        acorn.physicsBody = SKPhysicsBody(texture: SKTexture(imageNamed: "acorn"), size: CGSize(width: 150, height: 150))
        acorn.physicsBody?.isDynamic = true
        acorn.physicsBody?.affectedByGravity = true
        acorn.physicsBody?.allowsRotation = true
        acorn.physicsBody?.restitution = 0.7
        acorn.physicsBody?.mass = 0.5
        acorn.physicsBody?.linearDamping = 0.15
        
        acorn.physicsBody?.categoryBitMask = category.acorn
        acorn.physicsBody?.collisionBitMask = category.nuts[0] | category.nuts[1] | category.nuts[2] | category.nuts[3] | category.floor | category.acorn | category.finish
        acorn.physicsBody?.contactTestBitMask = category.nuts[0] | category.nuts[1] | category.nuts[2] | category.nuts[3] | category.floor | category.acorn | category.finish
        acorn.name = "acorn"
        
        let randomPosition = Int.random(in: 0..<300)
        acorn.position = CGPoint(x: -742, y: randomPosition)
        
        self.addChild(acorn)
        number_of_acorns += 1
        
        let randomImpulse = Int.random(in: 50..<100)
        
        acorn.physicsBody?.applyImpulse( CGVector(dx: randomImpulse, dy: 300 - (randomPosition - 20)) )
    }
    
    func scoreAcorn(acorn: SKPhysicsBody){
        acorn.node?.removeFromParent()
        score += 1
        number_of_acorns -= 1
        scoreDisplay.text = String(score)
    }
    
    func overNut(x: CGFloat, nut: Int) -> Bool {
        return (x >= nutArray[nut-1].position.x - (nut_width/2) - nut_offset) && (x <= nutArray[nut-1].position.x + (nut_width/2) + nut_offset)
    }
    
    //needs fine tuning
    func acornNutCollide(nut: Int, acorn: SKPhysicsBody) {
        acorn.applyImpulse(CGVector(dx: 33 - nut*3, dy: 18 + nut*3))
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
    
    func moveNut(nut: Int) {
        nutArray[nut-1].run(SKAction.moveTo(y: (nut_height / 2) + floor_height - (screen_height), duration: 0.05))
    }
    
    func returnNut(nut: Int) {
        nutArray[nut-1].run(SKAction.move(to: startArray[nut-1], duration: 0.05))
    }
    
    override func update(_ currentTime: TimeInterval){
        if(number_of_acorns >= 20){
            //reset game
        }
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
