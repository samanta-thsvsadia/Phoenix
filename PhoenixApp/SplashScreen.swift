import SwiftUI

struct SplashScreenView: View {
    
    @State var isActive: Bool = false
    
    var body: some View {
        ZStack {
        if self.isActive {
            PView()
               
        } else {
            ZStack {
               
            gwall.ignoresSafeArea(.all)
               
                VStack(alignment:.center){
                    
                    VStack(spacing:-30) {
                        Image("plogo")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 300, height: 300)
                    .offset(x: 30)
                        
                        Text("PHOENIX")
                            .font(.system(size: 60))
                            .font(.headline.bold())
                            .fontWeight(.heavy)
                        
                        Text("fly higher than high")
                                .font(.system(size: 30).weight(.light).italic())
                                .padding(.top,20)

                    }
                        
                }
                .padding(.bottom,90)
            }
            }
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                withAnimation(.easeInOut(duration: 0.7)){
                    self.isActive = true
                }
            }
                  }
               }
            
            }
    
struct SplashScreenView_Previews: PreviewProvider {
    static var previews: some View {
        SplashScreenView()
    }
}
