//
//  PlayGameScreen.swift
//  Lift-Off
//
//  Created by Ryan Schefske on 3/7/19.
//  Copyright © 2019 Ryan Schefske. All rights reserved.
//

import SpriteKit
import GameplayKit
import CoreMotion

class PlayGameScreen: SKScene, SKPhysicsContactDelegate {
    
    var rocket = SKSpriteNode()
    var cloud = SKSpriteNode()
    var cloud1 = SKSpriteNode()
    var explosion = SKSpriteNode()
    var explodingFrames: [SKTexture] = []
    
    var viewController = GameViewController()
    var motionManager = CMMotionManager()
    var destX = 0.0
    
    var score = 0
    var gatesPassed = 0
    var losses = 0
    var scoreLabel = SKLabelNode()
    
    var timer = Timer()
    var gemTimer = Timer()
    var fastTimer = Timer()
    var reallyFastTimer = Timer()
    
    let rocketCategory : UInt32 = 0x1 << 1
    let cloudCategory : UInt32 = 0x1 << 2
    let wallCategory : UInt32 = 0x1 << 3
    let gapCategory : UInt32 = 0x1 << 4
    let gemCategory : UInt32 = 0x1 << 5
    
    var gameOver = false
    var isTouching = false
    var quickClouds = false
    var reallyQuickClouds = false
    
    override func didMove(to view: SKView) {
        self.physicsWorld.contactDelegate = self
        
        //Gets gameover explosion
        getExplodeTextures()
        
        self.backgroundColor = backgroundColor
        physicsWorld.gravity = CGVector(dx: 0, dy: 0)
        setUpGame()
    }
    
    func setUpGame() {
        
        self.backgroundColor = screenColor
        
        //Move rocket based on tilt
        if motionManager.isAccelerometerAvailable {
            motionManager.accelerometerUpdateInterval = 0.01
            motionManager.startAccelerometerUpdates(to: .main) {
                (data, error) in
                guard let data = data, error == nil else { return }
                let currentX = self.rocket.position.x
                self.destX = Double(currentX + CGFloat(data.acceleration.x * 1300))
            }
        }
        
        //Make clouds initially
        timer = Timer.scheduledTimer(withTimeInterval: 1.75, repeats: true, block: { (timer) in
            self.makeClouds()
        })
        
        gemTimer = Timer.scheduledTimer(withTimeInterval: 12, repeats: true, block: { (gemTimer) in
            self.makeGems()
        })
        
        //Create rocket SpriteNode
        let rocketTexture1 = SKTexture(imageNamed: "rocket3")
        rocket = SKSpriteNode(imageNamed: "rocket3")
        rocket.size = CGSize(width: self.frame.width / 6.9, height: self.frame.width / 5)
        rocket.position = CGPoint(x: self.frame.midX, y: self.frame.midY - self.frame.height / 4)
        rocket.physicsBody = SKPhysicsBody(texture: rocketTexture1, size: rocket.size)
        rocket.physicsBody?.isDynamic = false
        rocket.physicsBody?.allowsRotation = false
        rocket.physicsBody?.contactTestBitMask = cloudCategory | gemCategory
        rocket.physicsBody?.categoryBitMask = rocketCategory
        rocket.physicsBody?.collisionBitMask = rocketCategory
        self.addChild(rocket)
        
        //Create animation behind rocket
        let rocketEmitter = SKEmitterNode(fileNamed: "RocketParticle.sks")
        if let emitter = rocketEmitter {
            emitter.position.y -= rocket.size.height / 2
            emitter.particleColor = emitterColor
            emitter.alpha = 1
            emitter.targetNode = self.scene
            rocket.addChild(emitter)
        }
        
        //Create Walls and add collision detection
        let wall1 = SKSpriteNode(color: UIColor.red, size: CGSize(width: 1, height: self.frame.height))
        wall1.position = CGPoint(x: self.frame.midX + -(self.frame.width / 2) - 1, y: self.frame.midY)
        wall1.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: 1, height: self.frame.height))
        wall1.physicsBody!.isDynamic = false
        wall1.physicsBody!.contactTestBitMask = cloudCategory
        wall1.physicsBody!.categoryBitMask = cloudCategory
        wall1.physicsBody!.collisionBitMask = cloudCategory
        self.addChild(wall1)
        
        let wall2 = SKSpriteNode(color: UIColor.red, size: CGSize(width: 1, height: self.frame.height))
        wall2.position = CGPoint(x: self.frame.midX + (self.frame.width / 2) + 1, y: self.frame.midY)
        wall2.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: 1, height: self.frame.height))
        wall2.physicsBody!.isDynamic = false
        wall2.physicsBody!.contactTestBitMask = cloudCategory
        wall2.physicsBody!.categoryBitMask = cloudCategory
        wall2.physicsBody!.collisionBitMask = cloudCategory
        self.addChild(wall2)
        
        //Add score label at top of screen
        scoreLabel.fontName = "Noteworthy"
        scoreLabel.fontSize = 60
        scoreLabel.text = "0"
        scoreLabel.position = CGPoint(x: self.frame.midX, y: self.frame.height / 2.5)
        scoreLabel.zPosition = 2
        self.addChild(scoreLabel)
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        if gameOver == false {
            if contact.bodyA.categoryBitMask == gapCategory {
                contact.bodyA.node?.removeFromParent()
                score += 1
                gatesPassed += 1
                scoreLabel.text = String(score)
                
                //Changes speed of clouds based on gatesPassed
                if gatesPassed == 14 || gatesPassed == 34 {
                    quickClouds = true
                    fastClouds()
                } else if gatesPassed == 19 || gatesPassed == 44 {
                    quickClouds = false
                    fastClouds()
                } else if gatesPassed == 54 || gatesPassed == 79 || gatesPassed == 104 {
                    reallyQuickClouds = true
                    reallyFastClouds()
                } else if gatesPassed == 59 || gatesPassed == 89 || gatesPassed == 119 {
                    reallyQuickClouds = false
                    reallyFastClouds()
                }
                
            } else if contact.bodyB.categoryBitMask == gapCategory {
                contact.bodyB.node?.removeFromParent()
                score += 1
                gatesPassed += 1
                scoreLabel.text = String(score)
                
                //Changes speed of clouds based on gatesPassed
                if gatesPassed == 14 || gatesPassed == 34 {
                    quickClouds = true
                    fastClouds()
                } else if gatesPassed == 19 || gatesPassed == 44 {
                    quickClouds = false
                    fastClouds()
                } else if gatesPassed == 54 || gatesPassed == 79 || gatesPassed == 104 {
                    reallyQuickClouds = true
                    reallyFastClouds()
                } else if gatesPassed == 59 || gatesPassed == 89 || gatesPassed == 119 {
                    reallyQuickClouds = false
                    reallyFastClouds()
                }
                
            } else if contact.bodyA.categoryBitMask == gemCategory {
                contact.bodyA.node?.removeFromParent()
                score += 3
                
                let gemLabel = SKLabelNode()
                gemLabel.fontName = "Noteworthy"
                gemLabel.fontSize = 40
                gemLabel.fontColor = UIColor.white
                gemLabel.text = "+3"
                gemLabel.position = CGPoint(x: contact.contactPoint.x, y: contact.contactPoint.y)
                self.addChild(gemLabel)
                let fadeAction = SKAction.fadeAlpha(to: 0, duration: 2)
                gemLabel.run(fadeAction)
                
                scoreLabel.text = String(score)
                
            } else if contact.bodyB.categoryBitMask == gemCategory {
                contact.bodyB.node?.removeFromParent()
                score += 3
                
                let gemLabel = SKLabelNode()
                gemLabel.fontName = "Noteworthy"
                gemLabel.fontSize = 40
                gemLabel.fontColor = UIColor.white
                gemLabel.text = "+3"
                gemLabel.position = CGPoint(x: contact.contactPoint.x, y: contact.contactPoint.y)
                self.addChild(gemLabel)
                let fadeAction = SKAction.fadeAlpha(to: 0, duration: 2)
                gemLabel.run(fadeAction)
                
                scoreLabel.text = String(score)
            } else {
                
                rocket.removeFromParent()
                gameOver = true
                
                let explodeAnimation = SKAction.animate(with: explodingFrames, timePerFrame: 0.05)
                let makeExplode = SKAction.sequence([explodeAnimation])
                
                explosion = SKSpriteNode(imageNamed: "tile1")
                explosion.run(makeExplode) {
                    self.gameOverScreen()
                }
                explosion.size = CGSize(width: self.frame.width / 2, height: self.frame.width / 2)
                explosion.position = CGPoint(x: contact.contactPoint.x, y: contact.contactPoint.y)
                explosion.zPosition = 2
                self.addChild(explosion)
            }
        }
    }
    
    func getExplodeTextures() {
        for i in 1...36 {
            let explodeTexture = SKTexture(imageNamed: "tile\(i)")
            explodingFrames.append(explodeTexture)
        }
    }
    
    func makeGems() {
        let moveGems = SKAction.move(by: CGVector(dx: 0, dy: -10 * self.frame.height), duration: TimeInterval(self.frame.height / 40))
        let moveAndRemoveGems = SKAction.sequence([moveGems, SKAction.removeFromParent()])
        
        let gemSize = self.frame.width / 9
        let gemOffset = CGFloat(arc4random() % UInt32(self.frame.width - gemSize))
        
        let gemTexture = SKTexture(imageNamed: "ruby")
        let gem = SKSpriteNode(imageNamed: "ruby")
        gem.size = CGSize(width: gemSize, height: gemSize)
        gem.position = CGPoint(x: self.frame.midX + -self.frame.width / 2 + gemSize / 2 + gemOffset, y: self.frame.midY + self.frame.height / 1.5)
        
        gem.physicsBody = SKPhysicsBody(texture: gemTexture, size: gem.size)
        
        gem.physicsBody?.isDynamic = false
        
        gem.physicsBody!.contactTestBitMask = rocketCategory
        gem.physicsBody!.categoryBitMask = gemCategory
        gem.physicsBody!.collisionBitMask = 0
        
        gem.run(moveAndRemoveGems)
        self.addChild(gem)
    }
    
    func makeClouds() {
        var speed = CGFloat(-10.0)
        let width = self.frame.width / 1.6
        let height = self.frame.height / 7
        var gapWidth = rocket.size.width * 1.5
        
        if gatesPassed <= 8 {
            gapWidth = rocket.size.width * 2.2
            speed = CGFloat(-10.0)
        } else if gatesPassed > 8 && gatesPassed <= 18 {
            gapWidth = rocket.size.width * 2
            speed = CGFloat(-11.0)
        } else if gatesPassed > 18 && gatesPassed <= 28 {
            gapWidth = rocket.size.width * 1.9
            speed = CGFloat(-12.0)
        } else if gatesPassed > 28 && gatesPassed <= 38 {
            gapWidth = rocket.size.width * 1.8
            speed = CGFloat(-13.0)
        } else if gatesPassed > 38 && gatesPassed <= 57 {
            gapWidth = rocket.size.width * 1.7
            speed = CGFloat(-14.0)
        } else if gatesPassed > 57 && gatesPassed <= 75 {
            gapWidth = rocket.size.width * 1.5
            speed = CGFloat(-15.0)
        } else if gatesPassed > 75 && gatesPassed <= 100 {
            gapWidth = rocket.size.width * 1.4
            speed = CGFloat(-16.0)
        } else if gatesPassed > 100 && gatesPassed <= 120 {
            gapWidth = rocket.size.width * 1.3
            speed = CGFloat(-17.0)
        } else if gatesPassed > 120 && gatesPassed <= 150 {
            gapWidth = rocket.size.width * 1.2
            speed = CGFloat(-18.0)
        } else if gatesPassed > 150 && gatesPassed <= 180 {
            gapWidth = rocket.size.width * 1.1
            speed = CGFloat(-19.0)
        } else if gatesPassed > 180 {
            gapWidth = rocket.size.width * 1
            speed = CGFloat(-20.0)
        }
        
        let moveClouds = SKAction.move(by: CGVector(dx: 0, dy: speed * self.frame.height), duration: TimeInterval(self.frame.height / 40))
        let moveAndRemoveClouds = SKAction.sequence([moveClouds, SKAction.removeFromParent()])
        
        let movementAmount = arc4random() % UInt32(self.frame.width / 2)
        let cloudOffset = CGFloat(movementAmount) - self.frame.width / 4
        
        let cloudTexture = SKTexture(imageNamed: cloudColor)
        let cloud = SKSpriteNode(imageNamed: cloudColor)
        cloud.size = CGSize(width: width, height: height)
        cloud.position = CGPoint(x: self.frame.midX + CGFloat(width) / 2 + gapWidth / 2 + cloudOffset, y: self.frame.midY + self.frame.height / 1.5)
        cloud.run(moveAndRemoveClouds)
        
        cloud.physicsBody = SKPhysicsBody(texture: cloudTexture, size: cloud.size)
        cloud.physicsBody?.isDynamic = false
        cloud.physicsBody?.contactTestBitMask = cloudCategory
        cloud.physicsBody?.categoryBitMask = cloudCategory
        cloud.physicsBody?.collisionBitMask = cloudCategory
        
        self.addChild(cloud)
        
        let cloud1 = SKSpriteNode(imageNamed: cloudColor)
        cloud1.size = CGSize(width: width, height: height)
        cloud1.position = CGPoint(x: self.frame.midX + -CGFloat(width) / 2 + -gapWidth / 2 + cloudOffset, y: self.frame.midY + self.frame.height / 1.5)
        cloud1.run(moveAndRemoveClouds)
        
        cloud1.physicsBody = SKPhysicsBody(texture: cloudTexture, size: cloud1.size)
        cloud1.physicsBody?.isDynamic = false
        cloud1.physicsBody?.contactTestBitMask = cloudCategory
        cloud1.physicsBody?.categoryBitMask = cloudCategory
        cloud1.physicsBody?.collisionBitMask = cloudCategory
        
        self.addChild(cloud1)
        
        let gap = SKNode()
        
        gap.position = CGPoint(x: self.frame.midX + cloudOffset, y: self.frame.midY + self.frame.height / 1.5)
        
        gap.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: width, height: height))
        
        gap.physicsBody!.isDynamic = false
        gap.run(moveAndRemoveClouds)
        
        gap.physicsBody!.contactTestBitMask = rocketCategory
        gap.physicsBody!.categoryBitMask = gapCategory
        gap.physicsBody!.collisionBitMask = gapCategory
        
        self.addChild(gap)
    }
    
    
    func fastClouds() {
        if quickClouds {
            quickClouds = false
            timer.invalidate()
            fastTimer = Timer.scheduledTimer(withTimeInterval: 1.1, repeats: true, block: { (timer) in
                self.makeClouds()
            })
        } else if quickClouds == false {
            fastTimer.invalidate()
            timer = Timer.scheduledTimer(withTimeInterval: 1.5, repeats: true, block: { (timer) in
                self.makeClouds()
            })
        }
    }
    
    func reallyFastClouds() {
        if reallyQuickClouds {
            reallyQuickClouds = false
            timer.invalidate()
            reallyFastTimer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { (timer) in
                self.makeClouds()
            })
        } else if reallyQuickClouds == false {
            reallyFastTimer.invalidate()
            timer = Timer.scheduledTimer(withTimeInterval: 1.5, repeats: true, block: { (timer) in
                self.makeClouds()
            })
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    }
    
    override func update(_ currentTime: TimeInterval) {
        let action = SKAction.moveTo(x: CGFloat(destX), duration: 1)
        rocket.run(action)
        rocket.physicsBody?.isDynamic = true
    }
    
    func gameOverScreen() {
        timer.invalidate()
        gemTimer.invalidate()
        fastTimer.invalidate()
        reallyFastTimer.invalidate()
        
        if losses % 3 == 0 {
            //NotificationCenter.default.post(name: NSNotification.Name(rawValue: "showAd"), object: nil)
        }
        
        losses += 1
        
        removeAllChildren()
        
        let gameOverScreen = GameOverScreen(fileNamed: "GameOverScreen")
        gameOverScreen?.scaleMode = .fill
        gameOverScreen?.score = score
        self.view?.presentScene(gameOverScreen)
    }
    
}

