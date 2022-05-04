import SwiftUI

struct ContentView: View {

    init() {
        UITabBar.appearance().backgroundColor = UIColor(Color.custom.secondaryBackground)
    }
    
    var body: some View {
        ZStack{
            Color.custom.secondaryBackground.edgesIgnoringSafeArea(.all)
            if Reachability.isConnectedToNetwork() {
                AppView()
            }else {
                VStack {
                    Image(systemName: "wifi.exclamationmark")
                        .resizable()
                        .frame(width: 200, height: 200)
                    .foregroundColor(Color.secondary)
                    Text("No Internet Connection")
                        .foregroundColor(Color.secondary)
                }
            }
        }
    }
}



struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .preferredColorScheme(.light)
    }
}
