//
//  ProfileViewController.swift
//  messenger-ios
//
//  Created by Kirill on 21.12.2020.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase

class ProfileViewController: UIViewController {
    
    @IBOutlet var tableView: UITableView!
    @IBOutlet var name: UILabel!
    @IBOutlet var lastName: UILabel!
    @IBOutlet var profileImage: UIImageView!
    
    
    var ref:DatabaseReference!
    
    let rows = ["Log Out"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "basicStyleCell")
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        profileImage = profileImageCustomization()
        getProfilePicture()
        getNames()
    }
    
    
    public func getNames() {
        name.text = ""
        name.font = UIFont.systemFont(ofSize: 20.0)
        lastName.text = ""
        lastName.font = UIFont.systemFont(ofSize: 20.0)
        
        ref = Database.database().reference()
        
        let getEmail = Auth.auth().currentUser?.email
        if let email = getEmail {
            var safeEmail: String {
                var safeEmail = email.replacingOccurrences(of: ".", with: "-")
                safeEmail = safeEmail.replacingOccurrences(of: "@", with: "-")
                return safeEmail
            }
            ref?.child(safeEmail).observe(DataEventType.value, with: { (snapshot) in
                if let data = snapshot.value as? [String: Any] {
                    print(data)
                    self.name.text = data["first_name"] as? String
                    self.lastName.text = data["last_name"] as? String
                    
                } else {
                    
                }
            })
        }
    }
    
}

extension ProfileViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return rows.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "basicStyleCell", for: indexPath)
        cell.textLabel?.text = rows[indexPath.row]
        cell.textLabel?.textColor = .red
        cell.textLabel?.textAlignment = .center
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        do {
            try FirebaseAuth.Auth.auth().signOut()
            let vc = LoginViewController()
            let nav = UINavigationController(rootViewController: vc)
            nav.modalPresentationStyle = .fullScreen
            present(nav, animated: true)
        }
        catch {
            print("Error while signing out")
        }
    }
    
}

extension ProfileViewController {
    func profileImageCustomization() -> UIImageView {
        profileImage.image = UIImage(systemName: "person.circle")
        profileImage.contentMode = .scaleAspectFit
        profileImage.layer.cornerRadius = profileImage.width/2
        return profileImage
    }
    
    func getProfilePicture() {
        guard let currentUserEmail = Auth.auth().currentUser?.email else {
            return
        }
        
        let link = "profilePictures/" + currentUserEmail + ".jpg"
        let storageRef = Storage.storage().reference(withPath: link)
        storageRef.getData(maxSize: 4 * 1024 * 1024) { [weak self] (data, error) in
            if let error = error {
                print("Error while downloading the avatar: \(error.localizedDescription)")
            }
            
            if let avatar = data, error == nil {
                self?.profileImage.image = UIImage(data: avatar)
            }
            
        }
        
    }
    
}
