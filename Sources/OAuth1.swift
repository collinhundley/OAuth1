//
//  OAuth1.swift
//
//  Created by Collin Hundley on 8/12/16.
//

import Foundation
import Cryptor


struct OAuth1 {

    enum Method: String {
        case get = "GET"
        case post = "POST"
    }
    
    let consumerKey: String
    let consumerSecret: String
    let token: String
    let tokenSecret: String
    private let nonceChars = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
    
    init(consumerKey: String, consumerSecret: String, token: String, tokenSecret: String) {
        self.consumerKey = consumerKey
        self.consumerSecret = consumerSecret
        self.token = token
        self.tokenSecret = tokenSecret
    }
    
    func generateHeaders(url: String, method: Method) -> [String : String] {
        // 1
        let nonce = generateNonce()
        let timestamp = "\(Date().timeIntervalSince1970)"
        
        // 2
        var paramArray: [String] = [
            "oauth_consumer_key",
            consumerKey,
            "oauth_nonce",
            nonce,
            "oauth_signature_method",
            "HMAC-SHA1",
            "oauth_timestamp",
            timestamp
        ]
        for index in 0..<paramArray.count {
            paramArray[index] = percentEncode(paramArray[index])
        }
        var paramString = "\(paramArray[0])=\(paramArray[1])&\(paramArray[2])=\(paramArray[3])&\(paramArray[4])=\(paramArray[5])&\(paramArray[6])=\(paramArray[7])"
        paramString = percentEncode(paramString)
        
        // 3
        let signatureBase = "\(method.rawValue)&\(url)&\(paramString)"
        
        // 4
        let key = CryptoUtils.byteArray(fromHex: consumerSecret)
        let data = CryptoUtils.byteArray(fromHex: signatureBase)
        let hmac = HMAC(using: HMAC.Algorithm.sha1, key: key).update(byteArray: data)?.final()
        let signature = String(bytes: hmac!, encoding: String.Encoding.utf8)!

        
        let headers: [String : String] = [
            "oauth_consumer_key" : consumerKey,
            "oauth_token" : token,
            "oauth_signature_method" : "HMAC-SHA1",
            "oauth_signature" : signature,
            "oauth_timestamp" : timestamp,
            "oauth_nonce" : nonce
        ]
        
        return headers
    }
    
    
    /// Generates a random 32-character alphanumeric nonce.
    ///
    /// - returns: the nonce.
    private func generateNonce() -> String {
        var nonce = ""
        for _ in 0..<32 {
            let rand = Int(arc4random_uniform(62))
            nonce += String(nonceChars[nonceChars.index(nonceChars.startIndex, offsetBy: rand)])
        }
        return nonce
    }
    
    private func percentEncode(_ str: String) -> String {
        #if os(Linux)
            return str.bridge().stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.urlQueryAllowed) ?? str
        #else
            return str.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed) ?? str
        #endif
    }
    

}
