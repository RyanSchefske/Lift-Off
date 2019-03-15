//
//  GameScene.swift
//  Rocket
//
//  Created by Ryan Schefske on 12/18/18.
//  Copyright © 2018 Ryan Schefske. All rights reserved.
//

var screenColor = UIColor(red: 0, green: 0.6, blue: 1, alpha: 0.5)

import SpriteKit

class GameScene: SKScene {
    var gameOver = false
    
    override func didMove(to view: SKView) {
        if let tempColor = UserDefaults.standard.colorForKey(key: "screenColor") {
            screenColor = tempColor
        }
        if let tempColor = UserDefaults.standard.colorForKey(key: "emitterColor") {
            emitterColor = tempColor
        }
        self.backgroundColor = screenColor
        startScreen()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first
        if let location = touch?.location(in: self) {
            let theNodes = nodes(at: location)
            
            for node in theNodes {
                if node.name == "play" {
                    let playScreen = PlayGameScreen(fileNamed: "PlayGameScreen")
                    playScreen?.scaleMode = .fill
                    self.view?.presentScene(playScreen)
                }
                if node.name == "settings" {
                    let settings = SettingsScreen(fileNamed: "SettingsScreen")
                    settings?.scaleMode = .fill
                    self.view?.presentScene(settings)
                }
            }
        }
        
    }
    
    func startScreen() {
        gameOver = true
        removeAllChildren()
        
        let startCloud = SKSpriteNode(imageNamed: "cloudWhite")
        startCloud.size = CGSize(width: self.frame.width / 2, height: self.frame.height / 6)
        startCloud.position = CGPoint(x: self.frame.midX + self.frame.width / 2.5, y: self.frame.midY + self.frame.height / 4.5)
        
        let startCloud1 = SKSpriteNode(imageNamed: "cloudWhite")
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
        
        let settingsButton = SKSpriteNode(imageNamed: "settings")
        settingsButton.size = CGSize(width: 100, height: 100)
        settingsButton.position = CGPoint(x: self.frame.width / 3, y: -self.frame.height / 5)
        settingsButton.name = "settings"
        self.addChild(settingsButton)
        
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

extension UserDefaults {
    func setColor(color: UIColor?, forKey key: String) {
        var colorData: NSData?
        if let color = color {
            colorData = NSKeyedArchiver.archivedData(withRootObject: color) as NSData?
        }
        set(colorData, forKey: key)
    }
    func colorForKey(key: String) -> UIColor? {
        var color: UIColor?
        if let colorData = data(forKey: key) {
            color = NSKeyedUnarchiver.unarchiveObject(with: colorData) as? UIColor
        }
        return color
    }
}
