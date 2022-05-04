import SwiftUI
import QRCode

struct ReceiveView: View {
    
    @Environment(\.dismiss) var dismiss
    
    var symbol: String
    var address: String
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.custom.secondaryBackground.ignoresSafeArea(.all)
                VStack {
                    Spacer()
                    Image(uiImage: getQR())
                        .resizable()
                        .frame(width: 230, height: 230)
                    Text("Your address")
                        .foregroundColor(Color.secondary)
                        .font(.caption)
                    Text(address)
                        .foregroundColor(Color.custom.mainText)
                        .font(.caption)
                    
                    Spacer()
                    
                    Button {
                        UIPasteboard.general.string = address
                        dismiss()
                    } label: {
                        Text("Copy")
                            .padding()
                            .frame(maxWidth: .infinity)
                            .contentShape(Rectangle())
                            .background(Color.custom.yellow)
                            .cornerRadius(30)
                            .padding([.leading, .trailing], 25)
                            .foregroundColor(Color.black)
                    }
                    Spacer()

                }
                .navigationTitle("Receive \(symbol)")
                .toolbar {
                    ToolbarItem(placement: .destructiveAction) {
                        Image(systemName: "xmark")
                            .foregroundColor(Color.custom.yellow)
                            .onTapGesture {
                                dismiss()
                            }
                    }
                    ToolbarItem(placement: .navigationBarLeading) {
                        Image(symbol.lowercased())
                            .resizable()
                            .frame(width: 30, height: 30)
                    }
            }
            }
        }
    }
    
    func getQR() -> UIImage{
        let qr = QRCode(address)!
        return qr.image!
    }
}

struct ReceiveView_Previews: PreviewProvider {
    static var previews: some View {
        ReceiveView(symbol: "ETH", address: "0x8583c4934eA1931771D0cc75f04E280ddB6705c4")
            .preferredColorScheme(.dark)
    }
}
