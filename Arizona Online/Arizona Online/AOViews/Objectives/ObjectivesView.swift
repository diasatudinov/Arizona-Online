import SwiftUI

struct ObjectivesView: View {
    @Environment(\.presentationMode) var presentationMode
    @StateObject var user = AOUser.shared
    
    @ObservedObject var viewModel: ObjectivesViewModel
    var body: some View {
        ZStack {
            
            VStack {
                
                ZStack {
                    Image(.timerBgAO)
                        .resizable()
                        .scaledToFit()
                    
                    TextWithBorder(text: viewModel.timeLeftFormatted, font: .custom(AOFonts.regular.rawValue, size: 24), textColor: .white, borderColor: .black, borderWidth: 1)
                }.frame(height: 50)
                
                
                ZStack {
                    Image(.calendarViewBgAO)
                        .resizable()
                        .scaledToFit()
                    
                    VStack {
                        TextWithBorder(text: "Objectives", font: .custom(AOFonts.regular.rawValue, size: 28), textColor: .white, borderColor: .black, borderWidth: 1)
                        
                        TextWithBorder(text: viewModel.currentGoal, font: .custom(AOFonts.regular.rawValue, size: 16), textColor: .white, borderColor: .black, borderWidth: 1)
                        if let index = viewModel.objectives.firstIndex(where: { $0.text == viewModel.currentGoal }) {
                            
                            Button {
                                if viewModel.objectives[index].isRewarded {
                                    
                                    viewModel.completeGoal()
                                    user.updateUserMoney(for: 50)
                                }
                            } label: {
                                
                                ZStack {
                                    
                                    Image(viewModel.objectives[index].isRewarded ? .buttonBgAO: .buttonOffBgAO)
                                        .resizable()
                                        .scaledToFit()
                                    
                                    TextWithBorder(text: "Reward", font: .custom(AOFonts.regular.rawValue, size: 20), textColor: .white, borderColor: .black, borderWidth: 1)
                                }.frame(height: 55)
                                
                                
                            }
                        }
                        
                        
                    }
                    
                }.frame(width: 477, height: 234)
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
        .onAppear {
            viewModel.startTimer()
        }
        .onDisappear {
            viewModel.stopTimer()
        }
    }
}

#Preview {
    ObjectivesView(viewModel: ObjectivesViewModel())
}
