
import SwiftUI


class CalendarViewModel: ObservableObject {
    
    @Published var bonuses: [BonusAO] = [
        BonusAO(day: 1, amount: 50, isCollected: false),
        BonusAO(day: 2, amount: 50, isCollected: false),
        BonusAO(day: 3, amount: 50, isCollected: false),
        BonusAO(day: 4, amount: 50, isCollected: false),
        BonusAO(day: 5, amount: 50, isCollected: false),
        BonusAO(day: 6, amount: 50, isCollected: false),
        BonusAO(day: 7, amount: 50, isCollected: false),
    
    ] {
        didSet {
            saveBonus()
        }
    }
    
    init() {
        loadBonus()
        
    }
    
    private let userDefaultsBonusesKey = "bonuseKeyAO"
    
    func resetBonuses() {
        for index in Range(0...bonuses.count - 1) {
            bonuses[index].isCollected = false
        }
    }
    
    func bonusesToggle(_ bonus: BonusAO) {
        guard let index = bonuses.firstIndex(where: { $0.id == bonus.id }) else {
            return
        }
        
        bonuses[index].isCollected.toggle()
        
    }
    
    func saveBonus() {
        if let encodedData = try? JSONEncoder().encode(bonuses) {
            UserDefaults.standard.set(encodedData, forKey: userDefaultsBonusesKey)
        }
        
    }
    
    func loadBonus() {
        if let savedData = UserDefaults.standard.data(forKey: userDefaultsBonusesKey),
           let loadedItem = try? JSONDecoder().decode([BonusAO].self, from: savedData) {
            bonuses = loadedItem
        } else {
            print("No saved data found")
        }
    }
}

struct BonusAO: Codable, Hashable {
    var id = UUID()
    var day: Int
    var amount: Int
    var isCollected: Bool
}
