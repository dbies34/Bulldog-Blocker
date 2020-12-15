//
//  MainMenu.swift
//  Bulldog Blocker
//
//  Created by Jackson  Ricks on 12/14/20.
//

import Foundation
import SpriteKit
import GameplayKit
import UIKit

class MainMenu: SKScene {
    // runs when the scene is displayed
    var background = SKSpriteNode()
    var title = SKSpriteNode()
    var logo = SKSpriteNode()
    var button = SKSpriteNode()
        
    override func didMove(to view: SKView) {
        
        
        isPaused = false
        background = SKSpriteNode(imageNamed: "mainmenu")
        background.zRotation = CGFloat.pi / 2
        background.zPosition = -1
        background.size = CGSize(width: self.frame.height, height: self.frame.width)
        
        title = SKSpriteNode(imageNamed: "title")
        title.size = CGSize(width: self.frame.width - 50, height: 100)
        title.position = CGPoint(x: self.frame.midX, y: self.frame.maxY - 75)
        addChild(title)
        
        logo = SKSpriteNode(imageNamed: "Bulldog")
        logo.size = CGSize(width: 75, height: 75)
        logo.position = CGPoint(x: self.frame.midX, y: self.frame.maxY - 175)
        addChild(logo)
        
        button = SKSpriteNode(imageNamed: "playButton")
        button.size = CGSize(width: 75, height: 75)
        button.position = CGPoint(x: self.frame.midX, y: self.frame.maxY - 300)
        button.name = "button"
        addChild(button)
        
        addChild(background)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches {
            //self.touchUp(atPoint: t.location(in: self))
            let point = t.location(in: self)
            let nodeArray = nodes(at: point)
            for node in nodeArray {
                if let name = node.name {
                    if name == "button" {
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
                    }
                }
            }

        }
    }
}
