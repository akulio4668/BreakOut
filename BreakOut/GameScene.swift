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
    var brick: SKSpriteNode!
    var loseZone: SKSpriteNode!
    
    override func didMove(to view: SKView)
    {
        physicsWorld.contactDelegate = self
        self.physicsBody = SKPhysicsBody(edgeLoopFrom: frame)   // makes edge of the view part of the physics
        createBackground()
        createBall()
        createPaddle()
        createBricks()
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
        if contact.bodyA.node?.name == "brick" || contact.bodyB.node?.name == "brick"
        {
            print("Brick Hit!")
            brick.removeFromParent()
        }
        if contact.bodyA.node?.name == "lose zone" || contact.bodyB.node?.name == "lose zone"
        {
            print("You Lose a Ball")
        }
        
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
        ball = SKSpriteNode(color: UIColor.blue, size: CGSize(width: ballDiameter, height: ballDiameter))
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
        paddle = SKSpriteNode(color: UIColor.white, size: CGSize(width: frame.width / 4, height: frame.height / 25))
        paddle.position = CGPoint(x: frame.midX, y: frame.minY + 125)
        paddle.name = "paddle"
        
        paddle.physicsBody = SKPhysicsBody(rectangleOf: paddle.size)
        
        paddle.physicsBody?.isDynamic = false
        
        addChild(paddle)
    }
    
    func createBricks()
    {
        var brickTexture = SKTexture(imageNamed: "brick")
        for i in 0..<1
        {
            for j in 1...3
            {
                brick = SKSpriteNode(texture: brickTexture)
                brick.position = CGPoint(x: CGFloat(i * 25), y: CGFloat(125 + (10 * (j - 1))))
                brick.name = "box" + String(i * j)
                brick.physicsBody = SKPhysicsBody(rectangleOf: brick.size)
                brick.physicsBody?.isDynamic = false
                addChild(brick)
            }
        }
        /*brick = SKSpriteNode(color: UIColor.green, size: CGSize(width: frame.width / 6, height: frame.height / 25))
        brick.position = CGPoint(x: frame.midX, y: frame.maxY - 30)
        brick.name = "brick"
        
        brick.physicsBody = SKPhysicsBody(rectangleOf: brick.size)
        
        brick.physicsBody?.isDynamic = false
        
        addChild(brick)*/
    }
    
    func createLoseZone()
    {
        loseZone = SKSpriteNode(color: UIColor.clear, size: CGSize(width: frame.width, height: 50))
        loseZone.position = CGPoint(x: frame.midX, y: frame.minY + 25)
        loseZone.name = "lose zone"
        
        loseZone.physicsBody = SKPhysicsBody(rectangleOf: loseZone.size)
        
        loseZone.physicsBody?.isDynamic = false
        
        addChild(loseZone)
    }

}
