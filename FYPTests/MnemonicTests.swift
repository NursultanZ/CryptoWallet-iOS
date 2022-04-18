//
//  MnemonicTests.swift
//  FYPTests
//
//  Created by user on 30/1/2022.
//

import XCTest
@testable import FYP

class MnemonicTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testMnemonicSeed() throws {
        
        guard let url = Bundle.main.url(forResource: "vectors", withExtension: "json") else {
            XCTFail("Vectors file not found!")
            return
        }
        
        do {
            let data = try Data(contentsOf: url)
            let vectors: [String: Any] = try JSONSerialization.jsonObject(with: data, options: [.allowFragments, .mutableContainers, .mutableLeaves]) as! [String: Any]
            
            if let cases: Array<Array<String>> = vectors["english"] as? Array<Array<String>> {
                for test in cases {
                    let s = String(test[0]).hexToBytes()
                    let words = Mnemonic.generateWords(entropy: s)
                    try Mnemonic.validatePhrase(words: words)
                    let m = test[1]
                    XCTAssertTrue(words.joined(separator: " ") == m, "Mnemonic phrase")
                    
                    let selfSeed = try Mnemonic.seed(mnemonic: words, passphrase: "TREZOR").hexEncodedString()
                    let seed = test[2]
                    XCTAssertTrue(selfSeed == seed, "seed")
                    
                    
                }
            }
        } catch {
            XCTFail("Something went wrong：\(error)")
        }
        
    }


}
