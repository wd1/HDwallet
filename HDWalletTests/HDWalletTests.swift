import XCTest
import HDWallet

class HDWalletTests: XCTestCase {

    override func setUp() {
        super.setUp()
        //// This is how we can generate new keys from secure random entropy:
        //        var entropy = Data(count: 32)
        //        // This creates the private key inside a block, result is of internal type ResultType.
        //        // We just need to check if it's 0 to ensure that there were no errors.
        //        let result = entropy.withUnsafeMutableBytes { mutableBytes in
        //            SecRandomCopyBytes(kSecRandomDefault, entropy.count, mutableBytes)
        //        }
        //        guard result == 0 else { fatalError("Failed to randomly generate and copy bytes for entropy generation. SecRandomCopyBytes error code: (\(result)).") }
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExample() {

        let words = "couple muscle snack heavy gloom orchard tooth alert crane spider ask horn".components(separatedBy: " ")
        let mnemonic = BTCMnemonic(words: words, password: nil, wordListType: .english)!

        // path 0H/1/0, used for ID
        let keychain = mnemonic.keychain.derivedKeychain(at: 0, hardened: true).derivedKeychain(at: 1).derivedKeychain(at: 0)
        print(keychain.key.privateKey, "9fb68eb9bba46f357c69323506c584d12a1e4865f0f8f763942650a288ba2a00".hexadecimalData!)

        // path 0H/)/0, used for FUNDS
        let walletKeychain = mnemonic.keychain.derivedKeychain(at: 0, hardened: true).derivedKeychain(at: 0).derivedKeychain(at: 0)
        print(walletKeychain.key.privateKey, "96fa3f53c7f1573f920a7422a0d48c23dfc644002f322b3612d32be494e8ff8e".hexadecimalData!)
    }
}

public extension String {
    public var hexadecimalData: Data? {
        let utf16 = self.replacingOccurrences(of: "0x", with: "").utf16
        guard let data = NSMutableData(capacity: utf16.count/2) else { return nil }

        var byteChars: [CChar] = [0, 0, 0]
        var wholeByte: CUnsignedLong = 0
        var i = utf16.startIndex

        while i < utf16.endIndex.advanced(by: -1) {
            byteChars[0] = CChar(truncatingBitPattern: utf16[i])
            byteChars[1] = CChar(truncatingBitPattern: utf16[i.advanced(by: 1)])
            wholeByte = strtoul(byteChars, nil, 16)
            data.append(&wholeByte, length: 1)
            i = i.advanced(by: 2)
        }

        return data as Data
    }
}
