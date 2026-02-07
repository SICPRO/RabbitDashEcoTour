import SpriteKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    var rabbit: RabbitNode!
    var ground: SKSpriteNode!
    var background: BackgroundNode!
    
    // Скорость игры
    var currentGameSpeed: CGFloat = Constants.initialGameSpeed
    var speedIncreaseTimer: TimeInterval = 0
    let speedIncreaseInterval: TimeInterval = 10.0  // Ускорение каждые 10 сек
    
    // HUD элементы
    var carrotCountLabel: SKLabelNode!
    var carrotIcon: SKSpriteNode!
    
    var platforms: [PlatformNode] = []
    var platformSpawnTimer: TimeInterval = 0
    let platformSpawnInterval: TimeInterval = 6.5  // Интервал спавна платформ
    
    // Морковки
    var carrots: [CarrotNode] = []
    var carrotSpawnTimer: TimeInterval = 0
    let carrotSpawnInterval: TimeInterval = 2.5  // Каждые 2.5 секунды
    var carrotsCollected: Int = 0
    
    // Препятствия
    var obstacles: [ObstacleNode] = []
    var obstacleSpawnTimer: TimeInterval = 0
    let obstacleSpawnInterval: TimeInterval = 3.5  // Каждые 3.5 секунды
    
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
    var isGameOver: Bool = false
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
        setupHUD()
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
    
    func setupHUD() {
        // Создаём красивую панель для счётчика (справа вверху)
        let panelWidth: CGFloat = 180
        let panelHeight: CGFloat = 60
        
        // Фон панели (округлый прямоугольник)
        let panel = SKShapeNode(rectOf: CGSize(width: panelWidth, height: panelHeight), cornerRadius: 15)
        panel.fillColor = UIColor(red: 0.2, green: 0.15, blue: 0.1, alpha: 0.9)
        panel.strokeColor = UIColor(red: 0.8, green: 0.6, blue: 0.3, alpha: 1.0)
        panel.lineWidth = 3
        panel.position = CGPoint(x: size.width - 120, y: size.height - 50)  // Справа!
        panel.zPosition = 99
        addChild(panel)
        
        // Иконка морковки (слева в панели)
        carrotIcon = SKSpriteNode(imageNamed: "hud_carrot_icon")
        carrotIcon.size = CGSize(width: 40, height: 40)
        carrotIcon.position = CGPoint(x: -50, y: 0)
        carrotIcon.zPosition = 1
        panel.addChild(carrotIcon)
        
        // Счётчик морковок (справа в панели)
        carrotCountLabel = SKLabelNode(fontNamed: "Arial-BoldMT")
        carrotCountLabel.fontSize = 36
        carrotCountLabel.fontColor = UIColor(red: 1.0, green: 0.9, blue: 0.7, alpha: 1.0)
        carrotCountLabel.position = CGPoint(x: 20, y: -12)
        carrotCountLabel.horizontalAlignmentMode = .left
        carrotCountLabel.zPosition = 1
        carrotCountLabel.text = "0"
        panel.addChild(carrotCountLabel)
        
        print("📊 HUD created")
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
    
    func spawnCarrot() {
        let carrot = CarrotNode()
        
        // Случайная позиция по высоте
        let minY: CGFloat = groundHeight + 80
        let maxY: CGFloat = size.height - 150
        let randomY = CGFloat.random(in: minY...maxY)
        
        // Появляется справа за экраном
        carrot.position = CGPoint(x: size.width + carrot.size.width, y: randomY)
        carrot.zPosition = 10  // Поверх фона
        
        addChild(carrot)
        carrots.append(carrot)
        
        print("🥕 Carrot spawned at Y: \(randomY)")
    }
    
    func spawnObstacle() {
        // Случайный тип препятствия
        let types: [ObstacleType] = [.log, .rock, .stump, .pit, .hedgehog]
        let randomType = types.randomElement()!
        
        let obstacle = ObstacleNode(type: randomType, worldName: "green_forest")
        
        // Позиция Y: ВСЕГДА на земле (препятствия не летают)
        let yPosition = groundHeight + obstacle.size.height / 2
        
        obstacle.position = CGPoint(x: size.width + obstacle.size.width, y: yPosition)
        obstacle.zPosition = 8
        
        addChild(obstacle)
        obstacles.append(obstacle)
        
        print("🚧 Obstacle spawned: \(randomType.rawValue) at Y: \(yPosition)")
    }
    
    func movePlatforms(deltaTime: CGFloat) {
        let moveSpeed = currentGameSpeed * 10.0 * deltaTime
        
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
    
    func moveCarrots(deltaTime: CGFloat) {
        let moveSpeed = currentGameSpeed * 10.0 * deltaTime
        
        for carrot in carrots {
            carrot.position.x -= moveSpeed
        }
        
        // Удаляем морковки за левым краем экрана
        carrots.removeAll { carrot in
            if carrot.position.x < -carrot.size.width {
                carrot.removeFromParent()
                print("🗑️ Carrot removed (off-screen)")
                return true
            }
            return false
        }
    }
    
    func moveObstacles(deltaTime: CGFloat) {
        let moveSpeed = currentGameSpeed * 10.0 * deltaTime
        
        for obstacle in obstacles {
            obstacle.position.x -= moveSpeed
        }
        
        // Удаляем препятствия за левым краем экрана
        obstacles.removeAll { obstacle in
            if obstacle.position.x < -obstacle.size.width {
                obstacle.removeFromParent()
                print("🗑️ Obstacle removed (off-screen)")
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
        // БЛОКИРУЕМ жесты если игра закончена
        guard !isGameOver else {
            print("⚠️ Tap blocked - game is over")
            return
        }
        
        if rabbit.isOnGround {
            rabbit.normalJump()
        } else {
            rabbit.doubleJump()
        }
    }

    @objc func handleLongPress(gesture: UILongPressGestureRecognizer) {
        // БЛОКИРУЕМ жесты если игра закончена
        guard !isGameOver else {
            print("⚠️ Long press blocked - game is over")
            return
        }
        
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
        
        // Проверка: если кролик падает слишком быстро вниз, сбрасываем состояние
        if let velocity = rabbit.physicsBody?.velocity {
            // Если кролик падает очень быстро и почти на земле
            if velocity.dy < -300 && rabbit.position.y < groundHeight + 100 {
                if !rabbit.isOnGround {
                    print("🚨 Emergency landing detection")
                    rabbit.landed()
                }
            }
        }
        
        if lastUpdateTime == 0 {
            lastUpdateTime = currentTime
        }
        let deltaTime = currentTime - lastUpdateTime
        lastUpdateTime = currentTime
        
        // Постепенное ускорение игры
        speedIncreaseTimer += deltaTime
        if speedIncreaseTimer >= speedIncreaseInterval {
            speedIncreaseTimer = 0
            
            // Увеличиваем скорость на 10%
            let newSpeed = currentGameSpeed * 1.1
            let maxSpeed = Constants.initialGameSpeed * 2.0
            
            if newSpeed <= maxSpeed {
                currentGameSpeed = newSpeed
                print("⚡ Speed increased to: \(currentGameSpeed)")
            }
        }
        
        background.update(deltaTime: CGFloat(deltaTime), gameSpeed: currentGameSpeed)
        
        // Спавн платформ: используем while, но вызываем spawnPlatform с проверками
        platformSpawnTimer += deltaTime
        while platformSpawnTimer >= platformSpawnInterval {
            spawnPlatform(currentTime: currentTime)
            platformSpawnTimer -= platformSpawnInterval
        }
        
        movePlatforms(deltaTime: CGFloat(deltaTime))
        
        // Спавн морковок
        carrotSpawnTimer += deltaTime
        if carrotSpawnTimer >= carrotSpawnInterval {
            spawnCarrot()
            carrotSpawnTimer = 0
        }

        moveCarrots(deltaTime: CGFloat(deltaTime))
        
        // Спавн препятствий
        obstacleSpawnTimer += deltaTime
        if obstacleSpawnTimer >= obstacleSpawnInterval {
            spawnObstacle()
            obstacleSpawnTimer = 0
        }

        moveObstacles(deltaTime: CGFloat(deltaTime))
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        let maskA = contact.bodyA.categoryBitMask
        let maskB = contact.bodyB.categoryBitMask
        let collision = maskA | maskB
        
        // Столкновение с препятствием → Game Over
        if collision == Constants.PhysicsCategory.player | Constants.PhysicsCategory.obstacle {
            let obstacleBody = (maskA == Constants.PhysicsCategory.obstacle) ? contact.bodyA : contact.bodyB
            
            if let obstacleNode = obstacleBody.node as? ObstacleNode {
                hitObstacle(obstacleNode)
            }
            return
        }
        
        // Сбор морковки (обрабатываем ПЕРВЫМ, не зависит от приземления)
        if collision == Constants.PhysicsCategory.player | Constants.PhysicsCategory.carrot {
            let carrotBody = (maskA == Constants.PhysicsCategory.carrot) ? contact.bodyA : contact.bodyB
            
            if let carrotNode = carrotBody.node as? CarrotNode {
                collectCarrot(carrotNode)
            }
            return // Выходим, чтобы не обрабатывать другие коллизии
        }
        
        // Приземление на землю
        if collision == Constants.PhysicsCategory.player | Constants.PhysicsCategory.ground {
            // Проверяем что кролик действительно падает
            if let velocity = rabbit.physicsBody?.velocity, velocity.dy <= 10 {
                rabbit.landed()
                print("🟫 Landed on ground")
            }
            return
        }
        
        // Приземление на платформу — только если контакт "сверху"
        if collision == Constants.PhysicsCategory.player | Constants.PhysicsCategory.platform {
            let playerBody = (maskA == Constants.PhysicsCategory.player) ? contact.bodyA : contact.bodyB
            let platformBody = (maskA == Constants.PhysicsCategory.platform) ? contact.bodyA : contact.bodyB
            
            guard let playerNode = playerBody.node as? RabbitNode,
                  let _ = platformBody.node as? SKSpriteNode else {
                return
            }
            
            // Кролик должен падать (не прыгать вверх)
            guard let velocity = playerNode.physicsBody?.velocity, velocity.dy <= 10 else {
                print("⚠️ Platform contact but rabbit going up (velocity.dy = \(playerNode.physicsBody?.velocity.dy ?? 0))")
                return
            }
            
            // Нормаль контакта должна быть "вверх"
            var normal = contact.contactNormal
            if contact.bodyA.categoryBitMask != Constants.PhysicsCategory.platform {
                normal = CGVector(dx: -normal.dx, dy: -normal.dy)
            }
            
            // Требуем более строгую проверку нормали
            if normal.dy > 0.7 {
                playerNode.landed()
                print("🟩 Landed on platform (normal.dy = \(normal.dy))")
            } else {
                print("⚠️ Platform contact but bad normal (dy = \(normal.dy))")
            }
        }
    }
    
    func collectCarrot(_ carrot: CarrotNode) {
        // Увеличиваем счётчик
        carrotsCollected += 1
        
        // Обновляем HUD
        carrotCountLabel.text = "\(carrotsCollected)"
        
        // Звук (пока заглушка)
        AudioManager.shared.playSFX("sfx_collect_carrot")
        
        // Удаляем из массива
        if let index = carrots.firstIndex(of: carrot) {
            carrots.remove(at: index)
        }
        
        // Анимация сбора
        carrot.collect {
            print("✨ Carrot collected! Total: \(self.carrotsCollected)")
        }
    }
    
    func hitObstacle(_ obstacle: ObstacleNode) {
        guard isGameRunning else { return }
        
        print("💥 Hit obstacle: \(obstacle.obstacleType.rawValue)")
        
        // СРАЗУ останавливаем игру И блокируем ввод
        isGameRunning = false
        isGameOver = true  // ← ДОБАВЬ ЭТУ СТРОКУ
        
        // Эффект на препятствии
        obstacle.hit()
        
        // Звук
        AudioManager.shared.playSFX("sfx_hit_obstacle")
        
        // ВАЖНО: Останавливаем движение кролика ПЛАВНО
        if let velocity = rabbit.physicsBody?.velocity {
            // Обнуляем только горизонтальную скорость
            rabbit.physicsBody?.velocity = CGVector(dx: 0, dy: velocity.dy)
        }
        
        // Отключаем гравитацию для кролика (чтобы не летел дальше)
        rabbit.physicsBody?.affectedByGravity = false
        rabbit.physicsBody?.velocity = .zero
        
        print("🎬 Playing hit animation...")
        
        // Проигрываем анимацию удара БЕЗ страховки (она теперь внутри)
        rabbit.playHitAnimation {
            print("🎬 Hit animation completed, calling gameOver")
            self.gameOver()
        }
    }

    func gameOver() {
        // Защита от повторных вызовов
        guard rabbit.physicsBody != nil else {
            print("⚠️ gameOver already called, skipping")
            return
        }
        
        print("💀 GAME OVER!")
        print("📊 Stats:")
        print("   Carrots collected: \(carrotsCollected)")
        
        // Полностью останавливаем кролика
        rabbit.removeAllActions()
        rabbit.physicsBody = nil  // Удаляем физику полностью
        
        // TODO: Переход в бонусную игру Lucky Harvest
        // ВРЕМЕННО: перезапускаем через 2 секунды
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            // Пока рестарт, потом заменим на Lucky Harvest
            self.transitionToBonusGame()
        }
    }

    // НОВАЯ функция (пока заглушка)
    func transitionToBonusGame() {
        print("🎰 Transitioning to Lucky Harvest...")
        
        // Пока просто рестарт, скоро заменим
        self.restartGame()
    }

    func restartGame() {
        // Очищаем сцену
        removeAllChildren()
        
        // Очищаем массивы
        platforms.removeAll()
        carrots.removeAll()
        obstacles.removeAll()
        
        // Сбрасываем таймеры
        platformSpawnTimer = 0
        carrotSpawnTimer = 0
        obstacleSpawnTimer = 0
        lastUpdateTime = 0
        carrotsCollected = 0
        currentGameSpeed = Constants.initialGameSpeed
        speedIncreaseTimer = 0
        
        isGameOver = false
        
        // Пересоздаём сцену
        setupPhysics()
        setupBackground()
        setupGround()
        setupRabbit()
        
        // Включаем физику кролика обратно
        rabbit.physicsBody?.isDynamic = true
        
        setupHUD()
        
        startGame()
        
        print("🔄 Game restarted")
    }
}

