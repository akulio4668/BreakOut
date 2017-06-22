//
//  GameScene.swift
//  BreakOut
//
//  Created by Akul Joshi on 6/21/17.
//  Copyright © 2017 Nebula. All rights reserved.
//

import SpriteKit
import GameplayKit

// SKPhysicsContactDelegate - Add to use contact physics
class GameScene: SKScene, SKPhysicsContactDelegate
{
    
    var ball: SKSpriteNode!
    var paddle: SKSpriteNode!
    var bricks: [SKSpriteNode?] = []
    var loseZone: SKSpriteNode!
    var lives = 3
    
    override func didMove(to view: SKView)
    {
        physicsWorld.contactDelegate = self
        self.physicsBody = SKPhysicsBody(edgeLoopFrom: frame)   // makes edge of the view part of the physics
        createBackground()
        createBall()
        createPaddle()
        generateBrick1()
        generateBrick2()
        generateBrick3()
        generateBrick4()
        generateBrick5()
        createLoseZone()
        
        // this will start the ball movement
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        if ball.physicsBody?.isDynamic == false
        {
            ball.physicsBody?.isDynamic = true
            ball.physicsBody?.applyImpulse(CGVector(dx: 5, dy: -5))
        }
        
        for touch in touches
        {
            let location = touch.location(in: self)
            paddle.position.x = location.x
        }
        
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        for touch in touches
        {
            let location = touch.location(in: self)
            paddle.position.x = location.x
        }
    }

    func didBegin(_ contact: SKPhysicsContact)
    {
        if contact.bodyA.node?.name == "brick"
        {
            contact.bodyA.node?.removeFromParent()
        }
        if contact.bodyB.node?.name == "brick"
        {
            contact.bodyB.node?.removeFromParent()
        }
        if contact.bodyA.node?.name == "lose zone" || contact.bodyB.node?.name == "lose zone"
        {
            if lives == 1
            {
                reset()
            }
            else
            {
                lives -= 1
                let alertGameOver = UIAlertController(title: "Game Over", message: nil, preferredStyle: .alert)
                let alertGameOverAction = UIAlertAction(title: "Restart", style: .default) { (addAction) in self.reset()}
            }
            ball.removeFromParent()
            paddle.removeFromParent()
            createBall()
            createPaddle()
        }
    }
    
    
    func reset()
    {
        lives = 3
        createBricks()
    }
    
    func createBackground()
    {
        let stars = SKTexture(imageNamed: "stars")
        
        for i in 0...1  // creates two stars backgrounds for seamless transition
        {
            let starsBackground = SKSpriteNode(texture: stars)
            starsBackground.zPosition = -1  // sets stacking order (lowest numbers in the very back; below everything)
            starsBackground.anchorPoint = CGPoint(x: 0.5, y: 0.5)   // anchors the image
            starsBackground.position = CGPoint(x: 0, y: (starsBackground.size.height * CGFloat(i) - CGFloat(1 * i)))
            
            addChild(starsBackground)
            
            let moveDown = SKAction.moveBy(x: 0, y: -starsBackground.size.height, duration: 20)
            let reset = SKAction.moveBy(x: 0, y: starsBackground.size.height, duration: 0)
            let moveLoop = SKAction.sequence([moveDown, reset])
            let loop = SKAction.repeatForever(moveLoop)
            
            starsBackground.run(loop)
        }
    }
    
    func createBall()
    {
        let ballDiameter = frame.width / 20
        let ballTexture = SKTexture(imageNamed: "donald trump")
        ball = SKSpriteNode(texture: ballTexture, color: UIColor.white, size: CGSize(width: ballDiameter, height: ballDiameter))
        ball.position = CGPoint(x: frame.midX, y: frame.midY)
        ball.name = "ball"
        
        ball.physicsBody = SKPhysicsBody(rectangleOf: ball.size)   // applies SKPhysicsBody to ball (invisible rectangle around ball)
        
        ball.physicsBody?.isDynamic = false     // ignores all forces and impulses
        ball.physicsBody?.usesPreciseCollisionDetection = true
        ball.physicsBody?.allowsRotation = false
        ball.physicsBody?.friction = 0
        ball.physicsBody?.affectedByGravity = false
        ball.physicsBody?.restitution = 1
        ball.physicsBody?.angularDamping = 0
        ball.physicsBody?.linearDamping = 0
        ball.physicsBody?.contactTestBitMask = (ball.physicsBody?.collisionBitMask)!
        
        addChild(ball)
    }
    
    func createPaddle()
    {
        paddle = SKSpriteNode(color: UIColor.white, size: CGSize(width: frame.width / 4, height: frame.height / 50))
        paddle.position = CGPoint(x: frame.midX, y: frame.minY + 125)
        paddle.name = "paddle"
        
        paddle.physicsBody = SKPhysicsBody(rectangleOf: paddle.size)
        
        paddle.physicsBody?.isDynamic = false
        
        addChild(paddle)
    }
    
    func generateBrick1()
    {
        let brick1 = SKSpriteNode(color: UIColor.white, size: CGSize(width: 69, height: 30))
        brick1.position = CGPoint(x: frame.minX + 5, y: frame.maxY - 30)
        brick1.physicsBody = SKPhysicsBody(rectangleOf: brick1.frame.size)
        brick1.physicsBody?.allowsRotation = false
        brick1.physicsBody?.friction = 0
        brick1.name = "brick1"
        brick1.physicsBody?.isDynamic = false
        addChild(brick1)
    }
    
    func generateBrick2()
    {
        let brick2 = SKSpriteNode(color: UIColor.white, size: CGSize(width: 69, height: 30))
        brick2.position = CGPoint(x: frame.minX + 79, y: frame.maxY - 30)
        brick2.physicsBody = SKPhysicsBody(rectangleOf: brick2.frame.size)
        brick2.physicsBody?.allowsRotation = false
        brick2.physicsBody?.friction = 0
        brick2.name = "brick2"
        brick2.physicsBody?.isDynamic = false
        addChild(brick2)
    }
    
    func generateBrick3()
    {
        let brick3 = SKSpriteNode(color: UIColor.white, size: CGSize(width: 69, height: 30))
        brick3.position = CGPoint(x: frame.minX + 153, y: frame.maxY - 30)
        brick3.physicsBody = SKPhysicsBody(rectangleOf: brick3.frame.size)
        brick3.physicsBody?.allowsRotation = false
        brick3.physicsBody?.friction = 0
        brick3.name = "brick3"
        brick3.physicsBody?.isDynamic = false
        addChild(brick3)
    }
    
    func generateBrick4()
    {
        let brick4 = SKSpriteNode(color: UIColor.white, size: CGSize(width: 69, height: 30))
        brick4.position = CGPoint(x: frame.minX + 227, y: frame.maxY - 30)
        brick4.physicsBody = SKPhysicsBody(rectangleOf: brick4.frame.size)
        brick4.physicsBody?.allowsRotation = false
        brick4.physicsBody?.friction = 0
        brick4.name = "brick4"
        brick4.physicsBody?.isDynamic = false
        addChild(brick4)
    }
    
    func generateBrick5()
    {
        let brick5 = SKSpriteNode(color: UIColor.white, size: CGSize(width: 69, height: 30))
        brick5.position = CGPoint(x: frame.minX + 301, y: frame.maxY - 30)
        brick5.physicsBody = SKPhysicsBody(rectangleOf: brick5.frame.size)
        brick5.physicsBody?.allowsRotation = false
        brick5.physicsBody?.friction = 0
        brick5.name = "brick5"
        brick5.physicsBody?.isDynamic = false
        addChild(brick5)
    }
    
    func makeBrick(xPosition : Double, yPosition : Double, width: Int, height: Int)
    {
        var brick = SKSpriteNode(color: UIColor.white, size: CGSize(width: width, height: height))
        brick.position = CGPoint(x: xPosition, y: yPosition)
        brick.name = "brick"
        brick.physicsBody = SKPhysicsBody(rectangleOf: brick.size)
        brick.physicsBody?.isDynamic = false
        addChild(brick)
    }
    
    func createLoseZone()
    {
        loseZone = SKSpriteNode(color: UIColor.clear, size: CGSize(width: frame.width, height: 1))
        loseZone.position = CGPoint(x: frame.midX, y: frame.minY + 25)
        loseZone.name = "lose zone"
        
        loseZone.physicsBody = SKPhysicsBody(rectangleOf: loseZone.size)
        
        loseZone.physicsBody?.isDynamic = false
        
        addChild(loseZone)
    }

}
