//
//  GameOver.swift
//  Bulldog Blocker
//
//  Created by Drew Bies on 12/14/20.
//

import Foundation
import SpriteKit
import GameplayKit
import UIKit

class GameOver: SKScene {
    // runs when the scene is displayed
    var background = SKSpriteNode()
    var title = SKLabelNode()
    var scoreLabel = SKLabelNode()
    var playLabel = SKLabelNode()
    var exitLabel = SKLabelNode()
    var playButton = SKSpriteNode()
    var exitButton = SKSpriteNode()
    
    var scoreOptional: Int? = nil
        
    override func didMove(to view: SKView) {
        
        isPaused = false
        background = SKSpriteNode(imageNamed: "mainmenu")
        background.zRotation = CGFloat.pi / 2
        background.zPosition = -1
        background.size = CGSize(width: self.frame.height, height: self.frame.width)
        addChild(background)
        
        title.text = "Game Over!"
        title.fontName = "CopperPlate"
        title.fontSize = 100
        title.position = CGPoint(x: self.frame.midX, y: self.frame.maxY - 75)
        addChild(title)
        
        if let score = scoreOptional {
            scoreLabel.text = "You scored \(score) points!"
            scoreLabel.fontName = "CopperPlate"
            scoreLabel.fontSize = 50
            scoreLabel.position = CGPoint(x: self.frame.midX, y: self.frame.maxX - 100)
            addChild(scoreLabel)
        }
        
        
        
        playButton = SKSpriteNode(imageNamed: "blank_button")
        playButton.size = CGSize(width: 440, height: 150)
        playButton.position = CGPoint(x: self.frame.midX, y: self.frame.maxY - 300)
        playButton.name = "playButton"
        playLabel.fontName = "CopperPlate"
        playLabel.fontSize = 70
        playLabel.text = "Play Again?"
        playLabel.zPosition = 1
        playLabel.position = CGPoint(x: self.frame.midX, y: self.frame.maxY - 320)
        addChild(playLabel)
        addChild(playButton)
        
        exitButton = SKSpriteNode(imageNamed: "blank_button")
        exitButton.size = CGSize(width: 440, height: 150)
        exitButton.position = CGPoint(x: self.frame.midX, y: self.frame.maxY - 500)
        exitButton.name = "playButton"
        exitLabel.fontName = "CopperPlate"
        exitLabel.fontSize = 55
        exitLabel.position = exitButton.position
        exitButton.addChild(exitLabel)
        addChild(exitButton)
        
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches {
            //self.touchUp(atPoint: t.location(in: self))
            let point = t.location(in: self)
            let nodeArray = nodes(at: point)
            for node in nodeArray {
                if let name = node.name {
                    if name == "playButton" {
                        guard let skView = self.view else {
                                print("Could not get Skview")
                                return
                            }

                            /* 2) Load Game scene */
                            guard let scene = GameScene(fileNamed:"GameScene") else {
                                print("Could not make GameScene, check the name is spelled correctly")
                                return
                            }

                            /* 3) Ensure correct aspect mode */
                            scene.scaleMode = .aspectFill

                            /* Show debug */
                            skView.showsPhysics = true
                            skView.showsDrawCount = true
                            skView.showsFPS = true

                            /* 4) Start game scene */
                            skView.presentScene(scene)
                    } else if name == "exitButton"{
                        // exit the game
                        exit(1)
                    }
                }
            }

        }
    }
}
