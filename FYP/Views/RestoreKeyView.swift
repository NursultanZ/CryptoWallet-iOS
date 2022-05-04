import SwiftUI

struct RestoreKeyView: View {
    
    @EnvironmentObject private var appVM: AppViewModel
    
    @Environment(\.dismiss) var dismiss
    
    @State var words: String = ""
    @State var showSalt: Bool = false
    @State var salt: String = ""
    
    @State var animationAmount = 0
    
    @State var isError: Bool = false
    
    @State var errorType: Mnemonic.MnemonicError? = nil
    
    var body: some View {
        NavigationView {
            
            ZStack {
                Color.custom.secondaryBackground.ignoresSafeArea(.all)
                VStack {
                    TextEditorView(text: $words)
                        .frame(height: 150)
                        .overlay{
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(lineWidth: 0.2)
                                .foregroundColor(Color.custom.secondaryText)
                        }
                    
                    FieldCaption(text: "Enter your mnemonic phrase which consists of between 12 and 24 words. The words should be separated by spaces.")
                    
                    toggleSalt
                    
                    if (showSalt){
                        PassphraseField

                        FieldCaption(text: "Enter the passphrase also known as salt, you used when creating th  is mnemonic phrase.")
                    }

                    Spacer()
                    
                }
                .toolbar(content: {
                    ToolbarItem(placement: .navigationBarLeading) {
                        Image(systemName: "xmark")
                            .foregroundColor(Color.custom.yellow)
                            .onTapGesture {
                                dismiss()
                            }
                            
                    }
                    
                    ToolbarItem(placement: .confirmationAction) {
                        Text("Restore")
                            .foregroundColor(Color.custom.yellow)
                            .onTapGesture {
                                
                                checkMnemonic()
                                
                                if(!isError) {
                                
                                    if(showSalt && salt.trimmingCharacters(in: .whitespacesAndNewlines) != "") {
                                        appVM.updateKey(words: getWords(), salt: salt.trimmingCharacters(in: .whitespacesAndNewlines))
                                    }else {
                                        appVM.updateKey(words: getWords(), salt: nil)
                                    }
                                    dismiss()
                                }
                            }
                    }
                })
                .padding()
                .navigationTitle("Enter mnemonic")
            }
            .alert(errorType?.desc ?? "", isPresented: $isError) {
                Button("OK", role: .cancel){
                    isError = false
                }
                .foregroundColor(Color.custom.yellow)
                
                
            }
            .accentColor(Color.custom.yellow)
            
        }
    }
    
    func getNumberOfWords() -> Int {
        return getWords().count
    }
    
    func getWords() -> [String] {
        return words.components(separatedBy: " ")
    }
    
    func checkMnemonic() {
        if(getNumberOfWords() > 24 || getNumberOfWords() < 12){
            isError = true
            errorType = .invalidWordsCount
            
        }else {
            do {
                try Mnemonic.validatePhrase(words: getWords())
            } catch Mnemonic.MnemonicError.invalidChecksum {
                isError = true
                errorType = .invalidChecksum
            } catch Mnemonic.MnemonicError.invalidMnemonicWord {
                isError = true
                errorType = .invalidMnemonicWord
            } catch {
                
            }
        }
    }
}

extension RestoreKeyView {
    var PassphraseField: some View {
        TextField("Passphrase", text: $salt)
            .padding(EdgeInsets(top: 0, leading: 12, bottom: 0, trailing: 12))
            .frame(height: 50)
            .background(Color.custom.background)
            .cornerRadius(8)
            .overlay(RoundedRectangle(cornerRadius: 8).stroke(lineWidth: 0.2)
                .foregroundColor(Color.custom.secondaryText))
            .foregroundColor(Color.custom.mainText)
            .accentColor(Color.custom.yellow)
            .disableAutocorrection(true)
            .autocapitalization(.none)
    }
    
    var toggleSalt: some View {
        HStack{
            Image(systemName: "key")
                .foregroundColor(Color.custom.yellow)
            Toggle("Passphrase", isOn: $showSalt)
                .tint(Color.custom.yellow)
        }
        .padding()
        .frame(height: 50)
        .background(Color.custom.background)
        .cornerRadius(8)
        .padding([.top, .bottom], 15)
    }
}

struct FieldCaption: View {
    
    var text: String
    var body: some View {
        Text(text)
            .foregroundColor(Color.custom.secondaryText)
            .font(.caption)
            .padding(8)
    }
}

struct RestoreKeyView_Previews: PreviewProvider {
    static var previews: some View {
        RestoreKeyView()
            .preferredColorScheme(.light)
            .environmentObject(dev.appVM)
    }
}
