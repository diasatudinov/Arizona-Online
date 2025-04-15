import SwiftUI

struct MenuViewAO: View {
    @State private var showGame = false
    @State private var showRules = false
    @State private var showShop = false
    @State private var showAchievements = false
    @State private var showSettings = false
    
//    @StateObject var settingsVM = SettingsViewModelDC()
//    @StateObject var achievementsVM = AchievementsViewModel()
//    @StateObject var storeVM = StoreViewModelDC()
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
                                showRules = true
                            } label: {
                                MenuTextBg(text: "Play")
                            }
                            
                            HStack(spacing: 20) {
                                Spacer()
                                Button {
                                    showGame = true
                                } label: {
                                    MenuTextBg(text: "Shop")
                                }
                                
                                Button {
                                    showShop = true
                                } label: {
                                    MenuTextBg(text: "Achievements")
                                }
                                Spacer()
                            }
                            
                            HStack(spacing: 20) {
                                
                                Button {
                                    showAchievements = true
                                } label: {
                                    MenuTextBg(text: "Objectives")
                                }
                                
                                Button {
                                    showSettings = true
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
                .fullScreenCover(isPresented: $showGame) {
                }
                .fullScreenCover(isPresented: $showRules) {
                }
                .fullScreenCover(isPresented: $showAchievements) {
                }
                .fullScreenCover(isPresented: $showSettings) {
                }
                .fullScreenCover(isPresented: $showShop) {
                }
        }
    }
    
}


#Preview {
    MenuViewAO()
}
