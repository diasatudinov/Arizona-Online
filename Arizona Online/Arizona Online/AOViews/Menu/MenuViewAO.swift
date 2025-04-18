import SwiftUI

struct MenuViewAO: View {
    @State private var showPlay = false
    @State private var showStore = false
    @State private var showAchievements = false
    @State private var showObjectives = false
    @State private var showCalendar = false
    
    @StateObject var achievementsVM = AchievementsViewModel()
    @StateObject var storeVM = StoreViewModelAO()
    @StateObject var objectivesVM = ObjectivesViewModel()
    @StateObject var calendarVM = CalendarViewModel()
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                VStack(spacing: 20) {
                    
                    ZStack(alignment: .top) {
                        HStack(alignment: .top) {
                            
                            Spacer()
                            
                            
                            MoneyViewDC()
                        }
                        
                        
                        
                    }.padding([.horizontal, .top], 20)
                    Spacer()
                }
                
                VStack(spacing: 20) {
                    Spacer()
                    HStack {
                        
                        VStack {
                            
                            Button {
                                showPlay = true
                            } label: {
                                MenuTextBg(text: "Play")
                            }
                            
                            HStack(spacing: 20) {
                                Spacer()
                                Button {
                                    showStore = true
                                } label: {
                                    MenuTextBg(text: "Shop")
                                }
                                
                                Button {
                                    showAchievements = true
                                } label: {
                                    MenuTextBg(text: "Achievements")
                                }
                                Spacer()
                            }
                            
                            HStack(spacing: 20) {
                                
                                Button {
                                    showObjectives = true
                                } label: {
                                    MenuTextBg(text: "Objectives")
                                }
                                
                                Button {
                                    showCalendar = true
                                } label: {
                                    MenuTextBg(text: "Rewards \nCalendar")
                                }
                            }
                        }
                        
                    }
                    Spacer()
                }
            }.ignoresSafeArea()
                .background(
                    Image(.bgAO)
                        .resizable()
                        .ignoresSafeArea()
                        .scaledToFill()
                    
                    
                )
//                .onAppear {
//                    if settingsVM.musicEnabled {
//                        DCSoundManager.shared.playBackgroundMusic()
//                    }
//                }
//                .onChange(of: settingsVM.musicEnabled) { enabled in
//                    if enabled {
//                        DCSoundManager.shared.playBackgroundMusic()
//                    } else {
//                        DCSoundManager.shared.stopBackgroundMusic()
//                    }
//                }
                .fullScreenCover(isPresented: $showPlay) {
                    GameView()
                }
                .fullScreenCover(isPresented: $showStore) {
                    StoreView(viewModel: storeVM)
                }
                .fullScreenCover(isPresented: $showAchievements) {
                    AchievementsView(viewModel: achievementsVM)
                }
                .fullScreenCover(isPresented: $showObjectives) {
                    ObjectivesView(viewModel: objectivesVM)
                }
                .fullScreenCover(isPresented: $showCalendar) {
                    CalendarView(viewModel: calendarVM)
                }
        }
    }
    
}


#Preview {
    MenuViewAO()
}
