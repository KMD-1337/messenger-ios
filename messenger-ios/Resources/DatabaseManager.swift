//
//  DatabaseManager.swift
//  messenger-ios
//
//  Created by Kirill on 03.01.2021.
//

import Foundation
import FirebaseDatabase

final class DatabaseManager {
    var ref:DatabaseReference?
    
    static let shared = DatabaseManager()
    
    private let database = Database.database().reference()
    
}

extension DatabaseManager {
    
    public func userExists(with email: String, completion: @escaping ((Bool) -> Void)){
        var safeEmail: String {
            var safeEmail = email.replacingOccurrences(of: ".", with: "-")
            safeEmail = safeEmail.replacingOccurrences(of: "@", with: "-")
            return safeEmail
        }
        
        database.child(safeEmail).observeSingleEvent(of: .value, with: { snapshot in
            guard snapshot.value as? String != nil else {
                completion(false)
                return
            }
            
            completion(true)
        })
    }
    
    public func insertUser(with user: ChatAppUser) {
        database.child(user.safeEmail).setValue([
            "first_name": user.firstname,
            "last_name": user.lastName
        ])
    }
    
    
}

struct ChatAppUser {
    var firstname: String
    var lastName: String
    let emailAddress: String
    
    var safeEmail: String {
        var safeEmail = emailAddress.replacingOccurrences(of: ".", with: "-")
        safeEmail = safeEmail.replacingOccurrences(of: "@", with: "-")
        return safeEmail
    }
    
  //  let profilePictureUrl: String
}
