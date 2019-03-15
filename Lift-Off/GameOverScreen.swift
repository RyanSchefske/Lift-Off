//
//  GameOverScreen.swift
//  Lift-Off
//
//  Created by Ryan Schefske on 3/7/19.
//  Copyright © 2019 Ryan Schefske. All rights reserved.
//

import Foundation
import SpriteKit

class GameOverScreen: SKScene {
    
    var score = 0
    
    let scoreLabel = SKLabelNode()
    let highScoreLabel = SKLabelNode()
    let newHighScore = SKLabelNode()
    let gameOverLabel = SKLabelNode()
    
    override func didMove(to view: SKView) {
        self.backgroundColor = screenColor
        
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
        
        let settingsButton = SKSpriteNode(imageNamed: "settings")
        settingsButton.size = CGSize(width: 100, height: 100)
        settingsButton.position = CGPoint(x: self.frame.width / 3, y: -self.frame.height / 5)
        settingsButton.name = "settings"
        self.addChild(settingsButton)
        
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
        
        let gameOverCloud = SKSpriteNode(imageNamed: "cloudWhite")
        gameOverCloud.size = CGSize(width: self.frame.width / 2, height: self.frame.height / 6)
        gameOverCloud.position = CGPoint(x: self.frame.midX + self.frame.width / 2.5, y: self.frame.midY + self.frame.height / 4.5)
        
        let gameOverCloud1 = SKSpriteNode(imageNamed: "cloudWhite")
        gameOverCloud1.size = CGSize(width: self.frame.width / 2, height: self.frame.height / 6)
        gameOverCloud1.position = CGPoint(x: self.frame.midX - self.frame.width / 2.5, y: self.frame.midY - self.frame.height / 5.5)
        
        self.addChild(gameOverCloud)
        self.addChild(gameOverCloud1)
        self.addChild(scoreLabel)
        self.addChild(gameOverLabel)
        self.addChild(highScoreLabel)
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
}
