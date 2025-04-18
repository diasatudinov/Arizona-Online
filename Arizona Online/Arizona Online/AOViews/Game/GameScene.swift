import SpriteKit

class GameScene: SKScene {
    let bird = SKSpriteNode(imageNamed: "mainBird")
    var leftPressed = false
    var rightPressed = false

    override func didMove(to view: SKView) {
        backgroundColor = .cyan
        bird.position = CGPoint(x: size.width/2, y: size.height/2)
        bird.zRotation = 0
        addChild(bird)

        spawnFollowers()
        startMovement()
    }

    func startMovement() {
        let moveAction = SKAction.repeatForever(SKAction.customAction(withDuration: 0.1) { _, _ in
            self.updateBirdMovement()
        })
        run(moveAction)
    }

    func updateBirdMovement() {
        if leftPressed {
            bird.zRotation += 0.03
        } else if rightPressed {
            bird.zRotation -= 0.03
        }

        let dx = cos(bird.zRotation) * 4
        let dy = sin(bird.zRotation) * 4
        bird.position = CGPoint(x: bird.position.x + dx, y: bird.position.y + dy)
    }

    func spawnFollowers() {
        for i in 0..<3 {
            let follower = SKSpriteNode(imageNamed: "followerBird")
            follower.name = "follower"
            follower.position = CGPoint(x: bird.position.x - CGFloat(i + 1) * 40, y: bird.position.y - 100)
            addChild(follower)
        }
    }

    override func update(_ currentTime: TimeInterval) {
        for node in children where node.name == "follower" {
            guard let follower = node as? SKSpriteNode else { continue }

            let dx = bird.position.x - follower.position.x
            let dy = bird.position.y - follower.position.y
            let angle = atan2(dy, dx)
            follower.zRotation = angle

            let speed: CGFloat = 2.0
            let vx = cos(angle) * speed
            let vy = sin(angle) * speed
            follower.position = CGPoint(x: follower.position.x + vx, y: follower.position.y + vy)
        }
    }

    // MARK: - Touches
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let location = touch.location(in: self)
            if location.x < size.width / 2 {
                leftPressed = true
            } else {
                rightPressed = true
            }
        }
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        leftPressed = false
        rightPressed = false
    }
}