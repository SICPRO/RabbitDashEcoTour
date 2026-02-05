import SpriteKit

enum PlatformSize {
    case small
    case medium
    case large
    
    var width: CGFloat {
        switch self {
        case .small: return 200
        case .medium: return 350
        case .large: return 500
        }
    }
}

class PlatformNode: SKSpriteNode {
    
    init(worldName: String, size: PlatformSize) {
        // Загружаем текстуру
        let textureName = "platform_\(worldName)"
        let texture = SKTexture(imageNamed: textureName)
        
        // Вычисляем размер
        let targetWidth = size.width
        let aspectRatio = texture.size().height / texture.size().width
        let targetHeight = targetWidth * aspectRatio
        let targetSize = CGSize(width: targetWidth, height: targetHeight)
        
        super.init(texture: texture, color: .clear, size: targetSize)
        
        setupPhysics()
        
        print("🟩 Platform created: \(size), actual size: \(targetSize)")
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupPhysics() {
        // Делаем верхнюю "крышку" платформы толще и шире для стабильной посадки
        let physicsHeight: CGFloat = size.height * 0.4
        let physicsSize = CGSize(width: size.width * 1.0, height: physicsHeight)
        let offset = CGPoint(x: 0, y: size.height / 2 - physicsHeight / 2)
        
        physicsBody = SKPhysicsBody(rectangleOf: physicsSize, center: offset)
        physicsBody?.isDynamic = false
        physicsBody?.categoryBitMask = Constants.PhysicsCategory.platform
        physicsBody?.contactTestBitMask = Constants.PhysicsCategory.player
        physicsBody?.collisionBitMask = Constants.PhysicsCategory.player  // ВАЖНО: твёрдая платформа
        physicsBody?.friction = 0.15
        physicsBody?.restitution = 0
    }
}
