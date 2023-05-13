import Foundation

class StorageManager {
    static let shared = StorageManager()


//Эта строка кода создает константу documentDirectory, которая представляет URL-адрес директории документов (для текущего пользователя), который может быть использован для сохранения файлов, которые будут доступны только вашему приложению. Например, мы можем сохранять файлы plist в директории документов, чтобы ваше приложение могло их загружать и обновлять.
    private let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    //переменная url для записи
    private var archiveURL: URL

    init() {
        archiveURL = documentDirectory.appendingPathComponent("Contacts").appendingPathExtension("plist")
        print(documentDirectory)
    }

    
//метод сохранения в файл
    func saveToFile(with contact: Contact) {
        //получим контакты
        var contacts = fetchFromFile()
        //добавляем контакт в список контактов
        contacts.append(contact)
        //пытаемся(try?) заенкодить data(данные)
        guard let data = try? PropertyListEncoder().encode(contacts) else { return }
        //записываем в archiveURL новый список контактов ,без залочивания
        try? data.write(to: archiveURL, options: .noFileProtection)
    }

    //метод полоучающий контакт (из файла) по URL
    func fetchFromFile() -> [Contact] {
        //получим данные по URL
        guard let data = try? Data(contentsOf: archiveURL) else { return [] }
        //получим контакты используя специальный декодер PropertyListDecoder с методом .decode помещая в [Contact]
        guard let contacts = try? PropertyListDecoder().decode([Contact].self, from: data) else { return [] }
        return contacts
    }

    //метод удаляющитй контакт (из файла)
    func deleteFromFile(at index: Int) {
        //получим контакты
        var contacts = fetchFromFile()
//        var contacts = fetchContacts()
        //удаляем из списка контакт
        contacts.remove(at: index)
        //пытаемся(try?) заенкодить data(данные)
        guard let data = try? PropertyListEncoder().encode(contacts) else {
            return
        }
        //записываем в archiveURL новый список контактов ,без залочивания
        try? data.write(to: archiveURL, options: .noFileProtection)
    }
}
