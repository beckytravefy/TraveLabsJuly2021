//
//  ContactAttribute+CoreDataProperties.swift
//  TraveFuture
//
//  Created by Becky Henderson on 7/12/21.
//
//

import Foundation
import CoreData


extension ContactAttribute {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ContactAttribute> {
        return NSFetchRequest<ContactAttribute>(entityName: "ContactAttribute")
    }

    @NSManaged public var type: Int16
    @NSManaged public var value: String?
    @NSManaged public var contactAttributeId: Int64

    var wrappedType: ContactAttributeType {
        get {
            ContactAttributeType(rawValue: Int(type)) ?? .email
        }
        set {
            type = Int16(newValue.rawValue)
        }
    }

    var wrappedValue: String {
        get {
            value ?? ""
        }
        set {
            value = newValue
        }
    }

}

enum ContactAttributeType: Int, CaseIterable {
    case email = 0, phone, address

    var label: String {
        switch self {
        case .email:
            return "Email"
        case .phone:
            return "Phone"
        case .address:
            return "Address"
        }
    }
}

extension ContactAttribute : Identifiable {

}
