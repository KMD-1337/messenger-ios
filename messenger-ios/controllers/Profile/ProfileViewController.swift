//
//  ProfileViewController.swift
//  messenger-ios
//
//  Created by Kirill on 21.12.2020.
//

import UIKit
import FirebaseAuth


class ProfileViewController: UIViewController {
    
    @IBOutlet var tableView: UITableView!
    @IBOutlet var name: UILabel!
    @IBOutlet var lastName: UILabel!
    @IBOutlet var profileImage: UIImageView!
    
    let rows = ["Settings","Log Out"]
    
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
        
        let getEmail = Auth.auth().currentUser?.email
        if let email = getEmail {
            var safeEmail: String {
                var safeEmail = email.replacingOccurrences(of: ".", with: "-")
                safeEmail = safeEmail.replacingOccurrences(of: "@", with: "-")
                return safeEmail
            }
            DatabaseManager.shared.getUserNames(safeEmail) { (success, response) in
                if success, let data = response as? [String: Any] {
                    self.name.text = data["first_name"] as? String
                    self.lastName.text = data["last_name"] as? String
                }
            }
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
        cell.textLabel?.textColor = .black
        cell.textLabel?.textAlignment = .natural
        cell.accessoryType = .disclosureIndicator
        if (indexPath.row == (rows.count - 1)) {
            cell.textLabel?.textColor = .red
            cell.textLabel?.textAlignment = .center
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        if (indexPath.row == (rows.count - 1)){
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
        } else if (indexPath.row == 0) {
            let vc = SettingsViewController()
            vc.title = "Settings"
            navigationController?.pushViewController(vc, animated: true)
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
        
        FBStorageManager.shared.getPicture(currentUserEmail) { [weak self](success, response) in
            if success, let avatar = response as? Data{
                self?.profileImage.image = UIImage(data: avatar)
            }
        }
    }
}
