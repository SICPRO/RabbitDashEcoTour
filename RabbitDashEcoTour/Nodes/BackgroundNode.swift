import SpriteKit

class BackgroundNode: SKNode {
    
    private var layer1Sprites: [SKSpriteNode] = []
    private var layer2Sprites: [SKSpriteNode] = []
    private var layer3Sprites: [SKSpriteNode] = []
    
    // Явный параллакс
    private let layer1Speed: CGFloat = 1.5   // дальний
    private let layer2Speed: CGFloat = 3.0   // средний
    private let layer3Speed: CGFloat = 6.0   // ближний
    
    private var screenWidth: CGFloat = 0
    private var screenHeight: CGFloat = 0
    
    private let overlap: CGFloat = 6
    
    private var layer1TileWidth: CGFloat = 0
    private var layer2TileWidth: CGFloat = 0
    private var layer3TileWidth: CGFloat = 0
    
    // Аккумуляторы дробных смещений по X для каждого слоя
    private var layer1FracShift: CGFloat = 0
    private var layer2FracShift: CGFloat = 0
    private var layer3FracShift: CGFloat = 0
    
    init(worldName: String, screenSize: CGSize) {
        super.init()
        
        self.screenWidth = screenSize.width
        self.screenHeight = screenSize.height
        
        layer1TileWidth = setupLayer(
            layerName: "bg_\(worldName)_layer1",
            yPosition: screenSize.height / 2,
            zPosition: -30,
            array: &layer1Sprites,
            anchorBottom: false,
            fitToScreen: true
        )
        
        layer2TileWidth = setupLayer(
            layerName: "bg_\(worldName)_layer2",
            yPosition: screenSize.height / 2,
            zPosition: -20,
            array: &layer2Sprites,
            anchorBottom: false,
            fitToScreen: false
        )
        
        layer3TileWidth = setupLayer(
            layerName: "bg_\(worldName)_layer3",
            yPosition: 0,
            zPosition: 2,
            array: &layer3Sprites,
            anchorBottom: true,
            fitToScreen: false
        )
        
        print("🌲 Background for '\(worldName)' created | tileWidths: L1=\(layer1TileWidth), L2=\(layer2TileWidth), L3=\(layer3TileWidth)")
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @discardableResult
    private func setupLayer(
        layerName: String,
        yPosition: CGFloat,
        zPosition: CGFloat,
        array: inout [SKSpriteNode],
        anchorBottom: Bool = false,
        fitToScreen: Bool = false
    ) -> CGFloat {
        let texture = SKTexture(imageNamed: layerName)
        if texture.size().width == 0 {
            print("⚠️ Background texture not found: \(layerName)")
            return 0
        }
        
        var scale: CGFloat = 1.0
        if fitToScreen {
            scale = screenHeight / texture.size().height
        }
        let spriteWidth = texture.size().width * scale
        
        for i in 0..<3 {
            let sprite = SKSpriteNode(texture: texture)
            sprite.anchorPoint = anchorBottom ? CGPoint(x: 0, y: 0) : CGPoint(x: 0, y: 0.5)
            sprite.xScale = scale
            sprite.yScale = scale
            sprite.texture?.filteringMode = .nearest
            
            let x = CGFloat(i) * (spriteWidth - overlap)
            sprite.position = CGPoint(x: x, y: yPosition) // без округления на старте
            sprite.zPosition = zPosition
            
            addChild(sprite)
            array.append(sprite)
        }
        return spriteWidth
    }
    
    func update(deltaTime: CGFloat, gameSpeed: CGFloat) {
        if layer1TileWidth == 0 || layer2TileWidth == 0 || layer3TileWidth == 0 {
            print("⚠️ Background: some tileWidth == 0 (L1 \(layer1TileWidth), L2 \(layer2TileWidth), L3 \(layer3TileWidth))")
        }
        moveLayer(array: layer1Sprites, tileWidth: layer1TileWidth, speed: layer1Speed * gameSpeed * deltaTime, fracShift: &layer1FracShift)
        moveLayer(array: layer2Sprites, tileWidth: layer2TileWidth, speed: layer2Speed * gameSpeed * deltaTime, fracShift: &layer2FracShift)
        moveLayer(array: layer3Sprites, tileWidth: layer3TileWidth, speed: layer3Speed * gameSpeed * deltaTime, fracShift: &layer3FracShift)
    }
    
    private func moveLayer(array: [SKSpriteNode], tileWidth: CGFloat, speed: CGFloat, fracShift: inout CGFloat) {
        guard tileWidth > 0 else { return }
        
        // Накопим смещение
        fracShift += speed
        
        // Целая часть — столько реально сдвигаем узлы
        let shiftInt = floor(fracShift)
        if shiftInt >= 1 {
            // Вычитаем целую часть из аккумулятора
            fracShift -= shiftInt
            
            for sprite in array {
                sprite.position.x -= shiftInt
                
                // Перестановка вправо при уходе за левый край
                let spriteRight = sprite.position.x + tileWidth
                if spriteRight < 0 {
                    if let maxSprite = array.max(by: { $0.position.x < $1.position.x }) {
                        let newX = maxSprite.position.x + tileWidth - overlap
                        sprite.position.x = newX
                    }
                }
            }
        }
    }
}

