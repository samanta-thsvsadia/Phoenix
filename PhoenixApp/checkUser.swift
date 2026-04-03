

import Foundation
import Firebase

func checkUser(completion: @escaping (Bool,String,String,String)->Void){
     
    let db = Firestore.firestore()
    
    db.collection("Users").getDocuments { (snap, err) in
        
        if err != nil{
            
            print((err?.localizedDescription)!)
            return
        }
        
        for i in snap!.documents{
            
            if i.documentID == Auth.auth().currentUser?.uid{
                
                completion(true,i.get("username") as! String,i.documentID,i.get("userProfileURL") as! String)
                return
            }
        }
        
        completion(false,"","","")
    }
    
}
