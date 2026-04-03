//
//  ReusablePostsView.swift
//  Phoenix
//
//  Created by Sadia on 25/12/22.
//

import SwiftUI
import Firebase
import FirebaseFirestore

struct ReusablePostsView: View {
    var basedOnUID: Bool = false
    var uid: String = ""
    @Binding var posts: [Post]
    
    @State private var isFetching: Bool = true
    @State private var paginationDoc: QueryDocumentSnapshot?
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            LazyVStack {
                if isFetching {
                    ProgressView()
                        .padding(.top, 30)
                } else {
                    if posts.isEmpty {
                        Text("No Post's Found")
                            .font(.caption)
                            .foregroundColor(.gray)
                            .padding(.top, 30)
                    } else {
                        // Clean Title Logic
                        if !basedOnUID {
                            Text("Phoenix Feed")
                                .font(.system(size: 50, weight: .heavy))
                                .padding(.bottom, 10)
                        }
                        
                        Posts()
                    }
                }
            }
            .padding(15)
        }
        // Background logic with safe area handling
        .background {
            if basedOnUID {
                Color.clear // Shows the gwall from ProfileView
            } else {
                gtext.ignoresSafeArea() // Fills the whole screen on Phoenix Feed
            }
        }
        .refreshable {
            guard !basedOnUID else { return }
            isFetching = true
            posts = []
            paginationDoc = nil
            await fetchPosts()
        }
        .task {
            guard posts.isEmpty else { return }
            await fetchPosts()
        }
    }
    
    /// - Displaying Fetched Post's
    @ViewBuilder
    func Posts() -> some View {
        ForEach(posts) { post in
            PostCardView(post: post) { updatedPost in
                // ... your update logic
            } onDelete: {
                // ... your delete logic
            }
            // 1. ADD INTERNAL TOP GAP HERE
            .padding(.top, basedOnUID ? 15 : 0) // Pushes name away from the top border
            .padding(.horizontal, basedOnUID ? 10 : 0) // Optional: gives side breathing room
            .padding(.bottom, basedOnUID ? 10 : 0) // Keeps the bottom from feeling cramped
            
            // 2. THE CARD BACKGROUND
            .background {
                if basedOnUID {
                    RoundedRectangle(cornerRadius: 15, style: .continuous)
                        .fill(Color.white.opacity(0.2))
                        .shadow(color: .black.opacity(0.1), radius: 4, x: 0, y: 2)
                }
            }
            
            // 3. THE EXTERNAL GAP BETWEEN POSTS
            .padding(.vertical, basedOnUID ? 10 : 0)
            
            .onAppear {
                if post.id == posts.last?.id && paginationDoc != nil {
                    Task { await fetchPosts() }
                }
            }
            
            if !basedOnUID {
                Divider()
                    .padding(.horizontal, -15)
            }
        }
    }
    
    /// - Fetching Post's
    func fetchPosts()async{
        do{
            var query: Query!
            /// - Implementing Pagination
            if let paginationDoc{
                query = Firestore.firestore().collection("Posts")
                    .order(by: "publishedDate", descending: true)
                    .start(afterDocument: paginationDoc)
                    .limit(to: 20)
            }else{
                query = Firestore.firestore().collection("Posts")
                    .order(by: "publishedDate", descending: true)
                    .limit(to: 20)
            }
            
            /// - New Query For UID Based Document Fetch
            /// Simply Filter the Post's Which is not belongs to this UID
            if basedOnUID{
                query = query
                    .whereField("userUID", isEqualTo: uid)
            }
            
            let docs = try await query.getDocuments()
            let fetchedPosts = docs.documents.compactMap { doc -> Post? in
                try? doc.data(as: Post.self)
            }
            await MainActor.run(body: {
                posts.append(contentsOf: fetchedPosts)
                paginationDoc = docs.documents.last
                isFetching = false
            })
        }catch{
            print(error.localizedDescription)
        }
    }
}

struct ReusablePostsView_Previews: PreviewProvider {
    static var previews: some View {
        PView()
    }
}
