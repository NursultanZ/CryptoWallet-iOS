import Foundation
import CryptoSwift

struct Mnemonic {
    enum WordsCount: Int {
        case twelve = 12
        case eighteen = 18
        case twentyFour = 24
        
        var bits: Int {
            self.rawValue / 3 * 32
        }
        
        var checkSumBits: Int {
            self.rawValue / 3
        }
        
    }
    
    enum MnemonicError: Error {
        case secureRandomBytesError
        case invalidWordsCount
        case invalidMnemonicWord
        case invalidChecksum
        
        var desc: String {
            switch self {
            case .invalidWordsCount: return "Mnemonic phrase should contain from 12 to 24 words."
            case .invalidMnemonicWord: return "Mnemonic phrase you entered contains one or more invalid words."
            case .invalidChecksum: return "The combination of words you entered can not produce valid wallet seed."
            case .secureRandomBytesError: return ""
            }
        }
    }
    
    enum SeedError: Error {
        case dataConversionError
        case PBKDF2Error
    }
    
    static func generateWords(wordsCount: WordsCount = .twelve) throws -> [String]{
        let bytesCount = wordsCount.bits / 8
        var bytes = [UInt8](repeating: 0, count: bytesCount)
        
        let status = SecRandomCopyBytes(kSecRandomDefault, bytesCount, &bytes)
        
        guard status == errSecSuccess else {
            throw MnemonicError.secureRandomBytesError
        }
        
        return generateWords(entropy: bytes)
        
    }
    
    static func generateWords(entropy: [UInt8]) -> [String] {
        
        
        let entropyBits = Data(entropy).binaryEncodedString(length: 8)
        
        let hashBits = Data(entropy.sha256()).binaryEncodedString(length: 8)
        
        let bin = entropyBits + hashBits.prefix(entropy.count / 4)
        
        var mnemonic: [String] = []
        
        for i in 0..<(bin.count / 11) {
            let start = bin.index(bin.startIndex, offsetBy: i * 11)
            let end = bin.index(bin.startIndex, offsetBy: i * 11 + 11)
            
            let index = Int(bin[start..<end], radix: 2)!
            mnemonic.append(MnemonicWordsList.words[index])
        }
        
        return mnemonic
    }
    
    
    
    static func seed(mnemonic words: [String], passphrase: String = "") throws -> Data {
        guard let phrase = words.joined(separator: " ").decomposedStringWithCompatibilityMapping.data(using: .utf8) else {
            throw SeedError.dataConversionError
        }
        guard let salt = ("mnemonic" + passphrase).decomposedStringWithCompatibilityMapping.data(using: .utf8) else {
            throw SeedError.dataConversionError
        }
        do {
            let seed = try PKCS5.PBKDF2(password: phrase.bytes, salt: salt.bytes, iterations: 2048, keyLength: 64, variant: .sha512).calculate()
            return Data(seed)
        }catch {
            throw SeedError.PBKDF2Error
        }
    }
    
    
    static func validatePhrase(words: [String]) throws {
        guard let wordCount = WordsCount(rawValue: words.count) else {
            throw MnemonicError.invalidWordsCount
        }
        
        var bits = ""
        
        for word in words {
            guard let index = MnemonicWordsList.words.firstIndex(of: word) else {
                throw MnemonicError.invalidMnemonicWord
            }
            
            let binaryString = String(index, radix: 2).normalize(length: 11)
            
            bits.append(contentsOf: binaryString)
        }
        
        let checksumLength = words.count / 3
        
        guard checksumLength == wordCount.checkSumBits else {
            throw MnemonicError.invalidChecksum
        }
        
        let dataBitsLength = bits.count - checksumLength
        
        let dataBits = String(bits.prefix(dataBitsLength))
        let checksumBits = String(bits.suffix(checksumLength))
        
        guard let dataBytes = dataBits.bitsToBytes() else {
            throw MnemonicError.invalidChecksum
        }
        
        let hash = dataBytes.sha256()

        let hashBits = hash.binaryEncodedString(length: 8).prefix(checksumLength)
        
        guard hashBits == checksumBits else {
            throw MnemonicError.invalidChecksum
        }
    }
    
}
