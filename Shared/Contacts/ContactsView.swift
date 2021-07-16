//
//  ContentView.swift
//  Shared
//
//  Created by Becky Henderson on 7/8/21.
//

import SwiftUI
import CoreData

struct ContactsView: View {
    @Environment(\.managedObjectContext) private var viewContext

    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Contact.name, ascending: true)],
        animation: .default)
    private var contacts: FetchedResults<Contact>

    @State private var searchText = ""
    private var searchResults: [Contact] {
        contacts.filter { contact in
            if searchText.isEmpty { return true }
            return contact.wrappedName.contains(searchText) || contact.primaryEmail != nil && contact.primaryEmail!.contains(searchText)
        }
    }

    @State private var newContact: Contact?

    var body: some View {
        NavigationView {
            List {
                ForEach(searchResults) { contact in
                    NavigationLink(destination: ContactDetailView(contact: contact, isEditModeOnly: false)) {
                        ItemPreview(data: contact.previewData)
                    }
                }
                .onDelete(perform: deleteContacts)
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    EditButton()
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: addContact, label: {
                        Image(systemName: "plus")
                    })
                }
            }
            .navigationTitle("Contacts")
            .searchable(text: $searchText)
        }
        .sheet(item: $newContact) { contact in
            NavigationView {
                ContactDetailView(contact: contact, isEditModeOnly: true)
            }
        }
    }

    private func createNewContact() -> Contact? {
        withAnimation {
            let contact = Contact(context: viewContext)

            let colors: [Color] = [.blue, .red, .green, .purple, .pink]
            contact.color = colors.randomElement() ?? .black

            return contact
        }
    }

    private func addContact() {
        guard let contact = createNewContact() else {
            return
        }
        newContact = contact
    }

    private func deleteContacts(offsets: IndexSet) {
        withAnimation {
            offsets.map { contacts[$0] }.forEach(viewContext.delete)

            do {
                try viewContext.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContactsView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
