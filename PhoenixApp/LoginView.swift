//
//  LoginView.swift
//  Phoenix
//
//  Created by Sadia on 07/12/23.
//


import SwiftUI
import PhotosUI
import Firebase
import FirebaseFirestore
import FirebaseStorage
import FirebaseAuth

struct LoginView: View {
    // MARK: User Details
    @State var emailID: String = ""
    @State var password: String = ""
    // MARK: View Properties
    @State var createAccount: Bool = false
    @State var showError: Bool = false
    @State var errorMessage: String = ""
    @State var isLoading: Bool = false
    // MARK: User Defaults
    @AppStorage("user_profile_url") var profileURL: URL?
    @AppStorage("user_name") var userNameStored: String = ""
    @AppStorage("user_UID") var userUID: String = ""
    @AppStorage("log_status") var logStatus: Bool = false
    @AppStorage("chat_logstatus") var chatlogstatus: Bool = false
    var body: some View {
        VStack(spacing: 10){
            Spacer(minLength: 30)
            Text("Welcome Back! \nLog in to your \(phoenix) account.")
                .font(.largeTitle.bold())
                .hAlign(.leading)
            
            //            Text("Welcome Back! \nLog in to your PHOENIX account.")
            //                .font(.largeTitle.bold())
            //                .hAlign(.leading)
            
            VStack(spacing: 22){
                TextField("Email", text: $emailID)
                    .frame(height:40)
                    .textContentType(.emailAddress)
                    .border(1, .gray.opacity(0.5))
                    .padding(.top,25)
                    .bold()
                
                
                
                SecureField("Password", text: $password)
                    .frame(height:40)
                    .textContentType(.emailAddress)
                    .border(1, .gray.opacity(0.5))
                    .bold()
                
                Button("Reset password?", action: resetPassword)
                    .font(.callout.italic())
                    .fontWeight(.medium)
                    .tint(.black)
                    .hAlign(.trailing)
                    .padding(.top,-10)
                    .foregroundColor(Color("darkpurple"))
                
                
                Button(action: loginUser){
                    // MARK: Login Button
                    Text("Sign in")
                        .font(.system(size: 20))
                        .foregroundColor(.white)
                        .hAlign(.center)
                        .fillView(.black)
                        .bold()
                }
                .padding(.top,20)
            }
            
            // MARK: Register Button
            HStack{
                Text("Don't have an account?")
                    .foregroundColor(.gray)
                
                Button("Register Now"){
                    createAccount.toggle()
                }
                .fontWeight(.bold)
                .foregroundColor(Color("darkpurple"))
                
                
            }
            .font(.callout)
            .vAlign(.bottom)
        }
        .vAlign(.top)
        .padding(15)
        .overlay(content: {
            LoadingView(show: $isLoading)
        })
        // MARK: Register View VIA Sheets
        .fullScreenCover(isPresented: $createAccount) {
            RegisterView()
        }
        // MARK: Displaying Alert
        .alert(errorMessage, isPresented: $showError, actions: {})
    }
    
//    func loginUser(){
//        isLoading = true
//        closeKeyboard()
//        Task{
//            do{
//                // With the help of Swift Concurrency Auth can be done with Single Line
//                try await Auth.auth().signIn(withEmail: emailID, password: password)
//                print("User Found")
//                
//                // Set UserDefaults values
//                UserDefaults.standard.set(userNameStored, forKey: "username")
//                UserDefaults.standard.set(userUID, forKey: "userUID")
//                UserDefaults.standard.set(profileURL, forKey: "userProfileURL")
//                
//                // MARK: Print values before fetchUser
//                print("Before fetchUser - userUID:", userUID)
//                print("Before fetchUser - userNameStored:", userNameStored)
//                print("Before fetchUser - profileURL:", profileURL?.absoluteString ?? "Not set")
//                
//                UserDefaults.standard.synchronize()
//                
//                
//                try await fetchUser()
//            }catch{
//                await setError(error)
//            }
//        }
//    }
//    
//    // MARK: If User if Found then Fetching User Data From Firestore
//    func fetchUser()async throws{
//        guard let userID = Auth.auth().currentUser?.uid else{return}
//        
//        // MARK: Print before fetching user data
//        print("Fetching user data for userID:", userID)
//        
//        let user = try await Firestore.firestore().collection("Users").document(userID).getDocument(as: User.self)
//        
//        // MARK: Print fetched user data
//        print("User data fetched successfully:", user)
//        
//        // MARK: UI Updating Must be Run On Main Thread
//        await MainActor.run(body: {
//            // Setting UserDefaults data and Changing App's Auth Status
//            userUID = userID
//            userNameStored = user.username
//            //  profileURL = URL(string: user.userProfileURL)
//            //profileURL = url
//            profileURL = user.userProfileURL
//            print("Username in UserDefaults:", userNameStored)
//            print("Profile URL in UserDefaults:", profileURL ?? "Not set")
//            logStatus = true
//            chatlogstatus = true
//        })
//    }
    
    func loginUser() {
        isLoading = true
        closeKeyboard()
        Task {
            do {
                // Step 1: Auth Sign In (Standard Spark Plan feature)
                try await Auth.auth().signIn(withEmail: emailID, password: password)
                print("DEBUG: Auth Successful")
                
                // Step 2: Fetch the actual Profile from Firestore
                try await fetchUser()
                
            } catch {
                // This catches "Wrong Password", "User Not Found", or "Malformed Credential"
                await setError(error)
            }
        }
    }

    func fetchUser() async throws {
        guard let userID = Auth.auth().currentUser?.uid else { return }
        
        // Step 3: Pull the document from your 2023 'Users' collection
        let user = try await Firestore.firestore().collection("Users").document(userID).getDocument(as: User.self)
        
        await MainActor.run {
            // Step 4: NOW we save to UserDefaults because we actually have the data
            self.userUID = userID
            self.userNameStored = user.username
            self.profileURL = user.userProfileURL // Will be nil if no photo exists, which is fine
            
            // Finalize Login State
            logStatus = true
            chatlogstatus = true
            isLoading = false
            print("DEBUG: Login Complete for \(user.username)")
        }
    }
    func resetPassword(){
        Task{
            do{
                // With the help of Swift Concurrency Auth can be done with Single Line
                try await Auth.auth().sendPasswordReset(withEmail: emailID)
                print("Link Sent")
            }catch{
                await setError(error)
            }
        }
    }
    
    // MARK: Displaying Errors VIA Alert
    //    func setError(_ error: Error)async{
    //        // MARK: UI Must be Updated on Main Thread
    //        await MainActor.run(body: {
    //            errorMessage = error.localizedDescription
    //            showError.toggle()
    //            isLoading = false
    //        })
    //    }
    
    // MARK: Displaying Errors VIA Alert
        func setError(_ error: Error)async{
            // ADD THIS LINE TO SEE THE ERROR IN THE CONSOLE
            print("DEBUG: Firebase Error -> \(error.localizedDescription)")
            
            // MARK: UI Must be Updated on Main Thread
            await MainActor.run(body: {
                errorMessage = error.localizedDescription
                showError.toggle()
                isLoading = false
            })
        }

}



// MARK: Register View


struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}


