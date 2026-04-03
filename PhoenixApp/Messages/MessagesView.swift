import Foundation
import SwiftUI
import Firebase
import SDWebImageSwiftUI

struct MessagesView: View {
    
  //  @State var username = UserDefaults.standard.value(forKey: "username") as! String
    @EnvironmentObject var datas : MainObservable
    @State var show = false
    @State var chat = false
    @State var userUID = ""
    @State var username = ""
    @State var userProfileURL = ""
  //  @State var blanktextmsgs = "blanktextmsgs"
    
   

    
    var body: some View {
        
        ZStack{
            Color.blue.opacity(0.2).edgesIgnoringSafeArea(.all)
            NavigationLink(destination: ChatView(username: self.username, userProfileURL: self.userProfileURL, userUID: self.userUID, chat: self.$chat), isActive: self.$chat) {
                
                Text("")
            }
            
            VStack(alignment: .leading){
                
                if self.datas.recents.count == 0{
                    
                    if self.datas.norecetns{
                        
                        Text("No Chat History")
                    }
                    else{
                        
                        Indicator()
                    }
                    
                }else{
                
                ScrollView(.vertical, showsIndicators: false) {
                    VStack(spacing: 12){
                        ForEach(datas.recents.sorted(by: {$0.stamp > $1.stamp})){ i in
                            
                            
                            Button(action: {
                                
                                self.userUID = i.id
                                self.username = i.username
                                self.userProfileURL = i.userProfileURL
                                self.chat.toggle()
                                
                                
                            }, label: {
                                RecentCellView(userProfileURL: i.userProfileURL, username: i.username, time: i.time, date: i.date, lastmsg: i.lastmsg)
                            })
                            
                        }
                    }.padding()
                    
                }
            }
            
        }
            .overlay(alignment: .bottomTrailing) {
                Button {
                    show.toggle()
                } label: {
                    
                   
                        HStack {
                            Image(systemName: "square.and.pencil")
                                .font(.title3)
                                .fontWeight(.semibold)
                                .foregroundColor(.white)
                                .padding(13)
                            .background(gtext,in: Circle())
                            
                            Text("New Chat")
                                .font(.system(size: 20, weight:.bold))
                                .foregroundStyle(.white)
                        }
                        .padding(10)
                        .background(.black.opacity(0.5),in: Rectangle())
                        .cornerRadius(11)
                        
                       
                    
                }
                .padding(15)
            }
        .navigationBarTitle("Chat", displayMode: .inline)
    }.sheet(isPresented: self.$show){
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
                //27m
//                AnimatedImage(url: URL(string: userProfileURL)!).resizable().renderingMode(.original).frame(width: 55, height: 55).clipShape(Circle())
                
                if let url = URL(string: userProfileURL), !userProfileURL.isEmpty {
                        AnimatedImage(url: url)
                            .resizable()
                            .renderingMode(.original)
                            .frame(width: 55, height: 55)
                            .clipShape(Circle())
                    } else {
                        Image(systemName: "person.circle.fill")
                            .resizable()
                            .frame(width: 55, height: 55)
                            .foregroundColor(.gray)
                    }
                
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
    @Binding var username : String
    @Binding var userUID : String
    @Binding var userProfileURL : String
    @Binding var show : Bool
    @Binding var chat : Bool
    @ObservedObject var datas = getAllUsers()
    
    var body : some View{
        
        VStack(alignment: .leading){
   
                if self.datas.users.count == 0{
                    
                    Indicator()
                    
                }else{
                    
                    Text("Select To Chat").font(.title).foregroundColor(Color.black.opacity(0.5))
                    
                    ScrollView(.vertical, showsIndicators: false) {
                        
                        VStack(spacing: 12){
                            
                            ForEach(datas.users){i in
                                
                                Button(action: {
                                    
                                    self.userUID = i.id
                                    self.username = i.username
                                    self.userProfileURL = i.userProfileURL
                                    self.show.toggle()
                                    self.chat.toggle()
                                    
                                    
                                }, label: {
                                    UserCellView(userProfileURL: i.userProfileURL, username: i.username, userBio: i.userBio)
                                })
                                
                                
                                
                            }
                            
                        }
                        
                    }
                }
                
        }.padding(.horizontal) //MARK: CHECK
        }
    }

       
class getAllUsers : ObservableObject{
    

    
    @Published var users = [ChatUser]()
   // @Published var empty = false
    
    init() {
        
        let db = Firestore.firestore()
        let userUID = UserDefaults.standard.value(forKey: "UID") as! String
        print ("userdef uid" , userUID)
        
        db.collection("Users").getDocuments { (snap, err) in

            if err != nil{
                
                print((err?.localizedDescription)!)
               // self.empty = true
                return
            }
            
        /*    if (snap?.documents.isEmpty)!{
                
                self.empty = true
                return
            }
         */
            //27M
//            for i in snap!.documents{
//                
//                let id = i.documentID
//                let username = i.get("username") as! String
//                let userProfileURL = i.get("userProfileURL") as! String
//                let userBio = i.get("userBio") as! String
//                
//              
//                    
//                if id != UserDefaults.standard.value(forKey: "UID") as! String{ //UID
//                    
//                    self.users.append(ChatUser(id: id, username: username, userProfileURL: userProfileURL, userBio: userBio))
//
//                }
//            }
            
            
            for i in snap!.documents {
                let id = i.documentID
                
                // Safely get fields. If they don't exist, use an empty string instead of crashing.
                let username = i.get("username") as? String ?? "User"
                let userProfileURL = i.get("userProfileURL") as? String ?? ""
                let userBio = i.get("userBio") as? String ?? ""
                
                // Use optional binding for the UID check
                if let myUID = UserDefaults.standard.string(forKey: "UID") {
                    if id != myUID {
                        self.users.append(ChatUser(id: id, username: username, userProfileURL: userProfileURL, userBio: userBio))
                    }
                } else {
                    // Fallback: if we can't find our own UID, just show the user anyway
                    self.users.append(ChatUser(id: id, username: username, userProfileURL: userProfileURL, userBio: userBio))
                }
            }
            
            
          /*  if self.users.isEmpty{
                
                self.empty = true
            }
           */
        }
    }
}



struct ChatUser: Identifiable{
    var id : String
    var username : String
    var userProfileURL : String
    var userBio : String
}


struct UserCellView : View {
    
    var userProfileURL : String
    var username : String
    var userBio : String
    
    var body : some View{
        
        HStack{
            
            //27m
            
//            AnimatedImage(url: URL(string: userProfileURL)!).resizable().renderingMode(.original).frame(width: 55, height: 55).clipShape(Circle())
            
            if let url = URL(string: userProfileURL), !userProfileURL.isEmpty {
                    AnimatedImage(url: url)
                        .resizable()
                        .renderingMode(.original)
                        .frame(width: 55, height: 55)
                        .clipShape(Circle())
                } else {
                    Image(systemName: "person.circle.fill")
                        .resizable()
                        .frame(width: 55, height: 55)
                        .foregroundColor(.gray)
                }
            
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
    
    var classificationViewModel = ClassificationViewModel()
    var username : String
    var userProfileURL : String
    var userUID : String
    @Binding var chat : Bool
    @State var msgs = [Msg]()
    @State var txt = ""
    @State var nomsgs = false
    @State private var blanktextchat = "blanktextchat"
    
    @State private var isCameraViewPresented = false
    @State private var isImageViewPresented = false
  


    
    
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
                                
                                if i.user == UserDefaults.standard.value(forKey: "UID") as! String{
                                    
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
                
                Button(action: {
                    isImageViewPresented = true
                }) {
                    HStack(spacing:2){
                        Text("ASL")
                            .font(.system(size: 10))
                            .bold()
                            .foregroundStyle(.black)
                            
                        Image(systemName: "photo")
                        
                    }
                    .padding(5)
                    .background(gtext)
                    .cornerRadius(10)
                }
                .sheet(isPresented: $isImageViewPresented) {
                    ImagePickerView(isImageViewPresented: $isImageViewPresented, imgToText: $txt
                    ).environmentObject(classificationViewModel)
                }
                
                
                
                Button(action: {
                    isCameraViewPresented = true
                }) {
                    HStack(spacing:2){
                        Text("ASL")
                            .font(.system(size: 10))
                            .bold()
                            .foregroundStyle(.black)
                            
                        Image(systemName: "camera.fill")
                        
                    }
                    .padding(5)
                    .background(gtext)
                    .cornerRadius(10)
                }
               
                .sheet(isPresented: $isCameraViewPresented) {
                    CameraView(
                        isCameraViewPresented: $isCameraViewPresented,
                        chatTextFieldText: $txt
                    ).environmentObject(classificationViewModel)
                }
                
                


                TextField("Enter Message", text: self.$txt).textFieldStyle(RoundedBorderTextFieldStyle())
                
                Button(action: {
                    
                    sendMsg(user: self.username, userUID: self.userUID, userProfileURL: self.userProfileURL, date: Date(), msg: self.txt)
                    
                    self.txt = ""
                //    self.chatTextFieldText = self.classificationViewModel.text //hello
                    
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
            if let userUID = UserDefaults.standard.value(forKey: "UID") as? String {
                    print("User UID from UserDefaults: \(userUID)")
                } else {
                    print("User UID not found in UserDefaults")
                }
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
                    let user = i.document.get("user") as! String
                    
                    self.msgs.append(Msg(id: id, msg: msg, user: user))
                }

            }
        }
    }
}

struct Msg : Identifiable {
    
    var id : String
    var msg : String
    var user : String
}

struct ChatBubble : Shape {
    
    var mymsg : Bool
    
    func path(in rect: CGRect) -> Path {
            
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: [.topLeft,.topRight,mymsg ? .bottomLeft : .bottomRight], cornerRadii: CGSize(width: 16, height: 16))
        
        return Path(path.cgPath)
    }
}

func sendMsg(user: String,userUID: String,userProfileURL: String,date: Date,msg: String){
    
    let db = Firestore.firestore()
    
    let myuid = Auth.auth().currentUser?.uid
    
    db.collection("Users").document(userUID).collection("recents").document(myuid!).getDocument { (snap, err) in
        
        if err != nil{
            
            print((err?.localizedDescription)!)
            // if there is no recents records....
            
            setRecents(username: user, userUID: userUID, userProfileURL: userProfileURL, msg: msg, date: date)
            return
        }
        
        if !snap!.exists{
            
            setRecents(username: user, userUID: userUID, userProfileURL: userProfileURL, msg: msg, date: date)
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
    
    let myname = UserDefaults.standard.value(forKey: "NAME") as! String
    
    let mypic = UserDefaults.standard.value(forKey: "PIC") as! String
    
    if 2+2==4{
                   print("myname is \(myname)")
                   print("mypic is \(mypic)")
               }
    
    db.collection("Users").document(userUID).collection("recents").document(myuid!).setData(["username": myname, "userProfileURL": mypic, "lastmsg": msg, "date": date]) { (err) in
        
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

func updateRecents(userUID: String,lastmsg: String,date: Date){
    
    let db = Firestore.firestore()
    
    let myuid = Auth.auth().currentUser?.uid
    
    db.collection("Users").document(userUID).collection("recents").document(myuid!).updateData(["lastmsg":lastmsg,"date":date])
    
     db.collection("Users").document(myuid!).collection("recents").document(userUID).updateData(["lastmsg":lastmsg,"date":date])
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

func fetchDataAndSetUserDefaults() {
    @AppStorage("chat_logstatus") var chatlogstatus: Bool = false
    
    if chatlogstatus == true{
        
        let db = Firestore.firestore()
        let myUID = Auth.auth().currentUser?.uid
        db.collection("Users").document(myUID!).getDocument{ (document, error) in
        if let document = document, document.exists{
            let fetchid = document.documentID
            let NAME = document.get("username") as? String ?? ""
            let PIC = document.get("userProfileURL") as? String ?? ""
            
            // Store values in UserDefaults
            UserDefaults.standard.set(myUID, forKey: "UID")
            UserDefaults.standard.set(NAME, forKey: "NAME")
            UserDefaults.standard.set(PIC, forKey: "PIC")
            print("Username in fetchDataAndSetUserDefaults:", NAME)
            print("Profile URL in fetchDataAndSetUserDefaults:" , PIC)
            print("UID in fetchDataAndSetUserDefaults:" , myUID)
            // Synchronize UserDefaults
            UserDefaults.standard.synchronize()
        }
    }
    }else{
        print("ERROR chatlogstatus == false or USER LOGGED OUT")
    }
}
