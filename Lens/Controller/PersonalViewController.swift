//
//  PersonalViewController.swift
//  Lens
//
//  Created by Archie Yu on 2018/2/25.
//  Copyright © 2018年 Archie Yu. All rights reserved.
//

import UIKit
import Alamofire
import Kingfisher

class PersonalViewController: TableViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
//    var shadowConstraint: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        
        // 设置NavigationBar阴影
//        self.navigationController?.navigationBar.shadowImage = UIImage()
//        self.shadowConstraint = Shadow.add(to: self.tableView)
        
        // 注册复用Cell
        self.tableView.register(UINib(nibName: "SwitchCell", bundle: nil), forCellReuseIdentifier: "SwitchCell")
        self.tableView.register(UINib(nibName: "PersonalUserCell", bundle: nil), forCellReuseIdentifier: "PersonalUserCell")
        self.tableView.register(UINib(nibName: "PersonalBudgetCell", bundle: nil), forCellReuseIdentifier: "PersonalBudgetCell")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.tableView.reloadData()
    }
    
//    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        self.shadowConstraint.constant = self.tableView.contentOffset.y
//    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch(section) {
        case 0:
            if user.token == nil {
                return 2
            } else {
                return 1
            }
        case 1: return 3
        case 2: return 2
        default: return 0
        }
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            if user.token == nil {
                switch indexPath.row {
                case 0:
                    let cell = tableView.dequeueReusableCell(withIdentifier: "SwitchCell", for: indexPath) as! SwitchCell
                    cell.label.text = NSLocalizedString("Login", comment: "Login")
                    return cell
                case 1:
                    let cell = tableView.dequeueReusableCell(withIdentifier: "SwitchCell", for: indexPath) as! SwitchCell
                    cell.label.text = NSLocalizedString("Register", comment: "Register")
                    return cell
                default: return UITableViewCell()
                }
                
            } else {
                let cell = tableView.dequeueReusableCell(withIdentifier: "PersonalUserCell", for: indexPath) as! PersonalUserCell
                if user.avatar == "" {
                    cell.avatarImageView.image = UIImage(named: "avatar")
                } else {
                    cell.avatarImageView.kf.setImage(with: URL(string: user.avatar))
                }
                cell.nicknameLabel.text = user.nickname
                cell.usernameLabel.text = "@" + user.username
                return cell
            }
        case 1:
            switch indexPath.row {
            case 0:
                let cell = tableView.dequeueReusableCell(withIdentifier: "SwitchCell", for: indexPath) as! SwitchCell
                cell.label?.text = NSLocalizedString("Library", comment: "Library")
                return cell
            case 1:
                let cell = tableView.dequeueReusableCell(withIdentifier: "SwitchCell", for: indexPath) as! SwitchCell
                cell.label?.text = NSLocalizedString("Wishlist", comment: "Wishlist")
                return cell
            case 2:
                let cell = tableView.dequeueReusableCell(withIdentifier: "PersonalBudgetCell", for: indexPath) as! PersonalBudgetCell
                cell.label?.text = NSLocalizedString("Budget", comment: "Budget")
                cell.budget?.text = "****"
                if user.settings.showBudget == true {
                    cell.budget?.text = user.settings.budget
                }
                return cell
            default: return UITableViewCell()
            }
        case 2:
            let cell = tableView.dequeueReusableCell(withIdentifier: "SwitchCell", for: indexPath) as! SwitchCell
            switch indexPath.row {
            case 0:
                cell.label?.text = NSLocalizedString("Settings", comment: "Settings")
            case 1:
                cell.label?.text = NSLocalizedString("About", comment: "About")
            default: break
            }
            return cell
        default: return UITableViewCell()
        }
    }
    
    func beginRegister(message: String?, username oldUsername: String? = nil, password oldPassword: String? = nil) {
        let alertController = UIAlertController(title: NSLocalizedString("Register", comment: "Register"), message: message, preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: NSLocalizedString("Cancel", comment: "Cancel"), style: .cancel, handler: nil)
        let confirmAction = UIAlertAction(title: NSLocalizedString("Confirm", comment: "Confirm"), style: .default, handler: { (action) in
            let username = alertController.textFields?[0].text
            let password = alertController.textFields?[1].text
            let password1 = alertController.textFields?[2].text
            if password != password1 {
                self.beginRegister(message: "⚠️ " + NSLocalizedString("Passwords do not match", comment: "Passwords do not match"), username: username)
            } else {
                user.register(username: username!, password: password!) { result in
                    if result {
                        self.tableView.reloadData()
                    } else {
                        self.beginRegister(message: "⚠️ " + NSLocalizedString("Username already exists", comment: "Username already exists"), password: password)
                    }
                }
            }
        })
        alertController.addAction(cancelAction)
        alertController.addAction(confirmAction)
        alertController.addTextField(configurationHandler: { (textField) in
            textField.text = oldUsername
            textField.placeholder = NSLocalizedString("username", comment: "username")
        })
        alertController.addTextField(configurationHandler: { (textField) in
            textField.text = oldPassword
            textField.isSecureTextEntry = true
            textField.placeholder = NSLocalizedString("password", comment: "password")
        })
        alertController.addTextField(configurationHandler: { (textField) in
            textField.text = oldPassword
            textField.isSecureTextEntry = true
            textField.placeholder = NSLocalizedString("password again", comment: "password again")
        })
        self.present(alertController, animated: true, completion: nil)
    }
    
    func beginLogin(message: String?, username oldUsername: String? = nil, password oldPassword: String? = nil) {
        let alertController = UIAlertController(title: NSLocalizedString("Login", comment: "Login"), message: message, preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: NSLocalizedString("Cancel", comment: "Cancel"), style: .cancel, handler: nil)
        let confirmAction = UIAlertAction(title: NSLocalizedString("Confirm", comment: "Confirm"), style: .default, handler: { (action) in
            let username = alertController.textFields?[0].text
            let password = alertController.textFields?[1].text
            user.login(username: username!, password: password!) { result in
                if result {
                    self.tableView.reloadData()
                } else {
                    self.beginLogin(message: "⚠️ " + NSLocalizedString("Wrong username or password", comment: "Wrong username or password"), username: username, password: password)
                }
            }
        })
        alertController.addAction(cancelAction)
        alertController.addAction(confirmAction)
        alertController.addTextField(configurationHandler: { (textField) in
            textField.text = oldUsername
            textField.placeholder = NSLocalizedString("username", comment: "username")
        })
        alertController.addTextField(configurationHandler: { (textField) in
            textField.text = oldPassword
            textField.isSecureTextEntry = true
            textField.placeholder = NSLocalizedString("password", comment: "password")
        })
        self.present(alertController, animated: true, completion: nil)
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.cellForRow(at: indexPath)?.isSelected = false
        switch indexPath.section {
        case 0:
            if user.token == nil {
                switch indexPath.row {
                case 0:
                    self.beginLogin(message: nil)
                case 1:
                    self.beginRegister(message: NSLocalizedString("Please input your username and password", comment: "Please input your username and password"))
                default: break
                }
            } else {
                let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
                let changeNameAction = UIAlertAction(title: NSLocalizedString("Change Nickname", comment: "Change Nickname"), style: .default, handler: { (action) in
                    let alertController = UIAlertController(title: NSLocalizedString("Change Nickname", comment: "Change Nickname"), message: nil, preferredStyle: .alert)
                    let cancelAction = UIAlertAction(title: NSLocalizedString("Cancel", comment: "Cancel"), style: .cancel, handler: nil)
                    let confirmAction = UIAlertAction(title: NSLocalizedString("Confirm", comment: "Confirm"), style: .default, handler: { (action) in
                        if let nickname = alertController.textFields?.first?.text {
                            user.update(nickname: nickname) { result in
                                if result {
                                    tableView.reloadRows(at: [IndexPath(row: 0, section: 0)], with: .automatic)
                                } else {
                                    // TODO
                                }
                            }
                        }
                    })
                    alertController.addAction(cancelAction)
                    alertController.addAction(confirmAction)
                    alertController.addTextField(configurationHandler: { (textField) in
                        textField.placeholder = NSLocalizedString("new nickname", comment: "new nickname")
                    })
                    self.present(alertController, animated: true, completion: nil)
                })
                let changeAvatarAction = UIAlertAction(title: NSLocalizedString("Change Userhead", comment: "Change Userhead"), style: .default, handler: { (action) in
                    let imagePickerController = UIImagePickerController()
                    imagePickerController.delegate = self
                    imagePickerController.allowsEditing = true
                    let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
                    let photoLibraryAction = UIAlertAction(title: NSLocalizedString("Select from photo library", comment: "Select from photo library"), style: .default, handler: { (action) in
                        imagePickerController.sourceType = .photoLibrary
                        self.present(imagePickerController, animated: true, completion: nil)
                    })
                    let cameraAction = UIAlertAction(title: NSLocalizedString("Camera", comment: "Camera"), style: .default, handler: { (action) in
                        imagePickerController.sourceType = .camera
                        self.present(imagePickerController, animated: true, completion: nil)
                    })
                    let cancelAction = UIAlertAction(title: NSLocalizedString("Cancel", comment: "Cancel"), style: .cancel, handler: nil)
                    alertController.addAction(photoLibraryAction)
                    alertController.addAction(cameraAction)
                    alertController.addAction(cancelAction)
                    self.present(alertController, animated: true, completion: nil)
                })
                let changePassAction = UIAlertAction(title: NSLocalizedString("Change Password", comment: "Change Password"), style: .default, handler: { (action) in
                    let alertController = UIAlertController(title: NSLocalizedString("Change Password", comment: "Change Password"), message: nil, preferredStyle: .alert)
                    let cancelAction = UIAlertAction(title: NSLocalizedString("Cancel", comment: "Cancel"), style: .cancel, handler: nil)
                    let confirmAction = UIAlertAction(title: NSLocalizedString("Confirm", comment: "Confirm"), style: .default, handler: { (action) in
                        if let oldPass = alertController.textFields?.first?.text,
                            let newPass = alertController.textFields?.last?.text {
                            user.updatePassword(old: oldPass, new: newPass) { result in
                                if !result {
                                    // TODO
                                }
                            }
                        }
                    })
                    alertController.addAction(cancelAction)
                    alertController.addAction(confirmAction)
                    alertController.addTextField(configurationHandler: { (textField) in
                        textField.placeholder = NSLocalizedString("old password", comment: "old password")
                    })
                    alertController.addTextField(configurationHandler: { (textField) in
                        textField.placeholder = NSLocalizedString("new password", comment: "new password")
                    })
                    alertController.addTextField(configurationHandler: { (textField) in
                        textField.placeholder = NSLocalizedString("new password again", comment: "new password again")
                    })
                    self.present(alertController, animated: true, completion: nil)
                })
                let logoutAction = UIAlertAction(title: NSLocalizedString("Logout", comment: "Logout"), style: .destructive, handler: { (action) in
                    user.logout() {
                        tableView.reloadData()
                    }
                })
                let cancelAction = UIAlertAction(title: NSLocalizedString("Cancel", comment: "Cancel"), style: .cancel, handler: nil)
                alertController.addAction(changeNameAction)
                alertController.addAction(changeAvatarAction)
                alertController.addAction(changePassAction)
                alertController.addAction(logoutAction)
                alertController.addAction(cancelAction)
                self.present(alertController, animated: true, completion: nil)
            }
        case 1:
            if user.token == nil {
                self.beginRegister(message: NSLocalizedString("Please login before you using these functions", comment: "Please login before you using these functions"))
            } else {
                switch indexPath.row {
                case 0:
                    let librariesViewController = BrowsePagerTabStripViewController()
                    librariesViewController.category = .library
                    librariesViewController.hidesBottomBarWhenPushed = true
                    navigationController?.pushViewController(librariesViewController, animated: true)
                case 1:
                    let wishlistViewController = BrowsePagerTabStripViewController()
                    wishlistViewController.category = .wishlist
                    wishlistViewController.hidesBottomBarWhenPushed = true
                    navigationController?.pushViewController(wishlistViewController, animated: true)
                case 2:
                    let alertController = UIAlertController(title: NSLocalizedString("Budget", comment: "Budget"), message: NSLocalizedString("Please input your budget", comment: "Please input your budget"), preferredStyle: .alert)
                    let cancelAction = UIAlertAction(title: NSLocalizedString("Cancel", comment: "Cancel"), style: .cancel, handler: nil)
                    let confirmAction = UIAlertAction(title: NSLocalizedString("Confirm", comment: "Confirm"), style: .default, handler: { (action) in
                        if let budget = alertController.textFields?.last?.text {
                            if budget != "" {
                                user.settings.budget = budget
                                user.syncSettings(completion: nil)
                                tableView.reloadData()
                            }
                        }
                    })
                    alertController.addAction(cancelAction)
                    alertController.addAction(confirmAction)
                    alertController.addTextField(configurationHandler: { (textField) in
                        textField.keyboardType = .decimalPad
                        textField.placeholder = user.settings.budget
                        user.syncSettings(completion: nil)
                        textField.addTarget(self, action: #selector(self.budgetTextFieldChanged(textField:)), for: .editingChanged)
                    })
                    self.present(alertController, animated: true, completion: nil)
                default:
                    break
                }
            }
        case 2:
            switch indexPath.row {
            case 0:
                let settingsViewController = SettingsViewController(style: .grouped)
                settingsViewController.hidesBottomBarWhenPushed = true
                settingsViewController.navigationItem.title = NSLocalizedString("Settings", comment: "Settings")
                navigationController?.pushViewController(settingsViewController, animated: true)
            case 1:
                let aboutViewController = WebViewController()
                aboutViewController.hidesBottomBarWhenPushed = true
                aboutViewController.navigationItem.title = NSLocalizedString("About", comment: "About")
                aboutViewController.urlString = "https://github.com/archie-yu/Lens"
                navigationController?.pushViewController(aboutViewController, animated: true)
            default:
                break
            }
        default:
            break
        }
    }
    
    @objc func budgetTextFieldChanged(textField: UITextField) {
        if let oldText = textField.text {
            var newText = ""
            for char in oldText {
                if "0123456789".contains(char) {
                    newText.append(char)
                }
            }
            textField.text = newText
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let image = info[UIImagePickerControllerOriginalImage] as! UIImage
        if picker.sourceType == .camera {
            UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
        }
        self.dismiss(animated: true, completion: nil)
        
//        let imageData = UIImageJPEGRepresentation(image, 0.1)
//        let dateFormatter = DateFormatter()
//        dateFormatter.dateFormat = "yyyyMMddHHmmss"
//        let fileName = "\(user.username)\(dateFormatter.string(from: Date())).jpg"
//
//        Alamofire.upload(multipartFormData: { multipartFormData in
//            multipartFormData.append(imageData!, withName: "file", fileName: fileName, mimeType: "image/jpeg")
//        }, usingThreshold: 1, to: "https://", method: .post, headers: nil, encodingCompletion: { encodingResult in
//            switch encodingResult {
//            case .success(let upload,_,_):
//                upload.responseJSON { response in
//                    if let JSON = response.result.value {
//                        //这里处理JSON数据
//                    }
//                }
//            case .failure(let encodingError):
//                print(encodingError)
//            }
//        })
    }
    
//    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
//        if viewController == self {
//            self.navigationController?.navigationBar.shadowImage = nil
//        }
//    }
    
    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
