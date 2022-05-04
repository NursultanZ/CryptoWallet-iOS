import Foundation
import web3swift
import BigInt
import SwiftUI
import CryptoKit

class EthereumManager{
    
    private var privateKey: HDPrivateKey
    private var wallet: Wallet
    
    private var w3: web3
        
    init(pk: HDPrivateKey) {
        
        w3 = Web3.InfuraRopstenWeb3()
        
        self.privateKey = pk
        let password = "eth.nzakirov2"
        let keystore = try! EthereumKeystoreV3(privateKey: pk.raw, password: password)!
        let name = "Eth Wallet"
        let address = keystore.addresses!.first!.address
        wallet = Wallet(address: address, name: name)
        
        let keystoreManager = KeystoreManager([keystore])
        
        w3.addKeystoreManager(keystoreManager)
    }
    
    func updateManager(pk: HDPrivateKey) {
        
        self.privateKey = pk
        
        let password = "eth.nzakirov2"
        let keystore = try! EthereumKeystoreV3(privateKey: pk.raw, password: password)!
        let name = "Eth Wallet"
        let address = keystore.addresses!.first!.address
        self.wallet = Wallet(address: address, name: name)
        
        let keystoreManager = KeystoreManager([keystore])
        
        self.w3.addKeystoreManager(keystoreManager)
    }
    
    func getAddress() -> String {
        return wallet.address
    }
    
    func getBalance() -> String {
        let walletAddress = EthereumAddress(wallet.address)!
        let balanceResult = try! w3.eth.getBalance(address: walletAddress)
        let balanceString = Web3.Utils.formatToEthereumUnits(balanceResult, toUnits: .eth, decimals: 3)!
        return balanceString
    }
    
    func getTransactionOptions(recipientAddress: EthereumAddress) -> TransactionOptions {
        var transaction = TransactionOptions.defaultOptions
        transaction.from = recipientAddress
        transaction.gasLimit = .automatic
        transaction.gasPrice = .automatic
        
        return transaction
    }
    
    func getGasPrice() -> Double {
        do {
            let weis = try w3.eth.getGasPrice()
            let fee = weis * BigUInt(40000)
            let eths = Web3.Utils.formatToEthereumUnits(fee, toUnits: .eth, decimals: 10)!
            return Double(eths)!
        }catch{
            fatalError("Not able to get Gas Price! \(error)")
        }
    }
    
    
    func checkAddress(address: String) -> Bool {
        let addr = EthereumAddress(address, ignoreChecksum: false)
        if (addr == nil){
            return false
        }else {
            return addr!.isValid
        }
    }
    
    func sendTransaction(amount: Double, address: String){
        
        do {
            let walletAddress = EthereumAddress(wallet.address)!
            let recipientAddress = EthereumAddress(address)!
            
            let amountConverted = Web3.Utils.parseToBigUInt(String(amount), units: .eth)
            
            let contract = w3.contract(Web3.Utils.coldWalletABI, at: recipientAddress, abiVersion: 2)!
            
            
            var options = TransactionOptions.defaultOptions
            options.value = amountConverted
            options.from = walletAddress
            options.gasLimit = .limited(BigUInt(40000))
            
            options.gasPrice = .manual(try w3.eth.getGasPrice())
            
            let tx = contract.write(
                "fallback",
                parameters: [AnyObject](),
                extraData: Data(),
                transactionOptions: options)!
            
            let result = try! tx.send(password: "eth.nzakirov2")
            print(result)
        }catch {
            print("Error occured while processing your transaction: \(error)")
        }
    }
}
