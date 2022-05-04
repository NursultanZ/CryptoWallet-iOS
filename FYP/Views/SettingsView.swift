import SwiftUI

struct SettingsView: View {
    
    @EnvironmentObject var appVM: AppViewModel
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.custom.secondaryBackground.ignoresSafeArea(.all)
                VStack {
                    List {
                        Section {
                            NavigationLink(destination: ManageWalletView().environmentObject(appVM)) {
                                SettingsListItem(imageName: "wallet.pass", text: "Manage Wallet")
                            }
                        }
                        .listRowBackground(Color.custom.background)
                    }
                    .padding(.top, 1)
                    .listStyle(.insetGrouped)
                }
                .navigationTitle("Settings")
            }
        }
        .accentColor(Color.custom.yellow)
    }
}

struct SettingsListItem: View{
    
    var imageName: String
    var text: String
    
    var body: some View {
        HStack {
            Image(systemName: imageName)
                .foregroundColor(Color.custom.secondaryText)
                .frame(width: 20)
            Text(text)
                .foregroundColor(Color.custom.mainText)
            Spacer()
        }
        .background(Color.custom.background)
        .listRowBackground(Color.custom.background)
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
            .environmentObject(dev.appVM)
            .preferredColorScheme(.dark)
    }
}
