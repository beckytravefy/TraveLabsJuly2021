//
//  ContactDetailView.swift
//  TraveFuture
//
//  Created by Becky Henderson on 7/8/21.
//

import SwiftUI
import CoreData

struct ContactDetailView: View {
    @Environment(\.managedObjectContext) var viewContext
    @ObservedObject var contact: Contact

    var isEditModeOnly: Bool
    @Environment(\.editMode) var mode

    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        VStack {
            HeaderView(contact: contact)
                .padding()

            if !(mode?.wrappedValue.isEditing ?? false) {
                QuickActionsView(contact: contact)

                ContactDisplayInfoView(contact: contact)
            } else {
                ContactEditInfoView(contact: contact)
            }
        }
        .background(Color(UIColor.secondarySystemBackground))
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(mode!.wrappedValue.isEditing)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                if mode!.wrappedValue.isEditing {
                    Button(action: discardChanges, label: {
                        Text("Cancel")
                    })
                } else {
                    EmptyView()
                }
            }
            ToolbarItem(placement: .navigationBarTrailing) {
                EditButton()
            }
        }
        .onAppear {
            if isEditModeOnly {
                mode?.wrappedValue = .active
            }
        }
        .onChange(of: mode!.wrappedValue, perform: { value in
            if value == .inactive {
                saveChanges()

                if isEditModeOnly {
                    presentationMode.wrappedValue.dismiss()
                }
            }
        })
    }

    func saveChanges() {
        try? viewContext.save()
    }

    func discardChanges() {
        viewContext.rollback()
        mode?.wrappedValue = .inactive
    }
}

struct HeaderView: View {
    @ObservedObject var contact: Contact
    @Environment(\.editMode) var mode

    var body: some View {
        VStack {
            Text(contact.wrappedName.initials())
                .padding(25)
                .background(contact.color)
                .foregroundColor(.white)
                .font(.largeTitle)
                .clipShape(Circle())
            if let mode = mode,
               !mode.wrappedValue.isEditing {
                Text(contact.wrappedName)
                    .font(.title)
            }
        }
    }
}

struct QuickActionsView: View {
    struct ActionButton: View {
        @State var action: () -> ()
        @State var title: String
        @State var iconName: String
        @State var isDisabled: Bool

        var body: some View {
            Button(action: action) {
                VStack {
                    Image(systemName: iconName)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 20, height: 20, alignment: .center)
                    Text(title)
                        .font(.footnote)
                }
            }
            .disabled(isDisabled)
            .frame(width: 90, height: 60, alignment: .center)
            .background(Color(UIColor.systemBackground))
            .cornerRadius(10)
        }
    }

    @ObservedObject var contact: Contact

    var body: some View {
        HStack {
            ActionButton(action: call, title: "call", iconName: "phone.fill", isDisabled:contact.primaryPhone == nil)
            ActionButton(action: email, title: "email", iconName: "envelope.fill", isDisabled:contact.primaryEmail == nil)
        }
    }

    func email() {
        if let primaryEmail = contact.primaryEmail,
            let url = URL(string: "mailto://\(primaryEmail)"), UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url)
        }
    }

    func call() {
        if let primaryPhone = contact.primaryPhone,
            let url = URL(string: "tel://\(primaryPhone)"), UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url)
        }
    }
}

struct ContactDisplayInfoView: View {
    @ObservedObject var contact: Contact

    var body: some View {
        Form {
            Section {
                if (contact.contactDescription != nil) {
                    Text(contact.wrappedDescription)
                }
            }
            Section {
                ForEach(contact.attributes) { attribute in
                    AttributeDisplayField(label: attribute.wrappedType.label, value: attribute.wrappedValue)
                }
            }
        }
    }
}

struct AttributeDisplayField: View {
    @State var label: String
    @State var value: String

    var body: some View {
        VStack(alignment: .leading) {
            Text(label)
                .font(.subheadline)
                .foregroundColor(Color(UIColor.secondaryLabel))
                .padding(.vertical, 4)
            Text(value)
                .padding(.bottom, 4)
        }
    }
}

struct ContactEditInfoView: View {
    @ObservedObject var contact: Contact
    @Environment(\.managedObjectContext) var viewContext

    var body: some View {
        List {
            Section {
                TextField("Name", text: $contact.wrappedName)
            }
            Section {
                VStack(alignment: .leading) {
                    Text("Description")
                        .font(.subheadline)
                    TextEditor(text: $contact.wrappedDescription)
                }
            }
            Section {
                ForEach(contact.attributes) { attribute in
                    AttributeEditField(contact: contact, attribute: attribute)
                }
                Button(action: addAttribute) {
                    HStack {
                        Image(systemName: "plus.circle.fill")
                            .foregroundColor(.green)
                        Text("Add Detail")
                    }
                }
            }
        }
        .listStyle(GroupedListStyle())
        //buttons aren't active in edit mode in lists
        //force it to be off since we're handling edit mode difference ourselves
        .environment(\.editMode, .constant(.inactive))
    }

    func addAttribute() {
        let attribute = ContactAttribute(context: viewContext)
        attribute.wrappedType = .email
        contact.addToContactAttributes(attribute)
    }
}

struct AttributeEditField: View {
    @Environment(\.managedObjectContext) var viewContext
    @ObservedObject var contact: Contact
    @ObservedObject var attribute: ContactAttribute

    var body: some View {
        HStack {
            HStack {
                Button(action: deleteAttribute) {
                    Image(systemName: "minus.circle.fill")
                        .foregroundColor(.red)
                }
                HStack {
                    Picker(attribute.wrappedType.label,
                           selection: $attribute.wrappedType) {
                        ForEach(ContactAttributeType.allCases, id: \.self) {
                            Text($0.label)
                        }
                    }
                    .pickerStyle(MenuPickerStyle())
                    Image(systemName: "chevron.forward")
                        .foregroundColor(Color(UIColor.secondaryLabel))
                }
            }
            Divider()
            TextField("Value", text: $attribute.wrappedValue)
        }
    }

    func deleteAttribute() {
        contact.removeFromContactAttributes(attribute)
        viewContext.delete(attribute)
    }
}

struct ContactDetailView_Previews: PreviewProvider {
    static let moc = PersistenceController.preview.container.viewContext
    static var previews: some View {
        let contact = Contact(context: moc)
        contact.name = "John Smith"
        contact.color = .purple
        contact.contactDescription = "This guy loves to travel. Upsell him!"

        let email = ContactAttribute(context: moc)
        email.contactAttributeId = 1
        email.value = "jsmith42@gmail.com"
        email.type = Int16(ContactAttributeType.email.rawValue)

        let phone = ContactAttribute(context: moc)
        phone.contactAttributeId = 2
        phone.value = "402-555-5555"
        phone.type = Int16(ContactAttributeType.phone.rawValue)

        let address = ContactAttribute(context: moc)
        address.contactAttributeId = 3
        address.value = "2025 B St\nLincoln, NE 68502"
        address.type = Int16(ContactAttributeType.address.rawValue)

        contact.addToContactAttributes(email)
        contact.addToContactAttributes(phone)
        contact.addToContactAttributes(address)

        return NavigationView {
            ContactDetailView(contact: contact, isEditModeOnly: false)
        }
    }
}
