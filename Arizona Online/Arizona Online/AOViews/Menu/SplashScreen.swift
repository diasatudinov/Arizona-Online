//
//  SplashScreen.swift
//  Arizona Online
//
//  Created by Dias Atudinov on 15.04.2025.
//

import SwiftUI

struct SplashScreen: View {
    @State private var scale: CGFloat = 1.0
    @State private var progress: CGFloat = 0.0
    @State private var timer: Timer?
    var body: some View {
        ZStack {
            VStack {
                Spacer()
                
                ZStack {
                    TextWithBorder(text: "The sky is not\n the limit", font: .custom(AOFonts.regular.rawValue, size: 40), textColor: .white, borderColor: .black, borderWidth: 1)
                        .multilineTextAlignment(.center)
                    
                    
                    
                }
                .frame(height: 150)
                
                Spacer()
                VStack(spacing: 0) {
                    TextWithBorder(text: "Loading...", font: .custom(AOFonts.regular.rawValue, size: 24), textColor: .white, borderColor: .black, borderWidth: 1)
                        .scaleEffect(scale)
                        .animation(
                            Animation.easeInOut(duration: 0.8)
                                .repeatForever(autoreverses: true),
                            value: scale
                        )
                        .onAppear {
                            scale = 0.8
                        }
                    
                    
                    ZStack {
                        Image(.loaderLineBgAO)
                            .resizable()
                            .scaledToFit()
                            .colorMultiply(.gray)
                        
                        Image(.loaderLineAO)
                            .resizable()
                            .scaledToFit()
                            .mask(
                                Rectangle()
                                    .frame(width: progress * 400)
                                    .padding(.trailing, (1 - progress) * 400)
                            )
                            .padding(.horizontal, 5)
                    }
                    .frame(width: 400)
                }
                .padding(.bottom, 15)
            }
        }.background(
            Image(.bgAO)
                .resizable()
                .edgesIgnoringSafeArea(.all)
                .scaledToFill()
            
        )
        .onAppear {
            startTimer()
        }
    }
    
    func startTimer() {
        timer?.invalidate()
        progress = 0
        timer = Timer.scheduledTimer(withTimeInterval: 0.07, repeats: true) { timer in
            if progress < 1 {
                progress += 0.01
            } else {
                timer.invalidate()
            }
        }
    }
}

#Preview {
    SplashScreen()
}
