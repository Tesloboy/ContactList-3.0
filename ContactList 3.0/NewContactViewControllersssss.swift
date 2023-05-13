
import UIKit

protocol NewContactViewControllerDelegate {
    func saveContact(_ contact: Contact)
}

class NewContactViewController: UIViewController {

    //    @IBOutlet var doneButton: UIBarButtonItem!
    //    @IBOutlet var firstNameTextField: UITextField!
    //    @IBOutlet var lastNameTextField: UITextField!
    
    var delegate: NewContactViewControllerDelegate!
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        firstNameTextField.addTarget(
            self,
            action: #selector(firstNameTextFieldDidChanged),
            for: .editingChanged
        )
    }
//
//        @IBAction func doneButtonPressed(_ sender: UIBarButtonItem) {
//        saveAndExit()
//    }
    
//@IBAction func canceButtonPressed(_ sender: UIBarButtonItem) {
//        dismiss(animated: true)
//    }
    
    @objc private func firstNameTextFieldDidChanged() {
        guard let firstName = firstNameTextField.text else { return }
        doneButton.isEnabled = !firstName.isEmpty ? true : false
    }
    
    private func saveAndExit() {
        guard let firstName = firstNameTextField.text else { return }
        guard let lastName = lastNameTextField.text else { return }

        let contact = Contact(firstName: firstName, lastName: lastName)
        //было StorageManager.shared.save(with: contact)
        StorageManager.shared.saveToFile(with: contact)
        delegate.saveContact(contact)
        dismiss(animated: true)
    }
}
