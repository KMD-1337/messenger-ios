//
//  FBStorageManager.swift
//  messenger-ios
//
//  Created by Dima on 09.01.2021.
//

import Foundation
import Firebase

final class FBStorageManager{
    static let shared = FBStorageManager()
    
    private let storage = Storage.storage()
}

extension FBStorageManager{
    func uploadProfilePicture(_ email: String,_ image: UIImage) {
        let uploadRef = storage.reference(withPath: "profilePictures/\(email).jpg")
        let uploadMetadata = StorageMetadata.init()
        guard let imageData = image.jpegData(compressionQuality: 0.8) else {
            return
        }
        uploadMetadata.contentType = "image/jpeg"
        
        uploadRef.putData(imageData, metadata: uploadMetadata) { (downloadMetadata, error) in
            if let err = error {
                print("There was an error while uploading your picture. Error:", err)
            } else {
                print("Picture was uploaded successfully")
            }
            
        }
    }
}

