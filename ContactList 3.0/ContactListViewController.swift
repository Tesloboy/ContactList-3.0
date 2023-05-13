
import UIKit

class ContactListViewController: UIViewController {
    
    @IBOutlet var tableView: UITableView!
    //@IBOutlet var tableView: UITableView!
    
    private var contacts: [Contact] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        contacts = StorageManager.shared.fetchFromFile()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showContactDetail" {
            let detailVC = segue.destination as! DetailViewController
            if let indexPath = tableView.indexPathForSelectedRow {
                detailVC.contact = contacts[indexPath.row]
            }
        } else if segue.identifier == "addNewContact" {
            let newContactVC = segue.destination as! NewContactViewController
            newContactVC.delegate = self
        }
    }
    
    //снятие выбора с ячейки
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }

}

// MARK: - UITAbleViewDataSource
extension ContactListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        contacts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Contact", for: indexPath)
        let contact = contacts[indexPath.row]
        cell.textLabel?.text = contact.fullName
        cell.textLabel?.font = UIFont.systemFont(ofSize: 15, weight: .medium)
        cell.imageView?.image = UIImage(systemName: "phone")
        return cell
    }
}

// MARK: - UITableViewDelegate
//Функция удаления контактов
extension ContactListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            contacts.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
            //было StorageManager.shared.deleteContact(at: indexPath.row)
            StorageManager.shared.deleteFromFile(at: indexPath.row)
        }
    }
}

// MARK: - NewContactViewControllerDelegate
extension ContactListViewController: NewContactViewControllerDelegate {
    func saveContact(_ contact: Contact) {
        contacts.append(contact)
        tableView.reloadData()
    }
}
