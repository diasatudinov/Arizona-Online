//
//  StoreView.swift
//  Arizona Online
//
//  Created by Dias Atudinov on 18.04.2025.
//

import SwiftUI

struct StoreView: View {
    @Environment(\.presentationMode) var presentationMode
    @StateObject var user = AOUser.shared
    @State var section: StoreSection = .bird
    @ObservedObject var viewModel: StoreViewModelAO

    var body: some View {
        ZStack {
            
            VStack {
                Spacer()
                ScrollView(.horizontal) {
                    HStack(spacing: section == .bird ? 10 : 40) {
                        
                        ForEach(section == .bird ? viewModel.shopTeamItems.filter({ $0.section == .bird }) : viewModel.shopTeamItems.filter({ $0.section == .backgrounds }), id: \.self) { item in
                            
                            achievementItem(item: item)
                            
                            
                        }
                    }
                }
                HStack {
                    Button {
                        withAnimation {
                            section = .bird
                        }
                    } label: {
                        Image(.backIconAO)
                            .resizable()
                            .scaledToFit()
                            .frame(height: AODeviceInfo.shared.deviceType == .pad ? 136:68)
                    }
                    Spacer()
                    HStack {
                        ZStack {
                            Image(.buttonBgAO)
                                .resizable()
                                .scaledToFit()
                                .frame(height: 55)
                            
                            TextWithBorder(text: "Birds", font: .custom(AOFonts.regular.rawValue, size: 20), textColor: .white, borderColor: .black, borderWidth: 1)
                        }.offset(y: section == .bird ? -10: 0)
                        
                        ZStack {
                            Image(.buttonBgAO)
                                .resizable()
                                .scaledToFit()
                                .frame(height: 55)
                            
                            TextWithBorder(text: "Arenas", font: .custom(AOFonts.regular.rawValue, size: 20), textColor: .white, borderColor: .black, borderWidth: 1)
                        }.offset(y: section == .backgrounds ? -10: 0)
                    }
                    Spacer()
                    Button {
                        withAnimation {
                            section = .backgrounds
                        }
                    } label: {
                        Image(.backIconAO)
                            .resizable()
                            .scaledToFit()
                            .frame(height: AODeviceInfo.shared.deviceType == .pad ? 136:68)
                            .scaleEffect(x: -1, y: 1)
                    }
                }
                
            }
            
            VStack {
                ZStack {
                    HStack {
                        TextWithBorder(text: "Shop", font: .custom(AOFonts.regular.rawValue, size: 48), textColor: .white, borderColor: .black, borderWidth: 1)
                    }
                    
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
    
    @ViewBuilder func achievementItem(item: Item) -> some View {
        
        ZStack {
            Image(.achievementItemBgAO)
                .resizable()
                .scaledToFit()
            
            VStack(spacing: 0) {
                Image(item.icon)
                    .resizable()
                    .scaledToFit()
                    .frame(height: section == .bird ? 100: 86)
                
                Button {
                    if viewModel.boughtItems.contains(where: { $0.name == item.name }) {
                        if section == .bird {
                            viewModel.currentPersonItem = item
                        } else {
                            viewModel.currentBgItem = item
                        }
                    } else {
                        
                        if !viewModel.boughtItems.contains(where: { $0.name == item.name }) {
                            
                            if user.money >= item.price {
                                user.minusUserMoney(for: item.price)
                                viewModel.boughtItems.append(item)
                            }
                        }
                    }
                } label: {
                    if viewModel.boughtItems.contains(where: { $0.name == item.name }) {
                        
                        if section == .bird {
                            if let currentItem = viewModel.currentPersonItem, currentItem.name == item.name {
                                ZStack {
                                    Image(.buttonBgAO)
                                        .resizable()
                                        .scaledToFit()
                                        .frame(height: 38)
                                    
                                    TextWithBorder(text: "Selected", font: .custom(AOFonts.regular.rawValue, size: 15), textColor: .white, borderColor: .black, borderWidth: 1)
                                    
                                }
                            } else {
                                ZStack {
                                    Image(.buttonBgAO)
                                        .resizable()
                                        .scaledToFit()
                                        .frame(height: 38)
                                    
                                    TextWithBorder(text: "Select", font: .custom(AOFonts.regular.rawValue, size: 15), textColor: .white, borderColor: .black, borderWidth: 1)
                                    
                                }
                            }
                        } else {
                            if let currentItem = viewModel.currentBgItem, currentItem.name == item.name {
                                ZStack {
                                    Image(.buttonBgAO)
                                        .resizable()
                                        .scaledToFit()
                                        .frame(height: 38)
                                    
                                    TextWithBorder(text: "Selected", font: .custom(AOFonts.regular.rawValue, size: 15), textColor: .white, borderColor: .black, borderWidth: 1)
                                    
                                }
                            } else {
                                ZStack {
                                    Image(.buttonBgAO)
                                        .resizable()
                                        .scaledToFit()
                                        .frame(height: 38)
                                    
                                    TextWithBorder(text: "Select", font: .custom(AOFonts.regular.rawValue, size: 15), textColor: .white, borderColor: .black, borderWidth: 1)
                                    
                                }
                            }
                        }
                        
                    } else {
                        if user.money >= item.price {
                            ZStack {
                                Image(.buttonBgAO)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(height: 38)
                                HStack {
                                    TextWithBorder(text: "Buy", font: .custom(AOFonts.regular.rawValue, size: 15), textColor: .white, borderColor: .black, borderWidth: 1)
                                    Image(.starIconAO)
                                        .resizable()
                                        .scaledToFit()
                                        .frame(height: 14)
                                    
                                    TextWithBorder(text: "\(item.price)", font: .custom(AOFonts.regular.rawValue, size: 15), textColor: .white, borderColor: .black, borderWidth: 1)
                                }
                            }
                        } else {
                            ZStack {
                                Image(.buttonOffBgAO)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(height: 38)
                                HStack {
                                    TextWithBorder(text: "Buy", font: .custom(AOFonts.regular.rawValue, size: 15), textColor: .white, borderColor: .black, borderWidth: 1)
                                    Image(.starIconAO)
                                        .resizable()
                                        .scaledToFit()
                                        .frame(height: 14)
                                    
                                    TextWithBorder(text: "\(item.price)", font: .custom(AOFonts.regular.rawValue, size: 15), textColor: .white, borderColor: .black, borderWidth: 1)
                                }
                            }
                        }
                    }
                }
            }
            
        }.frame(height: 189)
        
    }
    
}

#Preview {
    StoreView(viewModel: StoreViewModelAO())
}
