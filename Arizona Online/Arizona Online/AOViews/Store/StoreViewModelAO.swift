//
//  ShopViewModelGE.swift
//  Arizona Online
//
//  Created by Dias Atudinov on 18.04.2025.
//


import SwiftUI

class ShopViewModelGE: ObservableObject {
    @Published var shopTeamItems: [Item] = [
        
        Item(name: "bg1", image: "gameBg1GE", icon: "icon1GE", section: .backgrounds, price: 500),
        Item(name: "bg2", image: "gameBg4GE", icon: "icon2GE", section: .backgrounds, price: 500),
        Item(name: "bg3", image: "gameBg3GE", icon: "icon3GE", section: .backgrounds, price: 500),
        Item(name: "bg4", image: "gameBg2GE", icon: "icon4GE", section: .backgrounds, price: 500),

        Item(name: "person1", image: "gamePerson1GE", icon: "peronIcon1GE", section: .persons, price: 200, attackerIcon: "attackerType1", defenderIcon: "defenderType1", kingIcon: "kingType1"),
        Item(name: "person2", image: "gamePerson2GE", icon: "peronIcon2GE", section: .persons, price: 200, attackerIcon: "attackerType2", defenderIcon: "defenderType2", kingIcon: "kingType2"),
        Item(name: "person3", image: "gamePerson3GE", icon: "peronIcon3GE", section: .persons, price: 200, attackerIcon: "attackerType3", defenderIcon: "defenderType3", kingIcon: "kingType3"),
        Item(name: "person4", image: "gamePerson4GE", icon: "peronIcon4GE", section: .persons, price: 200, attackerIcon: "attackerType4", defenderIcon: "defenderType4", kingIcon: "kingType4"),
    ]
    
    @Published var boughtItems: [Item] = [
        Item(name: "bg1", image: "gameBg1GE", icon: "icon1GE", section: .backgrounds, price: 500),
        Item(name: "person1", image: "gamePerson1GE", icon: "peronIcon1GE", section: .persons, price: 200, attackerIcon: "attackerType1", defenderIcon: "defenderType1", kingIcon: "kingType1"),
    ] {
        didSet {
            saveBoughtItem()
        }
    }
    
    @Published var currentBgItem: Item? {
        didSet {
            saveCurrentBg()
        }
    }
    
    @Published var currentPersonItem: Item? {
        didSet {
            saveCurrentPerson()
        }
    }
    
    init() {
        loadCurrentBg()
        loadCurrentPerson()
        loadBoughtItem()
    }
    
    private let userDefaultsBgKey = "userDefaultsBgKey"
    private let userDefaultsPersonKey = "userDefaultsPersonKey"
    private let userDefaultsBoughtKey = "boughtItem"

    
    func saveCurrentBg() {
        if let currentItem = currentBgItem {
            if let encodedData = try? JSONEncoder().encode(currentItem) {
                UserDefaults.standard.set(encodedData, forKey: userDefaultsBgKey)
            }
        }
    }
    
    func loadCurrentBg() {
        if let savedData = UserDefaults.standard.data(forKey: userDefaultsBgKey),
           let loadedItem = try? JSONDecoder().decode(Item.self, from: savedData) {
            currentBgItem = loadedItem
        } else {
            currentBgItem = shopTeamItems[0]
            print("No saved data found")
        }
    }
    
    func saveCurrentPerson() {
        if let currentItem = currentPersonItem {
            if let encodedData = try? JSONEncoder().encode(currentItem) {
                UserDefaults.standard.set(encodedData, forKey: userDefaultsPersonKey)
            }
        }
    }
    
    func loadCurrentPerson() {
        if let savedData = UserDefaults.standard.data(forKey: userDefaultsPersonKey),
           let loadedItem = try? JSONDecoder().decode(Item.self, from: savedData) {
            currentPersonItem = loadedItem
        } else {
            currentPersonItem = shopTeamItems[4]
            print("No saved data found")
        }
    }
    
    func saveBoughtItem() {
        if let encodedData = try? JSONEncoder().encode(boughtItems) {
            UserDefaults.standard.set(encodedData, forKey: userDefaultsBoughtKey)
        }
        
    }
    
    func loadBoughtItem() {
        if let savedData = UserDefaults.standard.data(forKey: userDefaultsBoughtKey),
           let loadedItem = try? JSONDecoder().decode([Item].self, from: savedData) {
            boughtItems = loadedItem
        } else {
            print("No saved data found")
        }
    }
    
}

struct Item: Codable, Hashable {
    var id = UUID()
    var name: String
    var image: String
    var icon: String
    var section: ShopSection
    var price: Int
    var attackerIcon = ""
    var defenderIcon = ""
    var kingIcon = ""
}