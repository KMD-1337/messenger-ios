//
//  DatabaseManager.swift
//  messenger-ios
//
//  Created by Kirill on 03.01.2021.
//

import Foundation
import FirebaseDatabase

/// Database manager to read and write data to real time firebase database
final class DatabaseManager {
    /// Shared instance of class
    static let shared = DatabaseManager()
    /// An instance of FIRDatabaseReference to read or write data from the database
    private let database = Database.database().reference()
}

extension DatabaseManager {
    /// Checks if user exists for given email.
    ///
    /// - Parameter email: Target email to be checked
    /// - Parameter completion: Async closure to return with result
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

    /// Function that inserts a new user.
    ///
    /// - Parameter user: Target user to be insert
    /// - Parameter completion: Async closure to return with result
    public func insertUser(with user: ChatAppUser, completion: @escaping (Bool, Error?) -> Void) {
        database.child(user.safeEmail).setValue([
            "first_name": user.firstname,
            "last_name": user.lastName
        ], withCompletionBlock: { error, _ in
            guard error == nil else {
                print("An error has happened while writing to database")
                completion(false, error)
                return
            }
            
            self.database.child("users").observeSingleEvent(of: .value, with: { snapshot in
                if var usersCollection = snapshot.value as? [[String: String]]{
                    // Append to user dictionary
                    let newElement = [
                        "name": user.firstname + " " + user.lastName,
                        "email": user.safeEmail
                    ]
                    usersCollection.append(newElement)
                    
                    self.database.child("users").setValue(usersCollection, withCompletionBlock: { error, _ in
                        guard error == nil else {
                            completion(false, error)
                            return
                        }
                        
                        completion(true, nil)
                    })
                } else {
                    // create an array of users
                    let newCollection: [[String: String]] = [
                        [
                            "name": user.firstname + " " + user.lastName,
                            "email": user.safeEmail
                        ]
                    ]
                    
                    self.database.child("users").setValue(newCollection, withCompletionBlock: { error, _ in
                        guard error == nil else {
                            return
                        }
                        
                        completion(true, nil)
                    })
                }
            })
        })
        /*
               users => [
                  [
                      "name":
                      "safe_email":
                  ],
                  [
                      "name":
                      "safe_email":
                  ]
              ]
        */
    }
    /// Function that updates a user.
    ///
    /// - Parameter email: Target email to be updated
    /// - Parameter first_name: Target first name of user to be updated
    /// - Parameter last_name: Target last name of user to be updated
    public func updateUsers(with email: String, first_name: String, last_name: String) {
        let userRef = database.child(email)
        userRef.updateChildValues(["first_name": first_name, "last_name": last_name]) {
            (error:Error?, database:DatabaseReference) in
            if let error = error {
                print("Error while updating data: \(error.localizedDescription)")
            } else {
                print("Data has been updated successfully")
            }
         }
    }
    /// Function that gets all users from database
    ///
    /// - Parameter completion: Async closure to return with result
    public func getAllUsers(completion: @escaping (Result<[[String: String]], Error>) -> Void) {
        database.child("users").observeSingleEvent(of: .value, with: { snapshot in
            guard let value = snapshot.value as? [[String: String]] else {
                completion(.failure(DatabaseError.failedToFetch))
                return
            }
            
            completion(.success(value))
        })
    }
    /// Function that gets the username from firebase database
    ///
    /// - Parameter email: Target email to be getting user name
    /// - Parameter completion: Async closure to return with result
    public func getUserNames(_ email: String, completion: @escaping (Bool, Any?) -> Void) {
        database.child(email).observeSingleEvent(of: .value, with: { (snapshot) in
            if let data = snapshot.value as? [String: Any] {
                print(data)
                completion(true, data)
                
            } else {
                print("error while getting data from db")
                completion(false, nil)
            }
        })
    }
    /// Enumeration for database error
    public enum DatabaseError: Error {
        case failedToFetch
    }

}
/// A global container for all chat application users
struct ChatAppUser {
    var firstname: String
    var lastName: String
    let emailAddress: String
    var safeEmail: String {
        var safeEmail = emailAddress.replacingOccurrences(of: ".", with: "-")
        safeEmail = safeEmail.replacingOccurrences(of: "@", with: "-")
        return safeEmail
    }
}
