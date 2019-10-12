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
    static let bumper : UInt32 = 0x8
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
    
    //start_title
    var logo = SKSpriteNode()
    var play_button = SKSpriteNode()
    var button_pressed = false
    var button_pressable = false
    
    //game_over
    var pile = SKSpriteNode()
    var game_over_label = SKLabelNode()
    var restart_ready = false
    
    //nuts
    var nut1 = SKSpriteNode()
    var nut2 = SKSpriteNode()
    var nut3 = SKSpriteNode()
    var nut4 = SKSpriteNode()
    
    //environment
    var floor = SKSpriteNode()
    var bumper = SKSpriteNode()
    var sky = SKSpriteNode()
    var finish = SKSpriteNode()
    
    var nut1_start = CGPoint()
    var nut2_start = CGPoint()
    var nut3_start = CGPoint()
    var nut4_start = CGPoint()
    
    var nutArray = [SKSpriteNode]()
    var startArray = [CGPoint]()
    
    var acornTimer = Timer()
    var score_display = SKLabelNode()
    
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
        bumper = (self.childNode(withName: "bumper") as? SKSpriteNode)!
        
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
        
        bumper.physicsBody?.categoryBitMask = category.bumper
        bumper.physicsBody?.collisionBitMask = category.acorn
        bumper.physicsBody?.contactTestBitMask = category.acorn
        bumper.name = "bumper"
        
        floor.physicsBody?.categoryBitMask = category.floor
        floor.physicsBody?.collisionBitMask = category.acorn
        floor.physicsBody?.contactTestBitMask = category.acorn
        floor.name = "floor"
        
        finish.physicsBody?.categoryBitMask = category.finish
        finish.physicsBody?.collisionBitMask = category.acorn
        finish.physicsBody?.contactTestBitMask = category.acorn
        finish.name = "finish"
        
        startTitle()
        
        if let musicURL = Bundle.main.url(forResource: "banana_breeze", withExtension: "wav") {
            backgroundMusic = SKAudioNode(url: musicURL)
            addChild(backgroundMusic)
        }
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        var acor = SKPhysicsBody()
        var nutX = SKPhysicsBody()
        
        //acorn vs goal
        if( contact.bodyA.categoryBitMask == category.acorn && contact.bodyB.categoryBitMask == category.finish ) {
            acor = contact.bodyA
            scoreAcorn(acorn: acor)
        }
        else if( contact.bodyA.categoryBitMask == category.finish && contact.bodyB.categoryBitMask == category.acorn ) {
            acor = contact.bodyB
            scoreAcorn(acorn: acor)
        }
        
        //acorn vs nut
        if( contact.bodyA.categoryBitMask == category.acorn && contact.bodyB.categoryBitMask <= category.nuts[3] ) {
            acor = contact.bodyA
            nutX = contact.bodyB
        }
        else if( contact.bodyA.categoryBitMask <= category.nuts[3] && contact.bodyB.categoryBitMask == category.acorn ) {
            acor = contact.bodyB
            nutX = contact.bodyA
        }
        //acorn vs bumper
        if( contact.bodyA.categoryBitMask == category.acorn && contact.bodyB.categoryBitMask == category.bumper ) {
            acor = contact.bodyA
            acor.applyImpulse( CGVector(dx: 200, dy: 200) )
        }
        else if( contact.bodyA.categoryBitMask == category.bumper && contact.bodyB.categoryBitMask == category.acorn ) {
            acor = contact.bodyB
            acor.applyImpulse( CGVector(dx: 50, dy: 50) )
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
        restart_ready = false
        game_over_label.removeFromParent()
        pile.removeFromParent()
        score_display.removeFromParent()
        score = 0
        
        game_scene = game_mode.title
        logo = SKSpriteNode(imageNamed: "logo")
        logo.position = CGPoint(x: 0, y: 150)
        self.addChild(logo)
        
        play_button = SKSpriteNode(imageNamed: "play")
        play_button.position = CGPoint(x: 0, y: -150)
        play_button.name = "PLAY"
        self.addChild(play_button)
        
    }
    
    func startGame() {
        logo.removeFromParent()
        play_button.removeFromParent()
        
        game_scene = game_mode.game
        acornTimer = Timer.scheduledTimer(timeInterval: 2.25, target: self, selector: #selector(GameScene.spawnAcorn), userInfo: nil, repeats: true)
        
        score_display.fontName = "ARCO"
        score_display.horizontalAlignmentMode = .center
        score_display.position = CGPoint(x: 0, y: 280)
        score_display.zPosition = 1
        score_display.fontColor = UIColor(red: 39/255, green: 15/255, blue: 0/255, alpha: 1)
        score_display.fontSize = 80
        score_display.text = String(score)
        self.addChild(score_display)
    }
    
    func gameOver() {
        acornTimer.invalidate()
        
        pile = SKSpriteNode(imageNamed: "pile")
        pile.position = CGPoint(x: 0, y: -1 * (screen_height + pile.frame.height) )
        pile.zPosition = 5
        self.addChild(pile)
        pile.run(SKAction.moveTo(y: screen_height, duration: 2.5))
        game_scene = game_mode.over
    }
    
    func displayGameOver() {
        score_display.removeFromParent()
        removeAcorns()
        returnNuts()
        
        game_over_label.fontName = "ARCO"
        game_over_label.position = CGPoint(x: 0, y: 75)
        game_over_label.fontColor = UIColor(red: 39/255, green: 15/255, blue: 0/255, alpha: 1)
        game_over_label.fontSize = 150
        game_over_label.zPosition = 6
        game_over_label.text = "GAME OVER"
        game_over_label.alpha = 0.0
        
        score_display.fontName = "ARCO"
        score_display.position = CGPoint(x: 0, y: -150)
        score_display.fontColor = UIColor(red: 39/255, green: 15/255, blue: 0/255, alpha: 1)
        score_display.fontSize = 200
        score_display.zPosition = 6
        score_display.text = String(score)
        score_display.alpha = 0.0
        
        game_over_label.run(SKAction.fadeIn(withDuration: 0.25))
        score_display.run(SKAction.fadeIn(withDuration: 0.25))
        self.addChild(game_over_label)
        self.addChild(score_display)
        
        restart_ready = true
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
        acorn.physicsBody?.collisionBitMask = category.nuts[0] | category.nuts[1] | category.nuts[2] | category.nuts[3] | category.floor | category.acorn | category.finish | category.bumper
        acorn.physicsBody?.contactTestBitMask = category.nuts[0] | category.nuts[1] | category.nuts[2] | category.nuts[3] | category.floor | category.acorn | category.finish | category.bumper
        acorn.name = "acorn"
        
        let randomPosition = Int.random(in: 0..<300)
        acorn.position = CGPoint(x: Int(-1 * (screen_width + acorn_width) ), y: randomPosition)
        
        self.addChild(acorn)
        number_of_acorns += 1
        
        let randomImpulse = Int.random(in: 100..<300)
        
        acorn.physicsBody?.applyImpulse( CGVector(dx: randomImpulse, dy: 100) )
    }
    
    func removeAcorns() {
        for n in self.children {
            if(n.name == "acorn") {
                n.removeFromParent()
            }
        }
        number_of_acorns = 0
    }
    
    func scoreAcorn(acorn: SKPhysicsBody){
        if ( acorn.node?.removeFromParent() != nil ) {
            score += 1
            number_of_acorns -= 1
            score_display.text = String(score)
        }
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
            
            if(game_scene == game_mode.title) {
                if(self.atPoint(location).name == "PLAY") {
                    play_button.texture = SKTexture(imageNamed: "play_pressed")
                    button_pressed = true
                    button_pressable = true
                } else {
                    button_pressed = false
                    button_pressable = false
                }
            } else if(game_scene == game_mode.game) {
                for i in 1...4 {
                    if(overNut(x: location.x, nut: i)) {
                        moveNut(nut: i)
                    }
                }
            }
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let location = touch.location(in: self)
            let previous_location = touch.previousLocation(in: self)
            
            if(game_scene == game_mode.title) {
                if(self.atPoint(location).name == "PLAY" && button_pressable) {
                    play_button.texture = SKTexture(imageNamed: "play_pressed")
                    button_pressed = true
                } else {
                    play_button.texture = SKTexture(imageNamed: "play")
                    button_pressed = false
                }
            } else if(game_scene == game_mode.game || game_scene == game_mode.over) {
                    for i in 1...4 {
                        if (overNut(x: location.x, nut: i)) {
                            moveNut(nut: i)
                        } else if (overNut(x: previous_location.x, nut: i)) {
                            returnNut(nut: i)
                        }
                    }
            }
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let previous_location = touch.previousLocation(in: self)
            
            if(game_scene == game_mode.title) {
                if(button_pressed) {
                    button_pressed = false
                    button_pressable = false
                    startGame()
                } else {
                    button_pressable = false
                }
            } else if(game_scene == game_mode.game || game_scene == game_mode.over) {
                for i in 1...4 {
                    if(overNut(x: previous_location.x, nut: i)) {
                        returnNut(nut: i)
                    }
                }
            }
            if(restart_ready) {
                startTitle()
            }
        }
    }
    
    func moveNut(nut: Int) {
        nutArray[nut-1].run(SKAction.moveTo(y: (nut_height / 2) + floor_height - (screen_height), duration: 0.05))
    }
    
    func returnNut(nut: Int) {
        nutArray[nut-1].run(SKAction.move(to: startArray[nut-1], duration: 0.05))
    }
    
    func returnNuts() {
        for i in 1...4 {
            returnNut(nut: i)
        }
    }
    
    override func update(_ currentTime: TimeInterval){
        if(game_scene == game_mode.game) {
            if(number_of_acorns >= 25){
                gameOver()
            }
        } else if(game_scene == game_mode.over) {
            if (!restart_ready && pile.position == CGPoint(x: 0, y: screen_height)) {
                displayGameOver()
            }
        }
    }
}
