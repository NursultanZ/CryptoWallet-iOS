import Foundation
import CryptoSwift
import Base58Swift
import secp256k1
import ripemd160

class Crypto {
    static func HMAC_SHA512(data: Data, key: Data = "Bitcoin seed".data(using: .ascii)!) -> Data{
        let result: [UInt8]
        do {
            result = try HMAC(key: key.bytes, variant: .sha512).authenticate(data.bytes)
        }catch{
            fatalError("HMAC.SHA512 Failed! Description: \(error.localizedDescription)")
        }
        return Data(result)
    }
    
    static func Double_SHA256(data: Data) -> Data{
        return data.sha256().sha256()
    }
    
    static func base58_encode(data: Data) -> String{
        return Base58.base58Encode(data.bytes)
    }
    
    static func base58_decode(string: String) -> Data {
        return Data(Base58.base58Decode(string)!)
    }
    
    static func ripemd160_sha256(data: Data) -> Data{
        return Data(Ripemd160.digest(data.sha256().bytes))
    }
    
    static func createPublicKey(from privateRaw: Data, compressed: Bool = false) -> Data{
        
        let privateKey = privateRaw.withUnsafeBytes{
            [UInt8](UnsafeBufferPointer(start: $0.baseAddress!.assumingMemoryBound(to: UInt8.self), count: privateRaw.count))
        }
        
        let ctx = secp256k1_context_create(UInt32(SECP256K1_CONTEXT_SIGN))!
        defer {
            secp256k1_context_destroy(ctx)
        }
        
        var pubKey: secp256k1_pubkey = secp256k1_pubkey()
        _ = secp256k1_ec_pubkey_create(ctx, &pubKey, UnsafePointer<UInt8>(privateKey))
        
        let size = compressed ? 33 : 65
        let output = UnsafeMutablePointer<UInt8>.allocate(capacity: size)
        let outputLength = UnsafeMutablePointer<Int>.allocate(capacity: 1)
        
        defer {
            output.deallocate()
            outputLength.deallocate()
        }
        
        outputLength.initialize(to: size)
        secp256k1_ec_pubkey_serialize(ctx, output, outputLength, &pubKey, UInt32(compressed ? SECP256K1_EC_COMPRESSED : SECP256K1_EC_UNCOMPRESSED))
        let publicKey = [UInt8](UnsafeBufferPointer(start: output, count: size))
        
        return Data(publicKey)
    }
    
}

