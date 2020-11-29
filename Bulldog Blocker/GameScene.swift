//
//  GameScene.swift
//  Bulldog Blocker
//
//  Created by Drew Bies on 11/27/20.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    
    var activeBalls: [SKSpriteNode] = [SKSpriteNode]()
    var inactiveBalls: [SKSpriteNode] = [SKSpriteNode]()
    var hoop = SKSpriteNode()
    
    func setup(){
        print("setup")
        hoop = self.childNode(withName: "hoop") as! SKSpriteNode
 
        
    }
    
    // runs when the scene is displayed
    override func didMove(to view: SKView) {
        self.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        setup()
        addBall()
        // game loop
        run(SKAction.repeatForever(
            SKAction.sequence([
                SKAction.run(moveBalls),
                //SKAction.run(addBall),
                SKAction.run(moveEnemies),
                                SKAction.wait(forDuration: 0.01)])))
    }
    
    // add a new ball to the scene
    func addBall(){
        // if there is no ball to reuse, make a new one
        if inactiveBalls.count == 0{
            let ball = SKSpriteNode(imageNamed: "basketball")
            ball.size.height = 50.0
            ball.size.width = 50.0
            ball.position.x = 0.0
            ball.position.y = -260.0
            activeBalls.append(ball)
            addChild(ball)
        } else{
            // reuse the balls from the inactive ball array
            if let ball = inactiveBalls.popLast(){
                ball.position.x = 0.0
                ball.position.y = -240.0
            }
            
        }
        
        
        
    }
    
    // move the balls and check for collisions
    func moveBalls(){
        for ball in activeBalls{
            ball.position.y += 1.0
        }
    }
    
    // move the enemies towards the center and check for collisions
    func moveEnemies(){
        
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
