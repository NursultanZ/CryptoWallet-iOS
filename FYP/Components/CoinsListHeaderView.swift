import SwiftUI

struct CoinsListHeaderView: View {
    var body: some View {
        HStack{
            Spacer()
            ToggleButton()
        }
        
    }
}

struct CoinsListHeaderView_Previews: PreviewProvider {
    static var previews: some View {
        CoinsListHeaderView()
    }
}

struct ToggleButton: View {
    var body: some View {
        RoundedRectangle(cornerRadius: 20)
            .overlay {
                Text("Price")
            }
    }
}
