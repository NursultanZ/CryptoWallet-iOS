import Foundation

struct HDPublicKey {
    let xPub: UInt32
    let depth: UInt8
    let fingerprint: UInt32
    let index: UInt32
    
    let raw: Data
    let chainCode: Data
    
    init(privateKey: HDPrivateKey, xPub: UInt32, compressed: Bool = true){
        self.init(privateKey: privateKey.raw, chainCode: privateKey.chainCode, xPub: xPub, depth: 0, fingerprint: 0, childIndex: 0, compressed: compressed)
    }
    
    init(privateKey: Data, chainCode: Data, xPub: UInt32, depth: UInt8, fingerprint: UInt32, childIndex: UInt32, compressed: Bool){
        self.xPub = xPub
        self.chainCode = chainCode
        self.depth = depth
        self.fingerprint = fingerprint
        self.index = childIndex
        self.raw = Crypto.createPublicKey(from: privateKey, compressed: compressed)
    }
    
    func serialized() -> String{
        var data = Data()
        data += self.xPub.bigEndian.data
        data += self.depth.littleEndian.data
        data += self.fingerprint.littleEndian.data
        data += self.index.littleEndian.data
        data += self.chainCode
        data += self.raw
        let checksum = Crypto.Double_SHA256(data: data).prefix(4)
        return Crypto.base58_encode(data: data + checksum)
    }
    
//    func derive(at index: UInt32) -> HDPublicKey {
//        if((index & 0x80000000) != 0){
//            fatalError("Invalid Child Index!")
//        }
//
//        var data = Data()
//        data += self.raw
//        data += index.data
//
//        var digest = Crypto.HMAC_SHA512(data: data, key: self.chainCode)
//
//        var newRaw = digest[0..<32]
//
//        SwiftECC.
//    }
    
}
