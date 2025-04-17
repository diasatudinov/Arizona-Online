import SwiftUI


class CalendarViewModel: ObservableObject {
    
    @Published var bonuses: [Bonus] = [
        Bonus(day: 1, amount: 50, isCollected: false),
        Bonus(day: 2, amount: 100, isCollected: false),
        Bonus(day: 3, amount: 100, isCollected: false),
        Bonus(day: 4, amount: 150, isCollected: false),
        Bonus(day: 5, amount: 150, isCollected: false),
        Bonus(day: 6, amount: 200, isCollected: false),
        Bonus(day: 7, amount: 200, isCollected: false),
    
    ] {
        didSet {
            saveAchievementsItem()
        }
    }
    
    init() {
        loadAchievementsItem()
        
    }
    
    private let userDefaultsBonusesKey = "userDefaultsBonusesKey"
    
    func resetBonuses() {
        for index in Range(0...bonuses.count - 1) {
            bonuses[index].isCollected = false
        }
    }
    
    func bonusesToggle(_ bonus: Bonus) {
        guard let index = bonuses.firstIndex(where: { $0.id == bonus.id }) else {
            return
        }
        
        bonuses[index].isCollected.toggle()
        
    }
    
    func saveAchievementsItem() {
        if let encodedData = try? JSONEncoder().encode(bonuses) {
            UserDefaults.standard.set(encodedData, forKey: userDefaultsBonusesKey)
        }
        
    }
    
    func loadAchievementsItem() {
        if let savedData = UserDefaults.standard.data(forKey: userDefaultsBonusesKey),
           let loadedItem = try? JSONDecoder().decode([Bonus].self, from: savedData) {
            bonuses = loadedItem
        } else {
            print("No saved data found")
        }
    }
}

struct Bonus: Codable, Hashable {
    var id = UUID()
    var day: Int
    var amount: Int
    var isCollected: Bool
}
