import Foundation
import UIKit

protocol NewContactViewControllerDelegate {
    func saveContact(_ contact: Contact)
}

class NewContactViewController: UIViewController {
    
    
    @IBOutlet var doneButton: UIBarButtonItem!
    @IBOutlet var firstNameTextField: UITextField!
    @IBOutlet var lastNameTextField: UITextField!
    @IBOutlet var phoneNumberTextField: UITextField!
    @IBOutlet var emailTextField: UITextField!
    
    var delegate: NewContactViewControllerDelegate!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        firstNameTextField.addTarget(
            self,
            action: #selector(firstNameTextFieldDidChanged),
            for: .editingChanged
        )
    }
    
    @IBAction func doneButtonPressed(_ sender: UIBarButtonItem) {
//
//        guard let firstName = firstNameTextField.text, !firstName.isEmpty,
//              let lastName = lastNameTextField.text, !lastName.isEmpty,
//              let phoneNumber = phoneNumberTextField.text, !phoneNumber.isEmpty,
//              let email = emailTextField.text, !email.isEmpty else {
//
//            let alert = UIAlertController(title: "Ошибка", message: "Пожалуйста заполните все поля", preferredStyle: .alert)
//            alert.addAction(UIAlertAction(title: "OK", style: .default))
//            present(alert, animated: true)
//            return
//        }
//
        guard let firstName = firstNameTextField.text, !firstName.isEmpty else {
            displayAlert(with: "Пожалуйста введите имя")
            return
        }
        guard let lastName = lastNameTextField.text, !lastName.isEmpty else {
            displayAlert(with: "Пожалуйста введите фамилию")
            return
        }
        guard let email = emailTextField.text, !email.isEmpty else {
            displayAlert(with: "Пожалуйста введите email")
            return
        }
        guard let phoneNumber = phoneNumberTextField.text, !phoneNumber.isEmpty else {
            displayAlert(with: "Пожалуйста введите номер телефона")
            return
        }
        guard phoneNumber.rangeOfCharacter(from: CharacterSet.decimalDigits.inverted) == nil else {
            displayAlert(with: "Телефонный номер должен содержать только цифры")
            return
        }
        if emailTextField.text?.isValidEmail == false {
            // Выбросить ошибку, если строка не является корректным email-адресом
            displayAlert(with: "Введите корректный email")

            return
        }
        
                saveAndExit()
            }
        
        @IBAction func cancelButtonAction(_ sender: UIBarButtonItem) {
            dismiss(animated: true)
        }
        
        
        @objc private func firstNameTextFieldDidChanged() {
            guard let firstName = firstNameTextField.text else { return }
            doneButton.isEnabled = !firstName.isEmpty ? true : false
        }
        
        private func saveAndExit() {
            guard let firstName = firstNameTextField.text else { return }
            guard let lastName = lastNameTextField.text else { return }
            guard let phoneNumber = phoneNumberTextField.text else { return }
            guard let email = emailTextField.text else { return }
            
            let contact = Contact(firstName: firstName, lastName: lastName, phoneNumber: phoneNumber, email: email)
            StorageManager.shared.saveToFile(with: contact)
            delegate.saveContact(contact)
            dismiss(animated: true)
        }
    
    private func displayAlert(with message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(okAction)
        present(alert, animated: true, completion: nil)
    }
        
    }

extension String {
    var isValidEmail: Bool {
        // Это регулярное выражение проверяет, что строка является корректным email-адресом
        let emailRegex = "^[A-Z0-9._%+-]+@[A-Z0-9.-]+\\.[A-Z]{2,}$"
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        return emailPredicate.evaluate(with: self.uppercased())
    }
}
