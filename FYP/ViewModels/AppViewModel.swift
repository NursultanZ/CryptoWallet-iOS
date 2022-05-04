import Foundation
import KeychainAccess
import BigInt

class AppViewModel: ObservableObject {
    
    let keychain = SecureStorage(service: "com.nzakirov2.bank.FYP")
    
    @Published var isKeySaved: Bool = false
    @Published var isSaltSaved: Bool = false
    
    @Published var ethManager: EthereumManager?
    @Published var rootKey: HDPrivateKey?
    
    @Published var balance: String?
    
    @Published var isLoading = false
    
    @Published var gasPrice: Double?
    
    init(){
        let wordsSaved = keychain.checkData(key: "mnemonic")
        
        if (wordsSaved) {
            isKeySaved = true
            
            let salt = keychain.getString(key: "salt")
            
            if (salt != nil) {
                isSaltSaved = true
            }
            
            rootKey = generateMasterKey()
            
            if let pk = rootKey{
                ethManager = EthereumManager(pk: getEthPrivateKey(pk: pk))
            }
            
            updateBalance()
        }
        
    }
    
    func updateGasPrice() {
        gasPrice = ethManager?.getGasPrice()
    }
    
    func generateMasterKey() -> HDPrivateKey?{
        do {
            let words = keychain.getMnemonic()
            var seed: Data
            if(isSaltSaved) {
                let salt = keychain.getString(key: "salt")
                seed = try Mnemonic.seed(mnemonic: words!, passphrase: salt!)
            }else {
                seed = try Mnemonic.seed(mnemonic: words!)
            }
            return HDPrivateKey(seed: seed, xPrv: 0x0488ade4, xPub: 0x0488b21e)
        }catch{
            print("Error occured while generating master key from seed and salt!. \(error)")
        }
        return nil
    }
    
    func updateKey(words: [String], salt: String?) {
        
        isLoading = true
        clear()
        
        if(salt != nil) {
            keychain.saveString(key: "salt", value: salt!)
            isSaltSaved = true
        }
        
        keychain.saveMnemonic(words: words)
        isKeySaved = true
        
        rootKey = generateMasterKey()
        DispatchQueue.global().async {
            self.updateEthManager()
            self.updateBalance()
            self.isLoading = false
        }
    }
    
    func updateBalance(){
        balance = ethManager?.getBalance()
    }
    
    func updateEthManager(){
        if let pk = rootKey{
            ethManager?.updateManager(pk: getEthPrivateKey(pk: pk))
        }
    }
    
    func generateMnemonic(num: Int) -> [String] {
        var words: [String]
        do {
            words = try Mnemonic.generateWords(wordsCount: num == 12 ? .twelve : .twentyFour)
        } catch {
            fatalError("Some error occured during generation of mnemonic. \(error). Please try again")
        }
        
        return words
    }
    
    func clear() {
        do {
            try keychain.clear()
            isSaltSaved = false
            isKeySaved = false
            rootKey = nil
        }catch {
            print("Error occured while deleting your wallet phrase: \(error.localizedDescription)")
        }
    }
    
    func getEthPrivateKey(pk: HDPrivateKey) -> HDPrivateKey{
        let keychain = HDKeychain(privateKey: pk)
        return keychain.deriveKey(path: "44'/60'/0'/0/0")
    }
}
