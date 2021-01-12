//
//  ProfileViewController.swift
//  messenger-ios
//
//  Created by Kirill on 21.12.2020.
//

import UIKit
import FirebaseAuth //Manages users using e-mail addresses and passwords to sign in


class ProfileViewController: UIViewController {
    
    //Connecting UI elements from storyboard
    @IBOutlet var tableView: UITableView!
    @IBOutlet var name: UILabel!
    @IBOutlet var lastName: UILabel!
    @IBOutlet var profileImage: UIImageView!
    
    //Names for table cells
    let rows = ["Settings","Log Out"]
    
    //The function is called every time this ViewController loads.(Only once)
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "basicStyleCell")
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    //The function is called every time this ViewController appears.
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        profileImage = profileImageCustomization()
        getProfilePicture()
        getNames()
    }
    
    //Get current user's full name
    public func getNames() {
        name.text = ""
        name.font = UIFont.systemFont(ofSize: 20.0)
        lastName.text = ""
        lastName.font = UIFont.systemFont(ofSize: 20.0)
        
        let getEmail = Auth.auth().currentUser?.email  //Get current user's e-mail
        if let email = getEmail {
            var safeEmail: String {
                var safeEmail = email.replacingOccurrences(of: ".", with: "-")
                safeEmail = safeEmail.replacingOccurrences(of: "@", with: "-")
                return safeEmail
            }
            DatabaseManager.shared.getUserNames(safeEmail) {[weak self](success, response) in
                if success, let data = response as? [String: Any] {
                    self?.name.text = data["first_name"] as? String
                    self?.lastName.text = data["last_name"] as? String
                }
            }
        }
    }
}

// Add UITableView for profile
extension ProfileViewController: UITableViewDelegate, UITableViewDataSource {
    //Set number of rows
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return rows.count
    }

    //Configure cells of the UITableView
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "basicStyleCell", for: indexPath)
        
        cell.textLabel?.text = rows[indexPath.row]
        cell.textLabel?.textColor = .black
        cell.textLabel?.textAlignment = .natural
        cell.accessoryType = .disclosureIndicator
        if (indexPath.row == (rows.count - 1)) { //"Log out" cell
            cell.textLabel?.textColor = .red
            cell.textLabel?.textAlignment = .center
        }
        
        return cell
    }
    
    //Set functions for each cell
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        if (indexPath.row == (rows.count - 1)){ //"Log out" cell
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
        } else if (indexPath.row == 0) { // "Settings" cell
            let vc = SettingsViewController()
            vc.title = "Settings"
            navigationController?.pushViewController(vc, animated: true)
        }
    }
}

//Show the avatar in profile tab
extension ProfileViewController {
    
    //Set the default avatar
    func profileImageCustomization() -> UIImageView {
        profileImage.image = UIImage(systemName: "person.circle")
        profileImage.contentMode = .scaleAspectFit
        profileImage.layer.cornerRadius = profileImage.width/2
        return profileImage
    }
    
    //Get the current user's avatar from the Firegase storage
    func getProfilePicture() {
        guard let currentUserEmail = Auth.auth().currentUser?.email else {
            return
        }
        
        FBStorageManager.shared.getPicture(currentUserEmail) { [weak self](success, response) in
            if success, let avatar = response as? Data{
                self?.profileImage.image = UIImage(data: avatar)
            }
        }
    }
}
