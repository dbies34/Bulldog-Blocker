//
//  GameScene.swift
//  Bulldog Blocker
//
//  Created by Drew Bies on 11/27/20.
//
//

import SpriteKit
import GameplayKit
import UIKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    // array for the balls
    var activeBalls: [SKSpriteNode] = [SKSpriteNode]()
    var inactiveBalls: [SKSpriteNode] = [SKSpriteNode]()
    
    // array for the blockers
    var inactiveBlockers: [SKSpriteNode] = [SKSpriteNode]()
    var activeBlockers: [SKSpriteNode] = [SKSpriteNode]()
    
    var ball = SKSpriteNode()
    var block = SKSpriteNode()
    var background = SKSpriteNode()
    var hoop = SKSpriteNode()
    var scoreLabel = SKLabelNode()
    
    var score = 0 {
        didSet {
            scoreLabel.text = "Score: \(score)"
            if (score >= 5) {
                scoreLabel.fontName = "CopperPlate" //50, 168, 82
                scoreLabel.fontColor = UIColor.red
            }
            let swishSound = SKAction.playSoundFileNamed("swoosh.mp3", waitForCompletion: false)
            self.run(swishSound)
        }
    }
    
    var timer: Timer? = nil
    
    
    enum NodeCategory: UInt32 {
        case basketball = 1
        case blocker = 2
        case hoop = 4
    }
    
    // setup the game scene
    func setup(){
        print("setup")
        physicsWorld.gravity = .zero
        self.physicsWorld.contactDelegate = self
        
        // add the hoop to the scene
        hoop = SKSpriteNode(imageNamed: "hoop")
        hoop.name = "hoop"
        hoop.position = CGPoint(x: self.frame.midX, y: 205.0)
        hoop.size = CGSize(width: 75.0, height: 90.0)
        hoop.physicsBody = SKPhysicsBody(circleOfRadius: 10)
        hoop.physicsBody?.isDynamic = false
        hoop.physicsBody?.categoryBitMask = NodeCategory.hoop.rawValue
        hoop.physicsBody?.contactTestBitMask = NodeCategory.basketball.rawValue
        addChild(hoop)
        
        // add a background to the scene
        background = SKSpriteNode(imageNamed: "court")
        background.zRotation = CGFloat.pi / 2
        background.zPosition = -1
        background.size = CGSize(width: self.frame.height, height: self.frame.width)
        addChild(background)

        // add a score label to the scene
        scoreLabel.fontSize = 30
        scoreLabel.fontName = "CopperPlate-Bold"
        scoreLabel.position = CGPoint(x: self.frame.midX, y: self.frame.maxY - 25)
        score = 0
        addChild(scoreLabel)
    }
    
    // setup the timer for which will spawn the balls and the blockers
    func setupTimer(){
        timer = Timer.scheduledTimer(withTimeInterval: 2, repeats: true, block: { (timer) in
            //self.addBall()
            self.addBlock()
            self.addRightBlock()
            self.addBlock()
        })
    }
    
    // runs when the scene is displayed
    override func didMove(to view: SKView) {
        self.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        self.physicsWorld.contactDelegate = self
        startGame()
    }
    
    func startGame(){
        setup()
        isPaused = false
        setupTimer()
    }
    
    func gameOver(){
        self.isPaused = true
        timer?.invalidate()
        timer = nil
        // TODO: show game over screen with score, quit and restart button
    }
    
    // add a new ball to the scene
    func addBall(){
        // animate the ball to rise up the screen
        let moveUp = SKAction.move(to: CGPoint(x: self.frame.midX, y: self.frame.maxY), duration: 2)
        let rotateBall = SKAction.rotate(byAngle: 2 * CGFloat.pi, duration: 1)
        let rotateForever = SKAction.repeatForever(rotateBall)
        
        let newBall = getBall()
        newBall.position.x = self.frame.midX
        newBall.position.y = self.frame.minY - ball.size.height / 2
        newBall.run(moveUp)
        newBall.run(rotateForever)
        
        activeBalls.append(newBall)
        addChild(newBall)
    }
    
    // add a new blocker to the scene
    func addBlock() {
        let newBlocker = getBlocker(side: true)
        // TODO: make blocker postition random
        let minRandY = Int(self.frame.minY + 100)
        let maxRandY = Int(self.frame.maxY - 100)
        let randY = CGFloat(Int.random(in: minRandY...maxRandY))
        newBlocker.position.x = -250.0
        newBlocker.position.y = randY
        // create and run the blocker animation
        let moveBlocker = SKAction.move(to: CGPoint(x: self.frame.midX, y: (newBlocker.position.y)), duration: Double.random(in: 0.5...1.5))
        let removeBlocker = SKAction.removeFromParent()
        let flyAnimation = SKAction.sequence([moveBlocker, removeBlocker])
        newBlocker.run(flyAnimation)
        // add the new blocker to the active array and to the scene
        activeBlockers.append(newBlocker)
        addChild(newBlocker)
    }
    
    // add a new right side blocker to the scene
    func addRightBlock() {
        let newBlocker = getBlocker(side: false)
        // TODO: make blocker postition random
        let minRandY = Int(self.frame.minY + 100)
        let maxRandY = Int(self.frame.maxY - 100)
        let randY = CGFloat(Int.random(in: minRandY...maxRandY))
        newBlocker.position.x = self.frame.maxX + 100
        newBlocker.position.y = randY
        // create and run the blocker animation
        let moveBlocker = SKAction.move(to: CGPoint(x: self.frame.midX, y: (newBlocker.position.y)), duration: Double.random(in: 0.5...1.5))
        let removeBlocker = SKAction.removeFromParent()
        let flyAnimation = SKAction.sequence([moveBlocker, removeBlocker])
        newBlocker.run(flyAnimation)
        // add the new blocker to the active array and to the scene
        activeBlockers.append(newBlocker)
        addChild(newBlocker)
    }
    
    //
    func getBall() -> SKSpriteNode{
        // if there is no ball to reuse, make a new one
        if inactiveBalls.count == 0{
            let ball = SKSpriteNode(imageNamed: "basketball")
            ball.size.height = 50.0
            ball.size.width = 50.0
            ball.name = "ball"
            ball.physicsBody = SKPhysicsBody(circleOfRadius: ball.size.width / 2)
            //ball.physicsBody?.isDynamic = false
            ball.physicsBody?.categoryBitMask = NodeCategory.basketball.rawValue
            ball.physicsBody?.contactTestBitMask = NodeCategory.hoop.rawValue | NodeCategory.blocker.rawValue
            return ball
        } else{
            // reuse the balls from the inactive ball array
            if let ball = inactiveBalls.popLast(){
                return ball
            }
        }
        return ball
    }
    
    //
    func getBlocker(side: Bool) -> SKSpriteNode{
        // if there is no ball to reuse, make a new one
        if inactiveBlockers.count == 0{
            var block = SKSpriteNode()
            // True is left, false is right
            if (side){
                block = SKSpriteNode(imageNamed: "blocker")
            }
            else {
                block = SKSpriteNode(imageNamed: "rightSideBlocker")
            }
            block.size.height = 50.0
            block.size.width = 50.0
            block.name = "block"
            block.physicsBody = SKPhysicsBody(circleOfRadius: block.size.width / 2)
            //block.physicsBody?.isDynamic = true
            block.physicsBody?.categoryBitMask = NodeCategory.blocker.rawValue
            block.physicsBody?.contactTestBitMask = NodeCategory.basketball.rawValue
            return block
        } else{
            // reuse the blockers from the inactive blocker array
            if let blocker = inactiveBlockers.popLast(){
                return blocker
            }
            
        }
        return block
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        let nodeA = contact.bodyA.node!
        let nodeB = contact.bodyB.node!
//        let bodyNameA = String(describing: nodeA.name)
//        let bodyNameB = String(describing: nodeB.name)
        if let alphaName = nodeA.name {
            if let bravoName = nodeB.name {
                if alphaName == "block" && bravoName == "ball"{
                    nodeB.removeFromParent()
                } else if alphaName == "ball" && bravoName == "block" {
                    nodeA.removeFromParent()
                } else if alphaName == "hoop" && bravoName == "ball" {
                    nodeB.removeFromParent()
                    score += 1
                } else if alphaName == "ball" && bravoName == "hoop" {
                    nodeA.removeFromParent()
                    score += 1
                }
            }
        }
        activeBalls.removeAll()
        
        
        //print("Contact: \(contact.bodyA.node!.name), \(contact.bodyB.node!.name)")
        
        // check for contact between hoop and basketball
//        if contact.bodyA.categoryBitMask == NodeCategory.basketball.rawValue || contact.bodyB.categoryBitMask == NodeCategory.hoop.rawValue {
//            print("basketball made it to the hoop")
////            contact.bodyA.categoryBitMask == NodeCategory.basketball.rawValue ? contact.bodyA.node?.removeFromParent() : contact.bodyB.node?.removeFromParent()
//            contact.bodyA.node?.removeFromParent()
//
//            score += 1
//        }
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
    
    func touchDown(atPoint pos : CGPoint) {
        print("touch down")
        
    }
    
    func touchMoved(toPoint pos : CGPoint) {
       
    }
    
    func touchUp(atPoint pos : CGPoint) {
       
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if self.isPaused == true {
            // the user tapped to start a new game
            startGame()
        }
        else if (activeBalls.count == 0){
            addBall()
        }
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
    
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
    }
}

