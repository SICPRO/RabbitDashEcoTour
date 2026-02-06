import Foundation
import CoreGraphics

struct Constants {
    
    // MARK: - Physics Categories
    struct PhysicsCategory {
        static let none: UInt32 = 0
        static let player: UInt32 = 0b1      // 1
        static let ground: UInt32 = 0b10     // 2
        static let platform: UInt32 = 0b100  // 4
        static let obstacle: UInt32 = 0b1000 // 8
        static let carrot: UInt32 = 0b10000  // 16
    }
    
    // MARK: - Game Settings
    static let initialGameSpeed: CGFloat = 9.0
    static let speedIncreaseRate: CGFloat = 0.5
    static let maxGameSpeed: CGFloat = 20.0
    
    // MARK: - Jump Forces
    static let normalJumpForce: CGFloat = 200
    static let highJumpForce: CGFloat = 400
    static let doubleJumpForce: CGFloat = 200
    
    // MARK: - World Costs
    static let worldUnlockCosts: [Int] = [
        0,    // World 1 - Free
        500,  // World 2
        1000, // World 3
        1500, // World 4
        2000, // World 5
        2500, // World 6
        3000, // World 7
        3500, // World 8
        4000, // World 9
        5000  // World 10
    ]
    
    // MARK: - Rabbit Settings
    static let rabbitSize = CGSize(width: 128, height: 128)
}
