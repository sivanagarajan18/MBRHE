//
//  AddUserViewController.swift
//  MBRHE
//
//  Created by VC on 04/02/24.
//

import UIKit
import Combine

class AddUserViewController: UIViewController {
    @IBOutlet weak var nameTxtFld: UITextField!
    @IBOutlet weak var statusErrorView: UIView!
    @IBOutlet weak var statusInactiveButton: UIButton!
    @IBOutlet weak var statusActiveButton: UIButton!
    @IBOutlet weak var genderErrorView: UIView!
    @IBOutlet weak var genderFemailBtn: UIButton!
    @IBOutlet weak var genderMaleBtn: UIButton!
    @IBOutlet weak var nameErrorView: UIView!
    @IBOutlet weak var emailErrorView: UIView!
    @IBOutlet weak var emailErrorLabel: UILabel!
    @IBOutlet weak var emailTxtFld: UITextField!
    var vm: AddUserListViewModel!
    var bindings = Set<AnyCancellable>()
    
    @IBOutlet weak var loader: UIActivityIndicatorView!
    enum gender: String {
        case male
        case female
    }
    
    enum status: String {
        case active
        case inactive
    }
    
    var selectedGender: gender? = nil
    var selectedStatus: status? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setDefault()
        vm.bindDetail.receive(on: RunLoop.main).sink { err in
            self.loader.isHidden = true
            if err == nil {
                self.navigationController?.popViewController(animated: true)
            } else {
                self.displayError(message: err!)
            }
        }.store(in: &bindings)
    }
    
    
    func setDefault() {
        vm = AddUserListViewModel()
        selectedGender = nil
        selectedStatus = nil
        nameTxtFld.delegate = self
        emailTxtFld.delegate = self
        nameTxtFld.text = ""
        emailTxtFld.text = ""
        genderFemailBtn.tintColor = .white
        genderMaleBtn.tintColor = .white
        statusInactiveButton.tintColor = .white
        statusActiveButton.tintColor = .white
    }
    
    
    
    @IBAction func genderSelection(_ sender: UIButton) {
        self.view.endEditing(true)
        UIView.animate(withDuration: 0.3) {
            self.genderErrorView.isHidden = true
            self.view.layoutIfNeeded()
        }
        switch  sender.tag {
        case 10:
            selectedGender = .male
            genderMaleBtn.tintColor = .tintColor
            genderFemailBtn.tintColor = .white
            break
        case 20:
            selectedGender = .female
            genderMaleBtn.tintColor = .white
            genderFemailBtn.tintColor = .tintColor
            break
        default: break
        }
    }
    
    @IBAction func statusSelection(_ sender: UIButton) {
        self.view.endEditing(true)
        UIView.animate(withDuration: 0.3) {
            self.statusErrorView.isHidden = true
            self.view.layoutIfNeeded()
        }
        switch  sender.tag {
        case 30:
            selectedStatus = .active
            statusActiveButton.tintColor = .tintColor
            statusInactiveButton.tintColor = .white
            break
        case 40:
            selectedStatus = .inactive
            statusActiveButton.tintColor = .white
            statusInactiveButton.tintColor = .tintColor
            break
        default: break
        }
    }
    
    @IBAction func adduser(_ sender: UIButton) {
        var cnt = 0
        if nameTxtFld.text == "" {
            UIView.animate(withDuration: 0.3) {
                self.nameErrorView.isHidden = false
                self.view.layoutIfNeeded()
            }
            cnt = 0
        } else {
            cnt += 1
        }
        if emailTxtFld.text == "" {
            UIView.animate(withDuration: 0.3) {
                self.emailErrorView.isHidden = false
                self.emailErrorLabel.text = "Email Required"
                self.view.layoutIfNeeded()
            }
            cnt = 0
        } else if !isValidEmail(emailTxtFld.text ?? "") {
            UIView.animate(withDuration: 0.3) {
                self.emailErrorView.isHidden = false
                self.emailErrorLabel.text = "Enter Valid Email"
                self.view.layoutIfNeeded()
            }
            cnt = 0
        }else {
            cnt += 1
        }
        
        
        if selectedStatus == nil {
            UIView.animate(withDuration: 0.3) {
                self.statusErrorView.isHidden = false
                self.view.layoutIfNeeded()
            }
            cnt = 0
        }else {
            cnt += 1
        }
        if selectedGender == nil {
            UIView.animate(withDuration: 0.3) {
                self.genderErrorView.isHidden = false
                self.view.layoutIfNeeded()
            }
            cnt = 0
        }else {
            cnt += 1
        }
        if cnt == 4 {
            loader.isHidden = false
            vm.AddUserList(user: AddUsers(id: nil,
                                          name: nameTxtFld.text,
                                          email: emailTxtFld.text,
                                          gender: selectedGender?.rawValue,
                                          status: selectedStatus?.rawValue))
        }
    }
    
    func isValidEmail(_ email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"

        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: email)
    }
    func displayError(message: String) {
        let alertController = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        let okayAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(okayAction)
        self.present(alertController, animated: true, completion: nil)
    }
}

extension AddUserViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == nameTxtFld {
            UIView.animate(withDuration: 0.3) {
                self.nameErrorView.isHidden = true
                self.view.layoutIfNeeded()
            }
        }
        if textField == emailTxtFld {
            UIView.animate(withDuration: 0.3) {
                self.emailErrorView.isHidden = true
                self.view.layoutIfNeeded()
            }
        }
    }
}
