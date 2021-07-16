//
//  Persistence.swift
//  Shared
//
//  Created by Becky Henderson on 7/8/21.
//

import CoreData

struct PersistenceController {
    static let shared = PersistenceController()

    static var preview: PersistenceController = {
        let result = PersistenceController(inMemory: true)
        let viewContext = result.container.viewContext
        let names = ["Bob Belcher", "Anna Karenina", "Lizzy Bennet", "Hermione Granger", "Luke Danes", "Becky Sharp", "Bridget Jones", "George Bailey", "Jez Usborne", "Nessa Jenkins"]
        for index in 0..<10 {
            let contact = Contact(context: viewContext)
            let name = names[index]
            contact.name = name
            contact.color = .purple

            let email = ContactAttribute(context: viewContext)
            email.value = "\(name.lowercased().replacingOccurrences(of: " ", with: ""))@gmail.com"
            email.type = Int16(ContactAttributeType.email.rawValue)

            let d = Int.random(in: 0...9)
            let phone = ContactAttribute(context: viewContext)
            phone.value = "\(d)\(d)\(d)-\(d)\(d)\(d)\(d)"
            phone.type = Int16(ContactAttributeType.phone.rawValue)

            contact.addToContactAttributes(email)
            contact.addToContactAttributes(phone)
        }
        do {
            try viewContext.save()
        } catch {
            // Replace this implementation with code to handle the error appropriately.
            // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
        return result
    }()

    let container: NSPersistentContainer

    init(inMemory: Bool = false) {
        container = NSPersistentContainer(name: "TraveFuture")
        if inMemory {
            container.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "/dev/null")
        }
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.

                /*
                Typical reasons for an error here include:
                * The parent directory does not exist, cannot be created, or disallows writing.
                * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                * The device is out of space.
                * The store could not be migrated to the current model version.
                Check the error message to determine what the actual problem was.
                */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
    }
}
