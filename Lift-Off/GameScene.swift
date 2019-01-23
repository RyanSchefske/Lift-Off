//
//  GameScene.swift
//  Rocket
//
//  Created by Ryan Schefske on 12/18/18.
//  Copyright © 2018 Ryan Schefske. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    var rocket = SKSpriteNode()
    var cloud = SKSpriteNode()
    var cloud1 = SKSpriteNode()
    var explosion = SKSpriteNode()
    var explodingFrames: [SKTexture] = []
    
    var viewController = GameViewController()
    
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
    
    func makeClouds() {
        let moveClouds = SKAction.move(by: CGVector(dx: 0, dy: -10 * self.frame.height), duration: TimeInterval(self.frame.height / 40))
        let moveAndRemoveClouds = SKAction.sequence([moveClouds, SKAction.removeFromParent()])
        
        let width = self.frame.width / 1.6
        let height = self.frame.height / 7
        var gapWidth = rocket.size.width * 1.5
        if gatesPassed <= 8 {
            gapWidth = rocket.size.width * 1.5
        } else if gatesPassed > 8 && gatesPassed <= 18 {
            gapWidth = rocket.size.width * 1.4
        } else if gatesPassed > 18 && gatesPassed <= 28 {
            gapWidth = rocket.size.width * 1.3
        } else if gatesPassed > 28 && gatesPassed <= 38 {
            gapWidth = rocket.size.width * 1.2
        } else if gatesPassed > 38 && gatesPassed <= 57 {
            gapWidth = rocket.size.width * 1.1
        } else if gatesPassed > 57 && gatesPassed <= 75 {
            gapWidth = rocket.size.width * 1
        } else if gatesPassed > 75 && gatesPassed <= 100 {
            gapWidth = rocket.size.width * 0.95
        } else if gatesPassed > 100 && gatesPassed <= 120 {
            gapWidth = rocket.size.width * 0.9
        } else if gatesPassed > 120 && gatesPassed <= 150 {
            gapWidth = rocket.size.width * 0.87
        } else if gatesPassed > 150 && gatesPassed <= 180 {
            gapWidth = rocket.size.width * 0.83
        } else if gatesPassed > 180 {
            gapWidth = rocket.size.width * 0.8
        }
        
        let movementAmount = arc4random() % UInt32(self.frame.width / 2)
        let cloudOffset = CGFloat(movementAmount) - self.frame.width / 4
        
        let cloudTexture = SKTexture(imageNamed: "cloud6")
        let cloud = SKSpriteNode(imageNamed: "cloud6")
        cloud.size = CGSize(width: width, height: height)
        cloud.position = CGPoint(x: self.frame.midX + CGFloat(width) / 2 + gapWidth / 2 + cloudOffset, y: self.frame.midY + self.frame.height / 1.5)
        cloud.run(moveAndRemoveClouds)
        
        cloud.physicsBody = SKPhysicsBody(texture: cloudTexture, size: cloud.size)
        cloud.physicsBody?.isDynamic = false
        cloud.physicsBody?.contactTestBitMask = cloudCategory
        cloud.physicsBody?.categoryBitMask = cloudCategory
        cloud.physicsBody?.collisionBitMask = cloudCategory
        
        self.addChild(cloud)
        
        let cloud1 = SKSpriteNode(imageNamed: "cloud6")
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
    
    func didBegin(_ contact: SKPhysicsContact) {
        if gameOver == false {
            if contact.bodyA.categoryBitMask == gapCategory {
                contact.bodyA.node?.removeFromParent()
                score += 1
                gatesPassed += 1
                scoreLabel.text = String(score)
                
                if gatesPassed == 15 || gatesPassed == 55 {
                    quickClouds = true
                    fastClouds()
                } else if gatesPassed == 20 || gatesPassed == 65 {
                    quickClouds = false
                    fastClouds()
                } else if gatesPassed == 35 || gatesPassed == 80 || gatesPassed == 105 {
                    reallyQuickClouds = true
                    reallyFastClouds()
                } else if gatesPassed == 40 || gatesPassed == 90 || gatesPassed == 120 {
                    reallyQuickClouds = false
                    reallyFastClouds()
                }
                
            } else if contact.bodyB.categoryBitMask == gapCategory {
                contact.bodyB.node?.removeFromParent()
                score += 1
                gatesPassed += 1
                scoreLabel.text = String(score)
                
                if gatesPassed == 15 || gatesPassed == 55 {
                    quickClouds = true
                    fastClouds()
                } else if gatesPassed == 20 || gatesPassed == 65 {
                    quickClouds = false
                    fastClouds()
                } else if gatesPassed == 35 || gatesPassed == 80 {
                    reallyQuickClouds = true
                    reallyFastClouds()
                } else if gatesPassed == 40 || gatesPassed == 90 {
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
    
    
    func fastClouds() {
        if quickClouds {
            quickClouds = false
            timer.invalidate()
            fastTimer = Timer.scheduledTimer(withTimeInterval: 1.25, repeats: true, block: { (timer) in
                self.makeClouds()
            })
        } else if quickClouds == false {
            fastTimer.invalidate()
            timer = Timer.scheduledTimer(withTimeInterval: 2, repeats: true, block: { (timer) in
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
            timer = Timer.scheduledTimer(withTimeInterval: 2, repeats: true, block: { (timer) in
                self.makeClouds()
            })
        }
    }
    
    override func didMove(to view: SKView) {
        self.physicsWorld.contactDelegate = self
        
        getExplodeTextures()
        
        self.backgroundColor = UIColor(red: 0, green: 0.6, blue: 1, alpha: 0.5)
        physicsWorld.gravity = CGVector(dx: 6, dy: 0)
        startScreen()
    }
    
    func setUpGame() {
        
        self.backgroundColor = UIColor(red: 0, green: 0.6, blue: 1, alpha: 0.5)
        
        timer = Timer.scheduledTimer(withTimeInterval: 2, repeats: true, block: { (timer) in
            self.makeClouds()
        })
        
        gemTimer = Timer.scheduledTimer(withTimeInterval: 11.1, repeats: true, block: { (gemTimer) in
            self.makeGems()
        })
        
        let rocketTexture1 = SKTexture(imageNamed: "rocket1")
        let rocketTexture2 = SKTexture(imageNamed: "rocket2")
        
        let animation = SKAction.animate(with: [rocketTexture1,rocketTexture2], timePerFrame: 0.2)
        let makeRocketFly = SKAction.repeatForever(animation)
        
        rocket = SKSpriteNode(imageNamed: "rocket1")
        rocket.run(makeRocketFly)
        rocket.size = CGSize(width: self.frame.width / 4.75, height: self.frame.width / 4.75)
        rocket.physicsBody = SKPhysicsBody(texture: rocketTexture1, size: rocket.size)
        
        rocket.position = CGPoint(x: self.frame.midX, y: self.frame.midY - self.frame.height / 4)
        
        rocket.physicsBody?.isDynamic = false
        rocket.physicsBody?.allowsRotation = false
        rocket.physicsBody?.contactTestBitMask = cloudCategory | gemCategory
        rocket.physicsBody?.categoryBitMask = rocketCategory
        rocket.physicsBody?.collisionBitMask = rocketCategory
        
        self.addChild(rocket)
        
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
        
        scoreLabel.fontName = "Noteworthy"
        scoreLabel.fontSize = 60
        scoreLabel.text = "0"
        scoreLabel.position = CGPoint(x: self.frame.midX, y: self.frame.height / 2.5)
        scoreLabel.zPosition = 2
        
        self.addChild(scoreLabel)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if gameOver == false {
            isTouching = true
        }
        
        let touch = touches.first
        if let location = touch?.location(in: self) {
            let theNodes = nodes(at: location)
            
            for node in theNodes {
                if node.name == "play" {
                    score = 0
                    gatesPassed = 0
                    gameOver = false
                    self.speed = 1
                    self.removeAllChildren()
                    setUpGame()
                }
            }
        }
        
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        isTouching = false
    }
    
    override func update(_ currentTime: TimeInterval) {
        if isTouching {
            rocket.physicsBody!.isDynamic = true
            physicsWorld.gravity = CGVector(dx: -6, dy: 0)
        } else {
            physicsWorld.gravity = CGVector(dx: 6, dy: 0)
        }
    }
    
    func gameOverScreen() {
        
        timer.invalidate()
        gemTimer.invalidate()
        fastTimer.invalidate()
        reallyFastTimer.invalidate()
        
        let scoreLabel = SKLabelNode()
        let highScoreLabel = SKLabelNode()
        let newHighScore = SKLabelNode()
        let gameOverLabel = SKLabelNode()
        
        if losses % 3 == 0 {
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "showAd"), object: nil)
        }
        
        losses += 1
        
        removeAllChildren()
        
        let gameOverTexture1 = SKTexture(imageNamed: "startRocket1")
        let gameOverTexture2 = SKTexture(imageNamed: "startRocket2")
        
        let gameOverAnimation = SKAction.animate(with: [gameOverTexture1, gameOverTexture2], timePerFrame: 0.2)
        let gameOverFly = SKAction.repeatForever(gameOverAnimation)
        
        let playButton = SKSpriteNode(imageNamed: "startRocket1")
        playButton.run(gameOverFly)
        playButton.size = CGSize(width: self.frame.width / 2, height: self.frame.width / 2)
        playButton.position = CGPoint(x: self.frame.midX, y: self.frame.midY)
        playButton.name = "play"
        self.addChild(playButton)
        
        let loadData = UserDefaults.standard
        var highScore = loadData.integer(forKey: "highScore")
        
        if score > highScore {
            highScore = score
            let saveData = UserDefaults.standard
            saveData.set(score, forKey: "highScore")
            saveData.synchronize()
            newHighScore.fontName = "Noteworthy"
            newHighScore.fontColor = UIColor.yellow
            newHighScore.fontSize = 75
            newHighScore.text = "New High Score!"
            newHighScore.position = CGPoint(x: self.frame.midX, y: -self.frame.height / 2 + 260)
            self.addChild(newHighScore)
        }
        
        scoreLabel.fontName = "Noteworthy"
        scoreLabel.fontSize = 75
        scoreLabel.text = "Score: \(score)"
        scoreLabel.position = CGPoint(x: self.frame.midX, y: self.frame.height / 2 - 250)
        
        gameOverLabel.fontName = "Noteworthy"
        gameOverLabel.fontSize = 100
        gameOverLabel.text = "Game Over"
        gameOverLabel.position = CGPoint(x: self.frame.midX, y: self.frame.height / 2 - 150)
        
        highScoreLabel.fontName = "Noteworthy"
        highScoreLabel.fontSize = 75
        highScoreLabel.text = "High Score: \(highScore)"
        highScoreLabel.position = CGPoint(x: self.frame.midX, y: -self.frame.height / 2 + 175)
        
        let gameOverCloud = SKSpriteNode(imageNamed: "cloud6")
        gameOverCloud.size = CGSize(width: self.frame.width / 2, height: self.frame.height / 6)
        gameOverCloud.position = CGPoint(x: self.frame.midX + self.frame.width / 2.5, y: self.frame.midY + self.frame.height / 4.5)
        
        let gameOverCloud1 = SKSpriteNode(imageNamed: "cloud6")
        gameOverCloud1.size = CGSize(width: self.frame.width / 2, height: self.frame.height / 6)
        gameOverCloud1.position = CGPoint(x: self.frame.midX - self.frame.width / 2.5, y: self.frame.midY - self.frame.height / 5.5)
        
        self.addChild(gameOverCloud)
        self.addChild(gameOverCloud1)
        self.addChild(scoreLabel)
        self.addChild(gameOverLabel)
        self.addChild(highScoreLabel)
    }
    
    func startScreen() {
        
        gameOver = true
        removeAllChildren()
        
        let startCloud = SKSpriteNode(imageNamed: "cloud6")
        startCloud.size = CGSize(width: self.frame.width / 2, height: self.frame.height / 6)
        startCloud.position = CGPoint(x: self.frame.midX + self.frame.width / 2.5, y: self.frame.midY + self.frame.height / 4.5)
        
        let startCloud1 = SKSpriteNode(imageNamed: "cloud6")
        startCloud1.size = CGSize(width: self.frame.width / 2, height: self.frame.height / 6)
        startCloud1.position = CGPoint(x: self.frame.midX - self.frame.width / 2.5, y: self.frame.midY - self.frame.height / 5.5)
        self.addChild(startCloud)
        self.addChild(startCloud1)
        
        let startTexture1 = SKTexture(imageNamed: "startRocket1")
        let startTexture2 = SKTexture(imageNamed: "startRocket2")
        
        let startAnimation = SKAction.animate(with: [startTexture1, startTexture2], timePerFrame: 0.2)
        let startFly = SKAction.repeatForever(startAnimation)
        
        let playButton = SKSpriteNode(imageNamed: "startRocket1")
        playButton.run(startFly)
        playButton.size = CGSize(width: self.frame.width / 2, height: self.frame.width / 2)
        playButton.position = CGPoint(x: self.frame.midX, y: self.frame.midY)
        playButton.name = "play"
        self.addChild(playButton)
        
        let loadData = UserDefaults.standard
        let highScore = loadData.integer(forKey: "highScore")
        
        let highScoreLabel = SKLabelNode()
        highScoreLabel.fontName = "Noteworthy"
        highScoreLabel.fontSize = 75
        highScoreLabel.text = "High Score: \(highScore)"
        highScoreLabel.position = CGPoint(x: self.frame.midX, y: -self.frame.height / 2 + 175)
        
        let nameLabel = SKLabelNode()
        nameLabel.fontName = "Noteworthy"
        nameLabel.fontSize = 150
        nameLabel.text = "Lift-Off!"
        nameLabel.position = CGPoint(x: self.frame.midX, y: self.frame.height / 2 - 250)
        
        self.addChild(highScoreLabel)
        self.addChild(nameLabel)
    }
    
}
