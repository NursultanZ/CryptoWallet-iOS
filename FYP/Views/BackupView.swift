import SwiftUI

struct BackupView: View {
    
    @Environment(\.dismiss) var dismiss
    
    @State var words: [String] = []
    @State var salt: String?
    
    var body: some View {
        
        GeometryReader { metrics in
            NavigationView {
                ZStack {
                    Color.custom.secondaryBackground.ignoresSafeArea(.all)
                    VStack (alignment: .leading){
                        
                        VStack {
                            ForEach(0...words.count/2 - 1, id: \.self){ i in
                                HStack{
                                    Text("\(i+1).")
                                        .foregroundColor(Color.secondary)
                                        .frame(width: 30, alignment: .leading)
                                        .font(.title3)
                                    Text("\(words[i])")
                                        .foregroundColor(Color.custom.mainText)
                                        .font(.title2)
                                        .frame(width: metrics.size.width * 0.35, alignment: .leading)
                                    
                                    
                                    Text("\(i+7).")
                                        .foregroundColor(Color.secondary)
                                        .frame(width: 30, alignment: .leading)
                                        .font(.title3)
                                    Text("\(words[i + 6])")
                                        .foregroundColor(Color.custom.mainText)
                                        .font(.title2)
                                    Spacer()
                                }
                            }
                        }
                        .padding()
                        .background(Color.custom.background)
                        .cornerRadius(8)
                        
                        if (salt != nil) {
                            HStack{
                                Image(systemName: "key")
                                    .foregroundColor(Color.yellow)
                                    .frame(width: 25)
                                Text("Passphrase")
                                    .foregroundColor(Color.secondary)
                                Spacer()
                                
                                Text(salt!)
                                    .padding([.trailing, .leading])
                                    .padding([.top, .bottom], 7)
                                    .foregroundColor(Color.black)
                                    .background(Color.custom.yellow)
                                    .cornerRadius(20)
                                
                            }
                            .padding()
                            .frame(height: 50)
                            .background(Color.custom.background)
                            .cornerRadius(8)
                            .padding([.top, .bottom], 15)
                        }
                            
                        Spacer()
                    }
                    .padding()
                }
                .navigationTitle("Backup")
                .toolbar {
                    ToolbarItem(placement: .destructiveAction) {
                        Image(systemName: "xmark")
                            .foregroundColor(Color.custom.yellow)
                            .onTapGesture {
                                dismiss()
                            }
                            
                    }
                }
            }
        }
    }
}

struct BackupView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            BackupView(words: ["nurs", "possible", "nurs", "nursfd", "nurs", "nurs", "nurs", "nurs", "nurs", "nurs", "nurs", "nurs"], salt: "saltsads")
                .preferredColorScheme(.light)
        }
    }
}
