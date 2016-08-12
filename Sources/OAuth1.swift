//
//  OAuth1.swift
//
//  Created by Collin Hundley on 8/12/16.
//

import Foundation


struct OAuth1 {

    let consumerKey: String
    let token: String
    let tokenSecret: String
    
    init(consumerKey: String, token: String, tokenSecret: String) {
        self.consumerKey = consumerKey
        self.token = token
        self.tokenSecret = tokenSecret
    }
    
    func generateURL() -> String {
        
        
        return ""
    }
    
    

}
