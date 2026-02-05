import Foundation
import AVFoundation
import SpriteKit

class AudioManager {
    static let shared = AudioManager()
    
    private var musicPlayer: AVAudioPlayer?
    private var soundEffects: [String: SKAction] = [:]
    
    private init() {}
    
    func playMusic(_ track: String) {
        print("🎵 Playing music: \(track)")
        // TODO: Implement later
    }
    
    func stopMusic() {
        print("🎵 Stopping music")
        musicPlayer?.stop()
    }
    
    func playSFX(_ soundName: String) {
        print("🔊 Playing SFX: \(soundName)")
        // TODO: Implement later
    }
}
