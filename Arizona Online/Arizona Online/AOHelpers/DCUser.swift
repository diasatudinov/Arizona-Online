import SwiftUI

class AOUser: ObservableObject {
    
    static let shared = AOUser()
    
    @AppStorage("achievement") var achievementNum: Int = 0
    @AppStorage("money") var storedMoney: Int = 100
    @Published var money: Int = 100
    @Published var oldMoney = 0
    init() {
        money = storedMoney
    }
    
    func achievementDone() {
        achievementNum += 1
    }
    
    func updateUserMoney(for money: Int) {
        oldMoney = self.money
        self.money += money
        storedMoney = self.money
    }
    
    func minusUserMoney(for money: Int) {
        oldMoney = self.money
        self.money -= money
        if self.money < 0 {
            self.money = 0
        }
        storedMoney = self.money
        
    }
    
}
