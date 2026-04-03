//
//  CameraView.swift
//  PhoenixApp
// 
//
//  Created by Sadia on 04/11/23.
//

import SwiftUI

struct CameraView: View {
    @StateObject private var model = ContentViewModel()
    
    @EnvironmentObject var classificationViewModel: ClassificationViewModel
    @Binding var isCameraViewPresented: Bool
        @Binding var chatTextFieldText: String
    
    var truevar = true
    
    
    var body: some View {
        
        VStack {
            ZStack {
                FrameView(image: model.frame)
                    .ignoresSafeArea()
                ErrorView(error: model.error)
            }
           
                VStack {
                    
                    VStack {
                        ZStack {
                            if classificationViewModel.name != "" && classificationViewModel.name.count < 10 {
                                Text(classificationViewModel.name)
                                    .font(.system(size: 100, weight: .heavy))
                                    .foregroundColor(.black) //prediction
                                
                                
                            }
                            
                            if classificationViewModel.name.count > 10 && classificationViewModel.onLoop  {
                                Text(classificationViewModel.name)
                                    .font(.system(size: 30, weight: .bold))
                                    .foregroundStyle(.black.opacity(0.4)) //Position
                                    .multilineTextAlignment(.center)
                                
                            }
                            
                        }
                        
                        
                        
                        
                    }
                    .padding()
                    if classificationViewModel.onLoop {
                        VStack {
                            Text("\(classificationViewModel.text)")
                            
                        }
                    }
                    
                    HStack(spacing:70){
                        ZStack {
                            Button(classificationViewModel.onLoop == false ? "Translate" : "Pause") {if model.frame != nil {classificationViewModel.classifyImage(tmpImage: UIImage(cgImage: model.frame!))
                                classificationViewModel.onLoop.toggle()
                                classificationViewModel.callFunc()
                                classificationViewModel.text = ""
                            }
                                
                            }
                            .onAppear{
                                classificationViewModel.classificationLabel = ""
                                classificationViewModel.name = ""
                            }
                            .onDisappear{
                                classificationViewModel.onLoop = false
                            }.foregroundColor(.black)
                                .bold()
                            Circle()
                                .foregroundStyle(gtext)
                                .opacity(0.5)
                                .frame(width:90, height: 90)
                        }
                        
                        Button(action: {
                                        
                                            chatTextFieldText = classificationViewModel.text
                                            isCameraViewPresented = false
                                                       }) {
                                                           Text("Send")
                                                               .foregroundColor(.white)
                                                               .padding()
                                                               .background(Color.blue)
                                                               .cornerRadius(8)
                                                       }
                    }
                    
                    Image("ml")
                        .resizable()  // Make the image resizable
                        .scaledToFit()  // Maintain the aspect ratio while fitting the frame
                        .frame(height: 30)  // Set the desired size
                        .padding(.bottom, 5)
                        .opacity(0.6)
                    
                    
                    
                    
                }
            
        }.navigationBarTitleDisplayMode(.inline)
    }
}


