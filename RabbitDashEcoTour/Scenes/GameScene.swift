import SpriteKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    var rabbit: RabbitNode!
    var ground: SKSpriteNode!
    var background: BackgroundNode!
    
    var platforms: [PlatformNode] = []
    var platformSpawnTimer: TimeInterval = 0
    let platformSpawnInterval: TimeInterval = 6.5  // Интервал спавна платформ
    
    // Ограничения платформ
    private let maxPlatforms: Int = 3
    // Минимальная дистанция по X между крайней правой платформой и новой (в пикселях сцены)
    private var minPlatformGapX: CGFloat {
        return 1.5 * Constants.rabbitSize.width
    }
    // Доп. защита: минимальный "кулдаун" между спавнами (даже если while-цикл может сработать несколько раз)
    private let minSpawnCooldown: TimeInterval = 0.2
    private var lastPlatformSpawnTime: TimeInterval = 0
    
    var isGameRunning: Bool = false
    var lastUpdateTime: TimeInterval = 0
    
    // Единая высота земли, используем в двух местах
    private let groundHeight: CGFloat = 50
    
    override func didMove(to view: SKView) {
        print("🎮 GameScene loaded! Size: \(size)")
        
        backgroundColor = .black
        
        setupPhysics()
        setupBackground()
        setupGround()
        setupRabbit()
        setupGestureRecognizers()
        
        startGame()
    }
    
    func setupPhysics() {
        physicsWorld.gravity = CGVector(dx: 0, dy: -9.8)
        physicsWorld.contactDelegate = self
    }
    
    func setupBackground() {
        background = BackgroundNode(worldName: "green_forest", screenSize: size)
        addChild(background)
        print("🌲 Background added to scene")
    }
    
    func setupGround() {
        ground = SKSpriteNode(color: .clear, size: CGSize(width: size.width * 2, height: groundHeight))
        ground.position = CGPoint(x: size.width / 2, y: groundHeight / 2)
        ground.zPosition = 1
        
        ground.physicsBody = SKPhysicsBody(rectangleOf: ground.size)
        ground.physicsBody?.isDynamic = false
        ground.physicsBody?.categoryBitMask = Constants.PhysicsCategory.ground
        ground.physicsBody?.contactTestBitMask = Constants.PhysicsCategory.player
        ground.physicsBody?.collisionBitMask = Constants.PhysicsCategory.player
        
        addChild(ground)
        
        print("🟫 Ground height: \(groundHeight), position Y: \(ground.position.y)")
    }

    
    func setupRabbit() {
        rabbit = RabbitNode()
        let rabbitY: CGFloat = groundHeight + Constants.rabbitSize.height / 2 + 5
        rabbit.position = CGPoint(x: size.width * 0.5, y: rabbitY)
        rabbit.zPosition = 1
        addChild(rabbit)
    }
    
    private func canSpawnPlatform(currentTime: TimeInterval) -> Bool {
        // 0) Кулдаун
        if currentTime - lastPlatformSpawnTime < minSpawnCooldown { return false }
        // 1) Лимит по количеству
        if platforms.count >= maxPlatforms { return false }
        // 2) Минимальная дистанция по X от самой правой платформы до левого края экрана (точки спавна)
        if let rightmost = platforms.max(by: { $0.position.x < $1.position.x }) {
            let rightmostRightEdge = rightmost.position.x + rightmost.size.width / 2
            // Новая платформа появляется за правым краем экрана своим левым краем около size.width
            // Требуем, чтобы между правым краем последней и левым краем экрана был зазор
            let spawnLeftEdgeX = size.width
            let gap = spawnLeftEdgeX - rightmostRightEdge
            if gap < minPlatformGapX {
                return false
            }
        }
        return true
    }
    
    func spawnPlatform(currentTime: TimeInterval) {
        guard canSpawnPlatform(currentTime: currentTime) else {
            print("⏳ Skip spawn: constraints (count/gap/cooldown) not met")
            return
        }
        
        let sizes: [PlatformSize] = [.small, .medium, .large]
        let randomSize = sizes.randomElement()!
        
        let platform = PlatformNode(worldName: "green_forest", size: randomSize)
        
        // Позиция: справа за экраном, на случайной высоте
        let minY: CGFloat = groundHeight + 40
        let maxY: CGFloat = size.height - 200
        let randomY = CGFloat.random(in: minY...maxY)
        
        platform.position = CGPoint(x: size.width + platform.size.width / 2, y: randomY)
        platform.zPosition = 5
        
        addChild(platform)
        platforms.append(platform)
        lastPlatformSpawnTime = currentTime
        
        print("🟩 Platform spawned at Y: \(randomY)")
    }
    
    func movePlatforms(deltaTime: CGFloat) {
        let moveSpeed = Constants.initialGameSpeed * 10.0 * deltaTime
        
        for platform in platforms {
            platform.position.x -= moveSpeed
        }
        
        platforms.removeAll { platform in
            if platform.position.x < -platform.size.width {
                platform.removeFromParent()
                return true
            }
            return false
        }
    }
    
    func setupGestureRecognizers() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        tapGesture.numberOfTapsRequired = 1
        view?.addGestureRecognizer(tapGesture)
        
        let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress))
        longPressGesture.minimumPressDuration = 0.3
        view?.addGestureRecognizer(longPressGesture)
        
        longPressGesture.require(toFail: tapGesture)
    }
    
    @objc func handleTap() {
        if rabbit.isOnGround {
            rabbit.normalJump()
        } else {
            rabbit.doubleJump()
        }
    }
    
    @objc func handleLongPress(gesture: UILongPressGestureRecognizer) {
        if gesture.state == .began {
            rabbit.highJump()
        }
    }
    
    func startGame() {
        isGameRunning = true
        rabbit.startRunAnimation()
    }
    
    override func update(_ currentTime: TimeInterval) {
        guard isGameRunning else { return }
        
        if lastUpdateTime == 0 {
            lastUpdateTime = currentTime
        }
        let deltaTime = currentTime - lastUpdateTime
        lastUpdateTime = currentTime
        
        background.update(deltaTime: CGFloat(deltaTime), gameSpeed: Constants.initialGameSpeed)
        
        // Спавн платформ: используем while, но вызываем spawnPlatform с проверками
        platformSpawnTimer += deltaTime
        while platformSpawnTimer >= platformSpawnInterval {
            spawnPlatform(currentTime: currentTime)
            platformSpawnTimer -= platformSpawnInterval
        }
        
        movePlatforms(deltaTime: CGFloat(deltaTime))
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        let maskA = contact.bodyA.categoryBitMask
        let maskB = contact.bodyB.categoryBitMask
        let collision = maskA | maskB
        
        // Приземление на землю
        if collision == Constants.PhysicsCategory.player | Constants.PhysicsCategory.ground {
            rabbit.landed()
            return
        }
        
        // Приземление на платформу — только если контакт "сверху"
        if collision == Constants.PhysicsCategory.player | Constants.PhysicsCategory.platform {
            // Определяем кто игрок, кто платформа
            let playerBody = (maskA == Constants.PhysicsCategory.player) ? contact.bodyA : contact.bodyB
            let platformBody = (maskA == Constants.PhysicsCategory.platform) ? contact.bodyA : contact.bodyB
            
            guard let playerNode = playerBody.node as? RabbitNode,
                  let _ = platformBody.node as? SKSpriteNode else {
                return
            }
            
            // Скорость игрока должна быть вниз
            let isFalling = (playerNode.physicsBody?.velocity.dy ?? 0) <= 0
            
            // Нормаль контакта: хотим "от платформы к игроку" иметь положительный dy
            // В SpriteKit нормаль направлена из bodyA к bodyB.
            var normal = contact.contactNormal
            // Если bodyA не платформа, инвертируем нормаль (чтобы она была от платформы к игроку)
            if contact.bodyA.categoryBitMask != Constants.PhysicsCategory.platform {
                normal = CGVector(dx: -normal.dx, dy: -normal.dy)
            }
            let isFromPlatformUp = normal.dy > 0.5
            
            if isFalling && isFromPlatformUp {
                playerNode.landed()
            }
        }
    }
}

