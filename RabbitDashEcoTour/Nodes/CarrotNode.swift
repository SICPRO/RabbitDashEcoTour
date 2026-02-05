import SpriteKit

class CarrotNode: SKSpriteNode {
    
    private var shineTextures: [SKTexture] = []
    private var idleTexture: SKTexture!
    
    init() {
        // Загружаем базовую текстуру
        let baseTexture = SKTexture(imageNamed: "carrot_gold")
        let size = CGSize(width: 64, height: 64)
        
        super.init(texture: baseTexture, color: .clear, size: size)
        
        loadAnimations()
        setupPhysics()
        startShineAnimation()
        
        print("🥕 CarrotNode created")
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func loadAnimations() {
        // Пробуем загрузить из атласа
        let atlas = SKTextureAtlas(named: "Carrot")
        
        // Если атлас есть
        if !atlas.textureNames.isEmpty {
            print("✅ Carrot atlas found with \(atlas.textureNames.count) textures")
            
            // Загружаем shine анимацию
            for i in 1...5 {
                let textureName = "carrot_gold_shine_\(i)"
                if atlas.textureNames.contains(textureName) {
                    let texture = atlas.textureNamed(textureName)
                    shineTextures.append(texture)
                    print("✅ Loaded: \(textureName)")
                }
            }
            
            // Загружаем idle текстуру
            if atlas.textureNames.contains("carrot_gold") {
                idleTexture = atlas.textureNamed("carrot_gold")
            }
        } else {
            // Fallback: загружаем напрямую по имени
            print("⚠️ Carrot atlas not found, loading textures directly")
            
            for i in 1...5 {
                let texture = SKTexture(imageNamed: "carrot_gold_shine_\(i)")
                if texture.size().width > 0 {
                    shineTextures.append(texture)
                    print("✅ Loaded directly: carrot_gold_shine_\(i)")
                }
            }
            
            idleTexture = SKTexture(imageNamed: "carrot_gold")
        }
        
        // Если не загрузилось - используем базовую текстуру
        if shineTextures.isEmpty {
            print("⚠️ No shine textures loaded, using base texture")
            shineTextures = [texture ?? SKTexture()]
        }
        
        print("🎨 Total shine frames: \(shineTextures.count)")
    }
    
    private func setupPhysics() {
        // Уменьшаем физическое тело для точности
        let physicsSize = CGSize(width: size.width * 0.7, height: size.height * 0.7)
        
        physicsBody = SKPhysicsBody(rectangleOf: physicsSize)
        physicsBody?.isDynamic = false
        physicsBody?.categoryBitMask = Constants.PhysicsCategory.carrot
        physicsBody?.contactTestBitMask = Constants.PhysicsCategory.player
        physicsBody?.collisionBitMask = Constants.PhysicsCategory.none
    }
    
    private func startShineAnimation() {
        guard !shineTextures.isEmpty else { return }
        
        // Анимация блеска: проигрывается один раз, потом пауза
        let animate = SKAction.animate(with: shineTextures, timePerFrame: 0.1)
        let wait = SKAction.wait(forDuration: 2.0)
        let sequence = SKAction.sequence([animate, wait])
        let repeatForever = SKAction.repeatForever(sequence)
        
        run(repeatForever, withKey: "shine")
    }
    
    // Эффект сбора
    func collect(completion: @escaping () -> Void) {
        // Останавливаем анимацию
        removeAction(forKey: "shine")
        
        // Анимация сбора: вращение + увеличение + исчезновение
        let rotate = SKAction.rotate(byAngle: .pi * 2, duration: 0.3)
        let scaleUp = SKAction.scale(to: 1.8, duration: 0.2)
        let fadeOut = SKAction.fadeOut(withDuration: 0.2)
        
        let group = SKAction.group([rotate, scaleUp, fadeOut])
        let remove = SKAction.removeFromParent()
        
        let sequence = SKAction.sequence([group, remove])
        
        run(sequence) {
            completion()
        }
    }
}
