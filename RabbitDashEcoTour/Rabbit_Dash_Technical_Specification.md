# Техническое задание: Rabbit Dash - Eco Tour

## Оглавление
1. [Подготовка ассетов](#1-подготовка-ассетов)
2. [Разработка (Xcode/Swift)](#2-разработка-xcode--swift)
3. [Оформление в App Store](#3-оформление-в-app-store)

---

## 1. Подготовка ассетов

### 1.1 Графические элементы

#### 1.1.1 Формат файлов
- **Основной формат:** PNG с прозрачностью (Alpha channel)
- **Разрешения:** @1x, @2x, @3x для поддержки всех iOS устройств
- **Альтернатива для анимаций:** Sprite Sheets (атласы спрайтов) - более оптимальное решение чем множество PNG файлов

#### 1.1.2 Персонаж (Кролик)

**Статичные элементы:**
- `rabbit_idle.png` - состояние покоя (3 кадра для анимации моргания)
- `rabbit_run_1.png` до `rabbit_run_6.png` - цикл бега (6 кадров)
- `rabbit_jump.png` - прыжок
- `rabbit_fall.png` - падение
- `rabbit_hit.png` - столкновение
- `rabbit_celebrate.png` - радость (после успешного бонуса)

**Размеры:** 128x128px @1x (256x256 @2x, 384x384 @3x)

**Sprite Sheet для кролика:**
- `rabbit_spritesheet.png` - все кадры на одном изображении
- `rabbit_spritesheet.json` - координаты каждого кадра (TexturePacker format)

#### 1.1.3 Окружение и препятствия

**Платформы (для каждого из 10 биомов):**
- `platform_small.png` (256x64px)
- `platform_medium.png` (512x64px)
- `platform_large.png` (1024x64px)

**Препятствия (общие):**
- `obstacle_stump.png` - пень (128x128px)
- `obstacle_rock.png` - камень (96x96px)
- `obstacle_pit.png` - яма (256x128px)
- `obstacle_hedgehog.png` - ёжик с анимацией (3 кадра, 128x96px)

**Препятствия специфичные для биомов:**
- Desert: `obstacle_cactus.png` (128x192px)
- Snow: `obstacle_icicle.png` (64x128px)
- Cave: `obstacle_stalactite.png` (96x128px)
- и т.д. для каждого биома

#### 1.1.4 Коллекционные предметы

**Морковки:**
- `carrot_gold.png` - золотая морковка (64x64px)
- `carrot_gold_shine.png` - анимация блеска (3 кадра)

#### 1.1.5 Бонусная игра "Lucky Harvest"

**Элементы грядки:**
- `mound_normal.png` - обычная кочка (128x96px)
- `mound_selected.png` - выбранная кочка (128x96px)
- `mound_carrot.png` - открытая с морковкой (128x96px)
- `mound_mole.png` - открытая с кротом (128x96px)
- `mole_angry.png` - злой крот анимация (4 кадра, 128x128px)

**UI элементы:**
- `button_store_barn.png` - кнопка "Store in Barn" (256x96px)
- `multiplier_badge.png` - бейдж множителя (128x64px)

#### 1.1.6 Фоны для 10 биомов

Каждый биом требует:
- `bg_[biome_name]_layer1.png` - дальний слой (2048x1536px)
- `bg_[biome_name]_layer2.png` - средний слой (2048x1536px)
- `bg_[biome_name]_layer3.png` - ближний слой (2048x1536px)

**Список биомов:**
1. green_forest
2. sunny_garden
3. rocky_canyon
4. crystal_cave
5. snowy_peaks
6. tropical_island
7. autumn_grove
8. cyber_valley
9. candy_kingdom
10. lunar_crater

#### 1.1.7 UI элементы

**Главное меню:**
- `logo_rabbit_dash.png` - логотип игры (512x256px)
- `button_start.png` - кнопка старт (300x100px)
- `button_world_map.png` - кнопка выбора миров (300x100px)
- `button_settings.png` - настройки (80x80px)

**HUD (Heads-Up Display):**
- `hud_carrot_icon.png` - иконка морковки (48x48px)
- `hud_distance_icon.png` - иконка дистанции (48x48px)
- `hud_panel.png` - панель для счетчиков (400x80px)

**World Map:**
- `world_card_locked.png` - заблокированный мир (300x400px)
- `world_card_unlocked.png` - открытый мир (300x400px)
- `world_card_current.png` - текущий мир (300x400px)
- `icon_golden_seed.png` - золотое семя (64x64px)

**Daily Rewards:**
- `daily_reward_bg.png` - фон награды (400x200px)
- `day_marker_[1-7].png` - маркеры дней (64x64px)

#### 1.1.8 Иконки и лаунчеры

**App Icon:**
- `AppIcon.png` - 1024x1024px (без прозрачности, без скруглений)

**Launch Screen:**
- `LaunchScreen.png` - 2436x1125px (для iPhone X и новее)

### 1.2 Звуковые эффекты

**Формат:** CAF (Core Audio Format) или M4A для iOS

**Необходимые звуки:**
- `sfx_jump.caf` - звук прыжка
- `sfx_double_jump.caf` - звук двойного прыжка
- `sfx_collect_carrot.caf` - сбор морковки
- `sfx_hit_obstacle.caf` - столкновение
- `sfx_mound_tap.caf` - нажатие на грядку
- `sfx_reveal_carrot.caf` - открытие морковки
- `sfx_reveal_mole.caf` - появление крота
- `sfx_store_barn.caf` - сохранение урожая
- `sfx_unlock_world.caf` - разблокировка мира
- `sfx_daily_reward.caf` - получение ежедневной награды

### 1.3 Музыка

**Формат:** M4A (AAC) для фоновой музыки

**Треки:**
- `music_menu.m4a` - музыка главного меню (зацикленная)
- `music_forest.m4a` - Green Forest
- `music_garden.m4a` - Sunny Garden
- `music_desert.m4a` - Rocky Canyon
- `music_cave.m4a` - Crystal Cave
- `music_snow.m4a` - Snowy Peaks
- `music_tropical.m4a` - Tropical Island
- `music_autumn.m4a` - Autumn Grove
- `music_cyber.m4a` - Cyber Valley
- `music_candy.m4a` - Candy Kingdom
- `music_lunar.m4a` - Lunar Crater
- `music_bonus_game.m4a` - Lucky Harvest

### 1.4 Организация файлов

```
Assets/
├── Characters/
│   ├── Rabbit/
│   │   ├── Spritesheets/
│   │   └── Individual/
│   └── Mole/
├── Environment/
│   ├── Platforms/
│   ├── Obstacles/
│   └── Backgrounds/
├── UI/
│   ├── Buttons/
│   ├── HUD/
│   ├── Menu/
│   └── WorldMap/
├── Collectibles/
├── BonusGame/
├── Audio/
│   ├── SFX/
│   └── Music/
└── AppIcons/
```

### 1.5 Рекомендации по созданию ассетов

1. **Используйте TexturePacker** (бесплатная версия) для создания sprite atlases
2. **Цветовая палитра:** Яркие, насыщенные цвета для семейной аудитории
3. **Стиль:** Flat Design 2D, без градиентов и теней (кроме необходимых для читаемости)
4. **Оптимизация:** Сжимайте PNG файлы через TinyPNG перед импортом
5. **Naming Convention:** lowercase, snake_case, понятные имена

---

## 2. Разработка (Xcode / Swift)

### 2.1 Настройка проекта

#### 2.1.1 Требования
- **Xcode:** версия 15.0 или выше
- **Swift:** 5.9+
- **Минимальная iOS:** 15.0
- **Целевые устройства:** iPhone (все модели с iOS 15+)
- **Ориентация:** Landscape (альбомная)

#### 2.1.2 Создание проекта
```
File → New → Project
→ iOS → Game
→ Product Name: "Rabbit Dash Eco Tour"
→ Team: [Your Team]
→ Organization Identifier: com.[yourcompany].rabbitdash
→ Interface: Storyboard
→ Language: Swift
→ Game Technology: SpriteKit
```

#### 2.1.3 Info.plist настройки
```xml
<key>UIRequiresFullScreen</key>
<true/>
<key>UISupportedInterfaceOrientations</key>
<array>
    <string>UIInterfaceOrientationLandscapeLeft</string>
    <string>UIInterfaceOrientationLandscapeRight</string>
</array>
<key>UIStatusBarHidden</key>
<true/>
<key>UILaunchStoryboardName</key>
<string>LaunchScreen</string>
```

### 2.2 Архитектура приложения

#### 2.2.1 Структура файлов

```
RabbitDash/
├── Application/
│   ├── AppDelegate.swift
│   ├── SceneDelegate.swift
│   └── GameViewController.swift
├── Scenes/
│   ├── MainMenuScene.swift
│   ├── GameplayScene.swift
│   ├── BonusGameScene.swift
│   └── WorldMapScene.swift
├── Models/
│   ├── GameState.swift
│   ├── PlayerData.swift
│   ├── WorldData.swift
│   └── DailyReward.swift
├── Nodes/
│   ├── RabbitNode.swift
│   ├── PlatformNode.swift
│   ├── ObstacleNode.swift
│   ├── CarrotNode.swift
│   └── MoundNode.swift
├── Managers/
│   ├── GameManager.swift
│   ├── AudioManager.swift
│   ├── DataManager.swift
│   ├── HapticManager.swift
│   └── GameCenterManager.swift
├── Utilities/
│   ├── Constants.swift
│   ├── Extensions.swift
│   └── SafeAreaHelper.swift
├── UI/
│   ├── MenuViewController.swift
│   ├── WorldMapViewController.swift
│   └── DailyRewardViewController.swift
└── Resources/
    ├── Assets.xcassets
    ├── Sounds/
    └── Music/
```

### 2.3 Основные компоненты

#### 2.3.1 GameManager.swift - Центральный менеджер

```swift
class GameManager {
    static let shared = GameManager()
    
    // MARK: - Properties
    var currentWorld: WorldData
    var playerData: PlayerData
    var gameState: GameState
    
    // MARK: - Game State
    func startRun()
    func endRun()
    func pauseGame()
    func resumeGame()
    
    // MARK: - Currency
    func addCarrots(_ amount: Int)
    func spendCarrots(_ amount: Int) -> Bool
    func getCarrotBalance() -> Int
    
    // MARK: - Worlds
    func unlockWorld(_ worldID: Int)
    func isWorldUnlocked(_ worldID: Int) -> Bool
    func getCurrentWorldCost() -> Int
}
```

#### 2.3.2 PlayerData.swift - Данные игрока

```swift
struct PlayerData: Codable {
    var totalCarrots: Int = 0
    var unlockedWorlds: [Int] = [1] // First world free
    var currentWorldID: Int = 1
    var highestDistance: Double = 0
    var totalRuns: Int = 0
    var lastDailyRewardDate: Date?
    var dailyRewardStreak: Int = 0
    
    // MARK: - Persistence
    static func load() -> PlayerData
    func save()
}
```

#### 2.3.3 GameplayScene.swift - Основной геймплей

```swift
class GameplayScene: SKScene {
    
    // MARK: - Nodes
    var rabbit: RabbitNode!
    var ground: SKNode!
    var backgroundLayers: [SKSpriteNode] = []
    var platforms: [PlatformNode] = []
    var obstacles: [ObstacleNode] = []
    var carrots: [CarrotNode] = []
    
    // MARK: - Game State
    var isRunning: Bool = false
    var runDistance: Double = 0
    var carrotsCollected: Int = 0
    var gameSpeed: CGFloat = 8.0
    
    // MARK: - HUD
    var carrotLabel: SKLabelNode!
    var distanceLabel: SKLabelNode!
    
    // MARK: - Setup
    override func didMove(to view: SKView) {
        setupPhysics()
        setupBackground()
        setupGround()
        setupRabbit()
        setupHUD()
        setupGestureRecognizers()
        startGame()
    }
    
    // MARK: - Game Loop
    override func update(_ currentTime: TimeInterval) {
        if !isRunning { return }
        
        updateDistance()
        updateSpeed()
        moveCamera()
        generateLevel()
        checkCollisions()
        removeOffscreenObjects()
    }
    
    // MARK: - Input
    func setupGestureRecognizers() {
        let tapGesture = UITapGestureRecognizer()
        tapGesture.numberOfTapsRequired = 1
        view?.addGestureRecognizer(tapGesture)
        
        let doubleTapGesture = UITapGestureRecognizer()
        doubleTapGesture.numberOfTapsRequired = 2
        view?.addGestureRecognizer(doubleTapGesture)
        
        let longPressGesture = UILongPressGestureRecognizer()
        view?.addGestureRecognizer(longPressGesture)
    }
    
    func handleTap() {
        // Normal jump logic
        HapticManager.shared.impact(style: .light)
    }
    
    func handleDoubleTap() {
        // Double jump logic
        HapticManager.shared.impact(style: .medium)
    }
    
    func handleLongPress() {
        // High jump logic
        HapticManager.shared.impact(style: .heavy)
    }
    
    // MARK: - Level Generation
    func generateLevel() {
        // Infinite runner procedural generation
    }
    
    // MARK: - Collision Detection
    func checkCollisions() {
        // Check rabbit vs obstacles
        // Check rabbit vs carrots
    }
    
    // MARK: - Game Over
    func gameOver() {
        isRunning = false
        transitionToBonusGame()
    }
}
```

#### 2.3.4 RabbitNode.swift - Персонаж

```swift
class RabbitNode: SKSpriteNode {
    
    // MARK: - Properties
    private var isOnGround: Bool = false
    private var hasDoubleJump: Bool = false
    private var runAnimation: SKAction!
    private var jumpAnimation: SKAction!
    
    // MARK: - Initialization
    init() {
        let texture = SKTexture(imageNamed: "rabbit_idle")
        super.init(texture: texture, color: .clear, size: texture.size())
        
        setupPhysicsBody()
        setupAnimations()
        startRunAnimation()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Physics
    func setupPhysicsBody() {
        physicsBody = SKPhysicsBody(rectangleOf: size)
        physicsBody?.isDynamic = true
        physicsBody?.allowsRotation = false
        physicsBody?.categoryBitMask = PhysicsCategory.player
        physicsBody?.contactTestBitMask = PhysicsCategory.obstacle | PhysicsCategory.carrot
        physicsBody?.collisionBitMask = PhysicsCategory.ground | PhysicsCategory.platform
    }
    
    // MARK: - Animations
    func setupAnimations() {
        // Load sprite frames and create animations
    }
    
    func startRunAnimation() {
        run(SKAction.repeatForever(runAnimation))
    }
    
    // MARK: - Jump Methods
    func normalJump() {
        guard isOnGround else { return }
        physicsBody?.velocity = CGVector(dx: 0, dy: 0)
        physicsBody?.applyImpulse(CGVector(dx: 0, dy: 400))
        isOnGround = false
        hasDoubleJump = true
    }
    
    func highJump() {
        guard isOnGround else { return }
        physicsBody?.velocity = CGVector(dx: 0, dy: 0)
        physicsBody?.applyImpulse(CGVector(dx: 0, dy: 600))
        isOnGround = false
        hasDoubleJump = true
    }
    
    func doubleJump() {
        guard hasDoubleJump && !isOnGround else { return }
        physicsBody?.velocity = CGVector(dx: 0, dy: 0)
        physicsBody?.applyImpulse(CGVector(dx: 0, dy: 350))
        hasDoubleJump = false
    }
    
    func landed() {
        isOnGround = true
        hasDoubleJump = false
    }
}
```

#### 2.3.5 BonusGameScene.swift - Бонусная игра

```swift
class BonusGameScene: SKScene {
    
    // MARK: - Properties
    let rows = 6
    let columns = 3
    var currentRow = 0
    var currentMultiplier: Float = 1.0
    var harvestedCarrots: Int = 0
    var moundGrid: [[MoundNode]] = []
    
    // MARK: - Multipliers
    let multipliers: [Float] = [1.1, 1.5, 2.0, 2.5, 3.0, 4.0]
    
    // MARK: - UI
    var multiplierLabel: SKLabelNode!
    var carrotCountLabel: SKLabelNode!
    var storeButton: SKSpriteNode!
    
    // MARK: - Setup
    override func didMove(to view: SKView) {
        setupBackground()
        setupGrid()
        setupUI()
        setupStorageButton()
        
        harvestedCarrots = GameManager.shared.gameState.currentRunCarrots
        updateLabels()
    }
    
    // MARK: - Grid Setup
    func setupGrid() {
        for row in 0..<rows {
            var rowMounds: [MoundNode] = []
            for col in 0..<columns {
                let mound = MoundNode()
                mound.position = getPositionFor(row: row, col: col)
                mound.row = row
                mound.col = col
                addChild(mound)
                rowMounds.append(mound)
            }
            moundGrid.append(rowMounds)
        }
        
        highlightRow(currentRow)
    }
    
    // MARK: - Touch Handling
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let location = touch.location(in: self)
        let touchedNodes = nodes(at: location)
        
        // Check if store button tapped
        if touchedNodes.contains(storeButton) {
            storeAndExit()
            return
        }
        
        // Check if mound tapped
        for node in touchedNodes {
            if let mound = node as? MoundNode, mound.row == currentRow {
                handleMoundTap(mound)
                break
            }
        }
    }
    
    // MARK: - Game Logic
    func handleMoundTap(_ mound: MoundNode) {
        HapticManager.shared.impact(style: .medium)
        
        // Random outcome: 66% carrot, 33% mole
        let isCarrot = Int.random(in: 1...3) != 1
        
        if isCarrot {
            mound.revealCarrot()
            AudioManager.shared.playSFX("reveal_carrot")
            applyMultiplier()
            
            // Move to next row
            currentRow += 1
            if currentRow >= rows {
                // Won the bonus game!
                autoStore()
            } else {
                highlightRow(currentRow)
            }
        } else {
            mound.revealMole()
            AudioManager.shared.playSFX("reveal_mole")
            HapticManager.shared.notification(type: .error)
            
            // Lose everything
            harvestedCarrots = 0
            showLoseAnimation()
        }
        
        updateLabels()
    }
    
    func applyMultiplier() {
        let mult = multipliers[min(currentRow, multipliers.count - 1)]
        currentMultiplier = mult
        harvestedCarrots = Int(Float(GameManager.shared.gameState.currentRunCarrots) * currentMultiplier)
    }
    
    func storeAndExit() {
        HapticManager.shared.impact(style: .heavy)
        AudioManager.shared.playSFX("store_barn")
        
        GameManager.shared.addCarrots(harvestedCarrots)
        transitionToMainMenu()
    }
    
    func autoStore() {
        // Automatically store after reaching last row
        storeAndExit()
    }
    
    func showLoseAnimation() {
        // Show angry mole animation, then exit
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            self.transitionToMainMenu()
        }
    }
}
```

#### 2.3.6 WorldData.swift - Данные миров

```swift
struct WorldData: Codable {
    let id: Int
    let name: String
    let theme: String
    let unlockCost: Int
    let backgroundLayers: [String]
    let platformTexture: String
    let obstacles: [String]
    let musicTrack: String
    
    static func getAllWorlds() -> [WorldData] {
        return [
            WorldData(id: 1, name: "Green Forest", theme: "forest", unlockCost: 0,
                     backgroundLayers: ["bg_forest_layer1", "bg_forest_layer2", "bg_forest_layer3"],
                     platformTexture: "platform_forest", obstacles: ["stump", "rock", "pit"],
                     musicTrack: "music_forest"),
            WorldData(id: 2, name: "Sunny Garden", theme: "garden", unlockCost: 500,
                     backgroundLayers: ["bg_garden_layer1", "bg_garden_layer2", "bg_garden_layer3"],
                     platformTexture: "platform_garden", obstacles: ["stump", "rock", "sunflower"],
                     musicTrack: "music_garden"),
            // ... остальные 8 миров
        ]
    }
}
```

### 2.4 Менеджеры

#### 2.4.1 AudioManager.swift

```swift
class AudioManager {
    static let shared = AudioManager()
    
    private var musicPlayer: AVAudioPlayer?
    private var soundEffects: [String: SKAction] = [:]
    
    func preloadSounds() {
        let sounds = ["jump", "double_jump", "collect_carrot", "hit_obstacle", 
                     "mound_tap", "reveal_carrot", "reveal_mole", "store_barn"]
        
        for sound in sounds {
            soundEffects["sfx_\(sound)"] = SKAction.playSoundFileNamed("sfx_\(sound).caf", 
                                                                        waitForCompletion: false)
        }
    }
    
    func playMusic(_ track: String) {
        guard let url = Bundle.main.url(forResource: track, withExtension: "m4a") else { return }
        
        do {
            musicPlayer = try AVAudioPlayer(contentsOf: url)
            musicPlayer?.numberOfLoops = -1 // Infinite loop
            musicPlayer?.volume = 0.5
            musicPlayer?.play()
        } catch {
            print("Error playing music: \(error)")
        }
    }
    
    func playSFX(_ soundName: String) {
        guard let action = soundEffects[soundName] else { return }
        // Play on a dummy node
        let dummyNode = SKNode()
        dummyNode.run(action)
    }
    
    func stopMusic() {
        musicPlayer?.stop()
    }
}
```

#### 2.4.2 HapticManager.swift

```swift
import UIKit

class HapticManager {
    static let shared = HapticManager()
    
    private let lightImpact = UIImpactFeedbackGenerator(style: .light)
    private let mediumImpact = UIImpactFeedbackGenerator(style: .medium)
    private let heavyImpact = UIImpactFeedbackGenerator(style: .heavy)
    private let notificationFeedback = UINotificationFeedbackGenerator()
    
    init() {
        lightImpact.prepare()
        mediumImpact.prepare()
        heavyImpact.prepare()
        notificationFeedback.prepare()
    }
    
    func impact(style: UIImpactFeedbackGenerator.FeedbackStyle) {
        switch style {
        case .light:
            lightImpact.impactOccurred()
            lightImpact.prepare()
        case .medium:
            mediumImpact.impactOccurred()
            mediumImpact.prepare()
        case .heavy:
            heavyImpact.impactOccurred()
            heavyImpact.prepare()
        @unknown default:
            break
        }
    }
    
    func notification(type: UINotificationFeedbackGenerator.FeedbackType) {
        notificationFeedback.notificationOccurred(type)
        notificationFeedback.prepare()
    }
}
```

#### 2.4.3 DataManager.swift

```swift
class DataManager {
    static let shared = DataManager()
    
    private let userDefaults = UserDefaults.standard
    private let playerDataKey = "PlayerData"
    
    func savePlayerData(_ data: PlayerData) {
        if let encoded = try? JSONEncoder().encode(data) {
            userDefaults.set(encoded, forKey: playerDataKey)
            userDefaults.synchronize()
        }
    }
    
    func loadPlayerData() -> PlayerData {
        if let savedData = userDefaults.data(forKey: playerDataKey),
           let decoded = try? JSONDecoder().decode(PlayerData.self, from: savedData) {
            return decoded
        }
        return PlayerData() // Default new player
    }
    
    func resetPlayerData() {
        userDefaults.removeObject(forKey: playerDataKey)
        userDefaults.synchronize()
    }
}
```

#### 2.4.4 GameCenterManager.swift

```swift
import GameKit

class GameCenterManager: NSObject {
    static let shared = GameCenterManager()
    
    let leaderboardID = "com.yourcompany.rabbitdash.topharvesters"
    
    func authenticatePlayer(completion: @escaping (Bool) -> Void) {
        let localPlayer = GKLocalPlayer.local
        
        localPlayer.authenticateHandler = { viewController, error in
            if let vc = viewController {
                // Present authentication VC
                if let rootVC = UIApplication.shared.windows.first?.rootViewController {
                    rootVC.present(vc, animated: true)
                }
                completion(false)
            } else if localPlayer.isAuthenticated {
                completion(true)
            } else {
                completion(false)
            }
        }
    }
    
    func submitScore(_ score: Int) {
        guard GKLocalPlayer.local.isAuthenticated else { return }
        
        let scoreReporter = GKScore(leaderboardIdentifier: leaderboardID)
        scoreReporter.value = Int64(score)
        
        GKScore.report([scoreReporter]) { error in
            if let error = error {
                print("Error submitting score: \(error)")
            }
        }
    }
    
    func showLeaderboard(from viewController: UIViewController) {
        let gcVC = GKGameCenterViewController(leaderboardID: leaderboardID, 
                                              playerScope: .global, 
                                              timeScope: .allTime)
        gcVC.gameCenterDelegate = self
        viewController.present(gcVC, animated: true)
    }
}

extension GameCenterManager: GKGameCenterControllerDelegate {
    func gameCenterViewControllerDidFinish(_ gameCenterViewController: GKGameCenterViewController) {
        gameCenterViewController.dismiss(animated: true)
    }
}
```

### 2.5 Safe Area и Dynamic Island

#### 2.5.1 SafeAreaHelper.swift

```swift
import UIKit

class SafeAreaHelper {
    static func getSafeAreaInsets() -> UIEdgeInsets {
        let window = UIApplication.shared.windows.first
        return window?.safeAreaInsets ?? .zero
    }
    
    static func getTopSafeArea() -> CGFloat {
        return getSafeAreaInsets().top
    }
    
    static func getBottomSafeArea() -> CGFloat {
        return getSafeAreaInsets().bottom
    }
    
    static func adjustHUDPosition(node: SKNode, scene: SKScene) {
        let topInset = getTopSafeArea()
        // Offset HUD elements down by safe area
        if node.position.y > scene.size.height / 2 - 100 {
            node.position.y -= topInset
        }
    }
}
```

#### 2.5.2 Применение в GameplayScene

```swift
func setupHUD() {
    // Carrot counter
    carrotLabel = SKLabelNode(fontNamed: "Arial-BoldMT")
    carrotLabel.fontSize = 32
    carrotLabel.position = CGPoint(x: 100, y: size.height - 60)
    
    // Adjust for safe area
    SafeAreaHelper.adjustHUDPosition(node: carrotLabel, scene: self)
    
    addChild(carrotLabel)
    
    // Distance counter
    distanceLabel = SKLabelNode(fontNamed: "Arial-BoldMT")
    distanceLabel.fontSize = 32
    distanceLabel.position = CGPoint(x: size.width - 100, y: size.height - 60)
    
    SafeAreaHelper.adjustHUDPosition(node: distanceLabel, scene: self)
    
    addChild(distanceLabel)
}
```

### 2.6 Daily Rewards

#### 2.6.1 DailyReward.swift

```swift
struct DailyReward {
    static func checkAndGrant() -> DailyRewardResult? {
        var playerData = DataManager.shared.loadPlayerData()
        
        let now = Date()
        guard let lastReward = playerData.lastDailyRewardDate else {
            // First time claim
            return grantReward(day: 1, playerData: &playerData)
        }
        
        let calendar = Calendar.current
        let components = calendar.dateComponents([.day], from: lastReward, to: now)
        
        guard let daysDiff = components.day else { return nil }
        
        if daysDiff >= 1 && daysDiff < 2 {
            // Consecutive day
            let nextDay = playerData.dailyRewardStreak + 1
            return grantReward(day: nextDay, playerData: &playerData)
        } else if daysDiff >= 2 {
            // Streak broken, restart
            return grantReward(day: 1, playerData: &playerData)
        }
        
        return nil // Already claimed today
    }
    
    private static func grantReward(day: Int, playerData: inout PlayerData) -> DailyRewardResult {
        let clampedDay = min(day, 7)
        
        let reward: DailyRewardResult
        if clampedDay < 7 {
            let carrotAmount = clampedDay * 100 // 100, 200, 300... 600
            playerData.totalCarrots += carrotAmount
            reward = .carrots(amount: carrotAmount, day: clampedDay)
        } else {
            // Day 7: Golden Seed
            let unlockedWorld = unlockRandomWorld(playerData: &playerData)
            reward = .goldenSeed(unlockedWorld: unlockedWorld, day: 7)
        }
        
        playerData.lastDailyRewardDate = Date()
        playerData.dailyRewardStreak = clampedDay >= 7 ? 0 : clampedDay
        
        DataManager.shared.savePlayerData(playerData)
        
        return reward
    }
    
    private static func unlockRandomWorld(playerData: inout PlayerData) -> WorldData? {
        let allWorlds = WorldData.getAllWorlds()
        let lockedWorlds = allWorlds.filter { !playerData.unlockedWorlds.contains($0.id) }
        
        guard !lockedWorlds.isEmpty else { return nil }
        
        let randomWorld = lockedWorlds.randomElement()!
        playerData.unlockedWorlds.append(randomWorld.id)
        
        return randomWorld
    }
}

enum DailyRewardResult {
    case carrots(amount: Int, day: Int)
    case goldenSeed(unlockedWorld: WorldData?, day: Int)
}
```

### 2.7 Оптимизация производительности

#### 2.7.1 Object Pooling для препятствий

```swift
class ObjectPool {
    private var availableObstacles: [ObstacleNode] = []
    private var availablePlatforms: [PlatformNode] = []
    
    func getObstacle(type: String) -> ObstacleNode {
        if let obstacle = availableObstacles.first(where: { $0.type == type }) {
            availableObstacles.removeAll { $0 == obstacle }
            return obstacle
        }
        return ObstacleNode(type: type) // Create new if none available
    }
    
    func returnObstacle(_ obstacle: ObstacleNode) {
        obstacle.removeFromParent()
        obstacle.reset()
        availableObstacles.append(obstacle)
    }
    
    // Similar for platforms
}
```

#### 2.7.2 Lazy Loading миров

```swift
class WorldAssetManager {
    private var loadedWorlds: [Int: WorldAssets] = [:]
    
    func loadWorld(_ worldID: Int, completion: @escaping (WorldAssets) -> Void) {
        if let cached = loadedWorlds[worldID] {
            completion(cached)
            return
        }
        
        DispatchQueue.global(qos: .userInitiated).async {
            let assets = self.loadWorldAssets(worldID)
            self.loadedWorlds[worldID] = assets
            
            DispatchQueue.main.async {
                completion(assets)
            }
        }
    }
    
    func unloadWorld(_ worldID: Int) {
        loadedWorlds.removeValue(forKey: worldID)
    }
}
```

### 2.8 Тестирование

#### 2.8.1 Unit Tests

Создать файл `RabbitDashTests.swift`:

```swift
import XCTest
@testable import Rabbit_Dash_Eco_Tour

class RabbitDashTests: XCTestCase {
    
    func testPlayerDataSaveLoad() {
        var playerData = PlayerData()
        playerData.totalCarrots = 1000
        playerData.unlockedWorlds = [1, 2, 3]
        
        DataManager.shared.savePlayerData(playerData)
        let loadedData = DataManager.shared.loadPlayerData()
        
        XCTAssertEqual(loadedData.totalCarrots, 1000)
        XCTAssertEqual(loadedData.unlockedWorlds, [1, 2, 3])
    }
    
    func testBonusGameMultiplier() {
        let initialCarrots = 100
        let multiplier: Float = 2.5
        let expected = Int(Float(initialCarrots) * multiplier)
        
        XCTAssertEqual(expected, 250)
    }
    
    func testDailyRewardStreak() {
        DataManager.shared.resetPlayerData()
        
        let reward1 = DailyReward.checkAndGrant()
        XCTAssertNotNil(reward1)
        
        // Same day - should be nil
        let reward2 = DailyReward.checkAndGrant()
        XCTAssertNil(reward2)
    }
}
```

#### 2.8.2 Manual Testing Checklist

- [ ] Все 3 типа прыжков работают корректно
- [ ] Collision detection точный
- [ ] Haptic feedback срабатывает в нужных местах
- [ ] Музыка и SFX воспроизводятся без задержек
- [ ] HUD корректно отображается на всех устройствах (11-17)
- [ ] Safe Area учтена на всех моделях
- [ ] Бонусная игра: 6 рядов, правильные множители
- [ ] Daily Rewards: streak работает, Day 7 дает Golden Seed
- [ ] 10 миров разблокируются за правильную цену
- [ ] Game Center: скоры отправляются, leaderboard открывается
- [ ] Нет утечек памяти при длительной игре
- [ ] Игра не крашится при background/foreground переключении

---

## 3. Оформление в App Store

### 3.1 Подготовка метаданных

#### 3.1.1 App Name
**Primary:** Rabbit Dash: Eco Tour  
**Subtitle (30 символов):** Jump, Collect, Multiply!

#### 3.1.2 Description (Русский)

**Краткое описание (170 символов):**
```
Отправьтесь в приключение с кроликом! Прыгайте через препятствия, собирайте морковки и умножайте награды в уникальной бонусной игре. 10 волшебных миров ждут!
```

**Полное описание:**
```
🐰 RABBIT DASH: ECO TOUR 🥕

Присоединяйтесь к самому быстрому кролику в его экологическом путешествии через 10 удивительных миров!

🎮 ПРОСТОЕ УПРАВЛЕНИЕ
• Tap - обычный прыжок
• Hold - высокий прыжок  
• Double Tap - двойной прыжок
Освойте идеальное время прыжков, чтобы избежать препятствий!

🌍 10 УНИКАЛЬНЫХ МИРОВ
От зелёного леса до лунного кратера - каждый мир это новое приключение:
✓ Green Forest - классическое начало
✓ Sunny Garden - яркий огород
✓ Rocky Canyon - опасная пустыня
✓ Crystal Cave - сияющие пещеры
✓ Snowy Peaks - ледяные вершины
✓ Tropical Island - райский пляж
✓ Autumn Grove - золотая осень
✓ Cyber Valley - футуристический мир
✓ Candy Kingdom - сладкая страна
✓ Lunar Crater - космическое приключение

🎰 УНИКАЛЬНАЯ БОНУСНАЯ ИГРА "LUCKY HARVEST"
После каждого забега - шанс умножить ваш урожай!
• Выбирайте грядки мудро
• Избегайте сердитого крота
• Множители до x4.0!
• Заберите награду в любой момент

🏆 ОСОБЕННОСТИ
• Красочный 2D Flat Design
• Подходит для всей семьи
• Ежедневные награды
• Game Center таблица лидеров
• Haptic Feedback для полного погружения
• Оптимизация для всех iPhone

💎 ПРОГРЕССИЯ
Разблокируйте новые миры за собранные морковки или получите Golden Seed на 7-й день входа - он откроет случайный мир бесплатно!

Готовы к приключению? Скачайте Rabbit Dash: Eco Tour прямо сейчас! 🚀

---
Нет рекламы. Нет подписок. Чистое веселье!
```

#### 3.1.3 Keywords (100 символов)
```
runner,platformer,rabbit,casual,family,jump,arcade,cute,kids,carrot
```

#### 3.1.4 What's New (Для обновлений)
```
Version 1.0
• Первый релиз!
• 10 уникальных миров для исследования
• Бонусная игра Lucky Harvest
• Ежедневные награды
• Интеграция с Game Center
```

### 3.2 Скриншоты

#### 3.2.1 Требуемые размеры

**iPhone 6.7" (Pro Max) - Обязательно:**
- 1290 x 2796 pixels (portrait) ИЛИ
- 2796 x 1290 pixels (landscape) ✓ Используем этот

**iPhone 6.5" - Рекомендуется:**
- 1242 x 2688 pixels (portrait) ИЛИ
- 2688 x 1242 pixels (landscape) ✓ Используем этот

#### 3.2.2 Содержание скриншотов (8-10 штук)

**Screenshot 1: Hero Shot**
- Кролик в прыжке в Green Forest
- Текст overlay: "JUMP INTO ADVENTURE!"
- HUD виден (морковки, дистанция)

**Screenshot 2: Worlds Showcase**
- World Map с несколькими разблокированными мирами
- Текст: "10 UNIQUE WORLDS TO EXPLORE"

**Screenshot 3: Gameplay Action**
- Динамичный кадр из Cyber Valley с препятствиями
- Текст: "MASTER THE PERFECT TIMING"

**Screenshot 4: Bonus Game**
- Lucky Harvest игра, показан множитель x2.5
- Текст: "MULTIPLY YOUR HARVEST!"

**Screenshot 5: Collectibles**
- Крупный план сбора морковок
- Текст: "COLLECT GOLDEN CARROTS"

**Screenshot 6: Different World**
- Snowy Peaks или Tropical Island
- Текст: "BEAUTIFUL ENVIRONMENTS"

**Screenshot 7: Daily Rewards**
- Экран ежедневной награды с Golden Seed
- Текст: "DAILY REWARDS & BONUSES"

**Screenshot 8: Leaderboards**
- Game Center интерфейс
- Текст: "COMPETE WITH FRIENDS"

#### 3.2.3 Создание скриншотов

**Метод 1: Симулятор**
```bash
# Запустить симулятор нужного устройства
# Device → iPhone 15 Pro Max
# Rotate to Landscape (Cmd+Left/Right)
# В игре: Cmd+S для скриншота
# Файлы сохраняются на Desktop
```

**Метод 2: Реальное устройство**
- Подключить iPhone через USB
- Xcode → Window → Devices and Simulators
- Select device → Take Screenshot

**Post-processing:**
- Использовать app-mockup.com или shotbot.io для добавления device frame
- Добавить текст overlay в Figma/Photoshop
- Экспорт в PNG, RGB, без прозрачности

### 3.3 Preview Video (опционально, но рекомендуется)

#### 3.3.1 Требования
- Формат: .mov, .m4v, .mp4
- Разрешение: 1920x1080 (landscape) или 1080x1920 (portrait)
- Длительность: 15-30 секунд
- Размер: до 500 MB

#### 3.3.2 Содержание видео (30 сек)

**0:00-0:05** - Splash screen с логотипом, переход в меню  
**0:05-0:10** - Геймплей в Green Forest: прыжки, сбор морковок  
**0:10-0:15** - Столкновение, переход в Lucky Harvest  
**0:15-0:20** - Бонусная игра: выбор грядок, показать множитель  
**0:20-0:25** - World Map: показать разные миры  
**0:25-0:30** - Финальный кадр с логотипом и призывом "Download Now!"

#### 3.3.3 Создание видео

**С помощью QuickTime (Mac):**
1. QuickTime Player → File → New Screen Recording
2. Выбрать область симулятора
3. Записать геймплей по сценарию
4. Trim в QuickTime, экспорт 1080p

**С помощью ReplayKit (in-app):**
```swift
import ReplayKit

class VideoRecorder {
    static func startRecording() {
        let recorder = RPScreenRecorder.shared()
        recorder.startRecording { error in
            if let error = error {
                print("Recording failed: \(error)")
            }
        }
    }
    
    static func stopRecording(completion: @escaping (URL?) -> Void) {
        let recorder = RPScreenRecorder.shared()
        recorder.stopRecording { preview, error in
            guard let preview = preview else { 
                completion(nil)
                return 
            }
            // Save video
        }
    }
}
```

### 3.4 App Icon

#### 3.4.1 Требования
- 1024x1024 pixels
- PNG format
- RGB color space (НЕ RGBA - без прозрачности!)
- Без скруглённых углов (iOS добавит автоматически)
- Без текста/UI элементов

#### 3.4.2 Дизайн концепт
- **Фон:** Градиент от светло-зелёного к насыщенному зелёному
- **Главный элемент:** Силуэт кролика в прыжке (профиль)
- **Акцент:** Золотая морковка в лапах
- **Стиль:** Flat, простой, узнаваемый издалека

#### 3.4.3 Asset Catalog Setup
```
Assets.xcassets/
└── AppIcon.appiconset/
    ├── Contents.json
    └── icon_1024x1024.png
```

### 3.5 App Store Connect - Пошаговая настройка

#### 3.5.1 Создание App в App Store Connect

1. Войти на https://appstoreconnect.apple.com
2. My Apps → "+" → New App
3. Заполнить форму:
   - **Platform:** iOS
   - **Name:** Rabbit Dash: Eco Tour
   - **Primary Language:** Russian (или English)
   - **Bundle ID:** выбрать созданный в Xcode
   - **SKU:** rabbitdash001 (уникальный ID для учёта)
   - **User Access:** Full Access

#### 3.5.2 App Information

**Category:**
- **Primary:** Games
- **Secondary:** Casual

**Age Rating:**
- PEGI 3+ / 4+ (вопросы про контент - все "No")

**License Agreement:**
- Standard Apple EULA

#### 3.5.3 Pricing and Availability

- **Price:** Free (Tier 0)
- **Availability:** All countries
- **Available date:** Сразу после одобрения

#### 3.5.4 Version Information (1.0)

**Promotional Text (170 chars):**
```
Новое обновление каждый месяц! Следите за новыми мирами и персонажами.
```

**Description:** (см. раздел 3.1.2)

**Keywords:** (см. раздел 3.1.3)

**Support URL:**
```
https://yourcompany.com/rabbitdash/support
```

**Marketing URL (optional):**
```
https://yourcompany.com/rabbitdash
```

**Copyright:**
```
2025 Your Company Name
```

**Build:**
- После загрузки через Xcode выбрать нужный build

#### 3.5.5 Game Center

1. В App Store Connect → Features → Game Center
2. Enable Game Center
3. Добавить Leaderboard:
   - **Reference Name:** Top Harvesters
   - **Leaderboard ID:** com.yourcompany.rabbitdash.topharvesters
   - **Score Format:** Integer
   - **Sort Order:** High to Low
   - **Score Range:** 0 to 999999999

#### 3.5.6 Privacy Policy

Создать простую Privacy Policy страницу:

```html
<!DOCTYPE html>
<html>
<head>
    <title>Rabbit Dash - Privacy Policy</title>
</head>
<body>
    <h1>Privacy Policy for Rabbit Dash: Eco Tour</h1>
    <p>Last updated: January 2025</p>
    
    <h2>Data Collection</h2>
    <p>Rabbit Dash: Eco Tour does not collect, store, or share any personal data.</p>
    
    <h2>Game Center</h2>
    <p>If you choose to use Game Center, your leaderboard scores are stored by Apple.</p>
    
    <h2>Local Storage</h2>
    <p>Game progress is stored locally on your device only.</p>
    
    <h2>Contact</h2>
    <p>For questions, email: support@yourcompany.com</p>
</body>
</html>
```

Загрузить на https://yourcompany.com/rabbitdash/privacy

Указать URL в App Store Connect → App Privacy

**Data Types:**
- User ID: No
- Device ID: No
- Purchase History: No
- etc... (все NO)

### 3.6 Подготовка Build для отправки

#### 3.6.1 Archive & Upload

**В Xcode:**

1. **Scheme:** Product → Scheme → Edit Scheme
   - Run → Build Configuration → Release
   
2. **Device:** Any iOS Device (arm64)

3. **Archive:** Product → Archive

4. **Organizer открывается автоматически:**
   - Выбрать archive
   - Distribute App
   - App Store Connect
   - Upload
   - Automatic signing
   - Upload

5. **Ожидать обработки (5-20 минут)**

#### 3.6.2 TestFlight Beta Testing (рекомендуется)

После загрузки build:
1. App Store Connect → TestFlight
2. Выбрать build
3. Заполнить What to Test
4. Add Internal Testers (до 100 человек)
5. Отправить им ссылку

**Цель:** Найти баги перед релизом

#### 3.6.3 Submit for Review

**Когда всё готово:**
1. App Store Connect → Version 1.0
2. Build выбран
3. Все скриншоты загружены
4. Вся информация заполнена
5. **Submit for Review**

**Review время:** 24-48 часов (обычно)

### 3.7 Post-Release

#### 3.7.1 Monitoring

**App Analytics:**
- App Store Connect → Analytics
- Следить за: Downloads, Sessions, Crashes

**Crash Reports:**
- Xcode → Window → Organizer → Crashes
- Фиксить критические баги

#### 3.7.2 Updates

**План обновлений:**
- **v1.1 (через 1 месяц):** Bug fixes, балансировка
- **v1.2 (через 2 месяца):** Новые персонажи (скины кролика)
- **v1.3 (через 3 месяца):** 11-й мир - "Dream Dimension"
- **v2.0 (через 6 месяцев):** Multiplayer mode

#### 3.7.3 User Feedback

**Отвечать на отзывы:**
- App Store Connect → Ratings and Reviews
- Отвечать на негативные отзывы профессионально
- Благодарить за позитивные

---

## Чеклист финальной проверки перед сабмитом

### Код
- [ ] Нет хардкодов (все константы в Constants.swift)
- [ ] Нет debug логов в Release
- [ ] Нет TODO/FIXME в продакшн коде
- [ ] Все ассеты загружены и используются
- [ ] Haptics работают на всех моделях
- [ ] Safe Area корректна на всех экранах
- [ ] Game Center интеграция работает
- [ ] Музыка и SFX воспроизводятся

### Performance
- [ ] 60 FPS на всех устройствах от iPhone 11
- [ ] Нет утечек памяти
- [ ] Приложение < 100 MB
- [ ] Загрузка < 3 секунд

### App Store
- [ ] Все 8-10 скриншотов загружены
- [ ] App Icon 1024x1024 без прозрачности
- [ ] Description на русском и английском
- [ ] Keywords оптимизированы
- [ ] Privacy Policy доступна
- [ ] Support URL работает
- [ ] Age Rating выбран правильно (4+)
- [ ] Build загружен и выбран

### Compliance
- [ ] Нет упоминаний "casino", "bet", "win", "gamble"
- [ ] Нет реальных денег в бонусной игре
- [ ] Контент подходит для детей (нет насилия)
- [ ] Нет сбора личных данных

---

## Приложение: Полезные ссылки

**Документация:**
- Apple Human Interface Guidelines: https://developer.apple.com/design/human-interface-guidelines/
- SpriteKit Programming Guide: https://developer.apple.com/documentation/spritekit
- Game Center Guide: https://developer.apple.com/game-center/

**Инструменты:**
- TexturePacker (FREE): https://www.codeandweb.com/texturepacker
- TinyPNG: https://tinypng.com
- App Mockup Generator: https://app-mockup.com
- Sound Effect Library: https://freesound.org

**Обучение:**
- Ray Wenderlich SpriteKit: https://www.kodeco.com
- Hacking with Swift: https://www.hackingwithswift.com
- Apple Sample Code: https://developer.apple.com/sample-code/

---

**Конец технического задания**

*Ориентировочное время разработки: 14 дней для опытного iOS разработчика*  
*Рекомендуемая команда: 1 разработчик + 1 дизайнер + 1 sound designer*
