import Foundation

class DataManager {
    static let shared = DataManager()
    
    private let userDefaults = UserDefaults.standard
    private let playerDataKey = "PlayerData"
    
    private init() {}
    
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
        return PlayerData()
    }
    
    func resetPlayerData() {
        userDefaults.removeObject(forKey: playerDataKey)
        userDefaults.synchronize()
    }
}
