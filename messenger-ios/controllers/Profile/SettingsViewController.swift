//
//  SettingsViewController.swift
//  messenger-ios
//
//  Created by Dima on 11.01.2021.
//tut

import UIKit
import FirebaseAuth

class SettingsViewController: UIViewController {
    var updatedName: String?
    var updatedLastName: String?
    
    private let tableView: UITableView = {
        let table = UITableView(frame: .zero, style: .grouped)
        let nib = UINib(nibName: "FieldTableViewCell", bundle: nil)
        table.register(nib, forCellReuseIdentifier: "FieldTableViewCell")
        
        return table
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Done",
                                                            style: .done,
                                                            target: self,
                                                            action: #selector(didTapDoneButton))
        
        tableView.dataSource = self
        tableView.delegate = self
        
        view.addSubview(tableView)
    }
    
    @objc public func didTapDoneButton() {
        if let aTextField = self.view.viewWithTag(1) as? UITextField {
            aTextField.resignFirstResponder()
        }
        
        
        let getEmail = Auth.auth().currentUser?.email
        if let email = getEmail {
            var safeEmail: String {
                var safeEmail = email.replacingOccurrences(of: ".", with: "-")
                safeEmail = safeEmail.replacingOccurrences(of: "@", with: "-")
                return safeEmail
            }
            if let updatedName = updatedName, let updatedLastName = updatedLastName {
                DatabaseManager.shared.updateUsers(with: safeEmail, first_name: updatedName, last_name: updatedLastName)
            }
        }
        navigationController?.popViewController(animated: true)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        tableView.frame = view.bounds
    }

}

extension SettingsViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
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

