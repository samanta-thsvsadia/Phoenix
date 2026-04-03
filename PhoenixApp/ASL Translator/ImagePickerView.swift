//
//  ImagePickerView.swift
//  PhoenixApp
//
//  Created by Sadia Thasina Samanta on 04/11/23.
//


import SwiftUI
import Vision
import AVFoundation
import UIKit
import CoreImage


struct ImagePickerView: View {

    @EnvironmentObject var classificationViewModel: ClassificationViewModel
    @Binding var isImageViewPresented: Bool
    @Binding var imgToText: String
    
    var localClassificationLabel = ""
    

    let mlmodel = ASLHandPoseClassifier()

    
    @State private var image: UIImage? = UIImage(named: "sample")
    @State private var shouldPresentImagePicker = false
    @State private var shouldPresentActionScheet = false
    @State private var shouldPresentCamera = false
     var handPoseRequest = VNDetectHumanHandPoseRequest()
    
    var body: some View {
        VStack {
            Spacer(minLength: 5)
            Text("Select Image")
                .font(.system(size: 40, weight:.heavy)).opacity(0.5)
            VStack(spacing:5){
            Image(uiImage: image!)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 300, height: 300)
                .clipShape(Rectangle())
                .overlay(Rectangle().stroke(gtext, lineWidth: 10))
                .padding()
                HStack(spacing:150){
                ZStack {
                    Button("Translate") { classificationViewModel.classifyImage(tmpImage: image!)
                        print(classificationViewModel.classificationLabel)
                    }
                    .onAppear{
                        classificationViewModel.classificationLabel = ""
                        classificationViewModel.name = ""
                    }
                    .foregroundColor(.black)
                    .bold()
                    Circle()
                        .foregroundStyle(gtext)
                        .opacity(0.5)
                        .frame(width:90, height: 90)
                }
                
                Button(action: {
                    self.shouldPresentActionScheet = true
                }) {
                    
                    Image(systemName: "photo.badge.plus")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 80, height: 80)
                        .padding(.trailing, 8)
                        .foregroundStyle(.black)
                    
                }
                .sheet(isPresented: $shouldPresentImagePicker) {
                    SUImagePickerView(sourceType: self.shouldPresentCamera ? .camera : .photoLibrary, image: self.$image, isPresented: self.$shouldPresentImagePicker)
                }
                .actionSheet(isPresented: $shouldPresentActionScheet) { () -> ActionSheet in
                    ActionSheet(
                        title: Text("Select"),
                        message: Text("Please select your preferred method for choosing an image."),
                        buttons: [
                            .default(Text("Camera"), action: {
                                self.shouldPresentImagePicker = true
                                self.shouldPresentCamera = true
                            }),
                            .default(Text("Photo Library"), action: {
                                self.shouldPresentImagePicker = true
                                self.shouldPresentCamera = false
                            }),
                            .cancel()
                        ]
                    )
                }
            }
        }

            Spacer(minLength: 5)
           
            VStack {
                ZStack {
                    if classificationViewModel.name != "" && classificationViewModel.name.count < 10 {
                        Text(classificationViewModel.name)
                            .font(.system(size: 100, weight: .heavy))
                            .foregroundColor(.black) //prediction
                        
                    }
                    
                    if classificationViewModel.name.count > 10  {
                        Text(classificationViewModel.name)
                            .font(.system(size: 30, weight: .bold))
                            .foregroundStyle(.black.opacity(0.4)) //Position
                            .multilineTextAlignment(.center)
                        
                    }
                    
                }
                
            }
            .padding()
        
            
            Button("Send") {
                imgToText = classificationViewModel.name
                isImageViewPresented = false
            }
            .foregroundColor(.white)
            .padding()
            .background(Color.blue)
            .cornerRadius(8)
            
            Image("ml")
                .resizable()
                .scaledToFit()
                .frame(height: 30)
                .padding(.bottom, 15)
                .opacity(0.6)
        }
    }
}

