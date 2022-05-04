import Foundation
import KeychainAccess

class SecureStorage {
    
    private let keychain: Keychain
    
    init(service: String){
        keychain = Keychain(service: service).accessibility(.whenPasscodeSetThisDeviceOnly)
    }
    
    func saveString(key: String, value: String) {
        keychain[key] = value
    }
    
    func clear() throws {
        try keychain.removeAll()
    }
    
    func getString(key: String) -> String? {
        let value = keychain[key]
        
        if let safeValue = value {
            return safeValue
        }else {
            return nil
        }
    }
    
    func checkData(key: String) -> Bool {
        let data = try? keychain.getData(key)
        guard data != nil else {
            return false
        }
        return true
    }
    
    func getMnemonic() -> [String]? {
        let data = getData(key: "mnemonic")
        guard let safeData = data else {
            return nil
        }
        
        return dataToStringArray(data: safeData)
    }
    
    func saveMnemonic(words: [String]){
        let data = stringArrayToData(stringArray: words)
        keychain[data: "mnemonic"] = data
    }
    
    func getData(key: String) -> Data? {
        let data = try? keychain.getData(key)
        guard let safeData = data else {
            return nil
        }
        return safeData
    }
    
    func saveData(key: String, data: Data){
        keychain[data: key] = data
    }
    
    
    func stringArrayToData(stringArray: [String]) -> Data? {
      return try? JSONSerialization.data(withJSONObject: stringArray, options: [])
    }
    
    func dataToStringArray(data: Data) -> [String]? {
      return (try? JSONSerialization.jsonObject(with: data, options: [])) as? [String]
    }
    
}
