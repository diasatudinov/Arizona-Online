//
//  GameScene.swift
//  Arizona Online
//
//  Created by Dias Atudinov on 18.04.2025.
//


import SpriteKit

struct PhysicsCategory {
    static let none: UInt32      = 0
    static let player: UInt32    = 0x1 << 0
    static let enemy: UInt32     = 0x1 << 1
}

class GameScene: SKScene {
    
    // MARK: — Nodes & Properties
    var storeVM = StoreViewModelAO()
    private let worldNode = SKNode()
    private var player: SKSpriteNode!            // наша птица
    private var leftButton: SKSpriteNode!        // кнопка «влево»
    private var rightButton: SKSpriteNode!       // кнопка «вправо»
    private var backgrounds: [SKSpriteNode] = [] // тайлованные фоны
    
    private var turningLeft  = false
    private var turningRight = false
    
    private let playerSpeed: CGFloat   = 200    // точек/сек
    private let rotationSpeed: CGFloat = .pi/2  // рад/сек (90°/сек)
    
    private var lastEnemySpawnTime: TimeInterval = 0
    private let enemySpawnInterval: TimeInterval = 1.5
    
    // Бонусы
       private var lastBonusSpawnTime: TimeInterval = 0
       private let bonusSpawnInterval: TimeInterval = 10.0
    
    // MARK: — Scene Setup
    
    override func didMove(to view: SKView) {
        backgroundColor = .black
        
        // 1) Центрируем мир в середине экрана
        worldNode.position = CGPoint(x: size.width/2, y: size.height/2)
        addChild(worldNode)
        
        // 2) Бесконечный фон
        setupInfiniteBackground()
        
        // 3) Игрок (спрайт смотрит вверх при zRotation = 0)
        guard let item = storeVM.currentPersonItem else { return }
        player = SKSpriteNode(imageNamed: item.icon)
        player.setScale(0.5)
        player.size = CGSize(width: 80, height: 80)
        player.position = CGPoint(x: size.width/2, y: size.height/2)
        player.zPosition = 10
        addChild(player)
        
        // 4) UI: кнопки
        let btnSize = CGSize(width: 80, height: 80)
        leftButton = SKSpriteNode(imageNamed: "backIconAO")
        leftButton.size = btnSize
        leftButton.position = CGPoint(x: 100, y: 100)
        leftButton.name = "left"
        leftButton.zPosition = 20
        addChild(leftButton)
        
        rightButton = SKSpriteNode(imageNamed: "rightBtnIcon")
        rightButton.size = btnSize
        rightButton.position = CGPoint(x: size.width - 100, y: 100)
        rightButton.name = "right"
        rightButton.zPosition = 20
        addChild(rightButton)
    }
    
    private func setupInfiniteBackground() {
        guard let item = storeVM.currentBgItem else { return }
        let bgTex = SKTexture(imageNamed: item.image)
        bgTex.filteringMode = .nearest
        let bgSize = bgTex.size()
        
        for i in -1...1 {
            for j in -1...1 {
                let bg = SKSpriteNode(texture: bgTex)
                bg.anchorPoint = .init(x: 0.5, y: 0.5)
                bg.position = CGPoint(x: CGFloat(i) * bgSize.width,
                                      y: CGFloat(j) * bgSize.height)
                bg.zPosition = -10
                worldNode.addChild(bg)
                backgrounds.append(bg)
            }
        }
    }
    
    // MARK: – Touch Handling
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches {
            let loc = t.location(in: self)
            if leftButton.contains(loc) {
                turningLeft = true
                leftButton.color = .darkGray
            }
            if rightButton.contains(loc) {
                turningRight = true
                rightButton.color = .darkGray
            }
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        // Сбрасываем оба флага при отпускании любого касания
        turningLeft = false
        turningRight = false
        leftButton.color  = .gray
        rightButton.color = .gray
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        touchesEnded(touches, with: event)
    }
    
    // MARK: – Game Loop
    
    override func update(_ currentTime: TimeInterval) {
        let dt = CGFloat(1.0 / CGFloat(view!.preferredFramesPerSecond))
        
        // 1) Поворот игрока
        if turningLeft  { player.zRotation += rotationSpeed * dt }
        if turningRight { player.zRotation -= rotationSpeed * dt }
        
        // 2) Движение «вперёд» (sprite смотрит вверх при z=0)
        //    Forward vector = (‑sin(z), cos(z))
        let dx = -sin(player.zRotation) * playerSpeed * dt
        let dy =  cos(player.zRotation) * playerSpeed * dt
        worldNode.position.x -= dx
        worldNode.position.y -= dy
        
        // 3) Тайлинг фона
        tileBackgroundsIfNeeded()
        
        // Спавн бонусов
               if currentTime - lastBonusSpawnTime > bonusSpawnInterval {
                   spawnBonus(); lastBonusSpawnTime = currentTime
               }
        
        // 4) Спавн врагов
        if currentTime - lastEnemySpawnTime > enemySpawnInterval {
            spawnEnemy()
            lastEnemySpawnTime = currentTime
        }
        
        // 5) Обновление врагов
        for node in worldNode.children {
            if let enemy = node as? SKSpriteNode, enemy.name == "enemy" {
                updateEnemy(enemy, dt: dt)
            }
            if let bonus = node as? SKSpriteNode, bonus.name?.starts(with: "bonus") == true {
                handleBonusCollision(bonus)
            }
        }
    }
    
    private func tileBackgroundsIfNeeded() {
        guard let size = backgrounds.first?.size else { return }
        for bg in backgrounds {
            let pos = bg.convert(CGPoint.zero, to: self)
            if pos.x > frame.maxX + size.width/2    { bg.position.x -= size.width * 3 }
            if pos.x < frame.minX - size.width/2    { bg.position.x += size.width * 3 }
            if pos.y > frame.maxY + size.height/2   { bg.position.y -= size.height * 3 }
            if pos.y < frame.minY - size.height/2   { bg.position.y += size.height * 3 }
        }
    }
    
    // MARK: – Enemy Logic
    
    private func spawnEnemy() {
        let num = Int.random(in: Range(1...3))
        let enemy = SKSpriteNode(imageNamed: "enemyBird\(num)")
        enemy.name = "enemy"
        enemy.setScale(0.4)
        enemy.zPosition = 5
        
        // Выбираем сторону спауна
        let spawn: CGPoint
        switch Int.random(in: 0..<4) {
        case 0: spawn = CGPoint(x: .random(in: 0...size.width), y: size.height + 50)
        case 1: spawn = CGPoint(x: .random(in: 0...size.width), y: -50)
        case 2: spawn = CGPoint(x: -50, y: .random(in: 0...size.height))
        default: spawn = CGPoint(x: size.width + 50, y: .random(in: 0...size.height))
        }
        enemy.position = convert(spawn, to: worldNode)
        worldNode.addChild(enemy)
    }
    
    private func updateEnemy(_ enemy: SKSpriteNode, dt: CGFloat) {
        let playerPos = convert(player.position, to: worldNode)
        let toPlayer = CGVector(dx: playerPos.x - enemy.position.x,
                                dy: playerPos.y - enemy.position.y)
        let dist = hypot(toPlayer.dx, toPlayer.dy)
        guard dist > 0 else { return }
        
        // Поворачиваем «носом» к игроку (sprite смотрит вверх при z=0)
        enemy.zRotation = atan2(-toPlayer.dx, toPlayer.dy)
        
        // Бонусная скорость, если позади
        let forward = CGVector(dx: -sin(player.zRotation), dy: cos(player.zRotation))
        let vecEnemy = CGVector(dx: enemy.position.x - playerPos.x,
                                dy: enemy.position.y - playerPos.y)
        let dot = forward.dx * vecEnemy.dx + forward.dy * vecEnemy.dy
        let chaseSpeed: CGFloat = dot < 0 ? 180 : 150
        
        // Двигаем к игроку
        enemy.position.x += toPlayer.dx / dist * chaseSpeed * dt
        enemy.position.y += toPlayer.dy / dist * chaseSpeed * dt
        
        // Столкновение
        let playerFrame = convert(player.frame, to: worldNode)
        if enemy.frame.intersects(playerFrame) {
            enemy.removeFromParent()
        }
    }
    
    private func spawnBonus() {
            let types = ["bonusClear", "bonusStar", "bonusDummy"]
            let type = types.randomElement()!
            let bonus = SKSpriteNode(imageNamed: type)
            bonus.name = type
            bonus.setScale(0.5)
            bonus.zPosition = 5
            let x = CGFloat.random(in: 0...size.width)
            let y = CGFloat.random(in: 0...size.height)
            bonus.position = convert(CGPoint(x: x, y: y), to: worldNode)
            worldNode.addChild(bonus)
        }
        
        private func handleBonusCollision(_ bonus: SKSpriteNode) {
            let playerFrame = convert(player.frame, to: worldNode)
            if bonus.frame.intersects(playerFrame) {
                applyBonus(named: bonus.name!)
                bonus.removeFromParent()
            }
        }
        
        private func applyBonus(named name: String) {
            switch name {
            case "bonusClear":
                // Удаляем всех врагов
                for case let e as SKSpriteNode in worldNode.children where e.name == "enemy" {
                    e.removeFromParent()
                }
            case "bonusStar":
                AOUser.shared.updateUserMoney(for: 1)
            case "bonusDummy":
                // Ничего не происходит
                break
            default: break
            }
        }
    
    func restartGame() {
           // Очистка мира
           worldNode.removeAllChildren()
           backgrounds.removeAll()
           
           // Сброс фоновых тайлов
           setupInfiniteBackground()
           
           // Сброс позиции и поворота
           worldNode.position = CGPoint(x: size.width/2, y: size.height/2)
           player.zRotation = 0
           
           // Сброс таймеров
           lastEnemySpawnTime = 0
           lastBonusSpawnTime = 0
       }
}
