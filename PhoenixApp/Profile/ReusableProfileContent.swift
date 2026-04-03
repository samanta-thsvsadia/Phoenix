//
//  ReusableProfileContent.swift
//  Phoenix
//
//  Created by Sadia on 14/12/23.
//

import SwiftUI
import SDWebImageSwiftUI

struct ReusableProfileContent: View {
    var user: User
    @State private var fetchedPosts: [Post] = []
    var body: some View {
        ZStack{
        gwall.edgesIgnoringSafeArea(.all).opacity(0.7)
            ScrollView(.vertical, showsIndicators: false) {
            LazyVStack{
                VStack(spacing: 12){
                    WebImage(url:user.userProfileURL).placeholder{ // WORK DONE
                        // MARK: Placeholder Imgae
                        Image("NullProfile")
                            .resizable()
                    }
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 100, height: 100)
                    .clipShape(Circle())
                    
                    VStack(alignment: .center, spacing: 6) {
                        Text(user.username)
                            .font(.title3)
                            .fontWeight(.semibold)
                        
                        Text(user.userBio)
                            .font(.caption)
                            .foregroundColor(.gray)
                            .lineLimit(3)
                        
                        // MARK: Displaying Bio Link, If Given While Signing Up Profile Page
                        if let bioLink = URL(string: user.userBioLink){
                            Link(user.userBioLink, destination: bioLink)
                                .font(.callout)
                                .tint(.blue)
                                .lineLimit(1)
                        }
                    }
                    .hAlign(.leading)
                }
                
                Text("User Posts")
                    .font(.title2)
                    .fontWeight(.semibold)
                    .foregroundColor(.black)
                    .hAlign(.center)
                    .padding(.vertical,15)
                    .opacity(0.5)
                //  Spacer(minLength: 10)
                
                ReusablePostsView(basedOnUID: true, uid: user.userUID, posts: $fetchedPosts)
            }
            .padding(15)
        }}
    }
}


