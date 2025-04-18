//
//  GameView.swift
//  Arizona Online
//
//  Created by Dias Atudinov on 18.04.2025.
//


import SwiftUI
import SpriteKit

struct GameView: View {
    @Environment(\.presentationMode) var presentationMode

//    @ObservedObject var storeVM: StoreViewModelDC
//    @ObservedObject var achievementVM: AchievementsViewModel
//    @StateObject var viewModel = GameViewModel()
    
    @State private var gameScene: GameScene = {
        let scene = GameScene(size: UIScreen.main.bounds.size)
        scene.scaleMode = .resizeFill
        return scene
    }()
    
    @State private var powerUse = false
    
    var body: some View {
        ZStack {
            SpriteViewContainer(scene: gameScene)
                .ignoresSafeArea()
            
            VStack {
                HStack {
                    HStack(alignment: .top) {
                        Button {
                            presentationMode.wrappedValue.dismiss()
                            
                        } label: {
                            Image(.homeIconAO)
                                .resizable()
                                .scaledToFit()
                                .frame(height: AODeviceInfo.shared.deviceType == .pad ? 100:50)
                        }
                        Button {
                            gameScene.restartGame()
                            
                        } label: {
                            Image(.restartIconAO)
                                .resizable()
                                .scaledToFit()
                                .frame(height: AODeviceInfo.shared.deviceType == .pad ? 100:50)
                        }
                        Spacer()
                        MoneyViewDC()
                    }.padding([.horizontal, .top])
                }
                
                Spacer()
            }
            
        }
    }
}

#Preview {
    GameView()
}
