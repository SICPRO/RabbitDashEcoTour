import Foundation

struct PlayerData: Codable {
    var totalCarrots: Int = 0
    var unlockedWorlds: [Int] = [1] // First world free
    var currentWorldID: Int = 1
    var highestDistance: Double = 0
    var totalRuns: Int = 0
    var lastDailyRewardDate: Date?
    var dailyRewardStreak: Int = 0
    
    init() {}
}
