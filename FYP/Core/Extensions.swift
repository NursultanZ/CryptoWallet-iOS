import Foundation

extension String {

    func bitsToBytes() -> Data? {
        let length = 8
        
        guard count % length == 0 else {
            return nil
        }
        
        var bytes = Data(capacity: count)

        for x in 0 ..< count / length {
            let start = self.index(startIndex, offsetBy: x * length)
            let end = self.index(startIndex, offsetBy: x * length + length)
            let subString = self[start..<end]
            guard let byte = UInt8(subString, radix: 2) else {
                return nil
            }
            bytes.append(byte)
        }
        return bytes
    }
    
    public func hexToBytes() -> [UInt8] {
        var result: [UInt8] = []
        
        var i = 0
        var chars = ""
        for c in self {
            chars += String(c)
            if i % 2 == 1 {
                let byte: UInt8 = UInt8(strtoul(chars, nil, 16))
                result.append(byte)
                chars = ""
            }
            i += 1
        }
        
        return result
    }
    
    func normalize(length: Int) -> String {
        let zeros = String(repeating: "0", count: length)
        
        return String((zeros + self).suffix(length))
    }
}

extension Data {
    func hexEncodedString() -> String {
        return map { String(format: "%02hhx", $0) }.joined()
    }
    
    func binaryEncodedString(length l: Int) -> String {
        return map { String($0, radix: 2).normalize(length: l) }.joined()
    }
}

