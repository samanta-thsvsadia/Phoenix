import SwiftUI

struct Home2View: View {
    @State private var isChat2ViewPresented = false

    var body: some View {
        VStack {
            Text("Welcome to Home2View")
                .font(.title)
                .padding()

            Button("Open Chat2") {
                isChat2ViewPresented.toggle()
            }
            .padding()
            .sheet(isPresented: $isChat2ViewPresented) {
                NavigationView {
                    Chat2View(isChat2ViewPresented: $isChat2ViewPresented)
                }
            }
        }
    }
}

struct Chat2View: View {
    @Binding var isChat2ViewPresented: Bool
    @State private var isMessage2ViewPresented = false

    var body: some View {
        VStack {
            Text("Chat2View")
                .font(.title)
                .padding()

            NavigationLink(destination: Message2View(isChat2ViewPresented: $isChat2ViewPresented,isMessage2ViewPresented: $isMessage2ViewPresented),
                           isActive: $isMessage2ViewPresented) {
                EmptyView()
            }
            .hidden()

            FatPinkButton(action: {
                isMessage2ViewPresented = true
            }) {
                Text("Go to Message2View")
            }
            .padding()
        }
    }
}

struct Message2View: View {
    @Binding var isChat2ViewPresented: Bool
    @Binding var isMessage2ViewPresented: Bool

    var body: some View {
        VStack {
            Text("Message2View")
                .font(.title)
                .padding()

            Button(action: {
                isMessage2ViewPresented = false
                isChat2ViewPresented = false
            }) {
                Text("Return to Home2View")
                    .padding()
                    .foregroundColor(.white)
                    .background(Color.green)
                    .cornerRadius(10)
            }
            .padding()
        }
    }
}

struct FatPinkButton<Label>: View where Label: View {
    let action: () -> Void
    let label: Label

    init(action: @escaping () -> Void, @ViewBuilder label: () -> Label) {
        self.action = action
        self.label = label()
    }

    var body: some View {
        Button(action: action) {
            label
                .font(.headline)
                .padding()
                .foregroundColor(.white)
                .background(Color.pink)
                .cornerRadius(10)
        }
    }
}

struct Home2_Previews: PreviewProvider {
    static var previews: some View {
        Home2View()
    }
}
