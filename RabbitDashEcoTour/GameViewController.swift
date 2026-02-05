import UIKit
import SpriteKit

class GameViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // ВАЖНО: Ждём пока view получит правильный размер
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        // Теперь размер правильный - создаём сцену
        guard let skView = view as? SKView else {
            print("❌ View is not SKView!")
            return
        }
        
        // Размер сцены = размер view
        let sceneSize = skView.bounds.size
        print("📱 Screen size: \(sceneSize)")
        
        let scene = GameScene(size: sceneSize)
        scene.scaleMode = .aspectFill
        
        skView.presentScene(scene)
        
        skView.ignoresSiblingOrder = true
        skView.showsFPS = true
        skView.showsNodeCount = false
        skView.showsPhysics = true
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .landscape
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
}
