//
//  collection.swift
//  PhoenixApp
//
//  Created by Sadia Thasina on 04/12/2023.
//
/*
import Foundation
//
//  Home.swift
//  OTP
//
//  Created by Kavsoft on 18/01/20.
//  Copyright © 2020 Kavsoft. All rights reserved.
//

import SwiftUI
import Firebase
import SDWebImageSwiftUI

struct MessagesView : View {
    
    @State var userUID = UserDefaults.standard.value(forKey: "userUID") as! String
    @EnvironmentObject var datas : MainObservable
    @State var show = false
    @State var chat = false
    @State var id = ""
    @State var username = ""
    @State var userProfileURL = ""
    @State var userBio = ""
    
    var body : some View{
        
        
        ZStack{
            
            NavigationLink(destination: ChatView(username: self.username, userProfileURL: self.userProfileURL, userUID: self.userUID, chat: self.$chat), isActive: self.$chat) {
                
                Text("")
            }

            VStack{
                
                if self.datas.recents.count == 0{
                    
                    if self.datas.norecetns{
                        
                        Text("No Chat History")
                    }
                    else{
                        
                        Indicator()
                    }
                
                }
                else{
                    
                    ScrollView(.vertical, showsIndicators: false) {
                        
                        VStack(spacing: 12){
                            
                            ForEach(datas.recents.sorted(by: {$0.stamp > $1.stamp})){i in
                                
                                Button(action: {
                                    
                                    self.id = i.id
                                    self.username = i.username
                                    self.userProfileURL = i.userProfileURL
                                    self.chat.toggle()
                                    
                                }) {
                                    
                                    RecentCellView(userProfileURL: i.userProfileURL, username: i.username, time: i.time, date: i.date, lastmsg: i.lastmsg)
                                }
                                
                            }
                            
                        }.padding()
                        
                    }
                }
            }.navigationBarTitle("Home",displayMode: .inline)
              .navigationBarItems(leading:
              
                  Button(action: {
                      
                    UserDefaults.standard.set("", forKey: "username")
                    UserDefaults.standard.set("", forKey: "userUID")
                    UserDefaults.standard.set("", forKey: "userProfileURL")
                    
                    try! Auth.auth().signOut()
                    
                    UserDefaults.standard.set(false, forKey: "status")
                    
                    NotificationCenter.default.post(name: NSNotification.Name("statusChange"), object: nil)
                    
                  }, label: {
                      
                      Text("Sign Out")
                  })
                  
                  , trailing:
              
                  Button(action: {
                      
                    self.show.toggle()
                    
                  }, label: {
                      
                      Image(systemName: "square.and.pencil").resizable().frame(width: 25, height: 25)
                  }
              )
              
            )
        }
        .sheet(isPresented: self.$show) {
            
            newChatView(username: self.$username, userUID: self.$userUID, userProfileURL: self.$userProfileURL, show: self.$show, chat: self.$chat)
        }
    }
}

struct RecentCellView : View {
    
    var userProfileURL : String
    var username : String
    var time : String
    var date : String
    var lastmsg : String
    
    var body : some View{
        
        HStack{
            
            AnimatedImage(url: URL(string: userProfileURL)!).resizable().renderingMode(.original).frame(width: 55, height: 55).clipShape(Circle())
            
            VStack{
                
                HStack{
                    
                    VStack(alignment: .leading, spacing: 6) {
                        
                        Text(username).foregroundColor(.black)
                        Text(lastmsg).foregroundColor(.gray)
                    }
                    
                    Spacer()
                    
                    VStack(alignment: .leading, spacing: 6) {
                        
                         Text(date).foregroundColor(.gray)
                         Text(time).foregroundColor(.gray)
                    }
                }
                
                Divider()
            }
        }
    }
}

struct newChatView : View {
    
    @ObservedObject var datas = getAllUsers()
    @Binding var username : String
    @Binding var userUID : String
    @Binding var userProfileURL : String
    @Binding var show : Bool
    @Binding var chat : Bool
    
    
    var body : some View{
        
        VStack(alignment: .leading){

                if self.datas.users.count == 0{
                    
                    if self.datas.empty{
                        
                        Text("No Users Found")
                    }
                    else{
                        
                        Indicator()
                    }
                    
                }
                else{
                    
                    Text("Select To Chat").font(.title).foregroundColor(Color.black.opacity(0.5))
                    
                    ScrollView(.vertical, showsIndicators: false) {
                        
                        VStack(spacing: 12){
                            
                            ForEach(datas.users){i in
                                
                                Button(action: {
                                    
                                   
                                    self.username = i.username
                                    self.userBio = i.userBio
                                    self.userBioLink = i.userBioLink
                                    self.userUID = i.userUID
                                    self.userEmail = i.userEmail
                                    self.userProfileURL = i.userProfileURL
                                    self.show.toggle()
                                    self.chat.toggle()
                                    
                                    
                                }) {
                                    
                                    UserCellView(userProfileURL: i.userProfileURL, username: i.username, userBio: i.userBio)
                                }
                                
                                
                            }
                            
                        }
                        
                    }
              }
        }.padding()
    }
}

class getAllUsers : ObservableObject{
    
    @Published var users = [User]()
    @Published var empty = false
    
    init() {
        
        let db = Firestore.firestore()
        
        
        db.collection("Users").getDocuments { (snap, err) in

            if err != nil{
                
                print((err?.localizedDescription)!)
                self.empty = true
                return
            }
            
            if (snap?.documents.isEmpty)!{
                
                self.empty = true
                return
            }
            
            for i in snap!.documents{
                
                let id = i.documentID
                let username = i.get("username") as! String
                let userBio = i.get("userBio") as! String
                let userBioLink = i.get("userBioLink") as! String
                let userUID = i.get("userUID") as! String
                let userEmail = i.get("userEmail") as! String
                let userProfileURL = i.get("userProfileURL") as! String
               
                
                if id != UserDefaults.standard.value(forKey: "userUID") as! String{
                    
                    self.users.append(User(id: id, username: username, userBio: userBio, userBioLink: userBioLink, userUID: userUID, userEmail: userEmail, userProfileURL: userProfileURL))

                }
                
            }
            
            if self.users.isEmpty{
                
                self.empty = true
            }
        }
    }
}

/*struct User : Identifiable {
    
    var id : String
    var name : String
    var pic : String
    var about : String
}
 */

struct UserCellView : View {
    
    var userProfileURL : String
    var username : String
    var userBio : String
    
    var body : some View{
        
        HStack{
            
            AnimatedImage(url: URL(string: userProfileURL)).resizable().renderingMode(.original).frame(width: 55, height: 55).clipShape(Circle())
            
            VStack{
                
                HStack{
                    
                    VStack(alignment: .leading, spacing: 6) {
                        
                        Text(username).foregroundColor(.black)
                        Text(userBio).foregroundColor(.gray)
                    }
                    
                    Spacer()
                    
                }
                
                Divider()
            }
        }
    }
}

struct ChatView : View {
    
    var username : String
    var userProfileURL : String
    var userUID : String
    @Binding var chat : Bool
    @State var msgs = [Msg]()
    @State var txt = ""
    @State var nomsgs = false
    
    var body : some View{
        
        VStack{
            
            
            if msgs.count == 0{
                
                if self.nomsgs{
                    
                    Text("Start New Conversation !!!").foregroundColor(Color.black.opacity(0.5)).padding(.top)
                    
                    Spacer()
                }
                else{
                    
                    Spacer()
                    Indicator()
                    Spacer()
                }

                
            }
            else{
                
                ScrollView(.vertical, showsIndicators: false) {
                    
                    VStack(spacing: 8){
                        
                        ForEach(self.msgs){i in
                            
                            
                            HStack{
                                
                                if i.userUID == UserDefaults.standard.value(forKey: "userUID") as! String{
                                    
                                    Spacer()
                                    
                                    Text(i.msg)
                                        .padding()
                                        .background(Color.blue)
                                        .clipShape(ChatBubble(mymsg: true))
                                        .foregroundColor(.white)
                                }
                                else{
                                    
                                    Text(i.msg).padding().background(Color.green).clipShape(ChatBubble(mymsg: false)).foregroundColor(.white)
                                    
                                    Spacer()
                                }
                            }

                        }
                    }
                }
            }
            
            HStack{
                
                TextField("Enter Message", text: self.$txt).textFieldStyle(RoundedBorderTextFieldStyle())
                
                Button(action: {
                    
                    sendMsg(username: self.username, userUID: self.userUID, userProfileURL: self.userProfileURL, date: Date(), msg: self.txt)
                    
                    self.txt = ""
                    
                }) {
                    
                    Text("Send")
                }
            }
            
                .navigationBarTitle("\(username)",displayMode: .inline)
                .navigationBarBackButtonHidden(true)
                .navigationBarItems(leading: Button(action: {
                    
                    self.chat.toggle()
                    
                }, label: {
                
                    Image(systemName: "arrow.left").resizable().frame(width: 20, height: 15)
                    
                }))
            
        }.padding()
        .onAppear {
        
            self.getMsgs()
                
        }
    }
    
    func getMsgs(){
        
        let db = Firestore.firestore()
        
        let uid = Auth.auth().currentUser?.uid
        
        db.collection("msgs").document(uid!).collection(self.userUID).order(by: "date", descending: false).addSnapshotListener { (snap, err) in
            
            if err != nil{
                
                print((err?.localizedDescription)!)
                self.nomsgs = true
                return
            }
            
            if snap!.isEmpty{
                
                self.nomsgs = true
            }
            
            for i in snap!.documentChanges{
                
                if i.type == .added{
                    
                    
                    let id = i.document.documentID
                    let msg = i.document.get("msg") as! String
                    let username = i.document.get("username") as! String
                    
                    self.msgs.append(Msg(userUID: userUID, msg: msg, username: username))
                }

            }
        }
    }
}

struct Msg : Identifiable {
    
    var userUID : String
    var msg : String
    var username : String
}

struct ChatBubble : Shape {
    
    var mymsg : Bool
    
    func path(in rect: CGRect) -> Path {
            
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: [.topLeft,.topRight,mymsg ? .bottomLeft : .bottomRight], cornerRadii: CGSize(width: 16, height: 16))
        
        return Path(path.cgPath)
    }
}

func sendMsg(username: String, userUID: String, userProfileURL: String, date: Date, msg: String){
    
    let db = Firestore.firestore()
    
    let userUID = Auth.auth().currentUser?.uid
    
    db.collection("Users").document(userUID).collection("recents").document(userUID!).getDocument { (snap, err) in
        
        if err != nil{
            
            print((err?.localizedDescription)!)
            // if there is no recents records....
            
            setRecents(username:username, userUID: userUID, userProfileURL: userProfileURL, msg: msg, date: date)
            return
        }
        
        if !snap!.exists{
            
            setRecents(username: username, userUID: userUID, userProfileURL: userProfileURL, msg: msg, date: date)
        }
        else{
            
            updateRecents(userUID: userUID, lastmsg: msg, date: date)
        }
    }
    
    updateDB(userUID: userUID, msg: msg, date: date)
}

func setRecents(username: String,userUID: String,userProfileURL: String,msg: String,date: Date){
    
    let db = Firestore.firestore()
    
    let myuid = Auth.auth().currentUser?.uid
    
    let myname = UserDefaults.standard.value(forKey: "UserName") as! String
    
    let mypic = UserDefaults.standard.value(forKey: "pic") as! String
    
    db.collection("Users").document(userUID).collection("recents").document(myuid!).setData(["name":myname,"pic":mypic,"lastmsg":msg,"date":date]) { (err) in
        
        if err != nil{
            
            print((err?.localizedDescription)!)
            return
        }
    }
    
    db.collection("Users").document(myuid!).collection("recents").document(userUID).setData(["username":username,"userProfileURL":userProfileURL,"lastmsg":msg,"date":date]) { (err) in
        
        if err != nil{
            
            print((err?.localizedDescription)!)
            return
        }
    }
}

func updateRecents(uid: String,lastmsg: String,date: Date){
    
    let db = Firestore.firestore()
    
    let myuid = Auth.auth().currentUser?.uid
    
    db.collection("users").document(uid).collection("recents").document(myuid!).updateData(["lastmsg":lastmsg,"date":date])
    
     db.collection("users").document(myuid!).collection("recents").document(uid).updateData(["lastmsg":lastmsg,"date":date])
}

func updateDB(userUID: String,msg: String,date: Date){
    
    let db = Firestore.firestore()
    
    let myuid = Auth.auth().currentUser?.uid
    
    db.collection("msgs").document(userUID).collection(myuid!).document().setData(["msg":msg,"user":myuid!,"date":date]) { (err) in
        
        if err != nil{
            
            print((err?.localizedDescription)!)
            return
        }
    }
    
    db.collection("msgs").document(myuid!).collection(userUID).document().setData(["msg":msg,"user":myuid!,"date":date]) { (err) in
        
        if err != nil{
            
            print((err?.localizedDescription)!)
            return
        }
    }
}

*/
