import SpriteKit

enum ObstacleType: String, CaseIterable {
    case log = "log"
    case rock = "rock"
    case stump = "stump"
    case pit = "pit"
    case hedgehog = "hedgehog"
    
    var size: CGSize {
        switch self {
        case .log:
            return CGSize(width: 100, height: 50)  // Было 120x60
        case .rock:
            return CGSize(width: 60, height: 60)   // Было 80x80
        case .stump:
            return CGSize(width: 70, height: 70)   // Было 90x90
        case .pit:
            return CGSize(width: 70, height: 30)  // Было 150x70
        case .hedgehog:
            return CGSize(width: 70, height: 50)   // Было 96x96
        }
    }
    
    func textureName(worldName: String) -> String {
        switch self {
        case .log:
            // Уникальное для мира
            return "obstacle_\(worldName)_log"
        case .hedgehog:
            // Для ёжика берём первый кадр анимации
            return "obstacle_hedgehog_1"
        default:
            // Универсальные препятствия
            return "obstacle_\(self.rawValue)"
        }
    }
    
    var isAnimated: Bool {
        return self == .hedgehog
    }
    
    // Цвета-заглушки если нет текстур
    var placeholderColor: UIColor {
        switch self {
        case .log: return .brown
        case .rock: return .gray
        case .stump: return UIColor(red: 0.6, green: 0.4, blue: 0.2, alpha: 1.0)
        case .pit: return .red
        case .hedgehog: return UIColor(red: 0.8, green: 0.6, blue: 0.4, alpha: 1.0)
        }
    }
}

class ObstacleNode: SKSpriteNode {
    
    let obstacleType: ObstacleType
    private var animationTextures: [SKTexture] = []
    
    init(type: ObstacleType, worldName: String = "green_forest") {
        self.obstacleType = type
        
        // Загружаем текстуру
        let textureName = type.textureName(worldName: worldName)
        let texture = SKTexture(imageNamed: textureName)
        
        super.init(texture: texture.size().width > 0 ? texture : nil,
                   color: type.placeholderColor,
                   size: type.size)
        
        // Если текстуры нет - показываем цвет
        if texture.size().width == 0 {
            self.texture = nil
            print("⚠️ Obstacle texture not found: \(textureName), using placeholder color")
        }
        
        setupPhysics()
        
        // Если это анимированный объект - загружаем анимацию
        if type.isAnimated {
            loadAnimation(worldName: worldName)
            startAnimation()
        }
        
        print("🚧 ObstacleNode created: \(type.rawValue)")
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupPhysics() {
        var physicsSize: CGSize
        var offset: CGPoint = .zero
        
        switch obstacleType {
        case .pit:
            // Яма - только верхняя часть опасна (очень тонкая)
            physicsSize = CGSize(width: size.width * 0.01, height: size.height * 0.01)
            offset = CGPoint(x: 0, y: size.height / 3)
        case .hedgehog:
            // Ёжик - маленькое тело (60% от размера)
            physicsSize = CGSize(width: size.width * 0.01, height: size.height * 0.01)
        case .log:
            // Бревно - можно перепрыгнуть (70% высоты)
            physicsSize = CGSize(width: size.width * 0.01, height: size.height * 0.01)
        default:
            // Остальные (камень, пень) - 65% от размера
            physicsSize = CGSize(width: size.width * 0.01, height: size.height * 0.01)
        }
        
        physicsBody = SKPhysicsBody(rectangleOf: physicsSize, center: offset)
        physicsBody?.isDynamic = false
        physicsBody?.categoryBitMask = Constants.PhysicsCategory.obstacle
        physicsBody?.contactTestBitMask = Constants.PhysicsCategory.player
        physicsBody?.collisionBitMask = Constants.PhysicsCategory.none
        
        print("🔧 Physics body: \(physicsSize) for \(obstacleType.rawValue)")
    }
    
    private func loadAnimation(worldName: String) {
        // Пробуем загрузить анимацию ёжика
        for i in 1...3 {
            let textureName = "obstacle_hedgehog_\(i)"
            let texture = SKTexture(imageNamed: textureName)
            
            if texture.size().width > 0 {
                animationTextures.append(texture)
                print("✅ Loaded hedgehog frame: \(textureName)")
            } else {
                print("⚠️ Hedgehog frame not found: \(textureName)")
            }
        }
        
        // Если не загрузилось - используем базовую текстуру
        if animationTextures.isEmpty {
            print("⚠️ No hedgehog animation frames loaded")
        }
    }
    
    private func startAnimation() {
        guard !animationTextures.isEmpty else { return }
        
        let animate = SKAction.animate(with: animationTextures, timePerFrame: 0.2)
        let repeatForever = SKAction.repeatForever(animate)
        run(repeatForever, withKey: "obstacle_animation")
    }
    
    // Эффект столкновения
    func hit() {
        // Небольшая анимация при столкновении
        let scaleUp = SKAction.scale(to: 1.2, duration: 0.1)
        let scaleDown = SKAction.scale(to: 1.0, duration: 0.1)
        let sequence = SKAction.sequence([scaleUp, scaleDown])
        run(sequence)
    }
}
