//
//  SettingsScreen.swift
//  Lift-Off
//
//  Created by Ryan Schefske on 3/7/19.
//  Copyright © 2019 Ryan Schefske. All rights reserved.
//

import Foundation
import SpriteKit

var emitterColor = UIColor.orange
var cloudColor = "cloudWhite"

class SettingsScreen: SKScene {
    
    var selectedNode = SKNode()
    var backgroundLabel = SKLabelNode()
    var emitterLabel = SKLabelNode()
    var bgSelected = true
    
    override func didMove(to view: SKView) {
        self.backgroundColor = screenColor
        settingsScreen()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first
        if let location = touch?.location(in: self) {
            let theNodes = nodes(at: location)
            
            for node in theNodes {
                if node.name == "homeButton" {
                    let homeScreen = GameScene(fileNamed: "GameScene")
                    homeScreen?.scaleMode = .fill
                    self.view?.presentScene(homeScreen)
                }
                if node.name == "backgroundLabel" {
                    if bgSelected == false {
                        bgSelected = true
                        emitterLabel.alpha = 1
                        node.alpha = 0.3
                    }
                }
                if node.name == "emitterLabel" {
                    if bgSelected == true {
                        bgSelected = false
                        backgroundLabel.alpha = 1
                        node.alpha = 0.3
                    }
                }
                if node.name == "blueNode" {
                    selectedNode.alpha = 1
                    selectedNode = node
                    node.alpha = 0.7
                    if bgSelected == true {
                        screenColor = UIColor(red: 0, green: 0.6, blue: 1, alpha: 0.5)
                        UserDefaults.standard.setColor(color: screenColor, forKey: "screenColor")
                    } else {
                        emitterColor = UIColor(red: 0, green: 0.6, blue: 1, alpha: 0.5)
                        UserDefaults.standard.setColor(color: emitterColor, forKey: "emitterColor")
                    }
                }
                if node.name == "redNode" {
                    selectedNode.alpha = 1
                    selectedNode = node
                    node.alpha = 0.7
                    if bgSelected == true {
                        screenColor = UIColor.red
                        UserDefaults.standard.setColor(color: screenColor, forKey: "screenColor")
                    } else {
                        emitterColor = UIColor.red
                        UserDefaults.standard.setColor(color: emitterColor, forKey: "emitterColor")
                    }
                }
                if node.name == "whiteNode" {
                    selectedNode.alpha = 1
                    selectedNode = node
                    node.alpha = 0.7
                    if bgSelected == true {
                        screenColor = UIColor.white
                        UserDefaults.standard.setColor(color: screenColor, forKey: "screenColor")
                    } else {
                        emitterColor = UIColor.white
                        UserDefaults.standard.setColor(color: emitterColor, forKey: "emitterColor")
                    }
                }
                if node.name == "orangeNode" {
                    selectedNode.alpha = 1
                    selectedNode = node
                    node.alpha = 0.7
                    if bgSelected == true {
                        screenColor = UIColor.orange
                        UserDefaults.standard.setColor(color: screenColor, forKey: "screenColor")
                    } else {
                        emitterColor = UIColor.orange
                        UserDefaults.standard.setColor(color: emitterColor, forKey: "emitterColor")
                    }
                }
                if node.name == "grayNode" {
                    selectedNode.alpha = 1
                    selectedNode = node
                    node.alpha = 0.7
                    if bgSelected == true {
                        screenColor = UIColor.darkGray
                        UserDefaults.standard.setColor(color: screenColor, forKey: "screenColor")
                    } else {
                        emitterColor = UIColor.darkGray
                        UserDefaults.standard.setColor(color: emitterColor, forKey: "emitterColor")
                    }
                }
                if node.name == "blackNode" {
                    selectedNode.alpha = 1
                    selectedNode = node
                    node.alpha = 0.7
                    if bgSelected == true {
                        screenColor = UIColor.black
                        UserDefaults.standard.setColor(color: screenColor, forKey: "screenColor")
                    } else {
                        emitterColor = UIColor.black
                        UserDefaults.standard.setColor(color: emitterColor, forKey: "emitterColor")
                    }
                }
                if node.name == "purpleNode" {
                    selectedNode.alpha = 1
                    selectedNode = node
                    node.alpha = 0.7
                    if bgSelected == true {
                        screenColor = UIColor.purple
                        UserDefaults.standard.setColor(color: screenColor, forKey: "screenColor")
                    } else {
                        emitterColor = UIColor.purple
                        UserDefaults.standard.setColor(color: emitterColor, forKey: "emitterColor")
                    }
                }
                if node.name == "pinkNode" {
                    selectedNode.alpha = 1
                    selectedNode = node
                    node.alpha = 0.7
                    if bgSelected == true {
                        screenColor = UIColor(red: 1, green: 0.3, blue: 0.85, alpha: 1)
                        UserDefaults.standard.setColor(color: screenColor, forKey: "screenColor")
                    } else {
                        emitterColor = UIColor(red: 1, green: 0.3, blue: 0.85, alpha: 1) 
                        UserDefaults.standard.setColor(color: emitterColor, forKey: "emitterColor")
                    }
                }
                if node.name == "cyanNode" {
                    selectedNode.alpha = 1
                    selectedNode = node
                    node.alpha = 0.7
                    if bgSelected == true {
                        screenColor = UIColor.cyan
                        UserDefaults.standard.setColor(color: screenColor, forKey: "screenColor")
                    } else {
                        emitterColor = UIColor.cyan
                        UserDefaults.standard.setColor(color: emitterColor, forKey: "emitterColor")
                    }
                }
                self.backgroundColor = screenColor
            }
        }
    }
    
    func settingsScreen() {
        let homeButton = SKSpriteNode(imageNamed: "left-arrow")
        homeButton.size = CGSize(width: self.frame.width / 10, height: self.frame.width / 10)
        homeButton.position = CGPoint(x: -self.frame.width / 3, y: self.frame.height / 2.5)
        homeButton.name = "homeButton"
        addChild(homeButton)
        
        let nameLabel = SKLabelNode()
        nameLabel.fontName = "Noteworthy"
        nameLabel.fontSize = 100
        nameLabel.text = "Settings"
        nameLabel.name = "nameLabel"
        nameLabel.position = CGPoint(x: self.frame.midX, y: self.frame.height / 2.7)
        addChild(nameLabel)
        
        backgroundLabel = SKLabelNode()
        backgroundLabel.fontName = "Noteworthy"
        backgroundLabel.fontSize = 60
        backgroundLabel.text = "Background"
        backgroundLabel.name = "backgroundLabel"
        backgroundLabel.alpha = 0.3
        backgroundLabel.position = CGPoint(x: -self.frame.width / 5, y: self.frame.height / 4)
        addChild(backgroundLabel)
        
        emitterLabel = SKLabelNode()
        emitterLabel.fontName = "Noteworthy"
        emitterLabel.fontSize = 60
        emitterLabel.text = "Trail"
        emitterLabel.name = "emitterLabel"
        emitterLabel.position = CGPoint(x: self.frame.width / 4, y: self.frame.height / 4)
        addChild(emitterLabel)
        
        let width = self.frame.width / 4
        let height = self.frame.height / 6
        
        let blueNode = SKShapeNode(rect: CGRect(x: -self.frame.width / 2.25, y: self.frame.height / 20, width: width, height: height), cornerRadius: 10)
        blueNode.name = "blueNode"
        blueNode.fillColor = UIColor(red: 0, green: 0.6, blue: 1, alpha: 1)
        addChild(blueNode)
        
        let whiteNode = SKShapeNode(rect: CGRect(x: -self.frame.width / 2.25 + width * 1.3, y: self.frame.height / 20, width: width, height: height), cornerRadius: 10)
        whiteNode.name = "whiteNode"
        whiteNode.fillColor = UIColor.white
        addChild(whiteNode)
        
        let orangeNode = SKShapeNode(rect: CGRect(x: self.frame.width / 5, y: self.frame.height / 20, width: width, height: height), cornerRadius: 10)
        orangeNode.name = "orangeNode"
        orangeNode.fillColor = UIColor.orange
        addChild(orangeNode)
        
        let redNode = SKShapeNode(rect: CGRect(x: -self.frame.width / 2.25, y: -self.frame.height / 7, width: width, height: height), cornerRadius: 10)
        redNode.name = "redNode"
        redNode.fillColor = UIColor.red
        addChild(redNode)
        
        let grayNode = SKShapeNode(rect: CGRect(x: -self.frame.width / 2.25  + width * 1.3, y: -self.frame.height / 7, width: width, height: height), cornerRadius: 10)
        grayNode.name = "grayNode"
        grayNode.fillColor = UIColor.darkGray
        addChild(grayNode)
        
        let blackNode = SKShapeNode(rect: CGRect(x: self.frame.width / 5, y: -self.frame.height / 7, width: width, height: height), cornerRadius: 10)
        blackNode.name = "blackNode"
        blackNode.fillColor = UIColor.black
        addChild(blackNode)
        
        let pinkNode = SKShapeNode(rect: CGRect(x: -self.frame.width / 2.25, y: -self.frame.height / 3, width: width, height: height), cornerRadius: 10)
        pinkNode.name = "pinkNode"
        pinkNode.fillColor = UIColor(red: 1, green: 0.3, blue: 0.85, alpha: 1)
        addChild(pinkNode)
        
        let purpleNode = SKShapeNode(rect: CGRect(x: -self.frame.width / 2.25 + width * 1.3, y: -self.frame.height / 3, width: width, height: height), cornerRadius: 10)
        purpleNode.name = "purpleNode"
        purpleNode.fillColor = UIColor.purple
        addChild(purpleNode)
        
        let cyanNode = SKShapeNode(rect: CGRect(x: self.frame.width / 5, y: -self.frame.height / 3, width: width, height: height), cornerRadius: 10)
        cyanNode.name = "cyanNode"
        cyanNode.fillColor = UIColor.cyan
        addChild(cyanNode)
    }
    
}

