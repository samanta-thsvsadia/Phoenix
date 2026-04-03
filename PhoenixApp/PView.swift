
import SwiftUI
import FirebaseAuth
import FirebaseFirestore

struct  PView: View {
    @AppStorage("log_status") var logStatus: Bool = false
    var body: some View {
        // MARK: Redirecting User Based on Log Status
        if logStatus{
            MainView()
        }else{
            WelcomeView()
        }
    }
}

struct  PView_Previews: PreviewProvider {
    static var previews: some View {
        PView()
    }
}

class MainObservable : ObservableObject{
    
    @Published var recents = [Recent]()
    @Published var norecetns = false
    
    init() {
        
        let db = Firestore.firestore()
        let uid = Auth.auth().currentUser?.uid
        
        db.collection("Users").document(uid!).collection("recents").order(by: "date", descending: true).addSnapshotListener { (snap, err) in
            
            if err != nil{
                
                print((err?.localizedDescription)!)
                self.norecetns = true
                return
            }
            
            if snap!.isEmpty{
                
                self.norecetns = true
            }
            
            for i in snap!.documentChanges{
                
                if i.type == .added{
                    
                    let id = i.document.documentID
                    let username = i.document.get("username") as! String
                    let userProfileURL = i.document.get("userProfileURL") as! String
                    let lastmsg = i.document.get("lastmsg") as! String
                   let stamp = i.document.get("date") as! Timestamp
                    
                    let formatter = DateFormatter()
                    formatter.dateFormat = "dd/MM/yy"
                    let date = formatter.string(from: stamp.dateValue())
                    
                    formatter.dateFormat = "hh:mm a"
                    let time = formatter.string(from: stamp.dateValue())
                
                
                    
                    self.recents.append(Recent(id: id, username: username, userProfileURL: userProfileURL, lastmsg: lastmsg, time: time, date: date, stamp: stamp.dateValue()))
                }
                
                if i.type == .modified{
                    
                    let id = i.document.documentID
                    let lastmsg = i.document.get("lastmsg") as! String
                   let stamp = i.document.get("date") as! Timestamp
                    
                  let formatter = DateFormatter()
                  formatter.dateFormat = "dd/MM/yy"
                  let date = formatter.string(from: stamp.dateValue())
                    
                    formatter.dateFormat = "hh:mm a"
                   let time = formatter.string(from: stamp.dateValue())
                    
                    
                    for j in 0..<self.recents.count{
                        
                        if self.recents[j].id == id{
                            
                            self.recents[j].lastmsg = lastmsg
                           self.recents[j].time = time
                          self.recents[j].date = date
                           self.recents[j].stamp = stamp.dateValue()
                        }
                    }
                }
            }
        }
    }
}

struct Recent : Identifiable {
    
    var id : String
    var username : String
    var userProfileURL : String
    var lastmsg : String
   var time : String
   var date : String
  var stamp : Date
}
