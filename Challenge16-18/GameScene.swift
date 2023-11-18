import SpriteKit

class GameScene: SKScene {
    var gameTimer: Timer?
    var timerRow1: Timer?
    var timerRow2: Timer?
    var timerRow3: Timer?
    var scoreLabel: SKLabelNode!
    var bullets = [SKSpriteNode]()
    var isGameOver = false
    var score = 0 {
        didSet {
            scoreLabel.text = "Score: \(score)"
        }
    }
    
    override func didMove(to view: SKView) {
        let background = SKSpriteNode(imageNamed: "background")
        background.position = CGPoint(x: 512, y: 384)
        background.zPosition = -1
        background.blendMode = .replace
        addChild(background)
        
        scoreLabel = SKLabelNode(fontNamed: "Chalkduster")
        scoreLabel.position = CGPoint(x: 1000, y: 725)
        scoreLabel.horizontalAlignmentMode = .right
        addChild(scoreLabel)
        score = 0
        
        let reload = SKSpriteNode(imageNamed: "reload")
        reload.position = CGPoint(x: 965, y: 35)
        reload.name = "reload"
        addChild(reload)
        
        let bullet1 = SKSpriteNode(imageNamed: "bullet")
        bullet1.position = CGPoint(x: 907, y: 35)
        addChild(bullet1)
        let bullet2 = SKSpriteNode(imageNamed: "bullet")
        bullet2.position = CGPoint(x: 887, y: 35)
        addChild(bullet2)
        let bullet3 = SKSpriteNode(imageNamed: "bullet")
        bullet3.position = CGPoint(x: 867, y: 35)
        addChild(bullet3)
        let bullet4 = SKSpriteNode(imageNamed: "bullet")
        bullet4.position = CGPoint(x: 847, y: 35)
        addChild(bullet4)
        let bullet5 = SKSpriteNode(imageNamed: "bullet")
        bullet5.position = CGPoint(x: 827, y: 35)
        addChild(bullet5)
        let bullet6 = SKSpriteNode(imageNamed: "bullet")
        bullet6.position = CGPoint(x: 807, y: 35)
        addChild(bullet6)
        
        bullets.append(bullet6)
        bullets.append(bullet5)
        bullets.append(bullet4)
        bullets.append(bullet3)
        bullets.append(bullet2)
        bullets.append(bullet1)
        
        let row1 = SKSpriteNode(imageNamed: "row")
        row1.position = CGPoint(x: 512, y: 630)
        addChild(row1)
        let row2 = SKSpriteNode(imageNamed: "row")
        row2.position = CGPoint(x: 512, y: 405)
        addChild(row2)
        let row3 = SKSpriteNode(imageNamed: "row")
        row3.position = CGPoint(x: 512, y: 180)
        addChild(row3)
        
        gameTimer = Timer.scheduledTimer(timeInterval: 60, target: self, selector: #selector(gameOver), userInfo: nil, repeats: false)
        timerRow1 = Timer.scheduledTimer(timeInterval: Double.random(in: 1...3), target: self, selector: #selector(createTargetTop), userInfo: nil, repeats: true)
        timerRow2 = Timer.scheduledTimer(timeInterval: Double.random(in: 1...3), target: self, selector: #selector(createTargetMid), userInfo: nil, repeats: true)
        timerRow3 = Timer.scheduledTimer(timeInterval: Double.random(in: 1...3), target: self, selector: #selector(createTargetBot), userInfo: nil, repeats: true)
        
        physicsWorld.gravity = .zero
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        
        let location = touch.location(in: self)
        let objects = nodes(at: location)
        let fadeOut = SKAction.fadeOut(withDuration: 0.5)
        let remove = SKAction.removeFromParent()
        let sequence = SKAction.sequence([fadeOut, remove])
        
        outerLoop: for object in objects {
            if object.name == "reload" {
                reload()
                run(SKAction.playSoundFileNamed("reload", waitForCompletion: false))
                break outerLoop
            } else if object.name == "targetBigGood" {
                for bullet in bullets {
                    if bullet.isHidden == false {
                        run(SKAction.playSoundFileNamed("shoot", waitForCompletion: false))
                        score += 1
                        run(SKAction.playSoundFileNamed("targetGood", waitForCompletion: false))
                        object.run(sequence)
                        bullet.isHidden = true
                        break outerLoop
                    }
                }
            } else if object.name == "targetSmallGood" {
                for bullet in bullets {
                    if bullet.isHidden == false {
                        run(SKAction.playSoundFileNamed("shoot", waitForCompletion: false))
                        score += 3
                        run(SKAction.playSoundFileNamed("targetGood", waitForCompletion: false))
                        object.run(sequence)
                        bullet.isHidden = true
                        break outerLoop
                    }
                }
            } else if object.name == "targetBad" {
                for bullet in bullets {
                    if bullet.isHidden == false {
                        run(SKAction.playSoundFileNamed("shoot", waitForCompletion: false))
                        score -= 2
                        if score < 0 {
                            score = 0
                        }
                        run(SKAction.playSoundFileNamed("targetBad", waitForCompletion: false))
                        object.run(sequence)
                        bullet.isHidden = true
                        break outerLoop
                    }
                }
            } else {
                for bullet in bullets {
                    if bullet.isHidden == false {
                        run(SKAction.playSoundFileNamed("shoot", waitForCompletion: false))
                        bullet.isHidden = true
                        break outerLoop
                    }
                }
            }
        }
    }
    
    override func update(_ currentTime: TimeInterval) {
        for node in children {
            if node.position.x < -200 || node.position.x > 1200 {
                node.removeFromParent()
            }
        }
    }
    
    func reload() {
        for bullet in bullets {
            bullet.isHidden = false
        }
    }
    
    @objc func createTargetTop() {
        guard !isGameOver else { return }
        
        let randomNum = Int.random(in: 1...10)
        if randomNum > 0 && randomNum < 6 {
            let target = SKSpriteNode(imageNamed: "targetBigGood")
            target.position = CGPoint(x: -200, y: 630)
            target.physicsBody = SKPhysicsBody(texture: target.texture!, size: target.size)
            target.physicsBody?.velocity = CGVector(dx: Int.random(in: 200...300), dy: 0)
            target.physicsBody?.linearDamping = 0
            target.physicsBody?.collisionBitMask = 0
            target.name = "targetBigGood"
            target.zPosition = 1
            addChild(target)
        } else if randomNum > 5 && randomNum < 9 {
            let target = SKSpriteNode(imageNamed: "targetSmallGood")
            target.position = CGPoint(x: -200, y: 630)
            target.physicsBody = SKPhysicsBody(texture: target.texture!, size: target.size)
            target.physicsBody?.velocity = CGVector(dx: Int.random(in: 300...500), dy: 0)
            target.physicsBody?.linearDamping = 0
            target.physicsBody?.collisionBitMask = 0
            target.name = "targetSmallGood"
            target.zPosition = 1
            addChild(target)
        } else if randomNum > 8 {
            if randomNum == 9 {
                let target = SKSpriteNode(imageNamed: "targetBigBad")
                target.position = CGPoint(x: -200, y: 630)
                target.physicsBody = SKPhysicsBody(texture: target.texture!, size: target.size)
                target.physicsBody?.velocity = CGVector(dx: Int.random(in: 200...500), dy: 0)
                target.physicsBody?.linearDamping = 0
                target.physicsBody?.collisionBitMask = 0
                target.name = "targetBad"
                target.zPosition = 1
                addChild(target)
            } else {
                let target = SKSpriteNode(imageNamed: "targetSmallBad")
                target.position = CGPoint(x: -200, y: 630)
                target.physicsBody = SKPhysicsBody(texture: target.texture!, size: target.size)
                target.physicsBody?.velocity = CGVector(dx: Int.random(in: 200...500), dy: 0)
                target.physicsBody?.linearDamping = 0
                target.physicsBody?.collisionBitMask = 0
                target.name = "targetBad"
                target.zPosition = 1
                addChild(target)
            }
        }
    }
    
    @objc func createTargetMid() {
        guard !isGameOver else { return }
        
        let randomNum = Int.random(in: 1...10)
        if randomNum > 0 && randomNum < 6 {
            let target = SKSpriteNode(imageNamed: "targetBigGood")
            target.position = CGPoint(x: 1200, y: 405)
            target.physicsBody = SKPhysicsBody(texture: target.texture!, size: target.size)
            target.physicsBody?.velocity = CGVector(dx: -Int.random(in: 200...300), dy: 0)
            target.physicsBody?.linearDamping = 0
            target.physicsBody?.collisionBitMask = 0
            target.name = "targetBigGood"
            target.zPosition = 1
            addChild(target)
        } else if randomNum > 5 && randomNum < 9 {
            let target = SKSpriteNode(imageNamed: "targetSmallGood")
            target.position = CGPoint(x: 1200, y: 405)
            target.physicsBody = SKPhysicsBody(texture: target.texture!, size: target.size)
            target.physicsBody?.velocity = CGVector(dx: -Int.random(in: 300...500), dy: 0)
            target.physicsBody?.linearDamping = 0
            target.physicsBody?.collisionBitMask = 0
            target.name = "targetSmallGood"
            target.zPosition = 1
            addChild(target)
        } else if randomNum > 8 {
            if randomNum == 9 {
                let target = SKSpriteNode(imageNamed: "targetBigBad")
                target.position = CGPoint(x: 1200, y: 405)
                target.physicsBody = SKPhysicsBody(texture: target.texture!, size: target.size)
                target.physicsBody?.velocity = CGVector(dx: -Int.random(in: 200...500), dy: 0)
                target.physicsBody?.linearDamping = 0
                target.physicsBody?.collisionBitMask = 0
                target.name = "targetBad"
                target.zPosition = 1
                addChild(target)
            } else {
                let target = SKSpriteNode(imageNamed: "targetSmallBad")
                target.position = CGPoint(x: 1200, y: 405)
                target.physicsBody = SKPhysicsBody(texture: target.texture!, size: target.size)
                target.physicsBody?.velocity = CGVector(dx: -Int.random(in: 200...500), dy: 0)
                target.physicsBody?.linearDamping = 0
                target.physicsBody?.collisionBitMask = 0
                target.name = "targetBad"
                target.zPosition = 1
                addChild(target)
            }
        }
    }
    
    @objc func createTargetBot() {
        guard !isGameOver else { return }
        
        let randomNum = Int.random(in: 1...10)
        if randomNum > 0 && randomNum < 6 {
            let target = SKSpriteNode(imageNamed: "targetBigGood")
            target.position = CGPoint(x: -200, y: 180)
            target.physicsBody = SKPhysicsBody(texture: target.texture!, size: target.size)
            target.physicsBody?.velocity = CGVector(dx: Int.random(in: 200...300), dy: 0)
            target.physicsBody?.linearDamping = 0
            target.physicsBody?.collisionBitMask = 0
            target.name = "targetBigGood"
            target.zPosition = 1
            addChild(target)
        } else if randomNum > 5 && randomNum < 9 {
            let target = SKSpriteNode(imageNamed: "targetSmallGood")
            target.position = CGPoint(x: -200, y: 180)
            target.physicsBody = SKPhysicsBody(texture: target.texture!, size: target.size)
            target.physicsBody?.velocity = CGVector(dx: Int.random(in: 300...500), dy: 0)
            target.physicsBody?.linearDamping = 0
            target.physicsBody?.collisionBitMask = 0
            target.name = "targetSmallGood"
            target.zPosition = 1
            addChild(target)
        } else if randomNum > 8 {
            if randomNum == 9 {
                let target = SKSpriteNode(imageNamed: "targetBigBad")
                target.position = CGPoint(x: -200, y: 180)
                target.physicsBody = SKPhysicsBody(texture: target.texture!, size: target.size)
                target.physicsBody?.velocity = CGVector(dx: Int.random(in: 200...500), dy: 0)
                target.physicsBody?.linearDamping = 0
                target.physicsBody?.collisionBitMask = 0
                target.name = "targetBad"
                target.zPosition = 1
                addChild(target)
            } else {
                let target = SKSpriteNode(imageNamed: "targetSmallBad")
                target.position = CGPoint(x: -200, y: 180)
                target.physicsBody = SKPhysicsBody(texture: target.texture!, size: target.size)
                target.physicsBody?.velocity = CGVector(dx: Int.random(in: 200...500), dy: 0)
                target.physicsBody?.linearDamping = 0
                target.physicsBody?.collisionBitMask = 0
                target.name = "targetBad"
                target.zPosition = 1
                addChild(target)
            }
        }
    }
    
    @objc func gameOver() {
        isGameOver = true
        gameTimer?.invalidate()
        timerRow1?.invalidate()
        timerRow2?.invalidate()
        timerRow3?.invalidate()
        for bullet in bullets {
            bullet.isHidden = true
        }
        
        let gameOverPic = SKSpriteNode(imageNamed: "gameOver")
        gameOverPic.position = CGPoint(x: 512, y: 400)
        gameOverPic.zPosition = 2
        
        let finalScoreLabel = SKLabelNode(fontNamed: "Chalkduster")
        finalScoreLabel.text = "Final Score: \(score)"
        finalScoreLabel.fontSize = 80
        finalScoreLabel.position = CGPoint(x: 512, y: 280)
        finalScoreLabel.zPosition = 2
        
        addChild(gameOverPic)
        addChild(finalScoreLabel)
        run(SKAction.playSoundFileNamed("gameOverSound", waitForCompletion: false))
    }
}
