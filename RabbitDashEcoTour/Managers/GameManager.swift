import Foundation

class GameManager {
    static let shared = GameManager()
    
    var playerData: PlayerData
    var currentWorldID: Int = 1
    
    private init() {
        self.playerData = DataManager.shared.loadPlayerData()
        self.currentWorldID = playerData.currentWorldID
    }
    
    // MARK: - Currency
    func addCarrots(_ amount: Int) {
        playerData.totalCarrots += amount
        DataManager.shared.savePlayerData(playerData)
    }
    
    func spendCarrots(_ amount: Int) -> Bool {
        guard playerData.totalCarrots >= amount else { return false }
        playerData.totalCarrots -= amount
        DataManager.shared.savePlayerData(playerData)
        return true
    }
    
    func getCarrotBalance() -> Int {
        return playerData.totalCarrots
    }
    
    // MARK: - Worlds
    func unlockWorld(_ worldID: Int) {
        guard !playerData.unlockedWorlds.contains(worldID) else { return }
        playerData.unlockedWorlds.append(worldID)
        DataManager.shared.savePlayerData(playerData)
    }
    
    func isWorldUnlocked(_ worldID: Int) -> Bool {
        return playerData.unlockedWorlds.contains(worldID)
    }
    
    func setCurrentWorld(_ worldID: Int) {
        currentWorldID = worldID
        playerData.currentWorldID = worldID
        DataManager.shared.savePlayerData(playerData)
    }
}
