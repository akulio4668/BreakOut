//
//  GameScene.swift
//  BreakOut
//
//  Created by Akul Joshi on 6/21/17.
//  Copyright © 2017 Nebula. All rights reserved.
//

import SpriteKit
import GameplayKit
import AVFoundation

// SKPhysicsContactDelegate - Add to use contact physics
class GameScene: SKScene, SKPhysicsContactDelegate
{
    
    var ball: SKSpriteNode!
    var paddle: SKSpriteNode!
    var loseZone: SKSpriteNode!
    var lives = 3
    var lifeOne: SKSpriteNode!
    var lifeTwo: SKSpriteNode!
    var lifeThree: SKSpriteNode!
    var scoreLabel: SKLabelNode!
    var score = 0
    
    override func didMove(to view: SKView)
    {
        var sound = SKAction.playSoundFileNamed("Background.mp3", waitForCompletion: false)
        run(sound)
        physicsWorld.contactDelegate = self
        self.physicsBody = SKPhysicsBody(edgeLoopFrom: frame)   // makes edge of the view part of the physics
        createBackground()
        createBall()
        createPaddle()
        createLoseZone()
        createScoreLabel()
        createBricks(NumberOfRows: 3, NumberOfBricks: 10, XPosition: Double(frame.width / 25) - Double(frame.width / 2), YPosition: 25.0, Padding: Int(frame.width) / 20)
        generateLifeThree()
        generateLifeTwo()
        generateLifeOne()
        
        // this will start the ball movement
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        if ball.physicsBody?.isDynamic == false
        {
            ball.physicsBody?.isDynamic = true
            var yVectorDir = Int(arc4random() % 5 + 3)
            var xVectorDir = Int(arc4random() % 5 + 1)
            var signChoice = Int(arc4random() % 2)
            if (signChoice == 0)
            {
                xVectorDir = -xVectorDir
            }
            ball.physicsBody?.applyImpulse(CGVector(dx: xVectorDir, dy: -yVectorDir))
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
            score += 100
            scoreLabel.removeFromParent()
            createScoreLabel()
        }
        
        if contact.bodyB.node?.name == "brick"
        {
            contact.bodyB.node?.removeFromParent()
            score += 100
            scoreLabel.removeFromParent()
            createScoreLabel()
        }
        
        if contact.bodyA.node?.name == "lose zone" || contact.bodyB.node?.name == "lose zone"
        {
            if lives == 3
            {
                lifeThree.removeFromParent()
                lives = 2
            }
            else if lives == 2
            {
                lifeThree.removeFromParent()
                lifeTwo.removeFromParent()
                lives = 1
            }
            else if lives == 1
            {
                lifeThree.removeFromParent()
                lifeTwo.removeFromParent()
                lifeOne.removeFromParent()
                lives = 0
            }
            else if lives == 0
            {
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
        score = 0
        scoreLabel.removeFromParent()
        createScoreLabel()
        createBricks(NumberOfRows: 3, NumberOfBricks: 10, XPosition: Double(frame.width / 25) - Double(frame.width / 2), YPosition: 25.0, Padding: Int(frame.width) / 20)
        generateLifeOne()
        generateLifeTwo()
        generateLifeThree()
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
    
    func generateLifeOne()
    {
        let lifeOneTexture = SKTexture(imageNamed: "donald trump")
        let lifeOneSecondTexture = SKTexture(imageNamed: "t")
        lifeOne = SKSpriteNode(texture: lifeOneTexture, color: UIColor.white, size: CGSize(width: frame.width/20, height: frame.width/20))
        lifeOne.position = CGPoint(x: frame.maxX - 8, y: frame.maxY - 20)
        lifeOne.name = "lifeOne"
        lifeOne.physicsBody?.isDynamic = false
        lifeOne.alpha = 1.0
        lifeOne.zPosition = 10
        addChild(lifeOne)
        
    }
    
    func generateLifeTwo()
    {
        let lifeTwoTexture = SKTexture(imageNamed: "donald trump")
        let lifeTwoSecondTexture = SKTexture(imageNamed: "t")
        lifeTwo = SKSpriteNode(texture: lifeTwoTexture, color: UIColor.white, size: CGSize(width: frame.width/20, height: frame.width/20))
        lifeTwo.position = CGPoint(x: frame.maxX - 34.75, y: frame.maxY - 20)
        lifeTwo.name = "lifeTwo"
        lifeTwo.physicsBody?.isDynamic = false
        addChild(lifeTwo)
        lifeTwo.alpha = 1.0
        lifeTwo.zPosition = 10
    }
    
    func generateLifeThree()
    {
        let lifeThreeTexture = SKTexture(imageNamed: "donald trump")
        let lifeThreeSecondTexture = SKTexture(imageNamed: "t")
        lifeThree = SKSpriteNode(texture: lifeThreeTexture, color: UIColor.white, size: CGSize(width: frame.width/20, height: frame.width/20))
        lifeThree.position = CGPoint(x: frame.maxX - 61.5, y: frame.maxY - 20)
        lifeThree.name = "lifeThree"
        lifeThree.physicsBody?.isDynamic = false
        addChild(lifeThree)
        lifeThree.alpha = 1.0
        lifeThree.zPosition = 10
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

    
    func createBricks(NumberOfRows: Int, NumberOfBricks: Int, XPosition: Double, YPosition: Double, Padding: Int)
    {
        var numberOfRows = NumberOfRows
        var numberOfBricks = NumberOfBricks
        var xPosition = XPosition
        var yPosition = YPosition
        var padding = Padding
        var brickHeight = 10
        var brickWidth = (Int(frame.width) - padding * 9) / 10
        
        for rows in 1...numberOfRows
        {
            for index in 1...numberOfBricks
            {
                makeBrick(xPosition: xPosition, yPosition: yPosition, width: brickWidth, height: brickHeight)
                xPosition += Double(brickWidth + padding)
            }
            xPosition = Double(frame.width / 25) - Double(frame.width / 2)
            yPosition += Double(brickHeight + padding)
        }
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
    
    func createScoreLabel()
    {
        scoreLabel = SKLabelNode(text: "Score: \(score)")
        scoreLabel.position = CGPoint(x: frame.midX, y: frame.maxY - 100)
        scoreLabel.name = "score label"
        addChild(scoreLabel)
    }
}
