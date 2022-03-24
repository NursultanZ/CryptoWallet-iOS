import Foundation

struct HDKeychain{
    let privateKey: HDPrivateKey
    
    init (privateKey: HDPrivateKey){
        self.privateKey = privateKey
    }
    
    init(seed: Data, xPrv: UInt32, xPub: UInt32){
        self.privateKey = HDPrivateKey.init(seed: seed, xPrv: xPrv, xPub: xPub)
    }
    
    func deriveKey(path: String) -> HDPrivateKey{
        
        var key = privateKey
        
        for childIndex in path.split(separator: "/") {
            var hardened = false
            var indexString = childIndex
            
            if childIndex.contains("'"){
                hardened = true
                indexString = indexString.dropLast()
            }
            
            guard let index = UInt32(indexString) else {
                fatalError("Invalid path!")
            }
            
            key = key.derive(at: index, hardened: hardened)
            
        }
        
        return key
        
    }
}
