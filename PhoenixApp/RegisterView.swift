//
//  RegisterView.swift
//  PhoenixApp
//
//  Created by Sadia Thasina on 26/11/2023.
//

import SwiftUI
import PhotosUI
import Firebase
import FirebaseFirestore
import FirebaseStorage
import FirebaseAuth

struct RegisterView: View{
    // MARK: User Details
    @State var emailID: String = ""
    @State var password: String = ""
    @State var userName: String = ""
    @State var userBio: String = ""
    @State var userBioLink: String = ""
    @State var userProfilePicData: Data?
    // MARK: View Properties
    @Environment(\.dismiss) var dismiss
    @State var showImagePicker: Bool = false
    @State var photoItem: PhotosPickerItem?
    @State var showError: Bool = false
    @State var errorMessage: String = ""
    @State var isLoading: Bool = false
    // MARK: UserDefaults
    @AppStorage("log_status") var logStatus: Bool = false
    @AppStorage("user_profile_url") var profileURL: URL?
    @AppStorage("user_name") var userNameStored: String = ""
    @AppStorage("user_UID") var userUID: String = ""
    var body: some View{
        VStack(spacing: 10){
           // Spacer(minLength: 30)
            Text("Hello! Register to get started.")
                .font(.largeTitle.bold())
                .hAlign(.leading)
            
            // MARK: For Smaller Size Optimization
            ViewThatFits {
                ScrollView(.vertical, showsIndicators: false) {
                    HelperView()
                }
                
                HelperView()
            }
            
            // MARK: Register Button
            HStack{
                Text("Already Have an account?")
                    .foregroundColor(.gray)
                
                Button("Login Now"){
                    dismiss()
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
        .photosPicker(isPresented: $showImagePicker, selection: $photoItem)
        
        .onChange(of: photoItem) { newPhotoItem, _ in
            Task {
                do {
                    if let unwrappedPhotoItem = newPhotoItem {
                        guard let imageData = try await unwrappedPhotoItem.loadTransferable(type: Data.self) else { return }
                        // MARK: UI Must Be Updated on Main Thread
                        await MainActor.run {
                            userProfilePicData = imageData
                        }
                    } else {
                        // Handle the case where newPhotoItem is nil
                    }
                } catch {
                    print("Error loading data: \(error)")
                }
            }
        }

        
        
//        .onChange(of: photoItem) { newValue in
//            // MARK: Extracting UIImage From PhotoItem
//            if let newValue{
//                Task{
//                    do{
//                        guard let imageData = try await newValue.loadTransferable(type: Data.self) else{return}
//                        // MARK: UI Must Be Updated on Main Thread
//                        await MainActor.run(body: {
//                            userProfilePicData = imageData
//                        })
//
//                    }catch{}
//                }
//            }
//        }
        // MARK: Displaying Alert
        .alert(errorMessage, isPresented: $showError, actions: {})
    }
    
    @ViewBuilder
    func HelperView()->some View{
        VStack(spacing: 12){
            ZStack{
                if let userProfilePicData,let image = UIImage(data: userProfilePicData){
                    Image(uiImage: image)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                }else{
                    Image("NullProfile")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                }
            }
            .frame(width: 85, height: 85)
            .clipShape(Circle())
            .contentShape(Circle())
            .onTapGesture {
                showImagePicker.toggle()
            }
            .padding(.top,25)
            
            TextField("Username", text: $userName)
                .textContentType(.emailAddress)
                .border(1, .gray.opacity(0.5))
                .bold()
            
            TextField("Email", text: $emailID)
                .textContentType(.emailAddress)
                .border(1, .gray.opacity(0.5))
                .bold()
            
            SecureField("Password", text: $password)
                .textContentType(.emailAddress)
                .border(1, .gray.opacity(0.5))
                .bold()
            
            TextField("About You", text: $userBio,axis: .vertical)
                .frame(minHeight: 100,alignment: .top)
                .textContentType(.emailAddress)
                .border(1, .gray.opacity(0.5))
                .bold()
            
            TextField("Link (Optional)", text: $userBioLink)
                .textContentType(.emailAddress)
                .border(1, .gray.opacity(0.5))
                .bold()
            
            Button(action: registerUser){
                // MARK: Login Button
                Text("Sign up")
                    .font(.system(size: 20))
                    .foregroundColor(.white)
                    .hAlign(.center)
                    .fillView(.black)
                    .bold()
            }
            .disableWithOpacity(userName == "" || userBio == "" || emailID == "" || password == "")
            .padding(.top,10)
        }
    }
    
//    func registerUser(){
//        isLoading = true
//        closeKeyboard()
//        Task{
//            do{
//                // Step 1: Creating Firebase Account
//                try await Auth.auth().createUser(withEmail: emailID, password: password)
//                // Step 2: Uploading Profile Photo Into Firebase Storage
//                guard let userUID = Auth.auth().currentUser?.uid else{return}
//                guard let imageData = userProfilePicData else{return}
//                let storageRef = Storage.storage().reference().child("Profile_Images").child(userUID)
//                let _ = try await storageRef.putDataAsync(imageData)
//                // Step 3: Downloading Photo URL
//                let downloadURL = try await storageRef.downloadURL()
//                // Step 4: Creating a User Firestore Object
//                let user = User(username: userName, userBio: userBio, userBioLink: userBioLink, userUID: userUID, userEmail: emailID, userProfileURL: downloadURL)
//                // Step 5: Saving User Doc into Firestore Database
//                let _ = try Firestore.firestore().collection("Users").document(userUID).setData(from: user, completion: { error in
//                    if error == nil{
//                        // MARK: Print Saved Successfully
//                        print("Saved Successfully")
//                        userNameStored = userName
//                        self.userUID = userUID
//                        profileURL = downloadURL
//                        logStatus = true
//                    }
//                })
//            }catch{
//                // MARK: Deleting Created Account In Case of Failure
////                try await Auth.auth().currentUser?.delete()
//                await setError(error)
//            }
//        }
//    }
    func registerUser() {
        isLoading = true
        closeKeyboard()
        Task {
            do {
                // 1. Create the Auth Account (Always works on Spark)
                let result = try await Auth.auth().createUser(withEmail: emailID, password: password)
                let userUID = result.user.uid
                
                // 2. We skip the Storage logic entirely to avoid the "Upgrade" error
                // If you have old data in 2023, we just set this to nil for now.
                let downloadURL: URL? = nil
                
                // 3. Create the User Object
                let user = User(
                    username: userName,
                    userBio: userBio,
                    userBioLink: userBioLink,
                    userUID: userUID,
                    userEmail: emailID,
                    userProfileURL: downloadURL
                )
                
                // 4. Save to Firestore (Wait for it to finish)
                try await Firestore.firestore().collection("Users").document(userUID).setData(from: user)
                
                // 5. Update UI on Main Thread
                await MainActor.run {
                    userNameStored = userName
                    self.userUID = userUID
                    profileURL = downloadURL
                    logStatus = true
                    isLoading = false
                    print("2023 Registration Successful: Firestore doc created without Storage.")
                }
                
            } catch {
                // If Auth fails (e.g., email already exists) or Firestore fails (Rules expired)
                await setError(error)
            }
        }
    }
    // MARK: Displaying Errors VIA Alert
    func setError(_ error: Error)async{
        // MARK: UI Must be Updated on Main Thread
        await MainActor.run(body: {
            errorMessage = error.localizedDescription
            showError.toggle()
            isLoading = false
        })
    }
}

struct RegistertView_Previews: PreviewProvider {
    static var previews: some View {
        PView()
    }
}
