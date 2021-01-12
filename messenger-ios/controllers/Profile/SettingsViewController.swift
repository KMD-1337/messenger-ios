//
//  SettingsViewController.swift
//  messenger-ios
//
//  Created by Dima on 11.01.2021.
//

import UIKit
import FirebaseAuth

class SettingsViewController: UIViewController {
    var updatedName: String?
    var updatedLastName: String?
    
    //Create UITableView
    private let tableView: UITableView = {
        let table = UITableView(frame: .zero, style: .grouped)
        
        //Caches the contents of a nib file in memory
        let nib = UINib(nibName: "FieldTableViewCell", bundle: nil)
        table.register(nib, forCellReuseIdentifier: "FieldTableViewCell")
        
        return table
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        //Add "Done" button to the navigation bar
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Done",
                                                            style: .done,
                                                            target: self,
                                                            action: #selector(didTapDoneButton))
        
        tableView.dataSource = self
        tableView.delegate = self
        
        view.addSubview(tableView)
    }
    
    //The function is supposed to be called when "Done" button is tapped
    @objc public func didTapDoneButton() {
        if let aTextField = self.view.viewWithTag(1) as? UITextField {
            aTextField.resignFirstResponder() //End editing text field
        }
        
        
        let getEmail = Auth.auth().currentUser?.email //Get the user's e-mail
        if let email = getEmail {
            var safeEmail: String {
                var safeEmail = email.replacingOccurrences(of: ".", with: "-")
                safeEmail = safeEmail.replacingOccurrences(of: "@", with: "-")
                return safeEmail
            }
            if let updatedN = updatedName, let updatedLastN = updatedLastName {
                DatabaseManager.shared.updateUsers(with: safeEmail, first_name: updatedN, last_name: updatedLastN)
                
                let chatUser = ChatAppUser(firstname: updatedN,
                                           lastName: updatedLastN,
                                           emailAddress: email)
                DatabaseManager.shared.insertUser(with: chatUser, completion: { success in
                    if success {
                        print ("Successfully")
                    } else {
                        print("Unsuccessfully")
                    }
                })
            }
        }
        navigationController?.popViewController(animated: true)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        tableView.frame = view.bounds
    }

}

//Create setting table
extension SettingsViewController: UITableViewDelegate, UITableViewDataSource {
    //Define number of sections
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    //Define number of rows in section
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    //Configure cells
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FieldTableViewCell", for: indexPath) as! FieldTableViewCell

        if (indexPath.row == 0) {
            cell.textField.placeholder = "Name"
            cell.textField.tag = 0
        } else if (indexPath.row == 1) {
            cell.textField.placeholder = "Last name"
            cell.textField.tag = 1
        }
        cell.textField.delegate = self
        
        
        return cell
    }
     
}

//Functions which are called by text fields of the table
extension SettingsViewController: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        if !textField.text!.isEmpty {
            if (textField.tag == 0) {
                updatedName = textField.text
            } else if(textField.tag == 1) {
                updatedLastName = textField.text
            }
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if (textField.tag == 0) {
            textField.resignFirstResponder()
            if let aTextField = self.view.viewWithTag(1) as? UITextField {
                aTextField.becomeFirstResponder();
            }
        } else if (textField.tag == 1){
            didTapDoneButton()
        }

        return true
    }
}

