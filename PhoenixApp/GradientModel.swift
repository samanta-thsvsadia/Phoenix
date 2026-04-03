//
//  GradientModel.swift
//  PhoenixApp
//
//  Created by Sadia Thasina on 05/12/2023.
//


import SwiftUI

let angle: Double = -15  // desired angle

// Convert angle to radians
let radians = angle * .pi / 180.0

// Calculate startPoint and endPoint based on the angle
let startPoint = UnitPoint(x: CGFloat(cos(radians)), y: CGFloat(sin(radians)))
let endPoint = UnitPoint(x: -startPoint.x, y: -startPoint.y)

var gwall = LinearGradient(
gradient: Gradient(stops: [
    .init(color: Color("teal"), location: 0.25),
    .init(color: Color("purple"), location: 0.5),
    .init(color: Color("lightpink"), location: 0.75),
    
        .init(color: Color("pink"), location: 1)
]),
startPoint: startPoint,
endPoint: endPoint
)

var gtext =  LinearGradient(
              gradient: Gradient(colors: [Color("pink"), Color("lightpink"), Color("purple"), Color("teal")]),startPoint: .bottomLeading,endPoint: .topTrailing)

       
var phoenix = Text("PHOENIX")
    .font(.largeTitle.bold())
    .foregroundStyle(gtext)

struct GView: View {
    
    var body: some View {
        VStack(){
            Text("i like \(phoenix)")
        }
    }}

//struct GView_Previews: PreviewProvider {
//    static var previews: some View {
//        GView()
//    }
//}
