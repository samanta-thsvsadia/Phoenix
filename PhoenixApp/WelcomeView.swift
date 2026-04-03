
//
//  WelcomeView.swift
//  PhoenixApp
//
//  Created by Sadia Thasina on 01/11/2023.
//

import SwiftUI

struct WelcomeView: View {
    var body: some View {
        NavigationView {
            ZStack {

            gwall.ignoresSafeArea(.all)

                VStack(alignment:.center){

                    VStack(spacing: -30) {
                        Image("plogo")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 300, height: 300)
                    .offset(x: 30)

                        Text("PHOENIX")
                            .font(.system(size: 60))
                            .font(.headline.bold())
                            .fontWeight(.heavy)
                    }

                    Text("fly higher than high")
                        .font(.system(size: 30).weight(.light).italic())
                        .padding(.bottom,150)



                    NavigationLink(destination: LoginView()) {
                        Text("Login")
                            .frame(width: 270)
                            .foregroundColor(.white)
                            .fontWeight(.bold)
                            .font(.system(size: 20))
                            .padding()
                            .background(.black)
                            .cornerRadius(10)
                    }
                    .padding(.top,10)

                    NavigationLink(destination: RegisterView()) {
                            Text("Register")
                                .frame(width: 270)
                                .foregroundColor(.black)
                                .fontWeight(.bold)
                                .font(.system(size: 20))
                                .padding()
                                .cornerRadius(10)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 10)
                                        .stroke(Color.black, lineWidth: 2)
                            )
                        }
                        .background(Color.white)
                        .cornerRadius(10)
                        .padding(.top,10)





                }
                .padding(.bottom,80)
            }
        }
    }
}

#Preview {
    WelcomeView()
}
