import SwiftUI

class ObjectivesViewModel: ObservableObject {
    @Published var currentGoal: String = ""
    @Published var timeLeftFormatted: String = ""
    
    private var timer: Timer?
    private var goalChangeDate: Date = loadOrSetNextGoalDate()
    private var nextGoalChangeDate: Date = loadOrSetNextGoalDate()

    @Published var objectives: [Objective] = [
        Objective(num: 1, text: "Avoid collisions for 30 seconds", isRewarded: false),
        Objective(num: 1, text: "Play one game", isRewarded: false),
        Objective(num: 1, text: "Collect 5 coins in one run", isRewarded: false),
    ]
    
    func startTimer() {
        updateGoalIfNeeded()
        updateTimeLeft()
        
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
            self.updateTimeLeft()
        }
    }
    
    func stopTimer() {
        timer?.invalidate()
        timer = nil
    }
    
    private func updateTimeLeft() {
        let now = Date()
        let remaining = nextGoalChangeDate.timeIntervalSince(now)
        
        if remaining <= 0 {
            setNewGoal()
        } else {
            timeLeftFormatted = formatTime(remaining)
        }
    }
    
    private func updateGoalIfNeeded() {
        if Date() >= nextGoalChangeDate {
            setNewGoal()
        } else {
            currentGoal = UserDefaults.standard.string(forKey: "dailyGoal1") ?? "Avoid collisions for 30 seconds"
        }
    }
    func completeGoal() {
        setNewGoal()
    }
    private func setNewGoal() {
        currentGoal = objectives.randomElement()?.text ?? "Старайся!"
        nextGoalChangeDate = Date().addingTimeInterval(24 * 60 * 60) // +24 часа от текущего момента
        
        UserDefaults.standard.set(currentGoal, forKey: "dailyGoal1")
        UserDefaults.standard.set(nextGoalChangeDate, forKey: "goalChangeDate1")
        
        updateTimeLeft()
    }
    
    private func formatTime(_ timeInterval: TimeInterval) -> String {
        let hours = Int(timeInterval) / 3600
        let minutes = (Int(timeInterval) % 3600) / 60
        let seconds = Int(timeInterval) % 60
        return String(format: "%02d:%02d:%02d", hours, minutes, seconds)
    }
    
    private static func loadOrSetNextGoalDate() -> Date {
        if let saved = UserDefaults.standard.object(forKey: "goalChangeDate1") as? Date,
           saved > Date() {
            return saved
        } else {
            let newDate = Date().addingTimeInterval(24 * 60 * 60)
            UserDefaults.standard.set(newDate, forKey: "goalChangeDate1")
            return newDate
        }
    }
}

struct Objective: Codable, Hashable {
    var id = UUID()
    var num: Int
    var text: String
    var isRewarded: Bool
}
