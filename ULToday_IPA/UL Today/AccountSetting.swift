//
//  AccountSetting.swift
//  UL Today
//
//  Created by Andrew on 8/9/16.
//  Copyright © 2016 Andrew Design. All rights reserved.
//

import UIKit
fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l < r
  case (nil, _?):
    return true
  default:
    return false
  }
}


class AccountSetting: UITableViewController, UITextFieldDelegate, UINavigationControllerDelegate {
    
    // MARK: Properties
    var id: String = ""
    var role: String = ""
    var data: [String:AnyObject]?
    
    @IBOutlet var saveButton: UIBarButtonItem!
    @IBOutlet weak var editText: UITextField!
    
    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var detailsLabel: UILabel!
    
    @IBOutlet weak var studenTableViewCell: UITableViewCell!
    @IBOutlet weak var staffTableViewCell: UITableViewCell!
    
    // MARK: Customized Functions
    func loadUserInfo() -> UserInfo? {
        return NSKeyedUnarchiver.unarchiveObject(withFile: UserInfo.ArchiveURL.path) as? UserInfo
    }
    
    func saveUserInfo() {
        let isSuccessfulSave = NSKeyedArchiver.archiveRootObject(UserInfo(role:role, id: id)!, toFile: UserInfo.ArchiveURL.path)
        if !isSuccessfulSave {
            print("Failed to save user...")
        } else {
            if let appDelegate = UIApplication.shared.delegate as? AppDelegate, let config = AppDelegate.getRemoteConfig() {
                if config.getBool(ULRemoteConfigurationKey.exameFeature.rawValue) {
                    appDelegate.mainVc?.showClassTab(true, animated: false)
                } else {
                    appDelegate.mainVc?.showClassTab(false, animated: false)
                }
            }
        }
    }
    
    func checkData() -> Bool {
        
        if(editText.hasText == false){
            return false
        }
        if(editText.text?.count < 7){
            return false
        }
        return true
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if((indexPath as NSIndexPath).section == 1){
            self.editText.resignFirstResponder()
            if((indexPath as NSIndexPath).row == 0) {
                role = "STUDENT"
                studenTableViewCell.accessoryType = UITableViewCellAccessoryType.checkmark
                staffTableViewCell.accessoryType  = UITableViewCellAccessoryType.none
                self.editText.text = ""
                self.editText.keyboardType = UIKeyboardType.numberPad
                self.editText.becomeFirstResponder()
            } else {
                role = "STAFF"
                studenTableViewCell.accessoryType = UITableViewCellAccessoryType.none
                staffTableViewCell.accessoryType  = UITableViewCellAccessoryType.checkmark
                self.editText.text = ""
                self.editText.keyboardType = UIKeyboardType.default
                self.editText.becomeFirstResponder()
            }
        }
        tableView.deselectRow(at: indexPath, animated: true)
        
    }

    @IBAction func saveButton(_ sender: AnyObject) {
        saveButton.isEnabled = false
        if(checkData()){
//            var flag = -1
            self.editText.resignFirstResponder()
            
            self.id = editText.text!
            
            
//            if(flag == 0) {/*
//                if #available(iOS 8.0, *) {
//                    let alertController = UIAlertController(title: "Message", message: "Error happened, try again later.", preferredStyle: .Alert)
//                } else {
//                    // Fallback on earlier versions
//                }
//                
//                if #available(iOS 8.0, *) {
//                    let OKAction = UIAlertAction(title: "OK", style: .Default) { (action) in
//                    }
//                } else {
//                    // Fallback on earlier versions
//                }
//                alertController.addAction(OKAction)
//                self.presentViewController(alertController, animated: true) {
//                }
// */
//            }
//            else if(flag == 1) {
//                /*
//                let alertController = UIAlertController(title: "Message", message: "Your timetable is up to date.", preferredStyle: .Alert)
//                
//                let OKAction = UIAlertAction(title: "OK", style: .Default) { (action) in
//                }
//                alertController.addAction(OKAction)
//                self.presentViewController(alertController, animated: true) {
//                }
// */
//            }
//            else {
//                /*
//                let alertController = UIAlertController(title: "Message", message: "Successfully added.", preferredStyle: .Alert)
//                
//                let OKAction = UIAlertAction(title: "OK", style: .Default) { (action) in
//                }
//                alertController.addAction(OKAction)
//                self.presentViewController(alertController, animated: true) {
//                }
// */
//            }
            
            saveUserInfo()
            NotificationCenter.default.post(name: Notification.Name(rawValue: "reload"), object: nil)
            
            dismiss(animated: true, completion: nil)

            
        }
        else{
            /*
            let alertController = UIAlertController(title: "Message", message: "Please enter a valid user ID.", preferredStyle: .Alert)
            
            let OKAction = UIAlertAction(title: "OK", style: .Default) { (action) in
                // ...
            }
            alertController.addAction(OKAction)
            self.presentViewController(alertController, animated: true) {
            }
 */
        }

    }
    
    @IBAction func cancelButton(_ sender: AnyObject) {
        dismiss(animated: true, completion: nil)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if let savedUser = loadUserInfo() {
            id = savedUser.id
            role = savedUser.role
            typeLabel.text = role.uppercased()
            detailsLabel.text = id
        }
        else{
            id = "09003523"
            role = "STUDENT"
            data = nil
            typeLabel.text = ""
            detailsLabel.text = "Not logged in"
        }
        
        if(role == "STAFF") {
            studenTableViewCell.isSelected = false
            studenTableViewCell.accessoryType = UITableViewCellAccessoryType.none
            staffTableViewCell.isSelected = true
            staffTableViewCell.accessoryType  = UITableViewCellAccessoryType.checkmark
        }
        else {
            studenTableViewCell.isSelected = true
            studenTableViewCell.accessoryType = UITableViewCellAccessoryType.checkmark
            staffTableViewCell.isSelected = false
            staffTableViewCell.accessoryType  = UITableViewCellAccessoryType.none
        }
        
        editText.delegate = self
        editText.text = id
        
        //Add done button to the keyboard
        let toolbar = UIToolbar()
        let flexButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
        let doneButton = UIBarButtonItem.init(barButtonSystemItem: UIBarButtonSystemItem.done,
                                              target: self.editText, action: #selector(UITextField.resignFirstResponder))
        toolbar.setItems([flexButton, doneButton], animated: true)
        toolbar.sizeToFit()
        
        self.editText.inputAccessoryView = toolbar
    }

    
    // MARK: UITextFieldDelegate
    
    // MARK: UITextFieldDelegate
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        saveButton.isEnabled = false
        if(role == "STUDENT") {
            textField.keyboardType = UIKeyboardType.numberPad
            textField.becomeFirstResponder()
        } else {
            textField.keyboardType = UIKeyboardType.default
            textField.becomeFirstResponder()
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        textField.resignFirstResponder()
        id = textField.text!
        if(checkData()) {
            saveButton.isEnabled = true
        }
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
