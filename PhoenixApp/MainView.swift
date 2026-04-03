


//
//  MainView.swift
//  PhoenixApp
//
//  Created by Sadia Thasina on 01/11/2023.
//

import SwiftUI

struct MainView: View {
    
  //  var classificationViewModel = ClassificationViewModel()
   
    var body: some View {
        // MARK: TabView With Recent Post's And Profile Tabs
        TabView{
            PostsView()
                .tabItem {
                    Image(systemName: "rectangle.portrait.on.rectangle.portrait.angled")
                    Text("Post's")
                }
            
           
            
            NavigationView{
                MessagesView().environmentObject(MainObservable())
                    .onAppear(){
                        fetchDataAndSetUserDefaults()
                        
                    }
            } .tabItem {
                Image(systemName: "message.circle.fill")
                Text("Messages")
            }
            
            ProfileView()
                .tabItem {
                    Image(systemName: "gear")
                    Text("Profile")
                }
            
        }
        // Changing Tab Lable Tint to Black
        .tint(.black)
    }
}



struct MainView_Previews: PreviewProvider {
   
    static var previews: some View {
        MainView()
    }
}
