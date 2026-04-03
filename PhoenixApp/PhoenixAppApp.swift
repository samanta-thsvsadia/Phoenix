//
//  PhoenixAppApp.swift
//  PhoenixApp
//
//  Created by Sadia Thasina on 18/11/2023.
//


import SwiftUI
import Firebase

@main
struct PhoenixAppApp: App {

    init(){
        FirebaseApp.configure()
    }
    
    var body: some Scene {
        WindowGroup {
            SplashScreenView()
        }
    }
}

