import SwiftUI

enum AchievementType: Codable, Hashable {
    case overall,
    strategic,
    special,
    collectible
}


class AchievementsViewModel: ObservableObject {
    
    @Published var achievements: [Achievement] = [
        Achievement(image: "achievement1", category: .overall, isAchieved: false),
        Achievement(image: "achievement2", category: .overall, isAchieved: false),
        Achievement(image: "achievement3", category: .overall, isAchieved: false),
        Achievement(image: "achievement4", category: .overall, isAchieved: false),
        Achievement(image: "achievement5", category: .overall, isAchieved: false),
        
        Achievement(image: "achievement6", category: .strategic, isAchieved: false),
        Achievement(image: "achievement7", category: .strategic, isAchieved: false),
        Achievement(image: "achievement8", category: .strategic, isAchieved: false),
        Achievement(image: "achievement9", category: .strategic, isAchieved: false),
        Achievement(image: "achievement10", category: .strategic, isAchieved: false),
        
        Achievement(image: "achievement11", category: .special, isAchieved: false),
        Achievement(image: "achievement12", category: .special, isAchieved: false),
        Achievement(image: "achievement13", category: .special, isAchieved: false),
        Achievement(image: "achievement14", category: .special, isAchieved: false),
        Achievement(image: "achievement15", category: .special, isAchieved: false),
        
        Achievement(image: "achievement16", category: .collectible, isAchieved: false),
        Achievement(image: "achievement17", category: .collectible, isAchieved: false),
        Achievement(image: "achievement18", category: .collectible, isAchieved: false),
        Achievement(image: "achievement19", category: .collectible, isAchieved: false),
    ] {
        didSet {
            saveAchievementsItem()
        }
    }
    
    init() {
        loadAchievementsItem()
        
    }
    
    private let userDefaultsAchievementsKey = "userDefaultsAchievementsKey"
    
    func achieveToggle(_ achive: Achievement) {
        guard let index = achievements.firstIndex(where: { $0.id == achive.id })
        else {
            return
        }
        achievements[index].isAchieved.toggle()
        
    }
    
    func saveAchievementsItem() {
        if let encodedData = try? JSONEncoder().encode(achievements) {
            UserDefaults.standard.set(encodedData, forKey: userDefaultsAchievementsKey)
        }
        
    }
    
    func loadAchievementsItem() {
        if let savedData = UserDefaults.standard.data(forKey: userDefaultsAchievementsKey),
           let loadedItem = try? JSONDecoder().decode([Achievement].self, from: savedData) {
            achievements = loadedItem
        } else {
            print("No saved data found")
        }
    }
}

struct Achievement: Codable, Hashable {
    var id = UUID()
    var image: String
    var category: AchievementType
    var isAchieved: Bool
}
