//
//  AchievementsView.swift
//  Arizona Online
//
//  Created by Dias Atudinov on 17.04.2025.
//

import SwiftUI

struct AchievementsView: View {
    @Environment(\.presentationMode) var presentationMode
    @StateObject var user = AOUser.shared
    @ObservedObject var viewModel: AchievementsViewModel
    
    @State private var currentPage = 0
    
    private var pages: [[Achievement]] {
        stride(from: 0, to: viewModel.achievements.count, by: 3).map {
            Array(viewModel.achievements[$0..<min($0 + 3, viewModel.achievements.count)])
        }
    }
    
    var body: some View {
        ZStack {
            HStack {
                if !pages.isEmpty {
                    Button {
                        if currentPage > 0 {
                            currentPage -= 1
                        }
                    } label: {
                        Image(.backIconAO)
                            .resizable()
                            .scaledToFit()
                            .frame(height: AODeviceInfo.shared.deviceType == .pad ? 136:68)
                    }
                    .disabled(currentPage == 0)
                    HStack {
                        ForEach(pages[currentPage]) { item in
                            achievementItem(item: item)
                        }
                    }
                    Button{
                        if currentPage < pages.count - 1 {
                            currentPage += 1
                        }
                    } label: {
                        Image(.backIconAO)
                            .resizable()
                            .scaledToFit()
                            .frame(height: AODeviceInfo.shared.deviceType == .pad ? 136:68)
                            .scaleEffect(x: -1, y: 1)
                    }
                    .disabled(currentPage == pages.count - 1)
                    
                }
            }
            
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
    }
    
    @ViewBuilder func achievementItem(item: Achievement) -> some View {
        
        ZStack {
            Image(.achievementItemBgAO)
                .resizable()
                .scaledToFit()
            
            VStack(spacing: 0) {
                Image(item.isAchieved ? "\(item.image)" : "\(item.image)Off")
                    .resizable()
                    .scaledToFit()
                    .frame(height: 108)
                
                TextWithBorder(text: item.text, font: .custom(AOFonts.regular.rawValue, size: 14), textColor: .white, borderColor: .black, borderWidth: 1)
                
                TextWithBorder(text: item.subtitle, font: .custom(AOFonts.regular.rawValue, size: 10), textColor: .white, borderColor: .black, borderWidth: 1)
                    .padding(.bottom)
                
                ZStack {
                    Image(item.isAchieved ? .buttonBgAO: .buttonOffBgAO)
                        .resizable()
                        .scaledToFit()
                        .frame(height: 38)
                    
                    TextWithBorder(text: "Received", font: .custom(AOFonts.regular.rawValue, size: 15), textColor: .white, borderColor: .black, borderWidth: 1)
                }.onTapGesture {
                    viewModel.achieveToggle(item)
                }
                .padding(.bottom)
            }
            
        }.frame(height: 264)
        
    }
}

#Preview {
    AchievementsView(viewModel: AchievementsViewModel())
}
