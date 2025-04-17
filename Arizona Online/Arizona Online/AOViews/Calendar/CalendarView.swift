import SwiftUI

struct CalendarView: View {
    @Environment(\.presentationMode) var presentationMode
    @StateObject var user = GEUser.shared
    @ObservedObject var viewModel: CalendarViewModel
    @State private var timer: Timer?
    
    @State private var bonusAmount = 0
    @State private var showAnimation = false
    let defaults = UserDefaults.standard
    var bonuses: [Bonus] {
        return viewModel.bonuses
    }
     @AppStorage("openedBonuses") var openBonus = 1
    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    var body: some View {
        ZStack {
            if !showAnimation {
                ZStack {
                    Image(.calendarViewBgGE)
                        .resizable()
                        .scaledToFit()
                    HStack {
                        LazyVGrid(columns: columns, spacing: GEDeviceManager.shared.deviceType == .pad ? 32:16) {
                            ForEach(viewModel.bonuses, id: \.self) { bonus in
                                if bonus.day < 7 {
                                    VStack {
                                        Image("dayText\(bonus.day)")
                                            .resizable()
                                            .scaledToFit()
                                            .frame(height: GEDeviceManager.shared.deviceType == .pad ? 50:25)
                                        ZStack {
                                            Image(bonus.isCollected ? .openedBoxBgGE:.closedBoxBgGE)
                                                .resizable()
                                                .scaledToFit()
                                            
                                            Image(bonus.isCollected ? .openedBoxGE:.closedBoxGE)
                                                .resizable()
                                                .scaledToFit()
                                                .frame(width: GEDeviceManager.shared.deviceType == .pad ? 150:75,height: GEDeviceManager.shared.deviceType == .pad ? 150:75)
                                            
                                            if bonus.isCollected {
                                                VStack {
                                                    Spacer()
                                                    HStack {
                                                        Spacer()
                                                        Image(.stickGE)
                                                            .resizable()
                                                            .scaledToFit()
                                                            .frame(height: GEDeviceManager.shared.deviceType == .pad ? 80:40)
                                                            .offset(x: GEDeviceManager.shared.deviceType == .pad ? 20:10, y: GEDeviceManager.shared.deviceType == .pad ? 20:10)
                                                    }
                                                }
                                            } else {
                                                if openBonus >= bonus.day {
                                                    if !bonus.isCollected {
                                                        VStack {
                                                            Spacer()
                                                            Button {
                                                                bonusAmount = bonus.amount
                                                                withAnimation {
                                                                    viewModel.bonusesToggle(bonus)
                                                                }
                                                                triggerImageAnimation()
                                                                user.updateUserMoney(for: bonus.amount)
                                                                
                                                            } label: {
                                                                Image(.getBtnGE)
                                                                    .resizable()
                                                                    .scaledToFit()
                                                                    .frame(height: GEDeviceManager.shared.deviceType == .pad ? 80:40)
                                                            }
                                                        }
                                                        
                                                    }
                                                    
                                                    
                                                } else {
                                                    Image(.lockIconGE)
                                                        .resizable()
                                                        .scaledToFit()
                                                        .frame(height: GEDeviceManager.shared.deviceType == .pad ? 100:50)
                                                }
                                            }
                                            
                                        }.frame(width: GEDeviceManager.shared.deviceType == .pad ? 200:100,height: GEDeviceManager.shared.deviceType == .pad ? 200:100)
                                    }
                                }
                                
                            }
                        }.frame(width: GEDeviceManager.shared.deviceType == .pad ? 800:400)
                        
                        VStack {
                            Image("dayText\(viewModel.bonuses[6].day)")
                                .resizable()
                                .scaledToFit()
                                .frame(height: GEDeviceManager.shared.deviceType == .pad ? 70:35)
                            ZStack {
                                Image(viewModel.bonuses[6].isCollected ? .openedBoxBgGE:.closedBoxBgGE)
                                    .resizable()
                                    .scaledToFit()
                                
                                Image(viewModel.bonuses[6].isCollected ? .openedBoxGE:.closedSuperBoxGE)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: GEDeviceManager.shared.deviceType == .pad ? 200:100, height: GEDeviceManager.shared.deviceType == .pad ? 200:100)
                                
                                if viewModel.bonuses[6].isCollected {
                                    VStack {
                                        Spacer()
                                        HStack {
                                            Spacer()
                                            Image(.stickGE)
                                                .resizable()
                                                .scaledToFit()
                                                .frame(height: GEDeviceManager.shared.deviceType == .pad ? 120:60)
                                                .offset(x: GEDeviceManager.shared.deviceType == .pad ? 30:15, y: GEDeviceManager.shared.deviceType == .pad ? 30:15)
                                        }
                                    }
                                } else {
                                    if openBonus >= viewModel.bonuses[6].day {
                                        if !viewModel.bonuses[6].isCollected {
                                            VStack {
                                                Spacer()
                                                Button {
                                                    bonusAmount = viewModel.bonuses[6].amount
                                                    withAnimation {
                                                        viewModel.bonusesToggle(viewModel.bonuses[6])
                                                        
                                                    }
                                                    
                                                    triggerImageAnimation()
                                                    user.updateUserMoney(for: viewModel.bonuses[6].amount)
                                                } label: {
                                                    Image(.getBtnGE)
                                                        .resizable()
                                                        .scaledToFit()
                                                        .frame(height: GEDeviceManager.shared.deviceType == .pad ? 140:70)
                                                }
                                            }
                                            
                                        }
                                        
                                        
                                    } else {
                                        Image(.lockIconGE)
                                            .resizable()
                                            .scaledToFit()
                                            .frame(height: GEDeviceManager.shared.deviceType == .pad ? 140:70)
                                    }
                                }
                                
                            }.frame(width: GEDeviceManager.shared.deviceType == .pad ? 300:150, height: GEDeviceManager.shared.deviceType == .pad ? 300:150)
                        }
                        
                    }.padding(.top, GEDeviceManager.shared.deviceType == .pad ? 96:48)
                }
                
            }
            VStack {
                ZStack {
                    ZStack {
                        Image(.forAnimationGE)
                            .resizable()
                            .scaledToFit()
                        
                        Text("+\(bonusAmount)")
                            .font(.system(size: GEDeviceManager.shared.deviceType == .pad ? 100:50, weight: .bold))
                            .foregroundStyle(.yellow)
                            .offset(x: GEDeviceManager.shared.deviceType == .pad ? 80:40, y: GEDeviceManager.shared.deviceType == .pad ? 60:30)
                    }.scaleEffect(showAnimation ? 1 : 0)
                        .animation(.easeOut(duration: 3), value: showAnimation)
                }.frame(width: GEDeviceManager.shared.deviceType == .pad ? 600:300, height: GEDeviceManager.shared.deviceType == .pad ? 600:300)
                
            }
            
            
            VStack {
                HStack {
                    HStack(alignment: .top) {
                        Button {
                            presentationMode.wrappedValue.dismiss()
                            
                        } label: {
                            Image(.backIconGE)
                                .resizable()
                                .scaledToFit()
                                .frame(height: GEDeviceManager.shared.deviceType == .pad ? 150:75)
                        }
                        Spacer()
                        MoneyBgGE()
                    }.padding([.horizontal, .top])
                }
                Spacer()
            }
        }.background(
            ZStack {
                Image(.calendarBgGE)
                    .resizable()
                    .edgesIgnoringSafeArea(.all)
                    .scaledToFill()
            }
        )
        .onAppear {
            startRepeatingCheck()
        }
        .onDisappear {
            stopTimer()
        }
    }
    
    func triggerImageAnimation() {
        showAnimation = true
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            showAnimation = false
        }
    }
    
    func recordLastOpenTimeIfNeeded() {
        // If never opened before, set now
        if defaults.object(forKey: "lastOpenTime") == nil {
            defaults.set(Date(), forKey: "lastOpenTime")
        }
    }
    
    func has24HoursPassed() -> Bool {
        if let lastOpen = defaults.object(forKey: "lastOpenTime") as? Date {
            let now = Date()
            let interval = now.timeIntervalSince(lastOpen)
            return interval >= 86400 // 24 hours in seconds
        }
        return true
    }
    
    func check24HourStatus() {
        if has24HoursPassed() {
            if openBonus < 7 {
                openBonus += 1
            } else {
                openBonus = 1
                viewModel.resetBonuses()
            }
            
            defaults.set(Date(), forKey: "lastOpenTime")
        }
    }
    
    func startRepeatingCheck() {
        recordLastOpenTimeIfNeeded()
        
        check24HourStatus()
        
        timer = Timer.scheduledTimer(withTimeInterval: 60, repeats: true) { _ in
            self.check24HourStatus()
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