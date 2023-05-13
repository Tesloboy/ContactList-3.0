import UIKit

class DetailViewController: UIViewController {
    
    var contact: Contact!
    
    
    @IBOutlet var phoneLabel: UILabel!
    @IBOutlet var emailLabel: UILabel!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = contact.fullName
        
        if let contact = contact {
            phoneLabel.text = "Phone: \(contact.phoneNumber)"
            emailLabel.text = "Email: \(contact.email)"
        }
    }
    
}

