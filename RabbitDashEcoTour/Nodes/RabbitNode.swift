import SpriteKit

class RabbitNode: SKSpriteNode {
    
    var isOnGround: Bool = true
    private var hasDoubleJump: Bool = false
    
    private var idleTextures: [SKTexture] = []
    private var runTextures: [SKTexture] = []
    private var jumpTextures: [SKTexture] = []
    
    init() {
        let initialTexture = SKTexture(imageNamed: "rabbit_idle_1")
        super.init(texture: initialTexture, color: .clear, size: Constants.rabbitSize)
        
        setupPhysicsBody()
        loadAnimations()
        startIdleAnimation()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupPhysicsBody() {
        // Уменьшаем физическое тело
        let physicsSize = CGSize(
            width: size.width * 0.7,
            height: size.height * 0.7
        )
        
        physicsBody = SKPhysicsBody(rectangleOf: physicsSize)
        physicsBody?.isDynamic = true
        physicsBody?.allowsRotation = false
        physicsBody?.categoryBitMask = Constants.PhysicsCategory.player
        physicsBody?.contactTestBitMask = Constants.PhysicsCategory.obstacle | Constants.PhysicsCategory.carrot | Constants.PhysicsCategory.platform | Constants.PhysicsCategory.ground
        physicsBody?.collisionBitMask = Constants.PhysicsCategory.ground | Constants.PhysicsCategory.platform  // <-- ВЕРНИ PLATFORM!
        physicsBody?.restitution = 0
        physicsBody?.friction = 0.3
    }
    
    private func loadAnimations() {
        print("🎨 Loading rabbit animations...")
        
        // Проверяем что атлас существует
        let atlas = SKTextureAtlas(named: "Rabbit")
        print("🎨 Atlas 'Rabbit' texture names: \(atlas.textureNames)")
        
        // Если атлас пустой
        if atlas.textureNames.isEmpty {
            print("❌ Atlas 'Rabbit' is empty or not found!")
        }
        
        // Idle animation
        for i in 1...5 {
            let textureName = "rabbit_idle_\(i)"
            
            // Пробуем загрузить из атласа
            if atlas.textureNames.contains(textureName) {
                let texture = atlas.textureNamed(textureName)
                idleTextures.append(texture)
                print("✅ Loaded from atlas: \(textureName)")
            } else {
                print("❌ NOT FOUND in atlas: \(textureName)")
            }
        }
        
        // Если не нашли idle, используем fallback
        if idleTextures.isEmpty {
            print("⚠️ No idle textures! Creating colored sprite")
            // Создадим хотя бы пустую текстуру
            let texture = SKTexture()
            idleTextures.append(texture)
        }
        
        // Run animation
        for i in 1...6 {
            let textureName = "rabbit_run_\(i)"
            
            if atlas.textureNames.contains(textureName) {
                let texture = atlas.textureNamed(textureName)
                runTextures.append(texture)
                print("✅ Loaded from atlas: \(textureName)")
            } else {
                print("❌ NOT FOUND in atlas: \(textureName)")
            }
        }
        
        if runTextures.isEmpty {
            print("⚠️ No run textures! Using idle")
            runTextures = idleTextures
        }
        
        for i in 1...5 {
                let textureName = "rabbit_jump_\(i)"
                if atlas.textureNames.contains(textureName) {
                    let texture = atlas.textureNamed(textureName)
                    jumpTextures.append(texture)
                    print("✅ Loaded from atlas: \(textureName)")
                } else {
                    print("❌ NOT FOUND in atlas: \(textureName)")
                }
            }
            
            if jumpTextures.isEmpty {
                print("⚠️ No jump textures! Using idle")
                jumpTextures = idleTextures
            }
        
        print("🎨 Total idle frames: \(idleTextures.count)")
        print("🎨 Total run frames: \(runTextures.count)")
        print("🎨 Total jump frames: \(jumpTextures.count)")
    }
    
    func startIdleAnimation() {
        removeAllActions()
        let idleAction = SKAction.animate(with: idleTextures, timePerFrame: 0.15)
        let repeatAction = SKAction.repeatForever(idleAction)
        run(repeatAction, withKey: "idle")
    }
    
    func startRunAnimation() {
        removeAction(forKey: "idle")
        let runAction = SKAction.animate(with: runTextures, timePerFrame: 0.1)
        let repeatAction = SKAction.repeatForever(runAction)
        run(repeatAction, withKey: "run")
    }
    
    func startJumpAnimation() {
        removeAllActions()
        let jumpAction = SKAction.animate(with: jumpTextures, timePerFrame: 0.08)
        run(jumpAction, withKey: "jump")
    }
    
    func normalJump() {
        guard isOnGround else { return }
        physicsBody?.velocity = CGVector(dx: 0, dy: 0)
        physicsBody?.applyImpulse(CGVector(dx: 0, dy: Constants.normalJumpForce))
        isOnGround = false
        hasDoubleJump = true
        startJumpAnimation()
        AudioManager.shared.playSFX("sfx_jump")
    }
    
    func highJump() {
        guard isOnGround else { return }
        physicsBody?.velocity = CGVector(dx: 0, dy: 0)
        physicsBody?.applyImpulse(CGVector(dx: 0, dy: Constants.highJumpForce))
        isOnGround = false
        hasDoubleJump = true
        startJumpAnimation()
        AudioManager.shared.playSFX("sfx_jump")
    }
    
    func doubleJump() {
        guard hasDoubleJump && !isOnGround else { return }
        physicsBody?.velocity = CGVector(dx: 0, dy: 0)
        physicsBody?.applyImpulse(CGVector(dx: 0, dy: Constants.doubleJumpForce))
        hasDoubleJump = false
        startJumpAnimation()
        AudioManager.shared.playSFX("sfx_double_jump")
    }
    
    func landed() {
        isOnGround = true
        hasDoubleJump = false
        startRunAnimation()
    }
    
    func checkPlatformLanding(contact: SKPhysicsContact) {
        let platformBody = contact.bodyA.categoryBitMask == Constants.PhysicsCategory.platform ?
            contact.bodyA : contact.bodyB
        
        guard let platformNode = platformBody.node else { return }
        
        // Проверяем что кролик падает (не прыгает вверх)
        guard let velocity = physicsBody?.velocity, velocity.dy <= 10 else { return }
        
        let platformTop = platformNode.position.y + (platformNode.frame.size.height / 2)
        let rabbitBottom = position.y - (size.height / 2)
        
        // Более мягкая проверка
        if rabbitBottom >= platformTop - 20 && rabbitBottom <= platformTop + 30 {
            isOnGround = true
            hasDoubleJump = false
            startRunAnimation()
        }
    }
}
