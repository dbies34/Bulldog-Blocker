//
//  GameScene.swift
//  Bulldog Blocker
//
//  Created by Drew Bies on 11/27/20.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    
    var ballArray: [SKSpriteNode] = [SKSpriteNode]()
    var hoop = SKSpriteNode()
    
    func setup(){
        print("setup")
        hoop = self.childNode(withName: "hoop") as! SKSpriteNode
        // fill the ball array
        for _ in 0...10 {
            var ball = SKSpriteNode(imageNamed: "basketball")
            ball.size.height = 50.0
            ball.size.width = 50.0
            ball.position.x = 10.0
            ball.position.y = 10.0
            
            ballArray.append(ball)
        }
    }
    
    override func didMove(to view: SKView) {
        self.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        setup()
       
    }
    
    
    func touchDown(atPoint pos : CGPoint) {
        print("touch down")
        
    }
    
    func touchMoved(toPoint pos : CGPoint) {
       
    }
    
    func touchUp(atPoint pos : CGPoint) {
       
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
       
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
    
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
    }
}
