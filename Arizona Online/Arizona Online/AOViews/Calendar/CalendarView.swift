import SwiftUI

struct CalendarView: View {
    @Environment(\.presentationMode) var presentationMode
    @StateObject var user = AOUser.shared
    @ObservedObject var viewModel: CalendarViewModel
    @State private var timer: Timer?
    
    @State private var bonusAmount = 0
    @State private var showAnimation = false
    let defaults = UserDefaults.standard
    var bonuses: [BonusAO] {
        return viewModel.bonuses
    }
    @AppStorage("openedBonuses") var openBonus = 1
    
    var body: some View {
        ZStack {
            
            ZStack {
                Image(.calendarViewBgAO)
                    .resizable()
                    .scaledToFit()
                
                VStack(spacing: 12) {
                    TextWithBorder(text: "Rewards Calendar", font: .custom(AOFonts.regular.rawValue, size: 28), textColor: .white, borderColor: .black, borderWidth: 1)
                    
                    HStack(spacing: 3) {
                        ForEach(viewModel.bonuses, id: \.self) { bonus in
                            VStack {
                                ZStack {
                                    Image(.bonusBg)
                                        .resizable()
                                        .scaledToFit()
                                    VStack(spacing: 3) {
                                        TextWithBorder(text: "Day \(bonus.day)", font: .custom(AOFonts.regular.rawValue, size: 12), textColor: .white, borderColor: .black, borderWidth: 1)
                                        HStack(spacing: 3) {
                                            Image(.starIconAO)
                                                .resizable()
                                                .scaledToFit()
                                                .frame(height: 18)
                                            TextWithBorder(text: "\(bonus.amount)", font: .custom(AOFonts.regular.rawValue, size: 12), textColor: .white, borderColor: .black, borderWidth: 1)
                                        }
                                    }
                                    
                                }.frame(height: 64)
                                
                                if bonus.isCollected {
                                    Image(.checkIconAO)
                                        .resizable()
                                        .scaledToFit()
                                        .frame(height: 34)
                                } else {
                                    if openBonus >= bonus.day {
                                        if !bonus.isCollected {
                                            Button {
                                                bonusAmount = bonus.amount
                                                withAnimation {
                                                    viewModel.bonusesToggle(bonus)
                                                    
                                                }
                                                
                                                user.updateUserMoney(for: bonus.amount)
                                            } label: {
                                            ZStack {
                                                Image(.buttonBgAO)
                                                    .resizable()
                                                    .scaledToFit()
                                                    .frame(height: 17)
                                                TextWithBorder(text: "GET", font: .custom(AOFonts.regular.rawValue, size: 8), textColor: .white, borderColor: .black, borderWidth: 1)
                                                
                                            }.frame(height: 34)
                                        }
                                        }
                                    } else {
                                        Image(.xmarkIconAO)
                                            .resizable()
                                            .scaledToFit()
                                            .frame(height: 34)
                                    }
                                }
                                
                            }
                        }
                    }
                }
                
                
            }.frame(width: 477, height: 234)
            
            
            
            
            VStack {
                HStack {
                    HStack(alignment: .top) {
                        Button {
                            presentationMode.wrappedValue.dismiss()
                            
                        } label: {
                            Image(.backIconAO)
                                .resizable()
                                .scaledToFit()
                                .frame(height: AODeviceInfo.shared.deviceType == .pad ? 150:75)
                        }
                        Spacer()
                        MoneyViewDC()
                    }.padding([.horizontal, .top])
                }
                Spacer()
            }
        }.background(
            ZStack {
                Image(.bgAO)
                    .resizable()
                    .edgesIgnoringSafeArea(.all)
                    .scaledToFill()
            }
        )
        .onAppear {
            startCheckAO()
        }
        .onDisappear {
            stopTimer()
        }
    }
    
    func recordLastOpenTimeAO() {
        if defaults.object(forKey: "lastOpenTime") == nil {
            defaults.set(Date(), forKey: "lastOpenTime")
        }
    }
    
    func hasTimePassedAO() -> Bool {
        if let lastOpen = defaults.object(forKey: "lastOpenTime") as? Date {
            let now = Date()
            let interval = now.timeIntervalSince(lastOpen)
            return interval >= 86400
        }
        return true
    }
    
    func checkStatusAO() {
        if hasTimePassedAO() {
            if openBonus < 7 {
                openBonus += 1
            } else {
                openBonus = 1
                viewModel.resetBonuses()
            }
            
            defaults.set(Date(), forKey: "lastOpenTime")
        }
    }
    
    func startCheckAO() {
        recordLastOpenTimeAO()
        
        checkStatusAO()
        
        timer = Timer.scheduledTimer(withTimeInterval: 60, repeats: true) { _ in
            self.checkStatusAO()
        }
    }
    
    func stopTimer() {
        timer?.invalidate()
        timer = nil
    }
    
}

#Preview {
    CalendarView(viewModel: CalendarViewModel())
}
