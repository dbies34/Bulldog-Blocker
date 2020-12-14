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
    
    var background = SKSpriteNode()
    var hoop = SKSpriteNode()
    var scoreLabel = SKLabelNode()
    
    var score = 0 {
        didSet {
            scoreLabel.text = "Score: \(score)"
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
        physicsWorld.contactDelegate = self
        
        hoop = SKSpriteNode(imageNamed: "hoop")
        hoop.position = CGPoint(x: self.frame.midX, y: 205.0)
        hoop.size = CGSize(width: 75.0, height: 90.0)
        hoop.physicsBody = SKPhysicsBody(rectangleOf: hoop.size)
        hoop.physicsBody?.isDynamic = false
        hoop.physicsBody?.categoryBitMask = NodeCategory.hoop.rawValue
        hoop.physicsBody?.contactTestBitMask = NodeCategory.basketball.rawValue
        addChild(hoop)
        
        background = SKSpriteNode(imageNamed: "court")
        background.zRotation = CGFloat.pi / 2
        background.zPosition = -1
        background.size = CGSize(width: self.frame.height, height: self.frame.width)
        addChild(background)

        scoreLabel.fontSize = 30
        scoreLabel.position = CGPoint(x: self.frame.midX, y: self.frame.maxY - 25)
        score = 0
        addChild(scoreLabel)
        
        
    }
    
    // setup the timer for which will spawn the balls and the blockers
    func setupTimer(){
        timer = Timer.scheduledTimer(withTimeInterval: 2, repeats: true, block: { (timer) in
            self.addBall()
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
        let newBlocker = getBlocker()
        // TODO: make blocker postition random
        let minRandY = Int(self.frame.minY + 100)
        let maxRandY = Int(self.frame.maxY - 100)
        let randY = CGFloat(Int.random(in: minRandY...maxRandY))
        newBlocker.position.x = -250.0
        newBlocker.position.y = randY
        // create and run the blocker animation
        let moveBlocker = SKAction.move(to: CGPoint(x: -(newBlocker.position.x), y: -(newBlocker.position.y)), duration: 2)
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
            ball.physicsBody?.isDynamic = false
            ball.physicsBody?.contactTestBitMask = NodeCategory.hoop.rawValue | NodeCategory.blocker.rawValue
            ball.physicsBody?.categoryBitMask = NodeCategory.basketball.rawValue
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
    func getBlocker() -> SKSpriteNode{
        // if there is no ball to reuse, make a new one
        if inactiveBlockers.count == 0{
            let block = SKSpriteNode(imageNamed: "blocker")
            block.size.height = 50.0
            block.size.width = 50.0
            block.name = "block"
            block.physicsBody = SKPhysicsBody(circleOfRadius: block.size.width / 2)
            block.physicsBody?.isDynamic = true
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
        
        // check for contact between hoop and basketball
        if contact.bodyA.categoryBitMask == NodeCategory.basketball.rawValue || contact.bodyB.categoryBitMask == NodeCategory.hoop.rawValue {
            print("basketball made it to the hoop")
            contact.bodyA.categoryBitMask == NodeCategory.basketball.rawValue ? contact.bodyA.node?.removeFromParent() : contact.bodyB.node?.removeFromParent()
            
            score += 1
        }
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

