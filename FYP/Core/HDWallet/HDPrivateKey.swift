import Foundation

struct HDPrivateKey {
    let depth: UInt8
    let fingerprint: UInt32
    let xPrv: UInt32
    let xPub: UInt32
    let index: UInt32
    
    let raw: Data
    let chainCode: Data
    
    init(privateKey: Data, chainCode: Data, xPrv: UInt32, xPub: UInt32, depth: UInt8, fingerprint: UInt32, childIndex: UInt32){
        self.raw = privateKey
        self.chainCode = chainCode
        self.xPrv = xPrv
        self.xPub = xPub
        self.depth = depth
        self.fingerprint = fingerprint
        self.index = childIndex
    }
    
    init(seed: Data, xPrv: UInt32, xPub: UInt32){
        let hmac = Crypto.HMAC_SHA512(data: seed)
        let r = hmac[0..<32]
        let c = hmac[32..<64]
        self.init(privateKey: r, chainCode: c, xPrv: xPrv, xPub: xPub, depth: 0, fingerprint: 0, childIndex: 0)
    }
    
    func serialized() -> String {
        var serializedKey = Data()
        serializedKey += xPrv.bigEndian.data
        serializedKey += depth.littleEndian.data
        serializedKey += fingerprint.littleEndian.data
        serializedKey += index.littleEndian.data
        serializedKey += chainCode
        serializedKey += UInt8(0).data
        serializedKey += raw
        let checkSum = Crypto.Double_SHA256(data: serializedKey).prefix(4)
        return Crypto.base58_encode(data: serializedKey + checkSum)
    }
    
    func getPublicKey(compressed: Bool = true) -> HDPublicKey {
        return HDPublicKey(privateKey: raw, chainCode: chainCode, xPub: xPub, depth: depth, fingerprint: fingerprint, childIndex: index, compressed: compressed)
    }
    
    func derive(at index: UInt32, hardened: Bool = false) -> HDPrivateKey {
        if((index & 0x80000000) != 0){
            fatalError("Invalid Child Index!")
        }
        
        var data = Data()
        
        if(hardened){
            data += UInt8(0).data
            data += raw
        }else {
            data += getPublicKey().raw
        }
        
        let derivedIndex = CFSwapInt32BigToHost(hardened ? 0x80000000 | index : index)
        data += derivedIndex.data
        
        let digest = Crypto.HMAC_SHA512(data: data, key: chainCode)
        let newRaw = BInt(data: digest[0..<32])
        
        let curveOrder = BInt(hex: "FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEBAAEDCE6AF48A03BBFD25E8CD0364141")!
        let derivedPrivateKey = ((BInt(data: raw) + newRaw) % curveOrder).data
        let derivedChainCode = digest[32..<64]
        
        let derivedFingerprint = Crypto.ripemd160_sha256(data: self.getPublicKey().raw)[0..<4]

        return HDPrivateKey(privateKey: derivedPrivateKey, chainCode: derivedChainCode, xPrv: self.xPrv, xPub: self.xPub, depth: self.depth + 1, fingerprint: derivedFingerprint.uint32(), childIndex: derivedIndex)
    }
}
