//
//  GameScene.swift
//  Bulldog Blocker
//
//  Created by Drew Bies on 11/27/20.
//
//

import SpriteKit
import GameplayKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    var activeBalls: [SKSpriteNode] = [SKSpriteNode]()
    var ball: SKSpriteNode = SKSpriteNode(imageNamed: "basketball")
    var inactiveBalls: [SKSpriteNode] = [SKSpriteNode]()
    var block: SKSpriteNode = SKSpriteNode(imageNamed: "blocker")
    var inactiveBlockers: [SKSpriteNode] = [SKSpriteNode]()
    var activeBlockers: [SKSpriteNode] = [SKSpriteNode]()
    var hoop = SKSpriteNode()
    
    func setup(){
        print("setup")
        physicsWorld.gravity = .zero
        physicsWorld.contactDelegate = self
        hoop = self.childNode(withName: "hoop") as! SKSpriteNode
        hoop.physicsBody = SKPhysicsBody(rectangleOf: hoop.size)
        hoop.physicsBody?.isDynamic = false
        hoop.physicsBody!.contactTestBitMask = UInt32(1)
        addBall()
        addBlock()
        
        
        
    }
    
    // runs when the scene is displayed
    override func didMove(to view: SKView) {
        self.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        setup()
        //addBall()
        //addBlock()
        //addBall()
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
            //let ball = SKSpriteNode(imageNamed: "basketball")
            ball.size.height = 50.0
            ball.size.width = 50.0
            ball.name = "ball"
            ball.position.x = 0.0
            ball.position.y = -260.0
            ball.physicsBody = SKPhysicsBody(rectangleOf: ball.size)
            ball.physicsBody?.isDynamic = false
            ball.physicsBody!.contactTestBitMask = UInt32(2)
            block.physicsBody?.collisionBitMask = UInt32(2)
            activeBalls.append(ball)
            self.addChild(ball)
        } else{
            // reuse the balls from the inactive ball array
            if let ball = inactiveBalls.popLast(){
                ball.position.x = 0.0
                ball.position.y = -240.0
            }
            
        }
    }
    
    func addBlock() {
        // if there is no ball to reuse, make a new one
        if inactiveBlockers.count == 0{
            //let ball = SKSpriteNode(imageNamed: "basketball")
            block.size.height = 50.0
            block.size.width = 50.0
            block.name = "block"
            block.position.x = -250.0
            block.position.y = 200.0
            block.physicsBody = SKPhysicsBody(circleOfRadius: block.size.width/2)
            block.physicsBody?.isDynamic = true
            block.physicsBody!.contactTestBitMask = UInt32(2)
            block.physicsBody?.collisionBitMask = UInt32(2)
            activeBlockers.append(block)
            self.addChild(block)
        } else{
            // reuse the balls from the inactive ball array
            if let blocker = inactiveBlockers.popLast(){
                blocker.position.x = 100.0
                blocker.position.y = 100.0
            }
            
        }
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        let nodeA = contact.bodyA.node!
        let nodeB = contact.bodyB.node!
        let bodyNameA = String(describing: nodeA.name)
        let bodyNameB = String(describing: nodeB.name)
        if let alphaName = nodeA.name {
            if let bravoName = nodeB.name {
                if alphaName == "block" && bravoName == "ball"{
                    nodeB.removeFromParent()
                }
                else if alphaName == "ball" && bravoName == "block" {
                    nodeA.removeFromParent()
                }
            }
        }
        print("Contact: \(bodyNameA), \(bodyNameB)")
    }

    
    func collisionBetween(ball: SKNode, object: SKNode) {
        print("collided")
        if object.name == "ball" {
            destroy(ball: ball)
        } else if object.name == "block" {
            destroy(ball: ball)
        }
    }

    func destroy(ball: SKNode) {
        print("destroyed")
        ball.removeFromParent()
    }

    func didBeginContact(contact: SKPhysicsContact){
        print("lol")
        scene?.view?.isPaused = true
        self.ball.setScale(12.0)
        if contact.bodyA.node?.name == "ball" {
                collisionBetween(ball: contact.bodyA.node!, object: contact.bodyB.node!)
            } else if contact.bodyB.node?.name == "ball" {
                collisionBetween(ball: contact.bodyB.node!, object: contact.bodyA.node!)
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
        for blocker in activeBlockers {
            blocker.position.x += 1.0
            blocker.position.y -= 1.0
        }
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
        for t in touches {
            self.touchUp(atPoint: t.location(in: self))
            let point = t.location(in: self)
            let nodeArray = nodes(at: point)
            for node in nodeArray {
                if let name = node.name {
                    if name == "block" {
                        node.removeFromParent()
                    }
                }
            }

        }
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchUp(atPoint: t.location(in: self)) }
    }
    
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
    }
}

