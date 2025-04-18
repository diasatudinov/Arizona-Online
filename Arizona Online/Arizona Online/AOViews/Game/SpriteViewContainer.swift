//
//  SpriteViewContainer.swift
//  Arizona Online
//
//  Created by Dias Atudinov on 18.04.2025.
//


import SwiftUI
import SpriteKit


struct SpriteViewContainer: UIViewRepresentable {
    @StateObject var user = AOUser.shared
    var scene: GameScene
    func makeUIView(context: Context) -> SKView {
        // Устанавливаем фрейм равным размеру экрана
        let skView = SKView(frame: UIScreen.main.bounds)
        skView.backgroundColor = .clear
        // Настраиваем сцену
        scene.scaleMode = .resizeFill
        skView.presentScene(scene)
        
        return skView
    }
    
    func updateUIView(_ uiView: SKView, context: Context) {
        // Обновляем размер SKView при изменении размеров SwiftUI представления
        uiView.frame = UIScreen.main.bounds
    }
}
